-- ══════════════════════════════════════════════════════════════════════════════
-- MIGRATION v3 — Territoires & Secteurs
-- Exécutez ce script dans l'éditeur SQL de votre projet Supabase :
-- https://supabase.com/dashboard/project/arpglssgrecsadlhtxxg/sql/new
-- ══════════════════════════════════════════════════════════════════════════════

-- ── 1. TABLES ─────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS territoires (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  province_name TEXT NOT NULL REFERENCES provinces(name) ON DELETE CASCADE,
  name          TEXT NOT NULL,
  label         TEXT NOT NULL,
  UNIQUE (province_name, name)
);

CREATE TABLE IF NOT EXISTS secteurs (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  territoire_id   UUID NOT NULL REFERENCES territoires(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  label           TEXT NOT NULL,
  UNIQUE (territoire_id, name)
);

-- ── 2. ROW LEVEL SECURITY ─────────────────────────────────────────────────────

ALTER TABLE territoires ENABLE ROW LEVEL SECURITY;
ALTER TABLE secteurs    ENABLE ROW LEVEL SECURITY;

CREATE POLICY "territoires_select" ON territoires FOR SELECT TO anon USING (true);
CREATE POLICY "territoires_insert" ON territoires FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "territoires_update" ON territoires FOR UPDATE TO anon USING (true);
CREATE POLICY "territoires_delete" ON territoires FOR DELETE TO anon USING (true);

CREATE POLICY "secteurs_select" ON secteurs FOR SELECT TO anon USING (true);
CREATE POLICY "secteurs_insert" ON secteurs FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "secteurs_update" ON secteurs FOR UPDATE TO anon USING (true);
CREATE POLICY "secteurs_delete" ON secteurs FOR DELETE TO anon USING (true);

-- ── 3. SEED — Province Kwilu ──────────────────────────────────────────────────

INSERT INTO territoires (province_name, name, label) VALUES
  ('Kwilu', 'BULUNGU', 'Bulungu'),
  ('Kwilu', 'IDIOFA',  'Idiofa'),
  ('Kwilu', 'GUNGU',   'Gungu')
ON CONFLICT (province_name, name) DO UPDATE SET label = EXCLUDED.label;

-- Secteurs BULUNGU
INSERT INTO secteurs (territoire_id, name, label)
SELECT t.id, s.name, s.label FROM territoires t
CROSS JOIN (VALUES
  ('Imbongo','Imbongo'),('Kwenge','Kwenge'),('Kipuka','Kipuka')
) AS s(name,label)
WHERE t.province_name='Kwilu' AND t.name='BULUNGU'
ON CONFLICT (territoire_id, name) DO UPDATE SET label = EXCLUDED.label;

-- Secteurs IDIOFA
INSERT INTO secteurs (territoire_id, name, label)
SELECT t.id, s.name, s.label FROM territoires t
CROSS JOIN (VALUES
  ('Kipuku','Kipuku'),('Kalanganda','Kalanganda'),('Idiofa_Musanga','Idiofa Musanga')
) AS s(name,label)
WHERE t.province_name='Kwilu' AND t.name='IDIOFA'
ON CONFLICT (territoire_id, name) DO UPDATE SET label = EXCLUDED.label;

-- Secteurs GUNGU
INSERT INTO secteurs (territoire_id, name, label)
SELECT t.id, s.name, s.label FROM territoires t
CROSS JOIN (VALUES
  ('Mungindu','Mungindu'),('Kilamba','Kilamba'),('Mudikalunga','Mudikalunga'),('Gungu','Gungu'),('Lukamba','Lukamba')
) AS s(name,label)
WHERE t.province_name='Kwilu' AND t.name='GUNGU'
ON CONFLICT (territoire_id, name) DO UPDATE SET label = EXCLUDED.label;

-- ── 4. SEED — Province Kasaï ──────────────────────────────────────────────────

INSERT INTO territoires (province_name, name, label) VALUES
  ('Kasaï', 'TSHIKAPA', 'Tshikapa'),
  ('Kasaï', 'LWEBO',    'Lwebo'),
  ('Kasaï', 'MWEKA',    'Mweka')
ON CONFLICT (province_name, name) DO UPDATE SET label = EXCLUDED.label;

-- Secteurs TSHIKAPA
INSERT INTO secteurs (territoire_id, name, label)
SELECT t.id, s.name, s.label FROM territoires t
CROSS JOIN (VALUES
  ('Bakwaniambi','Bakwaniambi'),('Bapende','Bapende'),('Tshikapa','Tshikapa')
) AS s(name,label)
WHERE t.province_name='Kasaï' AND t.name='TSHIKAPA'
ON CONFLICT (territoire_id, name) DO UPDATE SET label = EXCLUDED.label;

-- Secteurs LWEBO
INSERT INTO secteurs (territoire_id, name, label)
SELECT t.id, s.name, s.label FROM territoires t
CROSS JOIN (VALUES
  ('Kabambayi','Kabambayi'),('Lwebo_Wedi','Lwebo-Wedi')
) AS s(name,label)
WHERE t.province_name='Kasaï' AND t.name='LWEBO'
ON CONFLICT (territoire_id, name) DO UPDATE SET label = EXCLUDED.label;

-- Secteurs MWEKA
INSERT INTO secteurs (territoire_id, name, label)
SELECT t.id, s.name, s.label FROM territoires t
CROSS JOIN (VALUES
  ('Bakuba','Bakuba')
) AS s(name,label)
WHERE t.province_name='Kasaï' AND t.name='MWEKA'
ON CONFLICT (territoire_id, name) DO UPDATE SET label = EXCLUDED.label;

-- ── 5. SEED — Province Kasaï Central ──────────────────────────────────────────

INSERT INTO territoires (province_name, name, label) VALUES
  ('Kasaï Central', 'DEMBA',  'Demba'),
  ('Kasaï Central', 'LUIZA',  'Luiza'),
  ('Kasaï Central', 'DIBAYA', 'Dibaya')
ON CONFLICT (province_name, name) DO UPDATE SET label = EXCLUDED.label;

-- Secteurs DEMBA
INSERT INTO secteurs (territoire_id, name, label)
SELECT t.id, s.name, s.label FROM territoires t
CROSS JOIN (VALUES
  ('Tshibote','Tshibote'),('Diofwa','Diofwa'),('Tshibungu','Tshibungu'),
  ('Lusonge','Lusonge'),('Benamamba','Benamamba'),('Lombelo','Lombelo'),('Mwanzangoma','Mwanzangoma')
) AS s(name,label)
WHERE t.province_name='Kasaï Central' AND t.name='DEMBA'
ON CONFLICT (territoire_id, name) DO UPDATE SET label = EXCLUDED.label;

-- Secteurs LUIZA
INSERT INTO secteurs (territoire_id, name, label)
SELECT t.id, s.name, s.label FROM territoires t
CROSS JOIN (VALUES
  ('Lusanza','Lusanza'),('Lueta','Lueta'),('Kalunga','Kalunga')
) AS s(name,label)
WHERE t.province_name='Kasaï Central' AND t.name='LUIZA'
ON CONFLICT (territoire_id, name) DO UPDATE SET label = EXCLUDED.label;

-- Secteurs DIBAYA
INSERT INTO secteurs (territoire_id, name, label)
SELECT t.id, s.name, s.label FROM territoires t
CROSS JOIN (VALUES
  ('Tshishilu','Tshishilu'),('Dibatayi','Dibatayi'),('Dibanda','Dibanda')
) AS s(name,label)
WHERE t.province_name='Kasaï Central' AND t.name='DIBAYA'
ON CONFLICT (territoire_id, name) DO UPDATE SET label = EXCLUDED.label;

-- ══════════════════════════════════════════════════════════════════════════════
-- FIN — Vérification rapide :
-- SELECT t.province_name, t.name AS territoire, s.name AS secteur, s.label
-- FROM secteurs s JOIN territoires t ON s.territoire_id = t.id
-- ORDER BY t.province_name, t.name, s.name;
-- ══════════════════════════════════════════════════════════════════════════════
