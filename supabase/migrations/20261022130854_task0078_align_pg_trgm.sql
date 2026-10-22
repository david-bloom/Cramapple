-- TASK-0078 ruling 6 (David, 2026-10-22): align Development to Production.
-- Bucket: pg_trgm. Production has pg_trgm 1.6 installed in schema public (no local migration, no
-- ledger row, no index or function uses it). Development lacks it; 37 of the 50 "Production-only
-- functions" in the drift inventory are this extension's own functions. Installing it in the same
-- schema closes that bucket. Idempotent.
create extension if not exists pg_trgm with schema public;
