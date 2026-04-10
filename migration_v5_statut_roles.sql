-- ════════════════════════════════════════════════════════════════════════════
-- Migration V5 — Statut des missions & rôle Comptable
-- ════════════════════════════════════════════════════════════════════════════
-- À exécuter dans l'éditeur SQL de Supabase (SQL Editor)
-- https://supabase.com/dashboard/project/arpglssgrecsadlhtxxg/sql/new
-- ════════════════════════════════════════════════════════════════════════════

-- ── 0. Correction des politiques RLS manquantes (OBLIGATOIRE si actions bloquées)
-- Exécuter si les boutons Créer/Modifier/Supprimer dans le dashboard RNSE ne fonctionnent pas.
DO $$ BEGIN
  -- users
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='users' AND policyname='users_insert') THEN
    EXECUTE 'CREATE POLICY "users_insert" ON users FOR INSERT TO anon WITH CHECK (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='users' AND policyname='users_update') THEN
    EXECUTE 'CREATE POLICY "users_update" ON users FOR UPDATE TO anon USING (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='users' AND policyname='users_delete') THEN
    EXECUTE 'CREATE POLICY "users_delete" ON users FOR DELETE TO anon USING (true)';
  END IF;
  -- provinces
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='provinces' AND policyname='provinces_insert') THEN
    EXECUTE 'CREATE POLICY "provinces_insert" ON provinces FOR INSERT TO anon WITH CHECK (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='provinces' AND policyname='provinces_update') THEN
    EXECUTE 'CREATE POLICY "provinces_update" ON provinces FOR UPDATE TO anon USING (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='provinces' AND policyname='provinces_delete') THEN
    EXECUTE 'CREATE POLICY "provinces_delete" ON provinces FOR DELETE TO anon USING (true)';
  END IF;
  -- missions_ref
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='missions_ref' AND policyname='missions_ref_insert') THEN
    EXECUTE 'CREATE POLICY "missions_ref_insert" ON missions_ref FOR INSERT TO anon WITH CHECK (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='missions_ref' AND policyname='missions_ref_update') THEN
    EXECUTE 'CREATE POLICY "missions_ref_update" ON missions_ref FOR UPDATE TO anon USING (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='missions_ref' AND policyname='missions_ref_delete') THEN
    EXECUTE 'CREATE POLICY "missions_ref_delete" ON missions_ref FOR DELETE TO anon USING (true)';
  END IF;
  -- territoires
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='territoires' AND policyname='territoires_insert') THEN
    EXECUTE 'CREATE POLICY "territoires_insert" ON territoires FOR INSERT TO anon WITH CHECK (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='territoires' AND policyname='territoires_update') THEN
    EXECUTE 'CREATE POLICY "territoires_update" ON territoires FOR UPDATE TO anon USING (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='territoires' AND policyname='territoires_delete') THEN
    EXECUTE 'CREATE POLICY "territoires_delete" ON territoires FOR DELETE TO anon USING (true)';
  END IF;
  -- secteurs
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='secteurs' AND policyname='secteurs_insert') THEN
    EXECUTE 'CREATE POLICY "secteurs_insert" ON secteurs FOR INSERT TO anon WITH CHECK (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='secteurs' AND policyname='secteurs_update') THEN
    EXECUTE 'CREATE POLICY "secteurs_update" ON secteurs FOR UPDATE TO anon USING (true)';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='secteurs' AND policyname='secteurs_delete') THEN
    EXECUTE 'CREATE POLICY "secteurs_delete" ON secteurs FOR DELETE TO anon USING (true)';
  END IF;
END $$;

-- ── 1. Colonne statut sur la table reports ────────────────────────────────────
-- Trois statuts possibles :
--   • en_attente  — créé par le missionnaire, en attente de validation financière
--   • activee     — complété et validé par le comptable (budget alloué)
--   • realisee    — mission effectivement réalisée (marquée par l'admin / missionnaire)

ALTER TABLE reports ADD COLUMN IF NOT EXISTS statut TEXT NOT NULL DEFAULT 'en_attente';

-- Colonnes de traçabilité
ALTER TABLE reports ADD COLUMN IF NOT EXISTS activated_by TEXT DEFAULT NULL;
ALTER TABLE reports ADD COLUMN IF NOT EXISTS activated_at TIMESTAMPTZ DEFAULT NULL;
ALTER TABLE reports ADD COLUMN IF NOT EXISTS completed_by TEXT DEFAULT NULL;
ALTER TABLE reports ADD COLUMN IF NOT EXISTS completed_at TIMESTAMPTZ DEFAULT NULL;

-- ── 2. Mettre les rapports existants (pré-v5) en statut "activee" ─────────────
-- Tous les rapports déjà enregistrés avant cette migration sont considérés
-- comme déjà validés financièrement (ils contenaient déjà les données financières).
UPDATE reports SET statut = 'activee' WHERE statut = 'en_attente';

-- ── 3. Index pour filtrage rapide par statut ──────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_reports_statut ON reports (statut);
CREATE INDEX IF NOT EXISTS idx_reports_province_statut ON reports (province, statut);

-- ── 4. Nouveau rôle "comptable" dans les utilisateurs ─────────────────────────
-- Le rôle "comptable" est géré côté applicatif (champ role TEXT).
-- Exemple d'ajout d'un compte comptable par province :

-- INSERT INTO users (email, password_b64, provinces, role, display_name) VALUES
--   ('compta_kwilu@pnda.cd',  'Q29tcHRhS3dpbHUjMjAyNg==', ARRAY['Kwilu'],          'comptable', 'Comptable Kwilu'),
--   ('compta_kasaic@pnda.cd', 'Q29tcHRhS0MjMjAyNg==',     ARRAY['Kasaï Central'],  'comptable', 'Comptable Kasaï Central'),
--   ('compta_kasai@pnda.cd',  'Q29tcHRhS2FzYWkjMjAyNg==', ARRAY['Kasaï'],          'comptable', 'Comptable Kasaï'),
--   ('compta_uncp@pnda.cd',   'Q29tcHRhVU5DUCMyMDI2',     ARRAY['UN'],             'comptable', 'Comptable UNCP')
-- ON CONFLICT (email) DO NOTHING;

-- ── 5. Vérification ───────────────────────────────────────────────────────────
-- SELECT statut, COUNT(*) FROM reports GROUP BY statut ORDER BY statut;
-- SELECT id, email, role, provinces FROM users ORDER BY role, email;
