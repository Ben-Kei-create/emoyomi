"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import {
  works,
  authors,
  emotionEmojis,
  type EmotionTag,
} from "@/data/works";

const allTags: EmotionTag[] = [
  "孤独",
  "不安",
  "嫉妬",
  "希望",
  "怒り",
  "恋愛",
  "罪悪感",
  "生きづらさ",
  "青春",
  "絶望",
  "自己嫌悪",
  "承認欲求",
];

export default function HomePage() {
  const router = useRouter();
  const [selectedTag, setSelectedTag] = useState<EmotionTag | null>(null);

  const filteredWorks = selectedTag
    ? works.filter((w) => w.tags.includes(selectedTag))
    : works;

  return (
    <main className="flex-1 pb-8">
      <header className="px-5 pt-12 pb-6">
        <div className="flex items-center justify-between mb-1">
          <h1
            className="text-2xl font-bold text-gradient"
            style={{ fontFamily: "'Noto Serif JP', serif" }}
          >
            よむエモ
          </h1>
          <button
            onClick={() => router.push("/premium")}
            className="text-xs px-3 py-1.5 rounded-full border border-accent-warm/30 text-accent-warm
                       hover:bg-accent-warm/10 transition-colors"
          >
            Premium
          </button>
        </div>
        <p className="text-text-secondary text-sm">
          今日はどんな気分？
        </p>
      </header>

      <section className="px-5 mb-8">
        <h2 className="text-xs text-text-secondary mb-3 uppercase tracking-wider">
          感情から選ぶ
        </h2>
        <div className="flex flex-wrap gap-2">
          {allTags.map((tag) => (
            <button
              key={tag}
              onClick={() =>
                setSelectedTag(selectedTag === tag ? null : tag)
              }
              className={`px-3.5 py-2 rounded-full text-sm transition-all duration-200 ${
                selectedTag === tag
                  ? "bg-accent-indigo text-white shadow-lg shadow-accent-indigo/30"
                  : "card-glass text-text-secondary hover:text-text-primary"
              }`}
            >
              {emotionEmojis[tag]} {tag}
            </button>
          ))}
        </div>
      </section>

      <section className="px-5 mb-8">
        <h2 className="text-xs text-text-secondary mb-4 uppercase tracking-wider">
          {selectedTag ? `「${selectedTag}」の作品` : "すべての作品"}
        </h2>
        <div className="flex flex-col gap-3">
          {filteredWorks.map((work, i) => (
            <button
              key={work.id}
              onClick={() => router.push(`/read/${work.id}`)}
              className="card-glass rounded-2xl p-4 text-left transition-all duration-200
                         hover:border-accent-indigo/30 active:scale-[0.98]
                         animate-fade-in-up"
              style={{ animationDelay: `${i * 80}ms` }}
            >
              <div className="flex items-start gap-3">
                <span className="text-3xl mt-0.5">{work.coverEmoji}</span>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-1">
                    <h3
                      className="text-base font-medium text-text-primary"
                      style={{ fontFamily: "'Noto Serif JP', serif" }}
                    >
                      {work.title}
                    </h3>
                    {work.premium && (
                      <span className="text-[10px] px-1.5 py-0.5 rounded-full bg-accent-warm/20 text-accent-warm">
                        Premium
                      </span>
                    )}
                  </div>
                  <p className="text-xs text-text-secondary mb-2">
                    {work.authorName} ・ {work.readTime}
                  </p>
                  <p className="text-xs text-text-secondary/70 line-clamp-1">
                    {work.description}
                  </p>
                  <div className="flex gap-1.5 mt-2">
                    {work.tags.map((tag) => (
                      <span
                        key={tag}
                        className="text-[10px] px-2 py-0.5 rounded-full bg-white/5 text-text-secondary/60"
                      >
                        {tag}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            </button>
          ))}
        </div>
      </section>

      <section className="px-5">
        <h2 className="text-xs text-text-secondary mb-4 uppercase tracking-wider">
          文豪たち
        </h2>
        <div className="flex gap-3 overflow-x-auto pb-2 -mx-5 px-5 scrollbar-hide">
          {authors.map((author) => (
            <button
              key={author.id}
              onClick={() => router.push(`/author/${author.id}`)}
              className="flex-shrink-0 card-glass rounded-2xl p-4 w-40 text-left
                         hover:border-accent-indigo/30 transition-all active:scale-[0.98]"
            >
              <span className="text-2xl block mb-2">{author.icon}</span>
              <p
                className="text-sm font-medium mb-1"
                style={{ fontFamily: "'Noto Serif JP', serif" }}
              >
                {author.name}
              </p>
              <p className="text-[10px] text-text-secondary line-clamp-2">
                {author.bio}
              </p>
            </button>
          ))}
        </div>
      </section>
    </main>
  );
}
