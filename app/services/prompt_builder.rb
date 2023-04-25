class PromptBuilder
    def initialize(project)
        @project = project
    end

    def build_prompt(question_asked, context)
        [header, additional_context(context), questions_and_answers(question_asked )].compact.join("\n\n\n")
    end

    private
    def header
        "#{@project.prompt_header}"
    end

    def additional_context(context)
        return nil if context.blank?
        "#{@project.context_header}\n#{context}"
    end

    def questions_and_answers(question_asked)
        questions_and_answers = @project.questions_and_answers.clone
        questions_and_answers << [question_asked, ""]
        questions_and_answers.map do |question, answer| 
            "Q:#{question}\n\nA:#{answer}"
        end.join("\n\n\n")
    end
end