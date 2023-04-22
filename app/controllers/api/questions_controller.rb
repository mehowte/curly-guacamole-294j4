class Api::QuestionsController < ApiController
  def create
    if params[:question].blank?
      render json: { error: "Question cannot be empty" }, status: :unprocessable_entity
      return
    end
    question_asked = Question.normalize_question(params[:question])
    question = Question.find_by(question: question_asked)
    if question.blank?
      question = Question.create!({question: question_asked, answer: generate_answer(question_asked)})
    end
    render json: question, status: :created
  end
end

SAMPLE_QUESTIONS = {
  "What is a minimalist entrepreneur?" => "A minimalist entrepreneur is someone who builds a business according to eight principles, the first of which is prioritizing profitability over growth.",
  "Who is Sahil Lavingia?" => "Sahil Lavingia is the founder of Gumroad, a minimalist entrepreneur, and the author of Minimalist Entrepreneurship.",
}

def generate_answer(question_asked)
  answer = SAMPLE_QUESTIONS[question_asked] 
  return "I don't know the answer to that question." if answer.blank?
  answer
end