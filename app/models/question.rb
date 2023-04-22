class Question < ApplicationRecord
    validates :question, presence: true, uniqueness: true
    validates :answer, presence: true
end
