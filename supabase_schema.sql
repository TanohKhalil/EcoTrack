-- Supabase schema for EcoTrack
-- Copie-colle ce SQL dans Supabase SQL Editor et exécute.

-- Si des tables existent déjà avec un schéma incompatible, on les supprime d'abord.
DROP TABLE IF EXISTS public.redemptions CASCADE;
DROP TABLE IF EXISTS public.rewards CASCADE;

-- Extensions nécessaires
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Profils utilisateurs liés à Supabase Auth
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text,
  city text,
  avatar_url text,
  total_points integer NOT NULL DEFAULT 0,
  level text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Signalements / reports des déchets
CREATE TABLE IF NOT EXISTS public.reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE SET NULL,
  description text,
  photo_url text,
  status text NOT NULL DEFAULT 'pending',
  latitude double precision,
  longitude double precision,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Collectes assignées aux collecteurs
CREATE TABLE IF NOT EXISTS public.collections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  collector_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  report_id uuid NOT NULL REFERENCES public.reports(id) ON DELETE CASCADE,
  scheduled_at timestamptz,
  status text NOT NULL DEFAULT 'assigned',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Récompenses disponibles
CREATE TABLE IF NOT EXISTS public.rewards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  points_cost integer NOT NULL,
  description text,
  image_url text,
  available boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Demandes de redemption
CREATE TABLE IF NOT EXISTS public.redemptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  reward_id uuid NOT NULL REFERENCES public.rewards(id) ON DELETE RESTRICT,
  status text NOT NULL DEFAULT 'requested',
  requested_at timestamptz NOT NULL DEFAULT now(),
  reviewed_at timestamptz,
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Indexes utiles
CREATE INDEX IF NOT EXISTS idx_reports_status ON public.reports(status);
CREATE INDEX IF NOT EXISTS idx_reports_location ON public.reports(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_collections_status ON public.collections(status);
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_redemptions_user_id ON public.redemptions(user_id);

-- Activer RLS sur les tables importantes
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.redemptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rewards ENABLE ROW LEVEL SECURITY;

-- Policies pour profiles
CREATE POLICY "profiles_select_own" ON public.profiles
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "profiles_insert_auth" ON public.profiles
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
CREATE POLICY "profiles_delete_own" ON public.profiles
  FOR DELETE USING (auth.uid() = user_id);

-- Policies pour reports
CREATE POLICY "reports_select_owner_or_admin" ON public.reports
  FOR SELECT USING (
    user_id = auth.uid() OR auth.role() = 'admin'
  );
CREATE POLICY "reports_insert_auth" ON public.reports
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "reports_update_owner_or_admin" ON public.reports
  FOR UPDATE USING (
    user_id = auth.uid() OR auth.role() = 'admin'
  ) WITH CHECK (
    user_id = auth.uid() OR auth.role() = 'admin'
  );
CREATE POLICY "reports_delete_owner_or_admin" ON public.reports
  FOR DELETE USING (
    user_id = auth.uid() OR auth.role() = 'admin'
  );

-- Policies pour collections
CREATE POLICY "collections_select_related" ON public.collections
  FOR SELECT USING (
    auth.role() = 'admin'
    OR collector_id = auth.uid()
    OR report_id IN (SELECT id FROM public.reports WHERE user_id = auth.uid())
  );
CREATE POLICY "collections_insert_admin" ON public.collections
  FOR INSERT TO authenticated WITH CHECK (auth.role() = 'admin');
CREATE POLICY "collections_update_assigned_or_admin" ON public.collections
  FOR UPDATE USING (
    auth.role() = 'admin' OR collector_id = auth.uid()
  );
CREATE POLICY "collections_delete_admin" ON public.collections
  FOR DELETE USING (auth.role() = 'admin');

-- Policies pour rewards
CREATE POLICY "rewards_select_public" ON public.rewards
  FOR SELECT USING (true);
CREATE POLICY "rewards_insert_admin" ON public.rewards
  FOR INSERT TO authenticated WITH CHECK (auth.role() = 'admin');
CREATE POLICY "rewards_update_admin" ON public.rewards
  FOR UPDATE USING (auth.role() = 'admin');
CREATE POLICY "rewards_delete_admin" ON public.rewards
  FOR DELETE USING (auth.role() = 'admin');

-- Policies pour redemptions
CREATE POLICY "redemptions_select_owner" ON public.redemptions
  FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "redemptions_insert_owner" ON public.redemptions
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "redemptions_update_admin" ON public.redemptions
  FOR UPDATE USING (auth.role() = 'admin');
CREATE POLICY "redemptions_delete_admin" ON public.redemptions
  FOR DELETE USING (auth.role() = 'admin');

-- Trigger helper for updated_at timestamps
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_set_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER reports_set_updated_at
  BEFORE UPDATE ON public.reports
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER collections_set_updated_at
  BEFORE UPDATE ON public.collections
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER rewards_set_updated_at
  BEFORE UPDATE ON public.rewards
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER redemptions_set_updated_at
  BEFORE UPDATE ON public.redemptions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
