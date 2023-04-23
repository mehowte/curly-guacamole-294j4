

COMPLETIONS_MODEL_NAME = "text-davinci-003"

EMBEDDINGS_MODEL_NAME = "curie"
DOC_EMBEDDINGS_MODEL = "text-search-#{EMBEDDINGS_MODEL_NAME}-doc-001"
QUERY_EMBEDDINGS_MODEL = "text-search-#{EMBEDDINGS_MODEL_NAME}-query-001"

class OpenaiClient
    def self.build()
        new(ENV["OPENAI_API_KEY"])
    end
    def initialize(access_token)
        @client = OpenAI::Client.new(access_token: access_token)
    end

    def generate_answer(question_asked)
        result = @client.completions(
            parameters: {
                temperature: 0.0,
                model: COMPLETIONS_MODEL_NAME,
                prompt: generate_prompt(question_asked),
                max_tokens: 150
            })
        result["choices"][0]["text"]
    end

    def get_embedding(text, model)
        result = @client.embeddings(
            parameters: {
                model: model,
                input: text
            })
        result["data"][0]["embedding"]
    end

    private
    def generate_prompt(question_asked)
    <<~PROMPT
    Sahil Lavingia is the founder and CEO of Gumroad, and the author of the book The Minimalist Entrepreneur (also known as TME). These are questions and answers by him. Please keep your answers to three sentences maximum, and speak in complete sentences. Stop speaking once your point is made.
    
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