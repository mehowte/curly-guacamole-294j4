class OpenaiClient
    COMPLETIONS_MODEL = "text-davinci-003"
    EMBEDDINGS_MODEL = "text-embedding-ada-002"
    MAX_EMBEDDING_TOKENS = 8191
    MAX_EMBEDDING_DIMENSIONS = 1536

    def self.build()
        new(ENV["OPENAI_API_KEY"])
    end
    def initialize(access_token)
        @client = OpenAI::Client.new(access_token: access_token)
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

    def self.token_encoder_for_embeddings
        Tiktoken.encoding_for_model(EMBEDDINGS_MODEL)
    end
end