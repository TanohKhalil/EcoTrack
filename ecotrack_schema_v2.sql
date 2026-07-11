-- ============================================================
-- EcoTrack — Schéma SQL Supabase (corrigé complet, v3)
-- Copie-colle dans Supabase SQL Editor et exécute en une fois.
-- ============================================================

DROP TABLE IF EXISTS public.votes_communautaires CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.lignes_commande CASCADE;
DROP TABLE IF EXISTS public.commandes CASCADE;
DROP TABLE IF EXISTS public.produits_marketplace CASCADE;
DROP TABLE IF EXISTS public.echanges_points CASCADE;
DROP TABLE IF EXISTS public.recompenses CASCADE;
DROP TABLE IF EXISTS public.itineraire_arrets CASCADE;
DROP TABLE IF EXISTS public.collecteur_stats CASCADE;
DROP TABLE IF EXISTS public.waste_scan_results CASCADE;
DROP TABLE IF EXISTS public.signalement_etapes CASCADE;
DROP TABLE IF EXISTS public.signalements CASCADE;
DROP TABLE IF EXISTS public.collect_points CASCADE;
DROP TABLE IF EXISTS public.dashboard_mairie CASCADE;
DROP TABLE IF EXISTS public.impact_carbone CASCADE;
DROP TABLE IF EXISTS public.auth_email_otps CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- ENUM : rôles utilisateur (correspond à UserRole du cahier)
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
    CREATE TYPE public.user_role AS ENUM ('menage', 'collecteur', 'filiere', 'mairie');
  END IF;
END
$$;

-- ENUM : catégories de déchets (correspond à WasteCategory)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'waste_category') THEN
    CREATE TYPE public.waste_category AS ENUM ('plastique', 'organique', 'metal_verre', 'dangereux', 'e_waste', 'carton');
  END IF;
END
$$;

-- ============================================================
-- Table : profiles (correspond à AppUser)
-- ============================================================
CREATE TABLE public.profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  prenom text,
  nom text,
  email text UNIQUE,
  phone text UNIQUE,
  is_email_verified boolean NOT NULL DEFAULT false,
  is_phone_verified boolean NOT NULL DEFAULT false,
  signup_method text NOT NULL DEFAULT 'email_otp',
  onboarding_completed boolean NOT NULL DEFAULT false,
  localisation text,
  role_actif public.user_role NOT NULL DEFAULT 'menage',
  roles_disponibles public.user_role[] NOT NULL DEFAULT ARRAY['menage']::public.user_role[],
  points integer NOT NULL DEFAULT 0,
  kg_valorises numeric NOT NULL DEFAULT 0,
  mois_actifs integer NOT NULL DEFAULT 0,
  badge text,
  is_admin boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Table : collect_points
