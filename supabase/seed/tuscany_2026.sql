-- Example trip package seed data (replace in forks)
-- Requires a real auth.users UUID before execution.

begin;

with inserted_trip as (
  insert into public.trips (slug, name, start_date, end_date, timezone, status, created_by)
  values ('tuscany-2026', 'Tuscany 2026', '2026-07-06', '2026-07-12', 'Europe/Rome', 'active', '00000000-0000-0000-0000-000000000000')
  returning id
),
inserted_membership as (
  insert into public.trip_members (trip_id, user_id, role)
  select id, '00000000-0000-0000-0000-000000000000', 'owner'::member_role
  from inserted_trip
),
inserted_config as (
  insert into public.trip_config (trip_id, branding, locale, currency, map_defaults, date_range)
  select
    id,
    '{"title":"Tuscany Road Trip","heroImage":"/trip-assets/tuscany/hero.jpg","style":"romantic-lifestyle"}'::jsonb,
    'en-US',
    'EUR',
    '{"center":{"lat":43.2,"lng":11.6},"zoom":7,"mapStyle":"warm-editorial"}'::jsonb,
    '{"start":"2026-07-06","end":"2026-07-12"}'::jsonb
  from inserted_trip
),
inserted_days as (
  insert into public.days (trip_id, day_number, date, title, summary)
  select id, 1, '2026-07-06', 'Arrival in Florence', 'Airport transfer, dinner, drinks, evening walk' from inserted_trip
  union all
  select id, 2, '2026-07-07', 'Florence to Chianti', 'Drive SR222 with stops in Greve and Panzano; check-in Podere Terreno (Volpaia)' from inserted_trip
  union all
  select id, 3, '2026-07-08', 'Chianti Lifestyle Day', 'Winery visits, picnic, cooking class, and explore Radda in Chianti' from inserted_trip
  union all
  select id, 4, '2026-07-09', 'Radda to Val d’Orcia', 'Stops in San Quirico, Vitaleta Chapel, and Pienza before Monticchiello stay' from inserted_trip
  union all
  select id, 5, '2026-07-10', 'Val d’Orcia to Casale Marittimo', 'Stops in Montalcino and Golfo di Baratti beach' from inserted_trip
  union all
  select id, 6, '2026-07-11', 'Bolgheri & Coast Day', 'Wineries, cypress roads, and coastline time near Casale Marittimo' from inserted_trip
  union all
  select id, 7, '2026-07-12', 'Departure Day', 'Return to Florence Airport with final Florence sightseeing before flight' from inserted_trip
  returning id, trip_id, day_number
),
inserted_stops as (
  insert into public.stops (trip_id, day_id, name, category, lat, lng, address, arrival_time, departure_time, priority, notes)
  select d.trip_id, d.id, 'Florence Airport (FLR)', 'town', 43.8100, 11.2051, 'Via del Termine, Firenze', '2026-07-06T18:00:00+02', '2026-07-06T18:40:00+02', 'must', 'Taxi ~25 min or tram ~40 min to city center' from inserted_days d where d.day_number = 1
  union all
  select d.trip_id, d.id, 'Hotel Hermitage, Florence', 'lodging', 43.7687, 11.2546, 'Vicolo Marzio, Florence', '2026-07-06T21:00:00+02', null, 'must', 'Check-in window 21:00–22:00' from inserted_days d where d.day_number = 1
  union all
  select d.trip_id, d.id, 'Greve in Chianti', 'town', 43.5853, 11.3177, 'Greve in Chianti', '2026-07-07T10:30:00+02', '2026-07-07T12:00:00+02', 'should', 'Coffee stop and piazza walk' from inserted_days d where d.day_number = 2
  union all
  select d.trip_id, d.id, 'Panzano in Chianti', 'food', 43.5443, 11.2824, 'Panzano in Chianti', '2026-07-07T12:20:00+02', '2026-07-07T13:40:00+02', 'should', 'Lunch stop before Volpaia' from inserted_days d where d.day_number = 2
  union all
  select d.trip_id, d.id, 'Podere Terreno (Volpaia)', 'lodging', 43.5315, 11.2928, 'Radda in Chianti, Volpaia', '2026-07-07T14:00:00+02', null, 'must', 'Check-in window 14:00–19:00' from inserted_days d where d.day_number = 2
  union all
  select d.trip_id, d.id, 'Radda in Chianti Old Town', 'town', 43.4866, 11.3728, 'Radda in Chianti', '2026-07-08T10:00:00+02', '2026-07-08T20:00:00+02', 'must', 'Explore village, wineries, picnic, cooking class' from inserted_days d where d.day_number = 3
  union all
  select d.trip_id, d.id, 'San Quirico d’Orcia', 'town', 43.0606, 11.6032, 'San Quirico d’Orcia', '2026-07-09T11:00:00+02', '2026-07-09T12:00:00+02', 'should', 'Historic center walk' from inserted_days d where d.day_number = 4
  union all
  select d.trip_id, d.id, 'Vitaleta Chapel', 'scenic', 43.0455, 11.6202, 'Località Vitaleta, San Quirico', '2026-07-09T12:20:00+02', '2026-07-09T13:00:00+02', 'must', 'Iconic cypress-lined chapel photo stop' from inserted_days d where d.day_number = 4
  union all
  select d.trip_id, d.id, 'Pienza', 'town', 43.0762, 11.6780, 'Pienza', '2026-07-09T13:20:00+02', '2026-07-09T15:00:00+02', 'must', 'Lunch and Renaissance old town' from inserted_days d where d.day_number = 4
  union all
  select d.trip_id, d.id, 'Via di Mezzo, 25 (Monticchiello)', 'lodging', 43.0968, 11.7477, 'Via di Mezzo, 25, Monticchiello', '2026-07-09T16:00:00+02', null, 'must', 'Check-in window 14:00–20:00' from inserted_days d where d.day_number = 4
  union all
  select d.trip_id, d.id, 'Montalcino', 'town', 43.0581, 11.4897, 'Montalcino', '2026-07-10T10:00:00+02', '2026-07-10T12:30:00+02', 'should', 'Brunello tasting and lunch' from inserted_days d where d.day_number = 5
  union all
  select d.trip_id, d.id, 'Golfo di Baratti', 'scenic', 42.9996, 10.5106, 'Golfo di Baratti, Piombino', '2026-07-10T15:00:00+02', '2026-07-10T17:00:00+02', 'should', 'Beach stop before evening arrival' from inserted_days d where d.day_number = 5
  union all
  select d.trip_id, d.id, 'Via del Castello 41 (Casale Marittimo)', 'lodging', 43.2950, 10.6200, 'Via del Castello 41, Casale Marittimo', '2026-07-10T18:30:00+02', null, 'must', 'Check-in window 15:00–20:00' from inserted_days d where d.day_number = 5
  union all
  select d.trip_id, d.id, 'Bolgheri', 'winery', 43.2504, 10.5420, 'Bolgheri', '2026-07-11T10:00:00+02', '2026-07-11T18:00:00+02', 'must', 'Wine route, cypress avenue, coast visit' from inserted_days d where d.day_number = 6
  union all
  select d.trip_id, d.id, 'Florence Airport Return', 'town', 43.8100, 11.2051, 'Via del Termine, Firenze', '2026-07-12T11:45:00+02', '2026-07-12T12:00:00+02', 'must', 'Return car and depart' from inserted_days d where d.day_number = 7
  returning id, trip_id, name
)
insert into public.segments (trip_id, from_stop_id, to_stop_id, distance_km, drive_minutes, toll_estimate, order_index)
select s1.trip_id, s1.id, s2.id, 8.0, 25, 0, 1
from inserted_stops s1
join inserted_stops s2 on s2.trip_id = s1.trip_id
where s1.name = 'Florence Airport (FLR)' and s2.name = 'Hotel Hermitage, Florence'
union all
select s1.trip_id, s1.id, s2.id, 50.0, 60, 0, 2
from inserted_stops s1 join inserted_stops s2 on s2.trip_id = s1.trip_id
where s1.name = 'Hotel Hermitage, Florence' and s2.name = 'Podere Terreno (Volpaia)'
union all
select s1.trip_id, s1.id, s2.id, 95.0, 105, 0, 3
from inserted_stops s1 join inserted_stops s2 on s2.trip_id = s1.trip_id
where s1.name = 'Podere Terreno (Volpaia)' and s2.name = 'Via di Mezzo, 25 (Monticchiello)'
union all
select s1.trip_id, s1.id, s2.id, 170.0, 155, 12, 4
from inserted_stops s1 join inserted_stops s2 on s2.trip_id = s1.trip_id
where s1.name = 'Via di Mezzo, 25 (Monticchiello)' and s2.name = 'Via del Castello 41 (Casale Marittimo)'
union all
select s1.trip_id, s1.id, s2.id, 125.0, 98, 8, 5
from inserted_stops s1 join inserted_stops s2 on s2.trip_id = s1.trip_id
where s1.name = 'Via del Castello 41 (Casale Marittimo)' and s2.name = 'Florence Airport Return';

commit;
