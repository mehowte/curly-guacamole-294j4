require "test_helper"

class HomepageControllerTest < ActionDispatch::IntegrationTest
  test "ask for existing question and get an answer and audio file" do
      post api_project_questions_url("grimm"), params: { question: "What is love?" }
      assert_response :success
      assert_equal "Baby don't hurt me.", JSON.parse(response.body)["answer"]
  end

  test "ask for existing question and get answer and request audio file" do
    VCR.use_cassette(:request_audio_file, :match_requests_on => [:method, :host]) do
      post api_project_questions_url("book"), params: { question: "What is the answer to the ultimate question?" }
      assert_response :success
      assert_equal "42", JSON.parse(response.body)["answer"]
    end
  end

  test "ask for non-existing question, fetch generated answer and request audio file" do
    VCR.use_cassette(:generate_answer_and_audio, :match_requests_on => [:method, :host]) do
      post api_project_questions_url("grimm"), params: { question: "What did Hansel and Gretel do?" }
      assert_response :success
      assert_equal "Hansel and Gretel escaped their stepmother's plan to abandon them in the forest by Hansel leaving a trail of pebbles to help them find their way home. They eventually made it back to their father's house.", JSON.parse(response.body)["answer"]
    end
  end

  test "ask for non-existing chat question, fetch generated answer and request audio file" do
    VCR.use_cassette(:generate_chat_answer_and_audio, :match_requests_on => [:method, :host]) do
      post api_project_questions_url("grimm"), params: { question: "What did Hansel and Gretel do?", openai_model: "gpt-3.5-turbo" }
      assert_response :success
      assert_equal "Hansel and Gretel were two children who got lost in the forest after their parents left them there. They eventually found a gingerbread house, which belonged to a wicked witch who wanted to eat them. However, they managed to outsmart the witch and escape from her clutches.", JSON.parse(response.body)["answer"]
    end
  end
end
