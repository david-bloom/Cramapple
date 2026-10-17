# APPROVAL-0183 — Mirror existing Calculus AB question images to matching BC questions

**Date:** 2026-10-16 America/New_York (2026-10-17 UTC).
**Approved By:** David Bloom.
**Related Task:** WORK-BC-IMAGE-MIRROR-BIOLOGY-U13; WORK-QUESTION-IMAGE-COMPLETENESS.
**Decision:** Approved.

David instructed: “Mirror images from calculus ab to calculus bc.” He separately authorized a complete-question visual/delivery audit of Biology Units 1–3 only, expressly excluding other subjects and later Biology units.

The verified existing mirror is `apcalcbc-mcq-ab-060`, version `fdeb1925-dcae-4331-935b-890751635487`, whose recorded provenance points to `apcalcab-mcq-060`, version `f492bfbf-5434-434f-a4d8-50b058477139`, under APPROVAL-0090. Stem, stimulus and all four choices match. Reuse the existing approved private v2 PNG ending `9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png`; add BC-version accessibility metadata and required/approved visual decision. Preserve question, choices, scoring, taxonomy and serving labels. No upload, schema, app or function deployment is needed.

No matching published BC presentation was found for the other three AB images; BC's similarly numbered questions contain different givens. The instruction does not authorize attaching those incorrect images, rewriting the BC questions, or assuming approval for new BC drawings. Clarification about BC-specific drawings is pending. Biology audit is read-only: no content/metadata/label changes or image commissioning authorized.

**Execution evidence:** Applied at 2026-10-17 03:03:45.79893 UTC. Guarded attachment and recovery mutation rehearsals passed with ROLLBACK, and the live path/metadata/required-approved decision remained after recovery rehearsal. Source/scoring/choices/taxonomy/labels unchanged; signed checksum matches and public read blocked. Live BC practice displays the exact image, decoded at680px natural width with expected hash filename/alt text. Current artifacts: `scripts/image_readiness/bc-ab-mirror-2026-10-16/`. No new object/app/function/schema deployment. Fresh independent QA authorization requested; no extra agent started. A new phone-browser check could not finish because Chrome disconnected.
