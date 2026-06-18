"use client";

import { useState, useEffect, useCallback } from "react";
import { useParams, useRouter } from "next/navigation";
import { works } from "@/data/works";
import type { GlossaryEntry } from "@/data/works";
import { getProgress, saveProgress } from "@/lib/store";
import EmotionMeter from "@/components/EmotionMeter";
import GlossaryPopup from "@/components/GlossaryPopup";

export default function ReadPage() {
  const params = useParams();
  const router = useRouter();
  const workId = params.workId as string;
  const work = works.find((w) => w.id === workId);

  const [currentIndex, setCurrentIndex] = useState(0);
  const [showVibes, setShowVibes] = useState(false);
  const [showEmotions, setShowEmotions] = useState(false);
  const [glossary, setGlossary] = useState<GlossaryEntry | null>(null);
  const [isReady, setIsReady] = useState(false);

  useEffect(() => {
    if (!work) return;
    const progress = getProgress(workId);
    if (progress.currentIndex < work.segments.length) {
      setCurrentIndex(progress.currentIndex);
    }
    setIsReady(true);
  }, [workId, work]);

  const handleNext = useCallback(() => {
    if (!work) return;
    if (currentIndex >= work.segments.length - 1) {
      saveProgress({ workId, currentIndex: work.segments.length, completed: true });
      router.push(`/read/${workId}/complete`);
      return;
    }
    const next = currentIndex + 1;
    setCurrentIndex(next);
    setShowVibes(false);
    setShowEmotions(false);
    saveProgress({ workId, currentIndex: next, completed: false });
  }, [currentIndex, work, workId, router]);

  if (!work) {
    return (
      <main className="flex-1 flex items-center justify-center">
        <p className="text-text-secondary">作品が見つかりません</p>
      </main>
    );
  }

  if (!isReady) return null;

  const segment = work.segments[currentIndex];
  const progress = ((currentIndex + 1) / work.segments.length) * 100;

  const renderTextWithGlossary = (text: string, glossaryItems?: GlossaryEntry[]) => {
    if (!glossaryItems || glossaryItems.length === 0) {
      return <span>{text}</span>;
    }

    let result: React.ReactNode[] = [];
    let remaining = text;
    let keyIndex = 0;

    for (const item of glossaryItems) {
      const idx = remaining.indexOf(item.word);
      if (idx === -1) continue;

      if (idx > 0) {
        result.push(<span key={`t-${keyIndex++}`}>{remaining.slice(0, idx)}</span>);
      }

      result.push(
        <button
          key={`g-${keyIndex++}`}
          onClick={(e) => {
            e.stopPropagation();
            setGlossary(item);
          }}
          className="relative inline border-b border-dashed border-accent-neon/50 text-accent-neon/90
                     hover:border-accent-neon transition-colors"
        >
          {item.word}
        </button>
      );

      remaining = remaining.slice(idx + item.word.length);
    }

    if (remaining) {
      result.push(<span key={`t-${keyIndex}`}>{remaining}</span>);
    }

    return <>{result}</>;
  };

  return (
    <main className="flex-1 flex flex-col relative">
      <header className="px-5 pt-12 pb-4 relative z-10">
        <div className="flex items-center justify-between mb-3">
          <button
            onClick={() => router.push("/home")}
            className="text-text-secondary hover:text-text-primary transition-colors text-sm"
          >
            ← 戻る
          </button>
          <p
            className="text-sm text-text-secondary"
            style={{ fontFamily: "'Noto Serif JP', serif" }}
          >
            {work.title}
          </p>
          <span className="text-xs text-text-secondary/50">
            {currentIndex + 1}/{work.segments.length}
          </span>
        </div>
        <div className="w-full h-1 bg-white/5 rounded-full overflow-hidden">
          <div
            className="progress-bar h-full rounded-full transition-all duration-500"
            style={{ width: `${progress}%` }}
          />
        </div>
      </header>

      <div className="flex-1 flex flex-col items-center justify-center px-5 py-8">
        <div
          className="card-paper rounded-2xl p-6 max-w-sm w-full animate-fade-in"
          key={currentIndex}
        >
          <p
            className="text-text-paper text-lg leading-relaxed"
            style={{ fontFamily: "'Noto Serif JP', serif" }}
          >
            {renderTextWithGlossary(segment.text, segment.glossary)}
          </p>
        </div>

        <div className="mt-6 w-full max-w-sm space-y-3">
          <button
            onClick={() => setShowVibes(!showVibes)}
            className={`w-full card-glass rounded-xl px-4 py-3 text-left transition-all duration-300 ${
              showVibes ? "border-accent-pink/30" : ""
            }`}
          >
            <p className="text-[10px] text-accent-pink uppercase tracking-wider mb-1">
              バイブス
            </p>
            <p
              className={`text-sm text-text-primary transition-all duration-300 ${
                showVibes
                  ? "opacity-100 max-h-20"
                  : "opacity-0 max-h-0 overflow-hidden"
              }`}
            >
              {segment.vibes}
            </p>
            {!showVibes && (
              <p className="text-xs text-text-secondary/50">タップして表示</p>
            )}
          </button>

          <button
            onClick={() => setShowEmotions(!showEmotions)}
            className={`w-full card-glass rounded-xl px-4 py-3 text-left transition-all duration-300 ${
              showEmotions ? "border-accent-indigo/30" : ""
            }`}
          >
            <p className="text-[10px] text-accent-neon uppercase tracking-wider mb-1">
              感情メーター
            </p>
            <div
              className={`transition-all duration-300 ${
                showEmotions
                  ? "opacity-100 max-h-40 mt-2"
                  : "opacity-0 max-h-0 overflow-hidden"
              }`}
            >
              <EmotionMeter emotions={segment.emotions} />
            </div>
            {!showEmotions && (
              <p className="text-xs text-text-secondary/50">タップして表示</p>
            )}
          </button>
        </div>
      </div>

      <div className="px-5 pb-8 flex justify-end">
        <button
          onClick={handleNext}
          className="w-16 h-16 rounded-full bg-accent-indigo text-white flex items-center justify-center
                     text-2xl shadow-lg shadow-accent-indigo/30 hover:bg-accent-neon transition-all
                     active:scale-90"
        >
          →
        </button>
      </div>

      {glossary && (
        <GlossaryPopup entry={glossary} onClose={() => setGlossary(null)} />
      )}
    </main>
  );
}
