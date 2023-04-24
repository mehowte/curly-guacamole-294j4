import React from "react";

export function Layout({ children }: { children: React.ReactNode }) {
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
        {children}
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
