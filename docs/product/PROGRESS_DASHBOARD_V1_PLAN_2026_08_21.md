# Progress Dashboard v1 — Plan of Record

**Date:** 2026-08-21
**Status:** Backend built, QA passed, applied to Production. Frontend wiring
not started. Not student-visible.
**Related:** `UX-007`, `DECISION-0003`,
`docs/research/PROGRESS_EXPERIENCE_STATE_OF_PLAY_2026_08_21.md`
**Product Owner decisions (2026-08-21):** live not snapshot; topics and
per-unit/per-topic score breakdowns cut; `estimatedScore1To5` included;
`/home` loader defects fixed in the same session; all subjects ship.

Governing principle: **deploy with honestly empty states.** A section with no
data says so. It never shows a fabricated number, and it never shows `0` where
the truthful answer is "we cannot compute this".

---

## 1. Architecture

- Supabase is the sole producer of every progress metric.
- Lovable is display-only; see
  `prompts/LOVABLE_PROGRESS_DASHBOARD_V1_2026_08_21.md`.
- One RPC: `public.get_student_progress_dashboard(_subject_key text default null)`.
- Migration: `supabase/migrations/20260821080000_progress_dashboard_v1.sql`.
- QA: `scripts/qa/progress_dashboard_v1_qa.sql`.

## 2. Changes from the original draft plan, and why

| Draft | Shipped | Reason |
| --- | --- | --- |
| Snapshot-backed, read newest from `app.progress_snapshots`, else empty state | **Live compute on every call** | Read-or-empty would show an empty page to a student who *has* evidence. At 41 grading rows and 2 users there is no performance case for a cache. `progress_snapshots` is left untouched for a later history/trend version, and its index still ships. |
| `app.build_..._snapshot(_user_id, …)` writer function | **Not built** | Nothing to write yet, and a `SECURITY DEFINER` writer taking `_user_id` is an escalation surface with no current benefit. |
| Metrics from "authoritative backend tables" | **`app.grading_results` joined via `app.attempts`** | `app.attempts.score_points` / `graded_at` are null on all 44 production rows — the grading path never writes back. Reading `attempts` alone returns all zeros. |
| `topics[]` + `topicsCovered` | **Cut entirely** | No join path exists from a student attempt to a taxonomy topic. `topic_code` lives only on `app.taxonomy_topics`, `app.topic_explainers`, `app.topic_point_briefs`. Any topic figure would be invented. |
| `statusColor: "gray" \| "red" \| …` | **Semantic `status` token + `statusLabel`** | Colour in the data contract breaks theming, dark mode and accessibility, and cannot be changed without a coordinated frontend release. Lovable owns the colour mapping. |
| `red` = "low performance or sparse weak evidence" | **No red at all** | It conflated weak performance with thin evidence, and UX-007's approved principle is that incomplete work is never framed as learner failure. |
| Single `minutes`, falling back to `available_minutes` | **`actualMinutes` + `sessionsWithoutDuration`** | `available_minutes` is *planned* time. Summing planned and actual yields a number nobody can interpret, source marker or not. |
| Unit counts from content unit labels | **Units listed from verified taxonomy, attribution explicitly unavailable** | See §4. Mapping the available labels would produce confidently wrong attribution. |

## 3. Metric definitions as built

Evidence is de-duplicated twice, and both layers are load-bearing:

1. **Latest grade per attempt.** One attempt can be graded many times —
   production holds 10 grading rows across 3 items for a single user.
2. **First independent attempt per item.** Only the first counts as cold
   evidence; later passes are repairs. This mirrors `isQualifyingAttempt()` in
   the frontend's `home-snapshot.ts`.

De-duplication happens *within* the countable set, not before filtering, so a
student whose first pass on an item was coached does not lose their later
independent evidence.

- **MCQ percent correct** — numerator and denominator both over graded,
  independent, first-attempt MCQ items with `points_available > 0`. `uncertain`
  grades are excluded from *both* and reported as `uncertainExcluded`.
- **FRQ points** — `earnedPoints` / `possiblePoints` over the same set.
- **`estimatedScore1To5`** — under DECISION-0003. Requires **≥3 graded FRQ
  items and ≥10 possible points**; below that it is `null` with
  `confidence: "none"`. Bands: ≥0.75→5, ≥0.60→4, ≥0.45→3, ≥0.30→2, else 1.
  Confidence is **capped at `low` for all of v1** because DECISION-0003's
  calibration follow-up is still open, and the payload always carries
  `isOfficial: false`, a `qualifier`, an `evidenceGaps` list, and a
  `nextAction`.
- **Sessions / minutes** — `app.learning_sessions` scoped to user and exam pack.
  Minutes are real elapsed time only.
