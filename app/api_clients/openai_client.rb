class OpenaiClient
    COMPLETIONS_MODEL = "text-davinci-003"
    EMBEDDINGS_MODEL = "text-embedding-ada-002"
    MAX_EMBEDDING_TOKENS = 8191
    MAX_EMBEDDING_DIMENSIONS = 1536
    EMBEDDINGS_FILE = "#{ENV["PROJECT_NAME"]}.pdf.embeddings.csv"
    FRAGMENTS_FILE = "#{ENV["PROJECT_NAME"]}.pdf.pages.csv"

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
    <<~PROMPT
    Sahil Lavingia is the founder and CEO of Gumroad, and the author of the book The Minimalist Entrepreneur (also known as TME). These are questions and answers by him. Please keep your answers to three sentences maximum, and speak in complete sentences. Stop speaking once your point is made.
    

    Context that may be useful, pulled from The Minimalist Entrepreneur:
    #{context}


    Q:How to choose what business to start?
    
    A:First off don't be in a rush. Look around you, see what problems you or other people are facing, and solve one of these problems if you see some overlap with your passions or skills. Or, even if you don't see an overlap, imagine how you would solve that problem anyway. Start super, super small.
    
    
    
    Q:Should we start the business on the side first or should we put full effort right from the start?
    
    A:Always on the side. Things start small and get bigger from there, and I don't know if I would ever “fully” commit to something unless I had some semblance of customer traction. Like with this product I'm working on now!
    
    
    
    Q:Should we sell first than build or the other way around?
    
    A:I would recommend building first. Building will teach you a lot, and too many people use “sales” as an excuse to never learn essential skills like building. You can't sell a house you can't build!
    
    
    
    Q:Andrew Chen has a book on this so maybe touché, but how should founders think about the cold start problem? Businesses are hard to start, and even harder to sustain but the latter is somewhat defined and structured, whereas the former is the vast unknown. Not sure if it's worthy, but this is something I have personally struggled with
    
    A:Hey, this is about my book, not his! I would solve the problem from a single player perspective first. For example, Gumroad is useful to a creator looking to sell something even if no one is currently using the platform. Usage helps, but it's not necessary.
    
    
    
    Q:What is one business that you think is ripe for a minimalist Entrepreneur innovation that isn't currently being pursued by your community?
    
    A:I would move to a place outside of a big city and watch how broken, slow, and non-automated most things are. And of course the big categories like housing, transportation, toys, healthcare, supply chain, food, and more, are constantly being upturned. Go to an industry conference and it's all they talk about! Any industry…
    
    
    
    Q:How can you tell if your pricing is right? If you are leaving money on the table
    
    A:I would work backwards from the kind of success you want, how many customers you think you can reasonably get to within a few years, and then reverse engineer how much it should be priced to make that work.
    
    
    
    Q:Why is the name of your book 'the minimalist entrepreneur' 
    
    A:I think more people should start businesses, and was hoping that making it feel more “minimal” would make it feel more achievable and lead more people to starting-the hardest step.
    
    
    
    Q:How long it takes to write TME
    
    A:About 500 hours over the course of a year or two, including book proposal and outline.
    
    
    
    Q:What is the best way to distribute surveys to test my product idea
    
    A:I use Google Forms and my email list / Twitter account. Works great and is 100% free.
    
    
    
    Q:How do you know, when to quit
        
    A:When I'm bored, no longer learning, not earning enough, getting physically unhealthy, etc… loads of reasons. I think the default should be to “quit” and work on something new. Few things are worth holding your attention for a long period of time.

    
    
    Q:#{question_asked}
        
    A:
    PROMPT
    end
end