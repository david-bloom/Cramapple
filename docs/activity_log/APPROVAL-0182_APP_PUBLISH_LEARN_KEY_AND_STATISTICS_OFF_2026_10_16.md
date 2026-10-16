# APPROVAL-0182 — Merge and publish app PRs #31 and #32 (learn-mode key; Statistics More help off)

**Decision:** Approved and applied; verified on the live domain.
**Date:** 2026-10-16
**Approver:** Product Owner David Bloom ("Merge #31 and #32 and publish"; "Publish once Lovable syncs")
**Tier:** Hard-Gate (live app publication)

**What shipped (app repo david-bloom/ap-prep-blueprint, `main` at `5bf2e4b`, Lovable project `56cae479…`):**
- **#31** Learn mode shows the answer key for served MCQs from the in-memory current-question preload (depends on Production `student-session-items` v41, APPROVAL-0181). Never in practice mode, never another question's answer.
- **#32** Statistics removed from the More help policy: the published app had shown the button (via #30) while Production's backend allows only Calculus AB/BC and Chemistry (HTTP 403 `subject_not_supported`).

**Sequence:** both checks green; merged #32 then #31 (merge commits); combined `main` 1194 tests pass, typecheck clean; waited until Lovable's `latest_commit_sha` equalled `5bf2e4b`, then published (deployment `8991ad8d-0260-48fb-b408-b24d19037bd0`, ap-prep-blueprint.lovable.app / app.cramapple.com).

**Live verification (signed-in Chrome):** AP Biology 1.4 learn mode: the worked example and every served question show a four-row key; Statistics 1.7 practice: no More help button, Submit/Hint intact. Not verified live: Calculus AB/BC and Chemistry still show More help (covered by unit tests; checking would change the active subject).

**Known roughness:** on each served learn-mode question the old "answer key isn't available here" text shows for about a second before the preload fills the key. A "Loading the answer key…" state would remove the flash.

**Still open:** Statistics More help is off in Production; re-enabling needs the gate migration, `more-help` v16+, the policy row, and the owner's acceptance of the output packet.
