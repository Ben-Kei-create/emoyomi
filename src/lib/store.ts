"use client";

const STORAGE_KEY = "emoyomi_progress";
const PREMIUM_KEY = "emoyomi_premium";
const FAVORITES_KEY = "emoyomi_favorites";

export interface ReadingProgress {
  workId: string;
  currentIndex: number;
  completed: boolean;
}

function getStorage<T>(key: string, fallback: T): T {
  if (typeof window === "undefined") return fallback;
  try {
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : fallback;
  } catch {
    return fallback;
  }
}

function setStorage<T>(key: string, value: T): void {
  if (typeof window === "undefined") return;
  localStorage.setItem(key, JSON.stringify(value));
}

export function getProgress(workId: string): ReadingProgress {
  const all = getStorage<Record<string, ReadingProgress>>(STORAGE_KEY, {});
  return all[workId] || { workId, currentIndex: 0, completed: false };
}

export function saveProgress(progress: ReadingProgress): void {
  const all = getStorage<Record<string, ReadingProgress>>(STORAGE_KEY, {});
  all[progress.workId] = progress;
  setStorage(STORAGE_KEY, all);
}

export function isPremium(): boolean {
  return getStorage<boolean>(PREMIUM_KEY, false);
}

export function setPremium(value: boolean): void {
  setStorage(PREMIUM_KEY, value);
}

export function getFavorites(): string[] {
  return getStorage<string[]>(FAVORITES_KEY, []);
}

export function toggleFavorite(workId: string): string[] {
  const favs = getFavorites();
  const next = favs.includes(workId)
    ? favs.filter((id) => id !== workId)
    : [...favs, workId];
  setStorage(FAVORITES_KEY, next);
  return next;
}
