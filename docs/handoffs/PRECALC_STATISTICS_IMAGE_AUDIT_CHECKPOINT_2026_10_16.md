# Precalculus and Statistics question-visual audit checkpoint

**Status:** conductor read-only Units 1–3 audit complete; missing visuals and independent/browser verification remain open.
**Task:** [WORK-PRECALC-STATISTICS-IMAGE-AUDIT-U13](../tasks/WORK-PRECALC-STATISTICS-IMAGE-AUDIT-U13.md).
**Report:** [full results and limits](../qa/PRECALC_STATISTICS_U13_IMAGE_AUDIT_2026_10_16.md).
**Branch:** `codex/question-images-precalc-statistics-u1-u3`. **PR:** pending.

David's “Now do precalculus and statistics” continued the preceding Units 1–3 audit. Reviewed all 801 selected published versions:312 Precalculus,489 Statistics. Strict coverage is794;7 Statistics boundary records are excluded. No other-subject or later-unit source census. Full same-version digests and routing metadata are unchanged at read-back.

Conductor found4 missing graph/chart representations:Precalculus `apprecalc-oht-1.3`; Statistics `APSTATS-OHT-1.4`, `1.5`, `2.1`. All4 are selected teaching examples with null image paths.45 further prose/graph-choice cases need subject adjudication (4 Precalculus,41 Statistics). No missing numerical givens or authored FRQ instructions found in source; actual part rendering is unverified.33 construction questions supply their inputs and must not receive completed answer graphs.

Live v41 pure visual gate passes801/801 because none has an image path or a required-image decision. Paged active-pack selectors return230 Precalculus/244 Statistics candidates; teaching RPCs return44/40 topic examples. Probes used a synthetic no-history selector identity and transaction-local existing owner/admin authority, not actual ordinary-student access. Browser reaches the unsigned-in login page, so no authenticated browser PASS. No learner state was changed.

All artifacts are committed under `scripts/image_readiness/precalc-statistics-u1-u3-2026-10-16/`; `progress.json` has801/801, zero unreviewed. `reviews.json` is the authoritative per-version ledger; `review-queue.json` narrows fresh review. `check-delivery.mjs` reconciles IDs/digests and the deployed pure gate.

Next owner subject reviewer/conductor: independently review4 proposed defects and45 uncertain representations, including negative controls. Stats1.5 supplies only one bin and the total; do not invent the rest of a histogram. Seek scoped implementation direction before creating/attaching images or changing content/labels, and use an authenticated browser before any student-rendering certificate. No independent agent, paid calls, Production writes, uploads or deployments were authorized/run. The user's original dirty checkout was preserved; work is isolated in the feature worktree. Earlier Biology/BC work remains separate in PR#479.
