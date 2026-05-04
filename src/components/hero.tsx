import { romanticLifestyleTheme } from '@/lib/trip-theme';

export function Hero() {
  return (
    <section
      className="mx-auto mt-10 max-w-5xl rounded-2xl border p-10"
      style={{
        background: romanticLifestyleTheme.palette.surface,
        borderColor: romanticLifestyleTheme.palette.frame,
        boxShadow: romanticLifestyleTheme.effects.cardShadow,
      }}
    >
      <p className="text-sm uppercase tracking-[0.2em]" style={{ color: romanticLifestyleTheme.palette.textMuted }}>
        Fork-First Template
      </p>
      <h1 className="mt-3 text-5xl" style={{ color: romanticLifestyleTheme.palette.textPrimary }}>
        Tuscany Road Trip
      </h1>
      <p className="mt-4 max-w-2xl text-base" style={{ color: romanticLifestyleTheme.palette.textMuted }}>
        Romantic lifestyle travel aesthetic with reusable trip configuration, Supabase schema, and seed-based itineraries.
      </p>
    </section>
  );
}
