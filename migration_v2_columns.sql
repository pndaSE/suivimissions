-- ══════════════════════════════════════════════════════════════════════════════
-- MIGRATION v2 — Colonnes manquantes
-- Exécutez dans l'éditeur SQL Supabase :
-- https://supabase.com/dashboard/project/arpglssgrecsadlhtxxg/sql/new
-- ══════════════════════════════════════════════════════════════════════════════

ALTER TABLE missions_ref ADD COLUMN IF NOT EXISTS category TEXT NOT NULL DEFAULT 'implementation';
ALTER TABLE reports      ADD COLUMN IF NOT EXISTS seq_number INT;
ALTER TABLE users        ADD COLUMN IF NOT EXISTS display_name TEXT;
