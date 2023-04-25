module ApplicationHelper
    def project
        project = Project.build
        { 
            name: project.name,
            title: project.title, 
            cover: project.cover, 
            sampleQuestions: project.sample_questions 
        }
    end
end
