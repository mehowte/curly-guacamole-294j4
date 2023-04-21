import React from "react";
import { askQuestion } from "../utils/api";

export function App() {
  const questionRef = React.useRef(null);
  function submitQuestion() {
    const question = String(questionRef.current.value).trim();
    if (question.length === 0) {
      alert("Please ask a question!");
      return;
    }
    askQuestion(question).then(console.log);
  }
  return (
    <>
      <h1>Ask my book</h1>
      <p>
        This is an experiment in using AI to make my book's content more
        accessible. Ask a question and AI'll answer it in real-time:
      </p>
      <form>
        <textarea
          ref={questionRef}
          defaultValue={"What is a minimalist entrepreneur?"}
          name="question"
          id="question"
          cols={30}
          rows={3}
        />
      </form>
      <button type="button" onClick={submitQuestion}>
        Ask question
      </button>
    </>
  );
}
