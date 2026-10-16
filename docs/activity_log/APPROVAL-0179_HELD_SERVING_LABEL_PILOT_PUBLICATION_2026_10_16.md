# APPROVAL-0179 — Publish the ten agreed serving labels from the held-label rerun pilot

**Decision:** Approved and applied; independently verified.
**Date:** 2026-10-16
**Approver:** Product Owner David Bloom
**Tier:** Hard-Gate (Production label metadata; no change to what students are served)

David directed: **"We might as well publish the labels we found in the pilot."** Scope is the ten rows from the [held-label rerun pilot](../qa/MORE_HELP_HELD_LABEL_RERUN_PILOT_2026_10_16.md) where the refreshed model pair (`openai/gpt-6.1-sol`, `google/gemini-3.8-flash`) agreed on the required-unit set. The seven pilot rows that stayed held (five disagreements, two call failures) were deliberately not rewritten.

**Effect:** the ten superseded `held` serving labels (Calculus BC 1, Chemistry 2, Physics 1 4, Physics C Mechanics 3 — see manifest) are replaced by ten current `provisional_model` rows, status `provisional_model`, no human validator, source `vercel_ai_gateway_two_model_serving_lane`, run `serving-units-mcp-2026-09-25-20261016122734`. Nine have a primary unit above 3 (units 4, 6, 7, 8); one (`apphy1-mcq-022`, Physics 1 unit 2) lies entirely within units 1–3. Serving reads only `validated` labels and a model may not write `validated` unsupervised (§T6), so nothing students see changes. No question, key, rubric, topic cell, learner record, More help policy or function was touched.

**Method:** unchanged labeler tool (`scripts/taxonomy/extend_serving_labels_mcp.mjs`); its guarded write (live-pack, current-version and taxonomy-hash checks; abort if a newer label exists; supersede, never delete). Rehearsed on Production in a transaction that applied the write, verified 10 inserted / 10 superseded, ran the recovery, proved the exact pre-state restored (md5 `4cd1da8f20fa2700acb21097ea474898`, 23 rows), and ended in a forced rollback; zero rows persisted. The real write added the same in-transaction verification.

**Result:** committed; independent read-back confirms 10 current `provisional_model` rows, 10 superseded `held` rows, 0 human validators. Pilot cost $1.25. Recovery: [`recover_labels.sql`](../../scripts/content-seed/more-help-held-labels-pilot-2026-10-16/recover_labels.sql) (refuses unless the 10 rows are unchanged). Metadata only; the generated SQL with model payloads stays private.

**ID check:** main's highest record was 0178; no open PRs or remote branches claimed 0179 at check.

**Open:** the ~77 other held labels are not rerun (expected 4–6 units-1–3 questions for about $5–6). Whether the labeler should compare primary unit rather than identical unit sets is a protocol decision for the Product Owner; revisit when units 4–7 open.
