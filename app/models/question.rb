class Question < ApplicationRecord
    validates :question, presence: true, uniqueness: true
    validates :answer, presence: true

    def self.normalize_question(question)
        question.strip.upcase_first.gsub(/\?*$/, "") + "?"
    end
end
