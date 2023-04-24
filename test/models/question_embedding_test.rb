require "test_helper"

class QuestionEmbeddingTest < ActiveSupport::TestCase
  test "valid question embedding" do
    load_fixtures :question_embeddings
     assert QuestionEmbedding.new(question: "What is a minimalist entrepreneur?", embedding: [1, 0.2, 0.001, 0.09]).valid?
  end

  test "invalid without question" do
    assert_not QuestionEmbedding.new(embedding: [1, 0.2, 0.001, 0.09]).valid?
  end

  test "invalid without embedding" do
    assert_not QuestionEmbedding.new(question: "What is a minimalist entrepreneur?").valid?
  end

  test "invalid with duplicate question" do
    load_fixtures :question_embeddings
    assert_not QuestionEmbedding.new(question: "What is love?", embedding: [1, 0.2, 0.001, 0.09]).valid?
  end
end
