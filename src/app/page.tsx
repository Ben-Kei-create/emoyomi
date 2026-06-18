"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";

export default function WelcomePage() {
  const router = useRouter();
  const [show, setShow] = useState(false);

  useEffect(() => {
    setShow(true);
  }, []);

  return (
    <main className="flex-1 flex flex-col items-center justify-center px-6 relative overflow-hidden">
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute top-1/4 left-1/4 w-64 h-64 bg-accent-indigo/10 rounded-full blur-3xl" />
        <div className="absolute bottom-1/3 right-1/4 w-48 h-48 bg-accent-pink/10 rounded-full blur-3xl" />
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-accent-neon/5 rounded-full blur-3xl" />
      </div>

      <div
        className={`relative z-10 text-center transition-all duration-1000 ${
          show ? "opacity-100 translate-y-0" : "opacity-0 translate-y-8"
        }`}
      >
        <div className="mb-8">
          <span className="text-6xl">📖</span>
        </div>

        <h1
          className="text-5xl font-bold mb-4 tracking-tight"
          style={{ fontFamily: "'Noto Serif JP', serif" }}
        >
          <span className="text-gradient">よむエモ</span>
        </h1>

        <p className="text-text-secondary text-lg mb-2 font-light">
          100年前の感情を、覗いてみよう。
        </p>
        <p className="text-text-secondary/60 text-sm mb-12">
          純文学 × タップ読書 × バイブス解説
        </p>

        <button
          onClick={() => router.push("/home")}
          className="relative px-10 py-4 bg-accent-indigo text-white rounded-full text-lg font-medium
                     hover:bg-accent-neon transition-all duration-300 animate-pulse-glow
                     active:scale-95"
        >
          はじめる
        </button>

        <div
          className={`mt-16 flex gap-8 text-text-secondary/40 text-xs transition-all duration-1000 delay-500 ${
            show ? "opacity-100" : "opacity-0"
          }`}
        >
          <span>太宰治</span>
          <span>芥川龍之介</span>
          <span>夏目漱石</span>
          <span>宮沢賢治</span>
        </div>
      </div>
    </main>
  );
}
