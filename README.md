# Tuscany Road Trip App Template

Fork-first road trip planner template designed to be reused across trips by changing configuration and seed data.

## Stack
- Next.js (App Router) + TypeScript + Tailwind
- Supabase (Postgres, Auth, RLS, Storage)
- Zod validation
- Map provider (Mapbox/Google)
- Vercel deployment

## Architecture Principles
1. **Trip-first modeling**: all user content links to `trip_id`.
2. **Configuration over code**: trip branding/defaults live in `trip_config`.
3. **Forkable boundaries**:
   - Core app code remains generic.
   - Trip package (`supabase/seed/*.sql`, optional media/docs) contains trip specifics.

## Database Setup
The SQL schema and policy scaffolding live in:
- `supabase/migrations/0001_fork_first_schema.sql`

Sample trip seed lives in:
- `supabase/seed/tuscany_2026.sql` (fully populated for July 6-12 itinerary, days, stops, and route segments)

Visual theme tokens for the Tuscany aesthetic live in:
- `src/lib/trip-theme.ts`

Apply in Supabase SQL editor or via CLI migrations.

## Fork Workflow
1. Fork this repository.
2. Update `supabase/seed/<trip>.sql` with a new `trips` row and content.
3. Update `trip_config` values for branding, locale, and map defaults.
4. Deploy to Vercel and wire env vars.

## Environment Variables
Create `.env.local`:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `NEXT_PUBLIC_MAPBOX_TOKEN` (or Google maps key)
- `SENTRY_DSN`

## Next Steps
- Add Next.js UI using these tables and policies.
- Add server actions/API routes validated with Zod.
- Add Sentry and Vercel Analytics to the app shell.

## Vercel Deployment
1. Import this repository into Vercel.
2. Framework preset: **Next.js** (auto-detected via `vercel.json`).
3. Add environment variables from the list above.
4. Deploy: every push gets a Preview deployment; merge to main for Production.

Run locally:
- `npm install`
- `npm run dev`