- **Excluded work** — `excludedNonIndependentItems` (coached or exam-practice)
  and `excludedOtherFormatItems` (`attempt_mode = 'quantitative'`, which v1 does
  not score) are counted and surfaced so no student's effort silently vanishes.

## 4. Why unit attribution is unavailable for every subject

`content_items` / `content_item_versions` carry no unit column. The only link
is `app.content_item_labels` with `label_type = 'unit'`, and its coverage is
both sparse and, where it exists, on the wrong curriculum:

- Only AP Statistics has substantial coverage (200 of 296 items). Biology,
  Chemistry and all four Physics subjects have **zero**.
- AP Statistics' labels use the legacy **nine**-unit structure (`unit_1` …
  `unit_9`), while its verified 2026-2027 taxonomy has **five** units with
  entirely different titles (old "Collecting Data" vs new "Inference for
  Categorical Data: Proportions").

Mapping label `unit_3` to taxonomy unit 3 would therefore be confidently wrong,
which is worse than absent. v1 lists units from the verified taxonomy — present
for all ten subjects — with `status: "attribution_unavailable"`,
`unitAttributionAvailable: false`, and `unitsWithEvidence: null` (null, not
zero: the value is uncomputable, not measured-as-none).

## 5. Security

Modelled on `public.get_student_taxonomy`: `STABLE SECURITY DEFINER`,
`SET search_path TO 'pg_catalog'`, `auth.uid()` null → `28000`, subject key
validated against `^[a-z0-9][a-z0-9_]*$`.

- Data is returned only for `auth.uid()`; the caller cannot name another user.
- Entitlement enforced against `app.subject_entitlements` (`status = 'active'`,
  `all_subjects` or matching `subject_id`, within `starts_at`/`ends_at`).
  Failure raises `42501`.
- Grants: `authenticated` only. Supabase's default privileges grant `EXECUTE`
  to `anon` at creation and `revoke ... from public` does **not** remove it —
  an explicit `revoke ... from anon` is required and is in the migration. The
  function's ACL now matches `get_student_taxonomy` exactly.
- Helper functions in `app` are revoked from `public`.

## 6. QA results (Production, 2026-08-21)

All checks in `scripts/qa/progress_dashboard_v1_qa.sql` pass:

| Check | Result |
| --- | --- |
| QA1 unauthenticated rejected | PASS |
| QA2 malformed subject key rejected | PASS |
| QA3 unentitled user rejected | PASS |
| QA4 no-subject returns a valid empty payload, not an error | PASS |
| QA5 required keys present, no `topics`, status enum closed | PASS |
| QA6 no cross-user leakage | PASS |
| QA7 de-dup math matches independent recomputation | PASS (2 items, 9/18, 1 uncertain) |
| QA8 withheld grades carry no point score | PASS |
| QA9 estimate honours evidence floor, bands, DECISION-0003 qualifiers | PASS |
| QA-UNITS units from taxonomy, attribution honestly absent | PASS |

## 7. Deviation from the draft rollout sequence

The draft sequenced Dev → QA → Prod. **Dev could not serve as the QA
environment.** Both projects record migration `20260820192400`, but Dev built a
divergent taxonomy design (`taxonomy_schemes`, `taxonomy_scheme_versions`,
`taxonomy_node_versions`, `taxonomy_node_relations`, `taxonomy_crosswalks`)
while Production built `taxonomy_source_versions` / `taxonomy_units` /
`taxonomy_topics`. The RPC therefore raises `42P01` on Dev.

Each project also carries migrations absent from the repo (Lovable-applied),
and repo migrations `20260821060000`–`20260821072000` are applied to neither.

Because the RPC is read-only, `STABLE`, and inert until Lovable calls it, it
was applied to Production and QA'd there. Nothing is student-visible.

**This drift is a standing problem beyond this work and needs its own task.**
Until it is reconciled, Dev cannot validate anything taxonomy-dependent.

## 8. Not done / next

1. **Wire Lovable** to the RPC and rebuild `/progress`, replacing the
   fixture-driven `_ux.progress.tsx`. Brief is written; not started.
2. **Grading write-back.** Nothing writes `app.attempts.score_points` /
   `graded_at`, or `app.attempt_criterion_results` (0 rows). Until that is
   fixed, `/home` still reports zero evidence even with its loader repaired,
   and criterion-level progress remains impossible.
3. **`/home` should migrate onto this RPC** so the two pages cannot disagree.
4. **Dev/Prod schema reconciliation** (§7).
5. **Unit labelling** for Biology, Chemistry and Physics, plus a decision on
   re-labelling AP Statistics against the 5-unit taxonomy, before unit
   attribution can ship.
6. **Calibrate `estimatedScore1To5`** per DECISION-0003's open follow-up before
   confidence rises above `low`.
7. **`src/lib/progress-queries.ts`** still queries the dead `sessions` table
   (0 rows, wrong column names). Unused by the route, but a landmine.
