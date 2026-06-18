"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import {
  works,
  authors,
  emotionEmojis,
  emotionColors,
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

export default function WorksPage() {
  const router = useRouter();
  const [selectedTag, setSelectedTag] = useState<EmotionTag | null>(null);

  const filteredWorks = selectedTag
    ? works.filter((w) => w.tags.includes(selectedTag))
    : works;

  return (
    <main className="flex-1 pb-8">
      <header className="px-5 pt-12 pb-4">
        <button
          onClick={() => router.push("/home")}
          className="text-text-secondary hover:text-text-primary transition-colors text-sm"
        >
          ← 戻る
        </button>
        <h1
          className="text-2xl font-bold mt-3"
          style={{ fontFamily: "'Noto Serif JP', serif" }}
        >
          作品一覧
        </h1>
      </header>

      <section className="px-5 mb-6">
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => setSelectedTag(null)}
            className={`px-3 py-1.5 rounded-full text-xs transition-all ${
              selectedTag === null
                ? "bg-accent-indigo text-white"
                : "card-glass text-text-secondary"
            }`}
          >
            すべて
          </button>
          {allTags.map((tag) => (
            <button
              key={tag}
              onClick={() => setSelectedTag(tag)}
              className={`px-3 py-1.5 rounded-full text-xs transition-all ${
                selectedTag === tag
                  ? "text-white shadow-lg"
                  : "card-glass text-text-secondary"
              }`}
              style={
                selectedTag === tag
                  ? { backgroundColor: emotionColors[tag] }
                  : undefined
              }
            >
              {emotionEmojis[tag]} {tag}
            </button>
          ))}
        </div>
      </section>

      <section className="px-5">
        <p className="text-xs text-text-secondary mb-4">
          {filteredWorks.length}作品
        </p>
        <div className="flex flex-col gap-3">
          {filteredWorks.map((work, i) => {
            const author = authors.find((a) => a.id === work.authorId);
            return (
              <button
                key={work.id}
                onClick={() => router.push(`/read/${work.id}`)}
                className="card-glass rounded-2xl p-5 text-left transition-all
                           hover:border-accent-indigo/30 active:scale-[0.98]
                           animate-fade-in-up"
                style={{ animationDelay: `${i * 60}ms` }}
              >
                <div className="flex items-start gap-4">
                  <span className="text-4xl mt-1">{work.coverEmoji}</span>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-1">
                      <h3
                        className="text-lg font-medium"
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
                      {author?.icon} {work.authorName} ・ {work.readTime}
                    </p>
                    <p className="text-sm text-text-secondary/70 mb-3">
                      {work.description}
                    </p>
                    <div className="flex flex-wrap gap-1.5">
                      {work.tags.map((tag) => (
                        <span
                          key={tag}
                          className="text-[10px] px-2 py-0.5 rounded-full"
                          style={{
                            backgroundColor: `${emotionColors[tag]}15`,
                            color: emotionColors[tag],
                          }}
                        >
                          {emotionEmojis[tag]} {tag}
                        </span>
                      ))}
                    </div>
                  </div>
                </div>
              </button>
            );
          })}
        </div>
      </section>
    </main>
  );
}
