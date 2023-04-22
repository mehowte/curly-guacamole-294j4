import React, { useEffect, useRef } from "react";

export function AutoplayAudio({ src }: { src: string }) {
  const audioRef = useRef<HTMLAudioElement>(null);
  useEffect(() => {
    const audio = audioRef.current!;
    audio.volume = 0.3;
    audio.play();
  }, []);
  return (
    <audio ref={audioRef} controls={false}>
      <source src={src} />
    </audio>
  );
}
