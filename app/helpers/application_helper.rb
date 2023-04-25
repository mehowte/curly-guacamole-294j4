module ApplicationHelper
    def default_project_name
        ENV["DEFAULT_PROJECT"]
    end

    def projects_by_name
        Project.all.map do |project| 
            [
                project.name, 
                { 
                    name: project.name,
                    title: project.title, 
                    cover: project.cover, 
                    sampleQuestions: project.sample_questions 
                }
            ] 
        end.to_h
    end

    def openai_models
        OpenaiClient::VALID_CHAT_AND_COMPLETION_MODELS
    end
end
