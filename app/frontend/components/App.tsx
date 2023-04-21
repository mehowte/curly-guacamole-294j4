import React, { useState } from "react";
import { Question, askQuestion } from "../utils/api";
import { TypedText } from "./TypedText";

const EXAMPLE_QUESTIONS = [
  "What is a minimalist entrepreneur?",
  "What is your definition of community?",
  "How do I decide what kind of business I should start?",
] as const;

function generateRandomQuestion() {
  return EXAMPLE_QUESTIONS[
    Math.floor(Math.random() * EXAMPLE_QUESTIONS.length)
  ];
}

export function App() {
  const questionRef = React.useRef(null);
  const [answeredQuestion, setAnsweredQuestion] = useState<Question | null>(
    null
  );
  const [requestState, setRequestState] = useState<
    "idle" | "in-progress" | "success" | "finished" | "error"
  >("idle");
  function handleFeelingLuckyClick() {
    questionRef.current.value = generateRandomQuestion();
    submitQuestion();
  }
  function submitQuestion() {
    const question = String(questionRef.current.value).trim();
    if (question.length === 0) {
      alert("Please ask a question!");
      return;
    }
    setRequestState("in-progress");
    askQuestion(question)
      .then((result) => {
        setAnsweredQuestion(result);
        setRequestState("success");
      })
      .catch(() => {
        setRequestState("error");
      });
  }
  function handleFinishTyping() {
    setRequestState("finished");
  }
  function handleReset() {
    setRequestState("idle");
    setAnsweredQuestion(null);
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
        <div>
          <button type="button" onClick={submitQuestion}>
            Ask question
          </button>
          <button type="button" onClick={handleFeelingLuckyClick}>
            Feeling lucky
          </button>
        </div>
      )}
      {requestState === "in-progress" && <p>Let me think about it...</p>}
      {answeredQuestion && (
        <p>
          <strong>Answer: </strong>
          <TypedText
            text={answeredQuestion.answer}
            onFinished={handleFinishTyping}
          />
        </p>
      )}
      {requestState === "error" && (
        <p>
          An error occured and I couldn't answer your question. Please try again
          later...
        </p>
      )}
      {(requestState === "finished" || requestState === "error") && (
        <button type="button" onClick={handleReset}>
          Ask another question
        </button>
      )}
    </>
  );
}
