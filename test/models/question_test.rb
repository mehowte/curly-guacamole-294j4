require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "valid question" do
    load_fixtures :questions
     assert Question.new(project_name: "grimm", question: "What is a minimalist entrepreneur?", answer: "A minimalist entrepreneur is someone who builds a business according to eight principles, the first of which is prioritizing profitability over growth.", openai_model: "text-davinci-003").valid?
  end

  test "invalid without question" do
    assert_not Question.new(project_name: "grimm", answer: "A minimalist entrepreneur is someone who builds a business according to eight principles, the first of which is prioritizing profitability over growth.", openai_model: "text-davinci-003").valid?
  end

  test "invalid without answer" do
    assert_not Question.new(project_name: "grimm", question: "What is a minimalist entrepreneur?", openai_model: "text-davinci-003").valid?
  end

  test "invalid without project_name" do
    assert_not Question.new(project_name: nil, question: "What is a minimalist entrepreneur?", answer: "A minimalist entrepreneur is someone who builds a business according to eight principles, the first of which is prioritizing profitability over growth.", openai_model: "text-davinci-003").valid?
  end

  test "invalid with duplicated question in the same project and openai_model" do
    load_fixtures :questions
    assert_not Question.new(project_name: "grimm", question: "What is love?", answer: "Love is fleeting.", openai_model: "text-davinci-003").valid?
  end

  test "valid with the same question in a different project" do
    load_fixtures :questions
    assert Question.new(project_name: "book", question: "What is love?", answer: "Shrek is love, Shrek is life.", openai_model: "text-davinci-003").valid?
  end

  test "valid with the same question with a different openai_model" do
    load_fixtures :questions
    assert Question.new(project_name: "grimm", question: "What is love?", answer: "Love is fleeting.", openai_model: "gpt-3.5.turbo").valid?
  end

  test "normalize_question" do
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("who is Sahil Lavingia?")
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("Who is Sahil Lavingia")
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("Who is Sahil Lavingia???")
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("Who is Sahil Lavingia? ")
    assert_equal "Who is Sahil Lavingia?", Question.normalize_question("\tWho is Sahil Lavingia?")
  end
end
