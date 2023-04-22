require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "valid question" do
    load_fixtures :questions
     assert Question.new(question: "What is a minimalist entrepreneur?", answer: "A minimalist entrepreneur is someone who builds a business according to eight principles, the first of which is prioritizing profitability over growth.").valid?
  end

  test "invalid without question" do
    assert_not Question.new(answer: "A minimalist entrepreneur is someone who builds a business according to eight principles, the first of which is prioritizing profitability over growth.").valid?
  end

  test "invalid without answer" do
    assert_not Question.new(question: "What is a minimalist entrepreneur?").valid?
  end

  test "invalid with duplicate question" do
    load_fixtures :questions
    assert_not Question.new(question: "What is love?", answer: "Love is fleeting.").valid?
  end

  test "normalize_question" do
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("who is Sahil Lavingia?")
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("Who is Sahil Lavingia")
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("Who is Sahil Lavingia???")
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("Who is Sahil Lavingia? ")
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("\tWho is Sahil Lavingia?")
  end
end
