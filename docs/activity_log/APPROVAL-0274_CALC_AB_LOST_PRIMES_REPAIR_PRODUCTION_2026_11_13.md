# APPROVAL-0274 — AP Calculus AB lost second-derivative primes restored in Production

- **Date:** 2026-11-13 (UTC).
- **Authorization:** David, in chat: "fix the Calc AB derivative primes", then "Apply to Production" after being shown scope, checker results and the Dev application.
- **What is written (Production, project `pcntajvbdfqhbeewmdry`):** `app.topic_explainers`, AP Calculus AB topics 5.6, 5.7, 5.8, 5.9, 5.11: 23 edits across the four text fields plus `weak_answer` on 5.6, 5.7, 5.8. Only prime counts changed (f'' h'' k'' m'' A'' had been stored with one prime). `source_note` appended.
- **Guard:** each update matched only the four-field md5 (and the exact old `weak_answer`) from the Production snapshot; a count check raises unless 5 rows carry the note. Ref confirmed with `--debug`.
- **Evidence:** `scripts/content-seed/structured-explainers-rest-2026-11-13/` (`migration_primes.sql`, `primes_proposed.json`, `primes_weak.json`, `primes_current.json`, `check_out/primes_*.json`, `check_out/primes2_*.json`). Two checker families; the first pass caught a missed prime in 5.8, fixed; second pass clean (10 of 10 pass).
- **Read-back:** Production: 5 of 5 four-field md5s and 3 of 3 `weak_answer` md5s equal the proposed text.
- **Limits:** only topics mentioning second derivatives, concavity or inflection were scanned; no human review; not seen rendered. Calculus BC's matching topics already had correct primes.
- **Rollback:** restore the old text from `primes_current.json` and the `old` values in `primes_weak.json`.
