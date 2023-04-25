class MessagesBuilder
    def initialize(project)
        @project = project
    end

    def build_messages(question_asked, context)
        [
            { role: "system", content: "You are a helpful assistant. You answer questions related to a book and it's author." },
            header_and_context(context),
            questions_and_answers,
            { role: "user", content: question_asked }
        ].flatten
    end

    private
    def header_and_context(context)
        { 
            role: "user", 
            content: [header, additional_context(context)].compact.join("\n\n\n") 
        }
    end

    def header
        "#{@project.prompt_header}"
    end

    def additional_context(context)
        return nil if context.blank?
        "#{@project.context_header}\n#{context}"
    end

    def questions_and_answers
        @project.questions_and_answers.map do |question, answer|
            [
                { role: "user", content: question},
                { role: "assistant", content: answer}
            ]
        end.flatten
    end
end