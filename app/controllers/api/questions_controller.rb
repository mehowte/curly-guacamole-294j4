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

  def audio
    id = params[:id]
    audio_src_url = params[:url]
    question = Question.find(id)
    question.update(audio_src_url: audio_src_url)
    render json: question, status: :ok
  end
end

def generate_answer(question_asked)
   OpenaiClient.build.generate_answer(question_asked)
end