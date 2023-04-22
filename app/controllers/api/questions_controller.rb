class Api::QuestionsController < ApiController
  def create
    if params[:question].blank?
      render json: { error: "Question cannot be empty" }, status: :unprocessable_entity
      return
    end
    question = { answer: "A minimalist entrepreneur is someone who builds a business according to eight principles, the first of which is prioritizing profitability over growth." }
    render json: question, status: :created
  end
end
