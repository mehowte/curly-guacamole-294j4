import React, { useState } from "react";
import { Layout } from "./Layout";
import { Question } from "./Question";
import type { Project } from "../utils/types";

declare global {
  var projectsByName: Record<string, Project>;
  var defaultProjectName: string;
  var openaiModels: string[];
}

export function App() {
  const [projectName, setProjectName] = useState(window.defaultProjectName);
  const project = window.projectsByName[projectName];
  const projects = Object.values(window.projectsByName);
  const openaiModels = window.openaiModels;
  return (
    <Layout
      currentProject={project}
      projects={projects}
      onProjectChange={(project) => setProjectName(project.name)}
    >
      <Question
        key={project.name}
        project={project}
        openaiModels={openaiModels}
      />
    </Layout>
  );
}
