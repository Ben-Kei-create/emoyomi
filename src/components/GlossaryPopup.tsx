"use client";

import type { GlossaryEntry } from "@/data/works";

interface Props {
  entry: GlossaryEntry;
  onClose: () => void;
}

export default function GlossaryPopup({ entry, onClose }: Props) {
  return (
    <div
      className="fixed inset-0 z-50 flex items-end justify-center"
      onClick={onClose}
    >
      <div className="absolute inset-0 bg-black/60" />
      <div
        className="relative w-full max-w-md mx-4 mb-8 animate-slide-up"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="card-glass rounded-2xl p-5">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3
                className="text-xl font-bold text-text-primary"
                style={{ fontFamily: "'Noto Serif JP', serif" }}
              >
                {entry.word}
              </h3>
              <p className="text-xs text-accent-neon mt-0.5">
                {entry.reading}
              </p>
            </div>
            <button
              onClick={onClose}
              className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center
                         text-text-secondary hover:bg-white/10 transition-colors"
            >
              ✕
            </button>
          </div>

          <div className="space-y-3">
            <div>
              <p className="text-[10px] text-text-secondary uppercase tracking-wider mb-1">
                意味
              </p>
              <p className="text-sm text-text-primary">{entry.meaning}</p>
            </div>
            <div className="border-t border-border-subtle pt-3">
              <p className="text-[10px] text-accent-pink uppercase tracking-wider mb-1">
                バイブス訳
              </p>
              <p className="text-sm text-text-primary">{entry.vibes}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
