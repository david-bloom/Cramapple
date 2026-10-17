# BC image mirror and Biology Units 1–3 visual audit

**Status:** Ready for Review (conductor audit and exact BC mirror executed; fresh independent QA not performed). **Owner:** Codex / Main Conductor. **Product Owner:** David Bloom.
**Tier:** Hard-Gate for the authorized BC Production attachment; Standard for the read-only Biology audit.
**Branch:** `codex/question-images-bc-biology-u1-u3`. **PR:** pending.
**Authorized:** 2026-10-16 America/New_York: David requested (1) mirror Calculus AB images to BC, (2) audit Biology Units 1–3 only, including existence and student delivery. No other subject or later Biology unit audit is authorized. The earlier image-audit PR #457 is merged.

## Execution scope

- Find genuine BC counterparts of AB's four live images by same question source/provenance, not matching numerical suffixes. Preserve question/choice/scoring/taxonomy data and reuse approved immutable bytes with BC-version-specific metadata.
- Read every published Biology Units 1–3 presentation, including choices and authored FRQ parts; distinguish actual missing visuals, complete tables/text, learner-created responses and missing instructions.
- Check existing private objects, approved metadata, current serving gates and the signed-in browser path. Record exactly what was exercised, rather than asserting that every published item was browser-tested.
- Preserve the six already approved AB/Chemistry objects. No app/function/schema changes, paid model runs, Biology content writes or later-unit review.

## Initial results

One exact published BC mirror exists: `apcalcbc-mcq-ab-060` explicitly names `apcalcab-mcq-060` and its exact source version under APPROVAL-0090; stem/stimulus/choices match. The three other AB image questions have no identical published BC presentation. BC's own topic-1.3 teaching example has different graph coordinates and cannot use AB's image. A clarification about new BC-specific drawings is pending; no new diagram is assumed authorized by silence.

Biology: 221 resolved in-scope versions (187 MCQs, 34 FRQs; U1 104, U2 80, U3 37) read completely. One private image (`APBIO-FRQ-S-003`) downloads but has no approved metadata; 15 legacy FRQs lack actual instructions in the presentation. No missing prompt image object is confirmed in the remaining complete questions. Two unassigned graph exercises remain explicit scope-boundary records, not an inferred unit assignment.

## Acceptance / QA

Exact-version/source guards, private-object checksum and public-denial checks; BC attachment and recovery rehearsals; unchanged question/scoring/choice/taxonomy hashes. Reconcile 221 inventory/review identities and recheck source drift. Verify representative Biology MCQ/FRQ/worked-example routes and the mirrored BC question, without submitting answers. Independent fresh QA authorization requested; no agent spawned yet.

**Approval state:** User instruction authorizes the bounded mirror and read-only audit. No Biology repair or broader publication is authorized. New BC visuals await the owner's clarification.
**Execution:** The one exact BC mirror was attached at 2026-10-17 03:03:45 UTC under APPROVAL-0183. Attachment and recovery mutation rehearsals passed with ROLLBACK; approved path remains live after recovery rehearsal. The image decoded on the live BC practice page, with the expected v2 filename, alt text and 680px natural width (622.65625 CSS display width). No new object or diagram was created. The browser disconnected during the narrow-viewport step; no new phone pass is claimed.

**Biology result:** [Full report](../qa/BIOLOGY_U13_QUESTION_VISUAL_AUDIT_2026_10_16.md). 221 canonical-mapped versions read; four later-unit serving conflicts are boundary exclusions, leaving217 strictly in scope. One image-delivery blocker;15 mapped-scope legacy presentations lack instructions (14 strictly in scope).193 eligible ordinary practice versions in a paged no-history probe;192 survive image metadata gating. All22 teaching-topic RPCs select audited versions. Representative owner-profile browser checks pass for MCQ/worked-example delivery and reproduce the missing3.4 FRQ/fallback; no ordinary-student or whole-question certification.

**QA / Done:** Fresh independent QA authorization remains pending; no agent was spawned. No blanket visual or whole-question completeness certificate; no Done decision. [Handoff](../handoffs/SESSION_CLOSE_2026_10_16_BC_MIRROR_BIOLOGY_VISUAL_AUDIT.md).
