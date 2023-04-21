import React, { useState, useEffect } from "react";

export function TypedText({
  text,
  onFinished,
}: {
  text: string;
  onFinished?: () => void;
}) {
  const [typedText, setTypedText] = useState("");
  const timeoutRef = React.useRef<ReturnType<typeof setTimeout> | null>(null);
  useEffect(() => {
    setTypedText("");
    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, [text]);
  useEffect(() => {
    if (typedText.length < text.length) {
      timeoutRef.current = setTimeout(() => {
        setTypedText(text.slice(0, typedText.length + 1));
      }, Math.random() * 20 + 30);
    } else {
      onFinished?.();
    }
    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, [typedText]);

  return typedText;
}
