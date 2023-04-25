class Question < ApplicationRecord
    validates :question, presence: true, uniqueness: { scope: [:project_name, :openai_model] }
    validates :answer, presence: true
    validates :project_name, presence: true

    def self.normalize_question(question)
        question.strip.upcase_first.gsub(/\?*$/, "") + "?"
    end
end
