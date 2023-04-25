require "test_helper"


class MessagesBuilderTest < ActiveSupport::TestCase
    def setup
        project = OpenStruct.new({
            prompt_header: "HEADER",
            context_header: "CONTEXT_HEADER",
            questions_and_answers: [["Q1", "A1"], ["Q2", "A2"],]
        })
        @builder = MessagesBuilder.new(project)
    end
  test "builds messages with context" do
    assert_equal [
        { role: "system", content: "You are a helpful assistant. You answer questions related to a book and it's author." },
        { role: "user", content: "HEADER\n\n\nCONTEXT_HEADER\nCONTEXT" },
        { role: "user", content: "Q1" },
        { role: "assistant", content: "A1" },
        { role: "user", content: "Q2" },
        { role: "assistant", content: "A2" },
        { role: "user", content: "QUESTION" },
    ], @builder.build_messages("QUESTION", "CONTEXT")
  end

  test "builds messages without context" do
    assert_equal [
        { role: "system", content: "You are a helpful assistant. You answer questions related to a book and it's author." },
        { role: "user", content: "HEADER" },
        { role: "user", content: "Q1" },
        { role: "assistant", content: "A1" },
        { role: "user", content: "Q2" },
        { role: "assistant", content: "A2" },
        { role: "user", content: "QUESTION" },
    ], @builder.build_messages("QUESTION", nil)
  end
end