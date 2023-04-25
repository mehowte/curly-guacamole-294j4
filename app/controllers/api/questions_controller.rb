class Api::QuestionsController < ApiController
  def create
    if params[:question].blank?
      render json: { error: "Question cannot be empty" }, status: :unprocessable_entity
      return
    end
    project = Project.new(params[:project_id])
    question_asked = Question.normalize_question(params[:question])
    question = Question.find_by(project_name: project.name, question: question_asked)
    if question.blank?
      question_embedding = QuestionEmbedding.find_by(question: question_asked)
      if question_embedding.blank?
        question_embedding = QuestionEmbedding.create!({question: question_asked, embedding: openai_client.get_embedding(question_asked)})
      end
      context = build_context(question_embedding.embedding, project)
      answer = get_answer(question_asked, context, project)
      question = Question.create!({question: question_asked, answer: answer, context: context, project_name: project.name})
    end
    if question.audio_src_url.blank?
      request_audio_file(question)
    end
    render json: question, status: :created
  end

  def show
    question = Question.find(params[:id])
    render json: question, status: :ok
  end

  def audio
    id = params[:id]
    audio_src_url = params[:url]
    question = Question.find(id)
    question.update(audio_src_url: audio_src_url)
    render json: question, status: :ok
  end

  private

  def build_context(question_embedding, project)
    ContextBuilder.new(project).build_context(question_embedding)
  end

  def get_answer(question_asked, context, project)
    openai_client.get_completion(
      PromptBuilder.new(project).build_prompt(question_asked, context)
    )
  end

  def openai_client
    @openai_client ||= OpenaiClient.build
  end

  def request_audio_file(question)
    callback_uri = ENV['BASE_URL'] + "/api/questions/#{question.id}/audio"
    ResembleClient.build.request_audio_file(question.answer, callback_uri)
  end
end