-- ============================================================
CREATE TABLE public.collect_points (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nom text NOT NULL,
  categorie public.waste_category NOT NULL,
  latitude double precision NOT NULL,
  longitude double precision NOT NULL,
  remplissage_iot_pct integer NOT NULL DEFAULT 0,
  horaires text,
  dechets_acceptes text[] DEFAULT '{}',
  dechets_exclus text[] DEFAULT '{}',
  gestionnaire text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Table : signalements
-- ============================================================
CREATE TABLE public.signalements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  localisation text,
  description text,
  photo_url text,
  categorie public.waste_category,
  status text NOT NULL DEFAULT 'en_attente',
  latitude double precision,
  longitude double precision,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.signalement_etapes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  signalement_id uuid NOT NULL REFERENCES public.signalements(id) ON DELETE CASCADE,
  titre text NOT NULL,
  agent text,
  date timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Table : waste_scan_results
-- ============================================================
CREATE TABLE public.waste_scan_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  categorie public.waste_category NOT NULL,
  confiance_ia numeric,
  sous_detail text,
  filiere_recommandee text,
  distance_filiere_km numeric,
  point_depot_id uuid REFERENCES public.collect_points(id) ON DELETE SET NULL,
  points_gagnes integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Table : collecteur_stats
-- ============================================================
CREATE TABLE public.collecteur_stats (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  notation numeric NOT NULL DEFAULT 0,
  nombre_collectes integer NOT NULL DEFAULT 0,
  zone text,
  solde_fcfa numeric NOT NULL DEFAULT 0,
  kg_collectes_semaine numeric NOT NULL DEFAULT 0,
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.itineraire_arrets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  collecteur_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  ordre integer NOT NULL,
  lieu text NOT NULL,
  categorie public.waste_category,
  remplissage_pct integer,
  date timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Table : recompenses et échanges
-- ============================================================
CREATE TABLE public.recompenses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  titre text NOT NULL,
  points_cost integer NOT NULL,
  description text,
  image_url text,
  disponible boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.echanges_points (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  recompense_id uuid NOT NULL REFERENCES public.recompenses(id) ON DELETE RESTRICT,
  status text NOT NULL DEFAULT 'demande',
  requested_at timestamptz NOT NULL DEFAULT now(),
  reviewed_at timestamptz,
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Table : produits_marketplace, commandes, lignes_commande
-- ============================================================
CREATE TABLE public.produits_marketplace (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nom text NOT NULL,
  fournisseur text,
  prix_fcfa integer NOT NULL,
  categorie text,
  image_url text,
  disponible boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.commandes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  statut text NOT NULL DEFAULT 'en_attente',
  total_fcfa integer NOT NULL DEFAULT 0,
  mode_paiement text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.lignes_commande (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  commande_id uuid NOT NULL REFERENCES public.commandes(id) ON DELETE CASCADE,
  produit_id uuid NOT NULL REFERENCES public.produits_marketplace(id) ON DELETE RESTRICT,
  quantite integer NOT NULL DEFAULT 1,
  prix_unitaire_fcfa integer NOT NULL
);

-- ============================================================
-- Table : impact_carbone
-- ============================================================
CREATE TABLE public.impact_carbone (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  tonnes_co2e_evitees numeric NOT NULL DEFAULT 0,
  equivalent_arbres integer NOT NULL DEFAULT 0,
  equivalent_km_voiture integer NOT NULL DEFAULT 0,
  certifie boolean NOT NULL DEFAULT false,
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Table : dashboard_mairie
-- ============================================================
CREATE TABLE public.dashboard_mairie (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  commune text NOT NULL UNIQUE,
  taux_collecte_pct numeric NOT NULL DEFAULT 0,
  tonnes_valorisees_mois numeric NOT NULL DEFAULT 0,
  depots_sauvages_actifs integer NOT NULL DEFAULT 0,
  emplois_soutenus integer NOT NULL DEFAULT 0,
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Table : notifications
-- ============================================================
CREATE TABLE public.notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  titre text NOT NULL,
  message text,
  lu boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Table : votes_communautaires
-- ============================================================
CREATE TABLE public.votes_communautaires (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  signalement_id uuid NOT NULL REFERENCES public.signalements(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  categorie_votee public.waste_category NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (signalement_id, user_id)
);

-- ============================================================
-- Indexes utiles
-- ============================================================
CREATE INDEX idx_profiles_user_id ON public.profiles(user_id);
CREATE INDEX idx_profiles_email ON public.profiles (email);
CREATE INDEX idx_profiles_phone ON public.profiles (phone);
CREATE INDEX idx_signalements_user_id ON public.signalements(user_id);
CREATE INDEX idx_signalements_status ON public.signalements(status);
CREATE INDEX idx_collect_points_categorie ON public.collect_points(categorie);
CREATE INDEX idx_waste_scan_user_id ON public.waste_scan_results(user_id);
CREATE INDEX idx_itineraire_collecteur_id ON public.itineraire_arrets(collecteur_id);
CREATE INDEX idx_echanges_points_user_id ON public.echanges_points(user_id);
CREATE INDEX idx_commandes_user_id ON public.commandes(user_id);
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);

-- ============================================================
-- Fonctions helper pour les policies RLS
-- ============================================================
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean AS $$
  SELECT COALESCE((SELECT is_admin FROM public.profiles WHERE user_id = auth.uid()), false);
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.has_role(target_role public.user_role)
RETURNS boolean AS $$
  SELECT COALESCE(
    (SELECT target_role = ANY(roles_disponibles) FROM public.profiles WHERE user_id = auth.uid()),
    false
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ============================================================
-- Activer RLS
-- ============================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collect_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signalements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signalement_etapes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.waste_scan_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collecteur_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.itineraire_arrets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recompenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.echanges_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.produits_marketplace ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.commandes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lignes_commande ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.impact_carbone ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dashboard_mairie ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.votes_communautaires ENABLE ROW LEVEL SECURITY;

-- ---------- profiles ----------
CREATE POLICY "profiles_select_own_or_admin" ON public.profiles
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());
CREATE POLICY "profiles_insert_auth" ON public.profiles
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "profiles_delete_own" ON public.profiles
  FOR DELETE USING (auth.uid() = user_id);

-- ---------- collect_points ----------
CREATE POLICY "collect_points_select_public" ON public.collect_points
  FOR SELECT USING (true);
CREATE POLICY "collect_points_write_admin" ON public.collect_points
  FOR INSERT TO authenticated WITH CHECK (public.is_admin() OR public.has_role('mairie'));
CREATE POLICY "collect_points_update_admin" ON public.collect_points
  FOR UPDATE USING (public.is_admin() OR public.has_role('mairie'));
CREATE POLICY "collect_points_delete_admin" ON public.collect_points
  FOR DELETE USING (public.is_admin() OR public.has_role('mairie'));

-- ---------- signalements ----------
CREATE POLICY "signalements_select_owner_or_privileged" ON public.signalements
  FOR SELECT USING (
    user_id = auth.uid() OR public.is_admin() OR public.has_role('mairie') OR public.has_role('collecteur')
  );
CREATE POLICY "signalements_insert_auth" ON public.signalements
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "signalements_update_owner_or_privileged" ON public.signalements
  FOR UPDATE USING (
    user_id = auth.uid() OR public.is_admin() OR public.has_role('mairie')
  );
CREATE POLICY "signalements_delete_owner_or_admin" ON public.signalements
  FOR DELETE USING (user_id = auth.uid() OR public.is_admin());

-- ---------- signalement_etapes ----------
CREATE POLICY "etapes_select_related" ON public.signalement_etapes
  FOR SELECT USING (
    public.is_admin()
    OR signalement_id IN (SELECT id FROM public.signalements WHERE user_id = auth.uid())
  );
CREATE POLICY "etapes_insert_privileged" ON public.signalement_etapes
  FOR INSERT TO authenticated WITH CHECK (public.is_admin() OR public.has_role('mairie'));

-- ---------- waste_scan_results ----------
CREATE POLICY "scan_select_own" ON public.waste_scan_results
  FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "scan_insert_own" ON public.waste_scan_results
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

-- ---------- collecteur_stats ----------
CREATE POLICY "collecteur_stats_select_own_or_admin" ON public.collecteur_stats
  FOR SELECT USING (user_id = auth.uid() OR public.is_admin());
CREATE POLICY "collecteur_stats_update_own" ON public.collecteur_stats
  FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY "collecteur_stats_insert_own" ON public.collecteur_stats
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

-- ---------- itineraire_arrets ----------
CREATE POLICY "itineraire_select_own_or_admin" ON public.itineraire_arrets
  FOR SELECT USING (collecteur_id = auth.uid() OR public.is_admin());
CREATE POLICY "itineraire_write_admin" ON public.itineraire_arrets
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());

-- ---------- recompenses ----------
CREATE POLICY "recompenses_select_public" ON public.recompenses
  FOR SELECT USING (true);
CREATE POLICY "recompenses_write_admin" ON public.recompenses
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "recompenses_update_admin" ON public.recompenses
  FOR UPDATE USING (public.is_admin());

-- ---------- echanges_points ----------
CREATE POLICY "echanges_select_owner_or_admin" ON public.echanges_points
  FOR SELECT USING (user_id = auth.uid() OR public.is_admin());
CREATE POLICY "echanges_insert_owner" ON public.echanges_points
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "echanges_update_admin" ON public.echanges_points
  FOR UPDATE USING (public.is_admin());

-- ---------- produits_marketplace ----------
CREATE POLICY "produits_select_public" ON public.produits_marketplace
  FOR SELECT USING (true);
CREATE POLICY "produits_write_filiere_admin" ON public.produits_marketplace
  FOR INSERT TO authenticated WITH CHECK (public.is_admin() OR public.has_role('filiere'));
CREATE POLICY "produits_update_filiere_admin" ON public.produits_marketplace
  FOR UPDATE USING (public.is_admin() OR public.has_role('filiere'));

-- ---------- commandes / lignes_commande ----------
CREATE POLICY "commandes_select_owner_or_admin" ON public.commandes
  FOR SELECT USING (user_id = auth.uid() OR public.is_admin());
CREATE POLICY "commandes_insert_owner" ON public.commandes
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "commandes_update_owner_or_admin" ON public.commandes
  FOR UPDATE USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY "lignes_select_related" ON public.lignes_commande
  FOR SELECT USING (
    public.is_admin()
    OR commande_id IN (SELECT id FROM public.commandes WHERE user_id = auth.uid())
  );
CREATE POLICY "lignes_insert_related" ON public.lignes_commande
  FOR INSERT TO authenticated WITH CHECK (
    commande_id IN (SELECT id FROM public.commandes WHERE user_id = auth.uid())
  );

-- ---------- impact_carbone ----------
CREATE POLICY "impact_select_own_or_admin" ON public.impact_carbone
  FOR SELECT USING (user_id = auth.uid() OR public.is_admin());
CREATE POLICY "impact_upsert_admin" ON public.impact_carbone
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "impact_update_admin" ON public.impact_carbone
  FOR UPDATE USING (public.is_admin());

-- ---------- dashboard_mairie ----------
CREATE POLICY "dashboard_select_mairie_admin" ON public.dashboard_mairie
  FOR SELECT USING (public.has_role('mairie') OR public.is_admin());
CREATE POLICY "dashboard_write_admin" ON public.dashboard_mairie
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "dashboard_update_admin" ON public.dashboard_mairie
  FOR UPDATE USING (public.is_admin());

-- ---------- notifications ----------
CREATE POLICY "notifications_select_own" ON public.notifications
  FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "notifications_update_own" ON public.notifications
  FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY "notifications_insert_admin" ON public.notifications
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());

-- ---------- votes_communautaires ----------
CREATE POLICY "votes_select_public" ON public.votes_communautaires
  FOR SELECT USING (true);
CREATE POLICY "votes_insert_own" ON public.votes_communautaires
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

-- ============================================================
-- Trigger updated_at (générique)
-- ============================================================
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_set_updated_at BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER collect_points_set_updated_at BEFORE UPDATE ON public.collect_points
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER signalements_set_updated_at BEFORE UPDATE ON public.signalements
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER collecteur_stats_set_updated_at BEFORE UPDATE ON public.collecteur_stats
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER recompenses_set_updated_at BEFORE UPDATE ON public.recompenses
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER echanges_points_set_updated_at BEFORE UPDATE ON public.echanges_points
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER produits_set_updated_at BEFORE UPDATE ON public.produits_marketplace
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER commandes_set_updated_at BEFORE UPDATE ON public.commandes
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER impact_carbone_set_updated_at BEFORE UPDATE ON public.impact_carbone
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER dashboard_mairie_set_updated_at BEFORE UPDATE ON public.dashboard_mairie
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- Trigger: créer automatiquement un profil quand un user auth est créé
-- ============================================================
CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (user_id, email, created_at)
  VALUES (NEW.id, NEW.email, now())
  ON CONFLICT (user_id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_auth_user();

-- ============================================================
-- Trigger: synchroniser email_confirmed_at -> profiles.is_email_verified
-- ============================================================
CREATE OR REPLACE FUNCTION public.sync_email_verified()
RETURNS trigger AS $$
BEGIN
  UPDATE public.profiles
  SET is_email_verified = (NEW.email_confirmed_at IS NOT NULL), updated_at = now()
  WHERE user_id = NEW.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_updated_email_confirmed_at ON auth.users;
CREATE TRIGGER on_auth_user_updated_email_confirmed_at
AFTER UPDATE OF email_confirmed_at ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.sync_email_verified();

-- ============================================================
-- Table de logs OTP (auth_email_otps)
-- ============================================================
CREATE TABLE public.auth_email_otps (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NULL REFERENCES public.profiles(id) ON DELETE SET NULL,
  email text,
  sent_at timestamptz NOT NULL DEFAULT now(),
  ip_address text,
  client_info text,
  success boolean NOT NULL DEFAULT false,
  method text NOT NULL DEFAULT 'signup_otp',
  meta jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_auth_email_otps_email ON public.auth_email_otps (email);
CREATE INDEX idx_auth_email_otps_user_id ON public.auth_email_otps (user_id);
CREATE INDEX idx_auth_email_otps_sent_at ON public.auth_email_otps (sent_at);

ALTER TABLE public.auth_email_otps ENABLE ROW LEVEL SECURITY;
CREATE POLICY "auth_email_otps_select_admin" ON public.auth_email_otps
  FOR SELECT USING (public.is_admin());
CREATE POLICY "auth_email_otps_insert_any_authenticated" ON public.auth_email_otps
  FOR INSERT TO authenticated WITH CHECK (true);

-- Fonction helper RPC pour logguer un envoi / tentative OTP
CREATE OR REPLACE FUNCTION public.log_email_otp(
  p_email TEXT,
  p_user_id UUID DEFAULT NULL,
  p_ip TEXT DEFAULT NULL,
  p_client_info TEXT DEFAULT NULL,
  p_success BOOLEAN DEFAULT false,
  p_method TEXT DEFAULT 'signup_otp',
  p_meta JSONB DEFAULT '{}'::jsonb
) RETURNS void AS $$
BEGIN
  INSERT INTO public.auth_email_otps (
    user_id, email, ip_address, client_info, success, method, meta, sent_at, created_at
  ) VALUES (
    p_user_id, p_email, p_ip, p_client_info, p_success, p_method, p_meta, now(), now()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.log_email_otp(TEXT, UUID, TEXT, TEXT, BOOLEAN, TEXT, JSONB) TO authenticated;

-- ============================================================
-- FIN du schéma
-- ============================================================