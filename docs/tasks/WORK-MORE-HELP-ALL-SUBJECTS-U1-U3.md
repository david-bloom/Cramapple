# More help for all subjects, Units 1–3

**Status:** In Progress  
**Tier:** Hard-Gate  
**Owner:** Codex conductor; David Bloom, Product Owner  
**Owner direction:** 2026-10-15: “I want to build and deploy More Help for all questions possible in Units 1-3,” following the all-subject coverage audit. This expands the earlier three-subject implementation and explicitly authorizes deployment after QA. Preserve existing later-unit coverage.

## Scope and acceptance

Enable all ten supported subjects across app eligibility, authenticated backend context and receipt reservation. First three course units include registry units9–11 for Physics2 and8–10 for Physics C E&M. Each eligible question needs a supported topic, published reference grounding, complete authored prompt/parts and trustworthy visual grounding where applicable. Do not force a topic or silently omit a required image to reach a count.

Baseline read-only Production census:2,365 latest published versions in known first-three-unit scope;1,458 in the seven currently unsupported subjects. Four known-scope versions lack selected topics;161 published versions have unresolved unit scope. All mapped first-three-unit questions have reference entries. Seven scoped image questions include six approved Calculus/Chemistry visuals and one Biology question requiring review. These are content counts, not learner counts or proof of serving eligibility.

Implement in isolated backend/app branches; run independent final-source review and real signed-in Development subject/type/phase tests. Check assistance persistence, scoring isolation, image/figure context and phone rendering. Retain exact source provenance, guarded SQL/recovery and Production smoke evidence. Do not overwrite the separately deployed student-session-items teaching-image branch.

The new scope authorizes necessary bounded verification. Establish a separate ledger capped at30 More help generations and$5 accounted model cost for this expansion, including failures/retries. The earlier12-request round remains exhausted. No FRQ grading/photo-provider calls, paid content generation, new provider/model slate, credit purchase or secret changes are authorized by this verification budget. Human reading of actual outputs remains an explicit release check in the existing work order; prepare a concrete review packet.

## Work lanes

- Backend: extend the two subject allowlists; preserve authorization, quotas, receipts and disclosure boundaries.
- App: canonical ten-subject eligibility, existing question template and real-font browser verification.
- Content audit: four known topic gaps, unresolved-unit membership and Biology image grounding; exact supported repairs or named blockers.
- Conductor: live-state reconciliation, independent QA, release/recovery and durable evidence.

Prior changes already merged: backend464, app29 and tagging473. Production More help remainsv1 at kickoff; Developmentv13 includes the earlier multipart/visual/figure and disclosure repairs. New deployment must include those reviewed fixes. Full question/model/auth artifacts stay private.
