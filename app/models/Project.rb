class Project
    def self.build
        new(ENV["DEFAULT_PROJECT"])
    end

    def self.all
        ENV["PROJECTS"].split(",").map { |project_name| new(project_name) } 
    end

    def initialize(name)
        @name = name
        @config = YAML.load_file(file_path("#{name}.yaml"))
    end

    def name
        @name
    end

    def title
        @config["title"]
    end

    def cover
        @config["cover"]
    end

    def sample_questions
        @config["sample_questions"]
    end

    def questions_and_answers
        @config["questions_and_answers"]
    end

    def prompt_header
        @config["prompt_header"]
    end

    def context_header
        @config["context_header"]
    end

    def fragments_file_path
        file_path("#{@name}.pdf.pages.csv")
    end

    def embeddings_file_path
        file_path("#{@name}.pdf.embeddings.csv")
    end

    private
    def file_path(file_name)
        Rails.root.join("static_files", file_name)
    end
end