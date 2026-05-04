import './globals.css';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Tuscany Road Trip Template',
  description: 'Fork-first road trip planner starter for Vercel + Supabase',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
