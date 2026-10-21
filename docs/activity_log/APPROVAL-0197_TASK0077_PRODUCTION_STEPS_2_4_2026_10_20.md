# APPROVAL-0197 — TASK-0077 Production rollout, runbook steps 2–4 (2026-10-20)

**STATUS: IN PROGRESS — step 2 executed; step 3 next.** **Approver:** David Bloom (chat, 2026-10-20: "Execute step 2-4").
**Runbook:** `docs/tasks/TASK-0077-PRODUCTION-RUNBOOK.md` (decisions D1–D5 answered the same day, recorded there).

## What is approved
Step 2 (email foundation, dormant), step 3 (trial backend, dormant, admission off) and step 4 (David adds the five Stripe live
webhook events, only after step 3.4). Not approved by this entry: step 5 (Lovable publish), step 6 (admission on, the $1 trial),
step 7 (launch, cardless retirement).

## Preconditions at approval
0.4: confirmed by David — Radar active, `https://cramapple.com/terms` saved on the Stripe public profile. 0.7: confirmed
by Claude — Production and Development hold the same `LOOPS_SECRET_KEY` digest, so the same Loops workspace that Development has
been sending these templates from. 0.5, 0.6: open (launch gates, not step 2–4 gates).

## Executed
- **2.1** Production migrations (versions Production stamped): `20261021003534` create_product_feedback_phase_b (repo
  `20261003000100`), `20261021003602` loops_transactional_email_outbox (repo `20261006084914`), `20261021003627`
  parent_email_lifecycle (repo `20261006143000`). Stored statements of the last two are md5-identical to Development's; the
  product-feedback table's columns, constraints, policies and grants are identical to Development's. Read-back: lifecycle tables
  RLS enabled + forced, service-role only; outbox RLS enabled (not forced, as the file defines), no client grants; both claim
  functions execute for `service_role` only; `product_feedback` select/insert for `authenticated` only.

- **2.2–2.4** secrets (17, digest-verified), two deploys (file-for-file equal to `3616edff`), worker 401/200 check passed; details
  in the runbook. Privacy URL also saved on the Stripe public profile (David, 2026-10-20).

## Rollback
Tables are additive and unused while the email flags are off. Redeploy `send-parent-payment-email` from `10abfd88` if step 2.3
has run.
