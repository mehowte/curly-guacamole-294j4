import React, { useState, useEffect } from "react";
import { Question, askQuestion, getQuestion } from "../utils/api";
import { TypedText } from "./TypedText";
import { AutoplayAudio } from "./AutoplayAudio";
import type { Project } from "../utils/types";

const MAX_QUESTION_REFRESH_RETRIES = 10;
const QUESTION_REFRESH_INTERVAL = 1500;

export function Question({ project }: { project: Project }) {
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
    questionRef.current.value = generateRandomQuestion(project.sampleQuestions);
    submitQuestion();
  }
  function submitQuestion() {
    const question = String(questionRef.current.value).trim();
    if (question.length === 0) {
      alert("Please ask a question!");
      return;
    }
    setRequestState("in-progress");
    askQuestion(question, project.name)
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
      <form>
        <textarea
          key={project.name}
          ref={questionRef}
          disabled={requestState !== "idle"}
          defaultValue={project.sampleQuestions[0] ?? ""}
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

function generateRandomQuestion(sampleQuestions) {
  return sampleQuestions[Math.floor(Math.random() * sampleQuestions.length)];
}
