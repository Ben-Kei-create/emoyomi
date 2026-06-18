"use client";

import { useParams, useRouter } from "next/navigation";
import { works, emotionEmojis } from "@/data/works";

export default function CompletePage() {
  const params = useParams();
  const router = useRouter();
  const workId = params.workId as string;
  const work = works.find((w) => w.id === workId);

  if (!work) {
    return (
      <main className="flex-1 flex items-center justify-center">
        <p className="text-text-secondary">作品が見つかりません</p>
      </main>
    );
  }

  return (
    <main className="flex-1 flex flex-col px-5 py-12">
      <div className="flex-1 flex flex-col items-center justify-center text-center">
        <div className="mb-6 animate-fade-in">
          <span className="text-6xl">{work.coverEmoji}</span>
        </div>

        <h1
          className="text-2xl font-bold mb-2 animate-fade-in-up"
          style={{
            fontFamily: "'Noto Serif JP', serif",
            animationDelay: "200ms",
          }}
        >
          読了
        </h1>
        <p
          className="text-text-secondary text-sm mb-8 animate-fade-in-up"
          style={{ animationDelay: "300ms" }}
        >
          {work.title} ── {work.authorName}
        </p>

        <div
          className="w-full max-w-sm space-y-4 animate-fade-in-up"
          style={{ animationDelay: "400ms" }}
        >
          <div className="card-glass rounded-2xl p-5 text-left">
            <p className="text-[10px] text-accent-neon uppercase tracking-wider mb-2">
              テーマ
            </p>
            <p className="text-sm text-text-primary leading-relaxed">
              {work.afterword.theme}
            </p>
          </div>

          <div className="card-glass rounded-2xl p-5 text-left">
            <p className="text-[10px] text-accent-pink uppercase tracking-wider mb-2">
              刺さるポイント
            </p>
            <p className="text-sm text-text-primary leading-relaxed">
              {work.afterword.point}
            </p>
          </div>

          <div className="card-glass rounded-2xl p-5 text-left">
            <p className="text-[10px] text-accent-warm uppercase tracking-wider mb-2">
              現代との共通点
            </p>
            <p className="text-sm text-text-primary leading-relaxed">
              {work.afterword.modern}
            </p>
          </div>

          <div className="card-glass rounded-2xl p-4 text-left">
            <p className="text-[10px] text-text-secondary uppercase tracking-wider mb-2">
              この作品の感情
            </p>
            <div className="flex flex-wrap gap-2">
              {work.tags.map((tag) => (
                <span
                  key={tag}
                  className="text-xs px-3 py-1 rounded-full bg-white/5 text-text-secondary"
                >
                  {emotionEmojis[tag]} {tag}
                </span>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div className="flex gap-3 mt-8">
        <button
          onClick={() => router.push(`/author/${work.authorId}`)}
          className="flex-1 py-3 rounded-full card-glass text-sm text-text-secondary
                     hover:text-text-primary transition-colors"
        >
          文豪を見る
        </button>
        <button
          onClick={() => router.push("/home")}
          className="flex-1 py-3 rounded-full bg-accent-indigo text-white text-sm
                     hover:bg-accent-neon transition-colors"
        >
          ホームに戻る
        </button>
      </div>
    </main>
  );
}
