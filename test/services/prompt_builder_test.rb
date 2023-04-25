require "test_helper"


class PromptBuilderTest < ActiveSupport::TestCase
    def setup
        project = OpenStruct.new({
            prompt_header: "HEADER",
            context_header: "CONTEXT_HEADER",
            questions_and_answers: [["Q1", "A1"], ["Q2", "A2"],]
        })
        @builder = PromptBuilder.new(project)
    end
  test "builds prompt with context" do
    expected_prompt = <<~PROMPT.strip
      HEADER


      CONTEXT_HEADER
      CONTEXT


      Q:Q1
      
      A:A1


      Q:Q2

      A:A2


      Q:QUESTION

      A:
    PROMPT
    assert_equal expected_prompt, @builder.build_prompt("QUESTION", "CONTEXT")
  end

  test "builds prompt without context" do
    expected_prompt = <<~PROMPT.strip
      HEADER


      Q:Q1
      
      A:A1


      Q:Q2

      A:A2


      Q:QUESTION

      A:
    PROMPT
    assert_equal expected_prompt, @builder.build_prompt("QUESTION", nil)
  end
end