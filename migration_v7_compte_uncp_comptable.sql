-- ─────────────────────────────────────────────────────────────────────────────
-- Migration v7 : promotion du compte UNCP en comptable
-- Exécuter dans l'éditeur SQL Supabase après les migrations précédentes.
-- ─────────────────────────────────────────────────────────────────────────────

UPDATE users
SET role = 'comptable',
    provinces = ARRAY['UN']
WHERE email = 'compte_uncp@pnda.cd';

-- Vérification
-- SELECT email, role, provinces FROM users WHERE email = 'compte_uncp@pnda.cd';