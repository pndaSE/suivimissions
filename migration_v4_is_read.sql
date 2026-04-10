-- ════════════════════════════════════════════════════════════════════
-- Migration V4 — Ajout du statut lu/non-lu sur les rapports
-- ════════════════════════════════════════════════════════════════════
-- À exécuter dans l'éditeur SQL de Supabase (SQL Editor)
-- ════════════════════════════════════════════════════════════════════

ALTER TABLE reports ADD COLUMN IF NOT EXISTS is_read BOOLEAN DEFAULT false;
ALTER TABLE reports ADD COLUMN IF NOT EXISTS read_at TIMESTAMPTZ DEFAULT NULL;
ALTER TABLE reports ADD COLUMN IF NOT EXISTS read_by TEXT DEFAULT NULL;

-- Index pour accélérer le filtrage des rapports non lus
CREATE INDEX IF NOT EXISTS idx_reports_is_read ON reports (is_read) WHERE is_read = false;
