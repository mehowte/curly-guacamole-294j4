class OpenaiClient
    COMPLETIONS_MODEL = "text-davinci-003"
    EMBEDDINGS_MODEL = "text-embedding-ada-002"
    MAX_EMBEDDING_TOKENS = 8191
    MAX_EMBEDDING_DIMENSIONS = 1536
    EMBEDDINGS_FILE = "#{ENV["PROJECT_NAME"]}.pdf.embeddings.csv"
    FRAGMENTS_FILE = "#{ENV["PROJECT_NAME"]}.pdf.pages.csv"
    PROJECT_YAML = "#{ENV["PROJECT_NAME"]}.yaml"
    MAX_SECTION_LEN = 500
    SEPARATOR = "\n* "

    def self.build()
        new(ENV["OPENAI_API_KEY"])
    end
    def initialize(access_token)
        @client = OpenAI::Client.new(access_token: access_token)
    end

    def generate_answer(question_asked, question_embedding)
        embeddings = load_fragment_embeddings(Rails.root.join("static_files", EMBEDDINGS_FILE))
        fragments = load_fragments(Rails.root.join("static_files", FRAGMENTS_FILE))
        
        sorted_fragments = sort_fragments_by_similarity(fragments, question_embedding, embeddings) 
        context = generate_context(sorted_fragments)
        prompt = generate_prompt(question_asked, context)
        
        { answer: get_completion(prompt), context: context }
    end

    def get_completion(prompt)
        result = @client.completions(
            parameters: {
                temperature: 0.0,
                model: COMPLETIONS_MODEL,
                prompt: prompt,
                max_tokens: 150
            })
        result["choices"][0]["text"]
    end

    def get_embedding(text)
        result = @client.embeddings(
            parameters: {
                model: EMBEDDINGS_MODEL,
                input: text
            })
        result["data"][0]["embedding"]
    end

    private
    def load_fragment_embeddings(file_path)
        fragment_embeddings = []
        CSV.foreach(file_path, headers: true, return_headers: false) do |row|
            fragment_embeddings << {title: row[0], embedding: row[1..-1].map(&:to_f)}
        end
        fragment_embeddings
    end
    
    def load_fragments(file_path)
        fragments_by_title = {}
        CSV.foreach(file_path, headers: true) do |row|
            fragments_by_title[row["title"]] = { content: row["content"], tokens: row["tokens"].to_i }
        end
        fragments_by_title
    end

    def sort_fragments_by_similarity(fragments_by_title, question_embedding, fragment_embeddings)
        fragment_embeddings.map do |fragment_embedding|
            similarity = embedding_similarity(question_embedding, fragment_embedding[:embedding])
            fragment = fragments_by_title[fragment_embedding[:title]]
            {content: fragment[:content], tokens: fragment[:tokens], similarity: similarity}
        end.sort_by { |embedding| embedding[:similarity] }.reverse! 
    end

    def embedding_similarity(x, y)
        # cosine similarity
        x.zip(y).map { |a, b| a * b }.reduce(:+) / (Math.sqrt(x.map { |a| a * a }.reduce(:+)) * Math.sqrt(y.map { |a| a * a }.reduce(:+)))
    end

    def generate_context(sorted_fragments)
        context = ""
        encoder = Tiktoken.encoding_for_model(COMPLETIONS_MODEL)
        separator_len = encoder.encode(SEPARATOR).length
        space_left = MAX_SECTION_LEN
        sorted_fragments.each do |fragment| 
            break if separator_len > space_left
            space_left -= separator_len
            if fragment[:tokens] > space_left
              content = truncate_text(fragment[:content], space_left, encoder)
              space_left = 0
              break if (content.blank?)
            else 
              content = fragment[:content]
              space_left -= fragment[:tokens]
            end
            context += SEPARATOR + fragment[:content]
        end
        context
    end

    def truncate_text(text, max_tokens, encoder)
        tokens = encoder.encode(text)
        encoder.decode(tokens[0..max_tokens])
    end

    def generate_prompt(question_asked, context)
        config = YAML.load_file(Rails.root.join("static_files", PROJECT_YAML))
        header = "#{config["header"]}\n#{context}"
        questions_and_answers = config["questions_and_answers"]
        questions_and_answers << [question_asked, ""]
        <<~PROMPT
        #{header}


        #{questions_and_answers.map { |question, answer| "Q:#{question}\n\nA:#{answer}" }.join("\n\n\n")}
        PROMPT
    end
end