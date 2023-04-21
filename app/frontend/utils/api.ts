export interface Question {
  answer: string;
}
export async function askQuestion(question: string): Promise<Question> {
  const response = await fetch("/api/questions", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ question }),
  });
  if (response.ok) {
    return response.json();
  } else {
    throw new Error("Something went wrong");
  }
}
