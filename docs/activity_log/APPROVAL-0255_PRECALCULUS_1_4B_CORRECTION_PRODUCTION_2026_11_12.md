# APPROVAL-0255 — AP Precalculus topic 1.4 seed B: two published items corrected in place (granted and executed 2026-11-12)

- **Status:** Granted by David in chat ("Fix in place", 2026-11-12) and executed.
- **Tier:** Production content edit (student-facing questions).
- **Basis:** A PR review found that `apprecalc-mcq-b10-h-1.4-b` and `apprecalc-mcq-b10-sv-h-1.4-b-v3` (published under APPROVAL-0243 to 0253) had turning-point counts that contradicted the stated end behavior, so neither had a valid answer.

## Change
- Base: 5 local extrema with both ends rising; answer degree 6 (was: ends opposite, which forces an even number of turning points). v3: 2 turning points with ends opposite; answer degree 3 (was: both ends rising, which forces an odd number).
- Stem, four choices (text, key, rationale) and the answer letter updated in place on the published versions. Editing content marks serving labels stale by design, so the two serving labels were re-confirmed with a new validation decision (owner chat instruction, topic and units unchanged) and re-stamped against the new content hash.
- Script: `scripts/content-seed/apprecalc-harder-seeds-u1a-2026-11-12/fix_1_4_b_2026_11_12.sql`; draft source corrected in the same folder.

## Verification
Rehearsed in a rolled-back transaction first (8 choice rows, 2 of 2 labels valid). After the real run: both items published, label_status validated, label hash equals the live content hash, keys B and A as intended.

## Not done
The other Unit 1 and Unit 2 seeds were not re-audited for the same kind of logical flaw; neither model's key check detects a question whose premises are inconsistent.
