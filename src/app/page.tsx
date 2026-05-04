import Link from 'next/link';
import { Hero } from '@/components/hero';
import { listTrips } from '@/lib/trips';
import { Badge } from '@/components/ui/badge';

export default async function HomePage() {
  const trips = await listTrips();

  return (
    <main className="min-h-screen px-6 pb-20" style={{ background: '#F6F0E8' }}>
      <Hero />
      <section className="mx-auto mt-8 max-w-5xl">
        <h2 className="text-2xl text-[#3A2A22]">Trips</h2>
        {trips.length === 0 ? (
          <p className="mt-3 text-[#7D675A]">No trip data found. Run Supabase migration + seed and set env vars.</p>
        ) : (
          <ul className="mt-4 space-y-3">
            {trips.map((trip) => (
              <li key={trip.id} className="rounded-xl border border-[#E9D9CB] bg-[#FFF9F2] p-4">
                <div className="flex items-center justify-between">
                  <Link href={`/trips/${trip.slug}`} className="text-lg text-[#3A2A22] underline">
                    {trip.name}
                  </Link>
                  <Badge className="bg-[#E9D9CB] text-[#3A2A22]">{trip.status}</Badge>
                </div>
                <p className="mt-2 text-sm text-[#7D675A]">
                  {trip.start_date} → {trip.end_date} ({trip.timezone})
                </p>
              </li>
            ))}
          </ul>
        )}
      </section>
    </main>
  );
}
