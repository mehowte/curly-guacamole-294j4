class ContextBuilder
    MAX_SECTION_LEN = 500
    SEPARATOR = "\n* "

    def initialize(project)
        @project = project
    end

    def build_context(question_embedding)
        context = ""
        encoder = OpenaiClient.token_encoder_for_embeddings
        separator_len = encoder.encode(SEPARATOR).length
        space_left = MAX_SECTION_LEN
        sorted_fragments(question_embedding).each do |fragment| 
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

    private

    def sorted_fragments(question_embedding)
        fragment_embeddings.map do |embedding|
            {
                content: fragment(embedding)[:content], 
                tokens: fragment(embedding)[:tokens], 
                similarity: cosine_similarity(question_embedding, embedding[:embedding])
            }
        end.sort_by { |embedding| embedding[:similarity] }.reverse!
    end

    def fragment_embeddings
       result = []
        CSV.foreach(@project.embeddings_file_path, headers: true, return_headers: false) do |row|
            result << {title: row[0], embedding: row[1..-1].map(&:to_f)}
        end
        result
    end

    def fragment(embedding)
       fragments_by_title[embedding[:title]]
    end

    def fragments_by_title
        return @fragments_by_title if @fragments_by_title
        @fragments_by_title = {}
        CSV.foreach(@project.fragments_file_path, headers: true) do |row|
            @fragments_by_title[row["title"]] = { content: row["content"], tokens: row["tokens"].to_i }
        end
        @fragments_by_title
    end

    def cosine_similarity(x, y)
        x.zip(y).map { |a, b| a * b }.reduce(:+) / (Math.sqrt(x.map { |a| a * a }.reduce(:+)) * Math.sqrt(y.map { |a| a * a }.reduce(:+)))
    end

    def truncate_text(text, max_tokens, encoder)
        tokens = encoder.encode(text)
        encoder.decode(tokens[0..max_tokens])
    end
end