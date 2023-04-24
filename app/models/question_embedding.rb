class QuestionEmbedding < ApplicationRecord
    validates :question, presence: true, uniqueness: true
    validates :embedding, presence: true
end
