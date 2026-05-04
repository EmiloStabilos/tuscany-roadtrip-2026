-- Tuscany Road Trip fork-first schema
create extension if not exists "pgcrypto";

create type trip_status as enum ('draft', 'active', 'archived');
create type member_role as enum ('owner', 'editor', 'viewer');
create type stop_category as enum ('town', 'winery', 'museum', 'food', 'scenic', 'lodging');
create type stop_priority as enum ('must', 'should', 'could');
create type booking_type as enum ('hotel', 'rental_car', 'restaurant', 'activity');
create type document_type as enum ('ticket', 'insurance', 'passport_copy', 'itinerary');

create table if not exists public.trips (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  start_date date not null,
  end_date date not null,
  timezone text not null,
  status trip_status not null default 'draft',
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (end_date >= start_date)
);

create table if not exists public.trip_members (
  trip_id uuid not null references public.trips(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role member_role not null,
  created_at timestamptz not null default now(),
  primary key (trip_id, user_id)
);

create table if not exists public.trip_config (
  trip_id uuid primary key references public.trips(id) on delete cascade,
  branding jsonb not null default '{}'::jsonb,
  locale text not null default 'en-US',
  currency text not null default 'EUR',
  map_defaults jsonb not null default '{"zoom":7}'::jsonb,
  date_range jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.days (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.trips(id) on delete cascade,
  day_number integer not null check (day_number > 0),
  date date not null,
  title text,
  summary text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (trip_id, day_number),
  unique (trip_id, date)
);

create table if not exists public.stops (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.trips(id) on delete cascade,
  day_id uuid references public.days(id) on delete set null,
  name text not null,
  category stop_category not null,
  lat double precision,
  lng double precision,
  address text,
  arrival_time timestamptz,
  departure_time timestamptz,
  priority stop_priority not null default 'could',
  notes text,
  cost_estimate numeric(10,2),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check ((lat is null and lng is null) or (lat between -90 and 90 and lng between -180 and 180))
);

create table if not exists public.segments (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.trips(id) on delete cascade,
  from_stop_id uuid not null references public.stops(id) on delete cascade,
  to_stop_id uuid not null references public.stops(id) on delete cascade,
  distance_km numeric(10,2),
  drive_minutes integer,
  toll_estimate numeric(10,2),
  order_index integer not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (trip_id, order_index),
  check (from_stop_id <> to_stop_id)
);

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.trips(id) on delete cascade,
  stop_id uuid references public.stops(id) on delete set null,
  type booking_type not null,
  provider text,
  confirmation_code text,
  start_at timestamptz,
  end_at timestamptz,
  price numeric(10,2),
  currency text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (end_at is null or start_at is null or end_at >= start_at)
);

create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.trips(id) on delete cascade,
  title text not null,
  storage_path text not null,
  doc_type document_type not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.trips enable row level security;
alter table public.trip_members enable row level security;
alter table public.trip_config enable row level security;
alter table public.days enable row level security;
alter table public.stops enable row level security;
alter table public.segments enable row level security;
alter table public.bookings enable row level security;
alter table public.documents enable row level security;

create policy "members can read trips" on public.trips
for select using (
  exists (
    select 1 from public.trip_members tm
    where tm.trip_id = trips.id and tm.user_id = auth.uid()
  )
);

create policy "owners and editors can mutate trips" on public.trips
for all using (
  exists (
    select 1 from public.trip_members tm
    where tm.trip_id = trips.id and tm.user_id = auth.uid() and tm.role in ('owner', 'editor')
  )
)
with check (
  exists (
    select 1 from public.trip_members tm
    where tm.trip_id = trips.id and tm.user_id = auth.uid() and tm.role in ('owner', 'editor')
  )
);

-- Repeatable helper policy pattern for trip-scoped tables
create policy "trip members can read trip_members" on public.trip_members
for select using (
  exists (
    select 1 from public.trip_members tm
    where tm.trip_id = trip_members.trip_id and tm.user_id = auth.uid()
  )
);
