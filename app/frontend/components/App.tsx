import React, { useState } from "react";
import { Question, askQuestion } from "../utils/api";
import { TypedText } from "./TypedText";

export function App() {
  const questionRef = React.useRef(null);
  const [answeredQuestion, setAnsweredQuestion] = useState<Question | null>(
    null
  );
  const [requestState, setRequestState] = useState<
    "idle" | "in-progress" | "success"
  >("idle");
  function handleReset() {
    setRequestState("idle");
    setAnsweredQuestion(null);
  }
  function submitQuestion() {
    const question = String(questionRef.current.value).trim();
    if (question.length === 0) {
      alert("Please ask a question!");
      return;
    }
    setRequestState("in-progress");
    askQuestion(question).then((result) => {
      setAnsweredQuestion(result);
      setRequestState("success");
    });
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
          disabled={requestState !== "idle"}
          defaultValue={"What is a minimalist entrepreneur?"}
          name="question"
          id="question"
          cols={30}
          rows={3}
        />
      </form>
      {requestState === "idle" && (
        <button type="button" onClick={submitQuestion}>
          Ask question
        </button>
      )}
      {requestState === "in-progress" && <p>Let me think about it...</p>}
      {answeredQuestion && (
        <p>
          <strong>Answer: </strong>
          <TypedText text={answeredQuestion.answer} />
        </p>
      )}
      {requestState === "success" && (
        <button type="button" onClick={handleReset}>
          Ask another question
        </button>
      )}
    </>
  );
}
