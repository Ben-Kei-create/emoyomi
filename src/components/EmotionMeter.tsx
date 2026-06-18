"use client";

import { emotionColors, emotionEmojis, type EmotionTag } from "@/data/works";

interface Props {
  emotions: Partial<Record<EmotionTag, number>>;
}

export default function EmotionMeter({ emotions }: Props) {
  const entries = Object.entries(emotions) as [EmotionTag, number][];
  if (entries.length === 0) return null;

  const sorted = entries.sort((a, b) => b[1] - a[1]);

  return (
    <div className="flex flex-col gap-2">
      {sorted.map(([tag, value]) => (
        <div key={tag} className="flex items-center gap-2">
          <span className="text-xs w-5 text-center">
            {emotionEmojis[tag]}
          </span>
          <span className="text-[10px] text-text-secondary w-16 truncate">
            {tag}
          </span>
          <div className="flex-1 h-1.5 bg-white/5 rounded-full overflow-hidden">
            <div
              className="h-full rounded-full transition-all duration-700 ease-out"
              style={{
                width: `${value}%`,
                backgroundColor: emotionColors[tag],
              }}
            />
          </div>
          <span className="text-[10px] text-text-secondary/50 w-6 text-right">
            {value}
          </span>
        </div>
      ))}
    </div>
  );
}
