import React, { useState } from "react";

export function App() {
  const [count, setCount] = useState(0);
  return (
    <>
      <h1>Hello React</h1>
      <p>clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>Click me</button>
    </>
  );
}
