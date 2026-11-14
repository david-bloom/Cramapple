# APPROVAL-0285 — Label 75 previously unit-less published items, 2026-11-14

- **Date:** 2026-11-14.
- **Authorization:** David Bloom (Product Owner), in chat: "Run votes and repairs for all" (after "Triage the 76"), on top of the standing direction to publish the missing labels. The 11 repaired items were rewritten under APPROVAL-0284.
- **What is written (Production `pcntajvbdfqhbeewmdry`), one transaction per subject (Calculus BC 37, Chemistry 8, Physics 1 7, Physics C: Mechanics 7, Physics 2 6, Physics C: E&M 5, Precalculus 4, Biology 1):** 75 validated primary topic cells and 75 validated hash-fresh serving labels. Each item's held, provisional or legacy label is superseded (non-validated rows only); no validated row is changed.
- **Basis:**
  - 58 items: blind six-vote topic probe (gemini-3.8-flash x2, deepseek-v4-pro x2, gpt-6.1-sol x1-2), topic named by at least 5 of the votes cast and every required unit named by at least 4.
  - 17 items: vote splits, ruled by the CED text and the item content (`scripts/content-seed/label-gap-audit-u6plus-2026-11-13/rulings_unitless.py`, one line of basis each). Six are judgment calls within a unit or between neighbouring topics and are flagged below.
  - The 11 items repaired in APPROVAL-0284 were voted on their new versions.
- **Judgment calls the owner may want to look at:** `apprecalc-frq-006` (1.7 vs 1.14), `apprecalc-frq-np2-010` (3.12 vs 1.8), `apcalcbc-mcq-004` (5.11 vs 4.2), `apcalcbc-frq-020` (5.12 vs 3.2), `apcalcbc-frq-u13-014` (5.1 vs 2.3 and others), `apphycm-mcq-019` (5.6 vs 6.3), `apphy2-frq-002` (10.3 vs 10.5). `apchem-mcq-004` overrules 4 of 6 votes (2.3) with CED 3.2's text on ionic conductivity.
- **Screen for out-of-course content:** the accepted topics' exclusion statements in the fact packs were checked (rolling 6.5, photoelectric 15.5, buffer 8.9 and others); the items under them stay inside the stated bounds. This screen is partial: it covers only the exclusion statements the fact packs record, and I read item text for the Euler, rolling and photoelectric cases only.
- **NOT labeled:** `apcalcbc-mcq-007` (Newton's method, not in the CED PDF text), left unserved for the owner to retire or keep.
- **NOT changed:** item text (APPROVAL-0284 did that for 11), any validated cell or label, any other item, schema, functions, frontends.
- **Rollback:** delete cells, labels and validation decisions with source `label_gap_fill_unitless_r8_2026_11_14`; clear `superseded_by` on the labels they superseded.
- **Numbering check:** highest APPROVAL on origin/main, open PRs and remote branches was 0284; this record takes 0285.
- **Rehearsal:** eight `REHEARSAL OK` (rolled back, constraints forced immediate).
- **Cost:** gateway votes about $2.0 and rubric rechecks about $0.3, measured from the ledgers in `stage8/`, `stage10/`, `stage9/`.
- **Result:** see the execution record below.
