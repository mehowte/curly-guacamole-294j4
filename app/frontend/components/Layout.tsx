import React from "react";
import type { Project } from "../utils/types";
export function Layout({
  currentProject,
  projects,
  children,
  onProjectChange,
}: {
  currentProject: Project;
  projects: Project[];
  children: React.ReactNode;
  onProjectChange: (project: Project) => void;
}) {
  return (
    <>
      <div className="header">
        <nav>
          <ul>
            {projects.map((project) => (
              <li
                className={currentProject.name === project.name ? "active" : ""}
                onClick={() => onProjectChange(project)}
              >
                {project.title}
              </li>
            ))}
          </ul>
        </nav>
        <div className="logo">
          <img
            src={`/${currentProject.cover}`}
            alt={`${currentProject.title}'s cover`}
            loading="lazy"
          />
          <h1>Ask a book</h1>
        </div>
      </div>
      <main>
        <p className="description">
          This is an experiment in using AI to make a book's content more
          accessible. Ask a question and AI'll answer it in real-time:
        </p>
        {children}
      </main>
      <footer>
        <div className="credits">
          Project by <a href="https://twitter.com/shl">Sahil Lavingia</a> •{" "}
          <a href="https://github.com/slavingia/askmybook">Fork on GitHub</a>
          <hr />
          Rails + React version by{" "}
          <a href="https://twitter.com/mehowte">Michał Taszycki</a> •{" "}
          <a href="https://github.com/mehowte/curly-guacamole-294j4">
            Fork on GitHub
          </a>
        </div>
      </footer>
    </>
  );
}
