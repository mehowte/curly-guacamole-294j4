require "test_helper"

class HomepageControllerTest < ActionDispatch::IntegrationTest
  test "ask for existing question and get an answer and audio file" do
      post api_questions_url, params: { question: "What is love?" }
      assert_response :success
      assert_equal JSON.parse(response.body)["answer"], "Baby don't hurt me."
  end

  test "ask for existing question and get answer and request audio file" do
    VCR.use_cassette(:request_audio_file) do
      post api_questions_url, params: { question: "What is the answer to the ultimate question?" }
      assert_response :success
      assert_equal JSON.parse(response.body)["answer"], "42"
    end
  end

  test "ask for non-existing question, fetch generated answer and request audio file" do
    VCR.use_cassette(:generate_answer_and_audio) do
      post api_questions_url, params: { question: "What did Hansel and Gretel do?" }
      assert_response :success
      assert_equal JSON.parse(response.body)["answer"], "Hansel and Gretel were two children who were abandoned in the forest by their stepmother. Hansel used pebbles to mark their path so they could find their way back home. They eventually made it back home safely."
    end
  end
end
