# APPROVAL-0187 — Enable More help for AP Physics 1 and AP Biology, units 1–3 (2026-10-16)

**STATUS: APPROVED, NOT YET EXECUTED** (the Production write was blocked by the tool permission classifier). **Approver:** David Bloom (chat, 2026-10-16: "do 2, 3, 4 for both subjects"). This is the owner's explicit override of "one subject at a time" for these two subjects.

## Steps and state
2. **Development proof (done):** policy rows for both subjects in Dev; second synthetic identity with temporary entitlements; 12 live requests, 12 delivered (Physics 1: 3 FRQ; Biology: 3 FRQ + 6 MCQ). Dev has no Physics 1 MCQs (the Production publish tool cannot load into Dev's drifted schema: missing `tutor_decision` column, Physics 1 skill grid), so **Physics 1 MCQs are untested**; the MCQ path is proven for other subjects and Biology.
3. **App (done, unmerged):** david-bloom/ap-prep-blueprint#34 adds `ap_biology` and `ap_physics_1` (units 1–3) to `MORE_HELP_UNITS`; tests pass. Do not publish the app until step 4 is done.
4. **Production enable (pending):** `enable_ap-physics-1.sql` and `enable_biology.sql` in `scripts/content-seed/more-help-gap-fill-bio-phy1-2026-10-16/` (from `docs/qa/more_help_release/02_enable_subject.sql`), run on Production from the home directory: `supabase db query --linked -f <file>`. Preconditions met: gate migrations and `more-help` v3 are live. Then the owner publishes the app, then the owner smoke test and `05_smoke_checks.sql`.

## Known finding from the Dev read
Before submission, Biology concept MCQs often get help that states the key idea that decides the answer (3.1 "Enzymes lower activation energy; they do not change overall energy released"; 2.2 "a larger cell generally has a lower SA:V"; 3.5 headline). The server's explicit-answer checks do not catch conceptual statements (known residual risk H03). Physics 1 FRQs were clean except 3.3 part (c) ("the change does not depend on where zero is set").

## Rollback
`docs/qa/more_help_release/03_rollback_subject.sql` per subject: refused before any model call, no data touched.
