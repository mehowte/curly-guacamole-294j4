import React, { useState, useEffect } from "react";
import { Question, askQuestion, getQuestion } from "../utils/api";
import { TypedText } from "./TypedText";
import { AutoplayAudio } from "./AutoplayAudio";

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
const MAX_QUESTION_REFRESH_RETRIES = 10;
const QUESTION_REFRESH_INTERVAL = 1500;

export function App() {
  const questionRef = React.useRef(null);
  const [answeredQuestion, setAnsweredQuestion] = useState<Question | null>(
    null
  );
  const [questionRefreshRetryCount, setQuestionRefreshRetryCount] = useState(
    MAX_QUESTION_REFRESH_RETRIES
  );
  useEffect(() => {
    if (!answeredQuestion) return;
    if (answeredQuestion.audio_src_url) return;
    if (questionRefreshRetryCount <= 0) return;
    const timeout = setTimeout(() => {
      getQuestion(answeredQuestion.id)
        .then((result) => {
          if (result) {
            setAnsweredQuestion(result);
            setQuestionRefreshRetryCount((prev) => prev - 1);
          }
        })
        .catch(console.error);
    }, QUESTION_REFRESH_INTERVAL);
    return () => clearTimeout(timeout);
  }, [answeredQuestion, questionRefreshRetryCount]);
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
    setQuestionRefreshRetryCount(MAX_QUESTION_REFRESH_RETRIES);
  }
  return (
    <>
      <div className="header">
        <div className="logo">
          <img src="/book.png" alt="Book cover" loading="lazy" />
          <h1>Ask a book</h1>
        </div>
      </div>
      <main>
        <p className="description">
          This is an experiment in using AI to make a book's content more
          accessible. Ask a question and AI'll answer it in real-time:
        </p>
        <form>
          <textarea
            ref={questionRef}
            disabled={requestState !== "idle"}
            defaultValue={EXAMPLE_QUESTIONS[0]}
            name="question"
            id="question"
            cols={30}
            rows={3}
          />
        </form>
        {requestState === "idle" && (
          <div className="buttons">
            <button type="button" onClick={submitQuestion}>
              Ask question
            </button>
            <button
              type="button"
              onClick={handleFeelingLuckyClick}
              className="secondary"
            >
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
        {answeredQuestion?.audio_src_url && (
          <AutoplayAudio src={answeredQuestion.audio_src_url} />
        )}

        {requestState === "error" && (
          <p>
            An error occured and I couldn't answer your question. Please try
            again later...
          </p>
        )}
        {(requestState === "finished" || requestState === "error") && (
          <button type="button" onClick={handleReset}>
            Ask another question
          </button>
        )}
      </main>
      <footer>
        <p className="credits">
          Project by <a href="https://twitter.com/shl">Sahil Lavingia</a> •{" "}
          <a href="https://github.com/slavingia/askmybook">Fork on GitHub</a>
          <hr />
          Rails + React version by{" "}
          <a href="https://twitter.com/mehowte">Michał Taszycki</a> •{" "}
          <a href="https://github.com/mehowte/curly-guacamole-294j4">
            Fork on GitHub
          </a>
        </p>
      </footer>
    </>
  );
}
