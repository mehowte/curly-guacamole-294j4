require "test_helper"

class HomepageControllerTest < ActionDispatch::IntegrationTest
  test "ask for existing question and get an answer and audio file" do
      post api_project_questions_url("grimm"), params: { question: "What is love?" }
      assert_response :success
      assert_equal JSON.parse(response.body)["answer"], "Baby don't hurt me."
  end

  test "ask for existing question and get answer and request audio file" do
    VCR.use_cassette(:request_audio_file, :match_requests_on => [:method, :host, :body]) do
      post api_project_questions_url("book"), params: { question: "What is the answer to the ultimate question?" }
      assert_response :success
      assert_equal JSON.parse(response.body)["answer"], "42"
    end
  end

  test "ask for non-existing question, fetch generated answer and request audio file" do
    VCR.use_cassette(:generate_answer_and_audio, :match_requests_on => [:method, :host, :body]) do
      post api_project_questions_url("grimm"), params: { question: "What did Hansel and Gretel do?" }
      assert_response :success
      assert_equal JSON.parse(response.body)["answer"], "Hansel and Gretel escaped their stepmother's plan to abandon them in the forest by Hansel leaving a trail of pebbles to help them find their way home. They eventually made it back to their father's house."
    end
  end
end
