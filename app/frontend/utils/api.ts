export interface Question {
  answer: string;
  audio_src_url: string | null;
}
export async function askQuestion(
  question: string,
  projectName: string,
  openaiModel: string
): Promise<Question> {
  const response = await fetch(`/api/projects/${projectName}/questions`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ question, openai_model: openaiModel }),
  });
  if (response.ok) {
    return response.json();
  } else {
    throw new Error("Something went wrong");
  }
}

export async function getQuestion(
  questionId: number
): Promise<Question | null> {
  const response = await fetch(`/api/questions/${questionId}`, {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  });
  if (response.ok) {
    return response.json();
  } else if (response.status === 404) {
    return null;
  } else {
    throw new Error("Something went wrong");
  }
}
