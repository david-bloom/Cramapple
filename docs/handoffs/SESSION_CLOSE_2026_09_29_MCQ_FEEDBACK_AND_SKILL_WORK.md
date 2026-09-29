# Session Close — 2026-09-29 — MCQ Feedback Rebuild, Skill Work Captured

**Product Owner:** David Bloom
**Agent:** Claude (Opus 5)
**Environments touched:** Development (deploy), **Production** (edge function deploy, authorized
in-session: "Deploy to prod"). No Production *schema* writes this session.

---

## What shipped

**MCQ feedback rebuilt and deployed to Production** (`TASK-0053`, PR #264, `evaluate-attempt` v67).
Every wrong MCQ answer had returned one fixed string on every item in every subject — "Select the
answer choice that matches the published correct answer" — while the item's own authored distractor
rationales sat unread two variables away. 34 of 63 recorded `highest_value_gap` rows were that
placeholder, across 19 items carrying 76 unused rationales.

It is now three moves — orient (skill/unit), point (the **chosen** distractor's authored rationale),
redirect (a question) — with the shape rotating across four variants by an FNV-1a hash of item ×
chosen key, so a twenty-question session does not read as one template. The correct choice's
rationale is never read.

**The scope finding:** this was never blocked on content. All **2,349** published distractors across
all ten subjects already carry an authored rationale — zero gaps — so coverage is 100% at deploy,
with no authoring and no model spend.

## THE MOST IMPORTANT THING TO PICK UP

**PR #272 must be merged.** It carries the entire skill-dimension body of work
(`claude/task-0050-statistics-phase-b`, ~13,500 lines) that was stranded on an unmerged branch while
**its effects were already live in Production**.

It also recovers **five migrations that existed nowhere in the repository**. Four had no file at all;
the fifth was a stub whose timestamp (`20260929113000`) did not match what Production recorded
(`20260929110501`), which would have made the next `supabase db push` re-apply it. Each recovered
file is verbatim from `supabase_migrations.schema_migrations`; byte counts match the recorded
lengths exactly.

That investigation surfaced `TASK-0055`: **at least 72 migrations since 2026-09-01 exist only in
Production**, 185 applied against 113 files in the repo. The schema cannot currently be rebuilt from
source.

## Open PRs

| PR | State | What it is |
|---|---|---|
| **#272** | open | **Skill dimension work + five recovered migrations. Highest priority.** |
| #270 | open | Student submit-to-grade smoke test. Written, **never run**. |
| #268 | **draft** | `taxonomy_source_versions.subject_id` FK. Parked — hardening with no current consumer. |

Merged this session: #264 (code), #265, #266, #267, #269, #271 (docs).

## Outstanding, in the order David set

1. **~~#264 merge + deploy~~** — done, Production v67. **But the live path is unverified**: nobody
   has submitted a wrong answer through it. The acceptance criterion is deliberately left unticked.
2. **Smoke test** — `scripts/student_grade_smoke.mjs` (PR #270). **David will run it immediately
   before handing the app to test students.** Blockers found: no Dev secret key is available locally
   (the one in `.secrets.env` is Production-only — verified Dev 401 / Prod 200) and Dev requires
   email confirmation. Against Production it creates a real user and a real graded attempt
   (`smoke+grade-*@cramapple.test`) and does **not** clean up after itself.
3. **TASK-0051 / TASK-0052 (Open Hand)** — not started this session.

## Corrections made, all published

Three of the session's PRs were self-corrections, which is itself the finding:

1. **406 → 304** skill-labelled MCQs (PR #266). `content_item_cells.skill_code` is nullable, so an
   `exists(...)` test counted topic-only tags as skill tags. Only Statistics has skill labelling.
2. **"Schema drift" was wrong** (PR #267). Migration `20260927004500` made topic-only tagging
   deliberate and had *already guarded* the MATCH SIMPLE hazard I reported as a discovery. I had read
   the migration that created the table rather than the newest one touching it.
3. **Two of three "traps" were not defects.** Nullable `skill_code` is by design; the missing
   `authenticated` grant on `content_item_cells` is INV-1 and granting it would undo a security
   decision. Only the subject-key namespace split is real (`replace('_','-')` silently drops
   Biology, whose registry key is `biology`, not `ap-biology`).

David's read, mid-session: *"I feel like we are learning but also getting off track."* Accurate — of
the PRs opened, only #264 was on the critical path. The stated discipline going forward: a phase run
**records** what it learns and stops only for what blocks the phase; everything else becomes a task
and waits to be sequenced.

## New tasks opened

- `TASK-0053` — distractor-specific MCQ feedback (launch gating; deployed, verification open)
- `TASK-0054` — reference content model: `topic_explainers` / `topic_point_briefs` key the taxonomy
  as plain text, have no FK and **no skill reference at all**; AP Physics C: E&M is short 14 topics
- `TASK-0055` — migration ledger reconciliation (the ~72 gap above)

## Answered this session

**"How were the explainers and point briefs authored?"** Not from a structured table. They were
markdown documents (`docs/product/AP_*_UNIT*_TOPIC_POINT_BRIEFS.md`) loaded into tables that store
the taxonomy position as plain text. The CED fact packs existed but protocol v1 referenced none of
them by path; the re-authoring batch for pre-v2 rows was deferred on 2026-08-21 and has never been
run — neither done nor cancelled.

**Next Owner:** David Bloom.
**Next Action:** merge PR #272; run the smoke test before test students; then Open Hand.
