# Continuation: AP Chemistry FRQ structure repair (in progress, not finished)

This is a handoff for the last unfinished piece of a two-day cross-subject FRQ-structure QA-and-repair effort. Read `docs/activity_log/ACTIVITY_LOG.md`'s "FRQ Structure QA and Repair Across Six Subjects" entry (2026-07-25/26) first for full context on what already happened in Bio, Physics, Calc AB/BC, and Precalculus — this file only covers what's left.

## What's already done (context, don't redo)

- AP Biology long FRQs: fixed, 42/42 verified.
- AP Biology short FRQs: bulk-retired by David, rebuild not yet scoped.
- AP Physics (all 4 subjects): Codex Phase 2 approved and in progress separately — not tracked in this repo session, don't touch.
- AP Calculus AB: fixed, 16/16 verified (9 points each), forked where reviewed, assigned to Carlos Eduardo Hutchings.
- AP Calculus BC: fixed, 16/16 verified (9 points each), edited in place (no prior reviews existed). **No reviewer assigned — BC has no qualified/assigned reviewer at all.** That's a pre-existing staffing gap, not something to fix by guessing; ask David.
- AP Precalculus: fixed, 16/16 verified (6 points each, correctly labeled "Part A/B/C", archetype-classified), forked, reassigned to Muhammad Saood.
- **AP Chemistry, 6 of 28 long FRQs fixed**: `apchem-frq-l-001` through `-006`, all now verified at exactly 10 points. 1 edited in place, 5 forked to Muhammad Zeeshan Hanif (the sole qualified Chemistry reviewer — note 2 of those 5 forks got an auto-created review assignment from an existing DB trigger; only 3 needed a manual insert. Check for this trigger behavior again before manually inserting for the remaining items, to avoid duplicate-key errors on `content_review_assignments`).

## Ground truth (verified directly from the primary source — reuse, don't re-derive)

`docs/teaching/ap-chemistry-course-and-exam-description.pdf` (local, Fall 2024 edition), confirmed via literal "Scoring Guidelines for Question N: [Short-Answer/Long-Answer] — [X] points" headers:

- **3 Long questions, 10 points each.**
- **4 Short questions, 4 points each.**
- No fixed part-count template — the CED's own sample long question has 8 lettered parts (a)-(h); its sample short question has 3 parts (a)-(c) with one part worth 2 points via two sub-bullets. Only the **total** is fixed. Match a defensible part structure to each item's actual content; don't force a rigid template.

Full detail and the original full-bank audit: `docs/research/AP_CHEMISTRY_FRQ_STRUCTURE_VALIDATION_2026_07_25.md`.

## What's left — exact item lists (verified 2026-07-26, re-verify before trusting if time has passed)

### 21 long FRQs still need fixing (target: 10 points; currently 7-9)

| content_key | current points | has submitted decision |
|---|---:|---|
| `apchem-frq-l-007` | 9 | no |
| `apchem-frq-l-008` | 9 | no |
| `apchem-frq-l-009` | 9 | no |
| `apchem-frq-l-010` | 8 | no |
| `apchem-frq-l-011` | 9 | no |
| `apchem-frq-l-012` | 9 | no |
| `apchem-frq-l-013` | 8 | no |
| `apchem-frq-l-014` | 8 | no |
| `apchem-frq-l-015` | 8 | no |
| `apchem-frq-l-016` | 8 | no |
| `apchem-frq-l-017` | 7 | no |
| `apchem-frq-l-018` | 9 | no |
| `apchem-frq-l-019` | 9 | no |
| `apchem-frq-l-020` | 9 | no |
| `apchem-frq-l-021` | 9 | no |
| `apchem-frq-l-022` | 9 | no |
| `apchem-frq-l-023` | 9 | no |
| `apchem-frq-l-024` | 8 | no |
| `apchem-frq-l-025` | 8 | no |
| `apchem-frq-l-026` | 7 | no |
| `apchem-frq-l-027` | 9 | no |

None of these have a submitted decision as of this writing — all can be edited in place (re-verify per item before doing so; don't trust this table blindly, the Bio/Precalc work this session both found decisions had been added between an initial audit and execution). The gap here is smaller than the 6 already fixed (+1 to +3 points needed, not +6) — likely a lighter touch: bump one or two of each item's existing criteria by 1 point each with a genuinely distinct added sub-check, rather than a full 3-way split of every part. `apchem-frq-l-028` is already correct at 10 points — leave it alone.

### 19 short FRQs still need fixing (target: 4 points)

**10 under-pointed at 2 points** (need +2 each): `apchem-sfrq-001` through `apchem-sfrq-010`.
- **`apchem-sfrq-001` is the highest-priority item in this whole list — it is currently `published` at both item and version level, meaning it may be reachable by real students right now**, under-pointed at 2/4. Has no submitted decision — safe to edit in place. Fix this one first.
- `apchem-sfrq-002` through `-010` (9 items) all have a submitted decision — must fork, not edit in place.

**4 under-pointed at 3 points** (need +1 each): `apchem-sfrq-026`, `-027`, `-029`, `-030`. No submitted decisions — edit in place.

**3 over-pointed at 5 points** (need -1 each): `apchem-sfrq-015`, `-019`, `-038`. No submitted decisions — edit in place. Trim rather than expand: identify the least-essential or most redundant point in each item's existing criteria and remove or merge it, don't just arbitrarily dock a point from an arbitrary criterion.

**1 over-pointed at 6 points** (needs -2): `apchem-sfrq-023`. No submitted decision — edit in place.

The other 20 short FRQs already sit at exactly 4 points — do not touch them.

## Method to follow (same discipline used for everything else this session)

1. Pull each item's actual stem/stimulus/criteria before designing a fix — don't guess from the content_key alone.
2. Design a fix that adds or removes genuine, distinct, verifiable content — not point inflation on an unchanged task. Verify any chemistry math/reasoning yourself before committing it.
3. Check `app.content_review_decisions` per item immediately before writing (not from this table, which is a point-in-time snapshot) — fork a new `content_item_versions` row for any item with a decision, edit in place otherwise.
4. After every write, run a fresh `SELECT` against the database and read its actual output before calling anything "verified." Do not report a value from memory or from what you intended to write — this exact mistake happened twice with a delegated Haiku process earlier in this effort and was only caught by independent re-querying.
5. Work in small batches (4-6 items) and verify each batch before moving to the next, rather than attempting all 40 remaining items in one unsupervised pass.
6. For any forked version, create a `content_review_assignment` — check first whether the DB trigger already auto-created one (seen twice on the Chemistry batch already done) to avoid a duplicate-key error, and route to Muhammad Zeeshan Hanif (the sole qualified Chemistry reviewer — confirmed via `app.validator_qualifications` / existing assignment counts, not assumed).

## Open items for David (not this session's call)

- No qualified reviewer exists for AP Calculus BC at all — needs a staffing decision.
- Chemistry has only one reviewer (Zeeshan) with no pairing partner for blind comparison — same situation Bio was in before Adil/Sarah were added.
- Whether/when to scope the AP Biology short-FRQ rebuild (100 items, each needs 2 new parts authored — a real content project, not mechanical).
