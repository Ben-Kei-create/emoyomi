"use client";

import { useParams, useRouter } from "next/navigation";
import { authors, works, emotionEmojis, emotionColors } from "@/data/works";

export default function AuthorPage() {
  const params = useParams();
  const router = useRouter();
  const authorId = params.authorId as string;
  const author = authors.find((a) => a.id === authorId);

  if (!author) {
    return (
      <main className="flex-1 flex items-center justify-center">
        <p className="text-text-secondary">文豪が見つかりません</p>
      </main>
    );
  }

  const authorWorks = works.filter((w) => w.authorId === authorId);

  return (
    <main className="flex-1 pb-8">
      <header className="px-5 pt-12 pb-4">
        <button
          onClick={() => router.push("/home")}
          className="text-text-secondary hover:text-text-primary transition-colors text-sm"
        >
          ← 戻る
        </button>
      </header>

      <div className="px-5">
        <div className="card-glass rounded-2xl p-6 mb-6 animate-fade-in-up">
          <div className="flex items-start gap-4 mb-4">
            <div className="w-16 h-16 rounded-full bg-accent-indigo/20 flex items-center justify-center text-3xl">
              {author.icon}
            </div>
            <div className="flex-1">
              <h1
                className="text-2xl font-bold mb-1"
                style={{ fontFamily: "'Noto Serif JP', serif" }}
              >
                {author.name}
              </h1>
              <p className="text-xs text-text-secondary">
                {author.born}–{author.died}
              </p>
            </div>
          </div>

          <p className="text-sm text-text-primary leading-relaxed mb-4">
            {author.bio}
          </p>

          <div className="flex flex-wrap gap-2">
            {author.tags.map((tag) => (
              <span
                key={tag}
                className="text-xs px-3 py-1.5 rounded-full flex items-center gap-1"
                style={{
                  backgroundColor: `${emotionColors[tag]}20`,
                  color: emotionColors[tag],
                }}
              >
                {emotionEmojis[tag]} {tag}
              </span>
            ))}
          </div>
        </div>

        <h2
          className="text-xs text-text-secondary mb-4 uppercase tracking-wider"
          style={{ animationDelay: "200ms" }}
        >
          作品
        </h2>

        <div className="flex flex-col gap-3">
          {authorWorks.map((work, i) => (
            <button
              key={work.id}
              onClick={() => router.push(`/read/${work.id}`)}
              className="card-glass rounded-2xl p-4 text-left transition-all
                         hover:border-accent-indigo/30 active:scale-[0.98]
                         animate-fade-in-up"
              style={{ animationDelay: `${(i + 1) * 100}ms` }}
            >
              <div className="flex items-center gap-3">
                <span className="text-2xl">{work.coverEmoji}</span>
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1">
                    <h3
                      className="text-base font-medium"
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
                  <p className="text-xs text-text-secondary">
                    {work.readTime}
                  </p>
                  <p className="text-xs text-text-secondary/60 mt-1 line-clamp-1">
                    {work.description}
                  </p>
                </div>
              </div>
            </button>
          ))}
        </div>
      </div>
    </main>
  );
}
