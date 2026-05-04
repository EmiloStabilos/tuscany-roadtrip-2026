import { createClient } from '@supabase/supabase-js';
import { env } from '@/lib/env';
import type { Database } from '@/lib/supabase/types';

export function createBrowserSupabaseClient() {
  if (!env.success) return null;

  return createClient<Database>(env.data.NEXT_PUBLIC_SUPABASE_URL, env.data.NEXT_PUBLIC_SUPABASE_ANON_KEY);
}
