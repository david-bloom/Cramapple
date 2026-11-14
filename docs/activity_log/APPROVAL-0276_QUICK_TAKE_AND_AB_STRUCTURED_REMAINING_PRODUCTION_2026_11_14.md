# APPROVAL-0276 — quick_take for six more subjects, Calculus AB structured text and AB source-field primes, applied to Production

- **Date:** 2026-11-14 (UTC).
- **Authorization:** David, in chat: "do #2 for every unit which is derived only; do #3 for calculus AB", then "move all updated cheat sheets to prod".
- **What is written (Production, project `pcntajvbdfqhbeewmdry`), in order:**
  1. AP Calculus AB 5.6-5.9 `answer_move` / `common_point_loss`: lost second-derivative primes restored (f'' had one prime); `source_note` appended.
  2. AP Calculus AB structured text (bullets, numbered steps) on 41 topics in units 1 and 6-8; 5 topics (1.5, 1.6, 1.7, 1.9, 1.11) left as single-idea prose.
  3. `quick_take` on 363 published rows that had none: Biology 6-8 (27), Chemistry 6-9 (43), Calculus AB (81), Calculus BC (111), Physics 1 (43), Precalculus (58). Physics 2 and Physics C excluded.
- **Guard:** each update matched only the Production hash the text was built on (`answer_move|common_point_loss` for quick_take, which also required `quick_take is null`; four-field md5 for structured text); count checks raise on a mismatch. Dev took all three first. Ref confirmed with `--debug`.
- **Evidence:** `scripts/content-seed/quick-take-rest-2026-11-14/` (src_*.json, qt_*.txt, proposed.json, snap_fixed.json, m1/m2/m3 SQL, check_out*, readback.sql). Authored in session by Claude agents; two checker families (`openai/gpt-6.1-sol`, `moonshotai/kimi-k3.1-pro`) over every topic; planted control caught by both; 3 real defects fixed (BC 10.2 parse bug, Physics 1 1.5, Precalculus 1.5) and rechecked clean; the AB structured set had no findings (no planted control run on that set).
- **Read-back:** independent Production query: quick_take 363/363 equal proposed text; AB structured 41/41; AB answer_move/common_point_loss 4/4.
- **Known limits:** no human review; not seen rendered; checkers compare against the same source fields, so source mismatches carry through (e.g. BC 1.16, 5.2, 8.2, 8.3, 10.5; Chemistry 7.3, 7.8, 8.1; Calculus AB hook line from the "Times the derivative of what's inside" hook on 3.1 only); about 55 quick_take lines have a label line over 25 words in total (sentences each within the limit); primes scanned only on concavity / second-derivative AB topics.
- **Rollback:** `update app.topic_explainers set quick_take = null` for the 363 rows; restore AB text and source fields from `fetch_ab.json` and `src_ap_calculus_ab.json`.
- **Numbering check:** 0275 is claimed by open PR 654 (label gap audit); this record uses 0276.
