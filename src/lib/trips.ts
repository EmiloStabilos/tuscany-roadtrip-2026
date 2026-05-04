import { createServerSupabaseClient } from '@/lib/supabase/server';

type TripRow = {
  id: string;
  slug: string;
  name: string;
  start_date: string;
  end_date: string;
  timezone: string;
  status: 'draft' | 'active' | 'archived';
};

export type DayPlan = {
  id: string;
  day_number: number;
  date: string;
  title: string | null;
  summary: string | null;
};

export async function listTrips(): Promise<TripRow[]> {
  const supabase = createServerSupabaseClient();
  if (!supabase) return [];

  const { data, error } = await supabase
    .from('trips')
    .select('id, slug, name, start_date, end_date, timezone, status')
    .order('start_date', { ascending: true });

  if (error) throw error;
  return (data as TripRow[] | null) ?? [];
}

export async function getTripDayPlan(slug: string): Promise<{ trip: TripRow | null; days: DayPlan[] }> {
  const supabase = createServerSupabaseClient();
  if (!supabase) return { trip: null, days: [] };

  const { data: trip, error: tripError } = await supabase
    .from('trips')
    .select('id, slug, name, start_date, end_date, timezone, status')
    .eq('slug', slug)
    .single();

  if (tripError || !trip) return { trip: null, days: [] };

  const { data: days, error: daysError } = await supabase
    .from('days')
    .select('id, day_number, date, title, summary')
    .eq('trip_id', (trip as TripRow).id)
    .order('day_number', { ascending: true });

  if (daysError) throw daysError;
  return { trip: trip as TripRow, days: (days as DayPlan[] | null) ?? [] };
}
