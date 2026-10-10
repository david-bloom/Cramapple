# AP Chemistry Units 5–9 escalations, round 3 (`task0067-chem-escalations-r3-2026-10-10`)

**Why:** 11 escalations from `task0067-chem-u5-u9-2026-10-10` plus two Unit 8 duplicates. Product Owner (David): "do all of your recommendations … yes, do those too", 2026-10-10. The decisions are recorded as `DECISION-0113`.

**Method:**
- Fresh extraction of 10 rows (`out/only_r3_u<n>.json`).
- Owner topics and tags were pinned by the Product Owner decision.
- One new general extraction rule: keep every CED qualifier and scope limit exactly, and never add a claim the CED does not make. Formula symbol definitions are required (from `task0067-chem-formula-symbols-2026-10-10`).
- The Unit 8 weak-base equation arrow was verified against the rendered CED page (p. 151, 8.4.A.3: equilibrium arrows ⇄; the text extraction renders the glyph as U+F080). The reading is recorded in that row's `ced_evidence`.
- Two checkers + the Haiku veto, each flag re-sampled once. Controls (`controls_r3_u5.json`: a dropped hedge from 5.5.A.2, a wrong owner for Maxwell–Boltzmann): **2/2 caught**.

**Round 3:**
- 6 accepted: Maxwell–Boltzmann (5.5), Kp/Qp (7.3), Kb (8.3), Buffer solution (8.4), Weak base + strong acid (8.4, equilibrium arrows), Entropy and dispersal of matter (9.1).
- 3 rejected only on a topic tag (content accepted by all three models): collision requirements, titration curve, Henderson–Hasselbalch. 1 rejected on content: catalysis types.

**Rounds 4–5 (check only, same extracted content, tags corrected as the checkers named from the CED):**
- Collision requirements → `[5.5]` and titration curve → `[8.5]`: accepted.
- Henderson–Hasselbalch: models split on owner (8.9 vs 8.4). Decided by the protocol's first-requiring-topic rule: owner 8.4 (8.4.A.2 "the pH can be determined from the Henderson-Hasselbalch (H−H) equation"), tags `[8.4, 8.9]`. Accepted by all three.

**Outcome:**
- 9 of 10 accepted and loaded to Development and Production (`out/load_ap_chemistry_u{5,7,8,9}.sql`).
- Left out: catalysis types (content overstated "elementary reactions", rejected twice) and Unit 6 "Direction of thermal energy flow" (dropped: covered by the accepted 6.1 exothermic/endothermic entries).
- Unit 8 duplicates retired by `out/retire_u8_duplicates.sql`: standalone "pKa" and "pKw, pH and pOH at 25°C". Their content stays in the "Ka" and "Kw" entries.

**Unit 8 to Production:**
1. `task0067-chem-u5-u9-2026-10-10/out/load_ap_chemistry_u8.sql`
2. `out/update_formulas_u8_only.sql` (the 7 Unit 8 symbol-definition updates from the formula pass)
3. `out/retire_u8_duplicates.sql`
4. `out/load_ap_chemistry_u8.sql` (this batch)

**Verified:**
- Production equals Development for every unit: U1 26 · U2 21 · U3 32 · U4 22 · U5 29 · U6 20 · U7 21 · U8 32 (+2 retired) · U9 24.
- Formulas without symbol definitions: only Coulomb's law (U1) and the conjugate pair Ka·Kb = Kw (U8).
- QA checks 1–8 ok in Production.
- RPC counts identical in both (8.4 → 10, 8.9 → 6, 5.5 → 2, 7.3 → 4, Unit 8 → 32).

**Cost:** $0.97 (raw logs not committed).
