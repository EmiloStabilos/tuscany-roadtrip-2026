-- Example trip package seed data (replace in forks)
-- Requires a real auth.users UUID before execution.

with inserted_trip as (
  insert into public.trips (slug, name, start_date, end_date, timezone, status, created_by)
  values ('tuscany-2026', 'Tuscany 2026', '2026-06-10', '2026-06-20', 'Europe/Rome', 'active', '00000000-0000-0000-0000-000000000000')
  returning id
)
insert into public.trip_config (trip_id, branding, locale, currency, map_defaults, date_range)
select
  id,
  '{"title":"Tuscany Road Trip","heroImage":"/trip-assets/tuscany/hero.jpg"}'::jsonb,
  'en-US',
  'EUR',
  '{"center":{"lat":43.7711,"lng":11.2486},"zoom":7}'::jsonb,
  '{"start":"2026-06-10","end":"2026-06-20"}'::jsonb
from inserted_trip;
