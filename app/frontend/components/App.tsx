import React from "react";
import { Layout } from "./Layout";
import { Question } from "./Question";

declare global {
  var project: {
    name: string;
    title: string;
    cover: string;
    sampleQuestions: string[];
  };
}

export function App() {
  return (
    <Layout>
      <Question />
    </Layout>
  );
}
