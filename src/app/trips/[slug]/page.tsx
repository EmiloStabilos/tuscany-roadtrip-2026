import { notFound } from 'next/navigation';
import { getTripDayPlan } from '@/lib/trips';
import type { DayPlan } from '@/lib/trips';

export default async function TripPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const { trip, days } = await getTripDayPlan(slug);

  if (!trip) notFound();

  return (
    <main className="min-h-screen bg-[#F6F0E8] px-6 py-10">
      <section className="mx-auto max-w-5xl rounded-2xl border border-[#E9D9CB] bg-[#FFF9F2] p-8">
        <h1 className="text-4xl text-[#3A2A22]">{trip.name}</h1>
        <p className="mt-2 text-sm text-[#7D675A]">
          {trip.start_date} to {trip.end_date} - {trip.timezone}
        </p>
      </section>

      <section className="mx-auto mt-6 max-w-5xl space-y-4">
        {days.map((day: DayPlan) => (
          <article key={day.id} className="rounded-xl border border-[#E9D9CB] bg-white/80 p-5">
            <h2 className="text-xl text-[#3A2A22]">Day {day.day_number}: {day.title ?? 'Untitled Day'}</h2>
            <p className="text-sm text-[#7D675A]">{day.date}</p>
            {day.summary ? <p className="mt-2 text-[#5A463D]">{day.summary}</p> : null}
          </article>
        ))}
      </section>
    </main>
  );
}
