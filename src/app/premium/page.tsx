"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { setPremium, isPremium as checkPremium } from "@/lib/store";

export default function PremiumPage() {
  const router = useRouter();
  const [purchased, setPurchased] = useState(false);

  const handlePurchase = () => {
    setPremium(true);
    setPurchased(true);
  };

  const alreadyPremium = typeof window !== "undefined" && checkPremium();

  const features = [
    { icon: "📚", title: "全作品アクセス", desc: "すべての作品が読み放題" },
    {
      icon: "💬",
      title: "全バイブス解説",
      desc: "すべてのシーンの感情解説",
    },
    {
      icon: "📊",
      title: "感情メーター",
      desc: "各シーンの感情値を可視化",
    },
    {
      icon: "🖋️",
      title: "文豪プロフィール",
      desc: "全文豪の詳細プロフィール",
    },
    {
      icon: "🎨",
      title: "テーマ変更",
      desc: "背景や配色をカスタマイズ",
    },
    {
      icon: "⭐",
      title: "お気に入り",
      desc: "好きな作品を保存",
    },
  ];

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
        <div className="text-center mb-8 animate-fade-in-up">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-accent-warm/10 text-accent-warm text-xs mb-4">
            ✦ Premium
          </div>
          <h1
            className="text-3xl font-bold mb-2"
            style={{ fontFamily: "'Noto Serif JP', serif" }}
          >
            すべての文学体験を
            <br />
            <span className="text-gradient">解放する</span>
          </h1>
          <p className="text-text-secondary text-sm">
            買い切りで、広告なし。ずっと使える。
          </p>
        </div>

        <div className="grid grid-cols-2 gap-3 mb-8">
          {features.map((f, i) => (
            <div
              key={f.title}
              className="card-glass rounded-2xl p-4 animate-fade-in-up"
              style={{ animationDelay: `${i * 80}ms` }}
            >
              <span className="text-2xl block mb-2">{f.icon}</span>
              <p className="text-sm font-medium mb-0.5">{f.title}</p>
              <p className="text-[10px] text-text-secondary">{f.desc}</p>
            </div>
          ))}
        </div>

        {purchased || alreadyPremium ? (
          <div className="card-glass rounded-2xl p-6 text-center animate-fade-in">
            <span className="text-4xl block mb-3">🎉</span>
            <p className="text-lg font-medium mb-1">Premium有効</p>
            <p className="text-sm text-text-secondary">
              すべての機能が使えます
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            <button
              onClick={handlePurchase}
              className="w-full py-4 rounded-full bg-accent-indigo text-white text-lg font-medium
                         hover:bg-accent-neon transition-all shadow-lg shadow-accent-indigo/30
                         active:scale-[0.98]"
            >
              ¥980 で購入（買い切り）
            </button>
            <p className="text-center text-[10px] text-text-secondary/50">
              一度の購入で、すべての機能がずっと使えます。
              <br />
              読書中の広告は表示されません。
            </p>
          </div>
        )}
      </div>
    </main>
  );
}
