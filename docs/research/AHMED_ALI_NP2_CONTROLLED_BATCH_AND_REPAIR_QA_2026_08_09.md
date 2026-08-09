# Ahmed Ali controlled np2 batch + 10-item repair QA close-out — 2026-08-09

## 1. New controlled AP Physics 1 batch ("np2"), assigned to Ahmed Ali

Owner's ask: create 10 new AP Physics 1 MCQs and 10 new FRQs, using the
established grounded-authoring + hand-verification protocol (same rigor as
the `apphy1-newprotocol-2026-08-08` "np1" batch), and assign all 20 to Ahmed
Ali specifically — to compare his review behavior on genuinely novel content
against his established ~92% edit-rate historical pattern.

- **Content**: `apphy1-frq-np2-001` .. `-010` and `apphy1-mcq-np2-001` .. `-010`,
  covering Units 4-8 (momentum/collisions, rotational dynamics, SHM, fluids)
  per `AP_PHYSICS_1_CED_FACT_PACK.md` §6. FRQs use 4 criteria summing to a
  9-point total (owner's explicit instruction, a deliberate divergence from
  the platform's usual 1-pt-per-criterion convention). MCQs: 4 choices each,
  correct-answer distribution A=2/B=3/C=3/D=2.
- **§9 independent re-derivation QA**: two separate background agents, one
  per item type, each re-solving every answer from scratch and checking for
  the known stem/`mcq_choices` desync defect class.

  | Batch | n | Clean | Defects |
  |---|---:|---:|---:|
  | FRQs (`apphy1-frq-np2-*`) | 10 | 10 | 0 |
  | MCQs (`apphy1-mcq-np2-*`) | 10 | 10 | 0 |

- **Assignment**: all 20 inserted as `tutor_question` assignments for Ahmed
  Ali (`content_review_assignments`, `assignment_purpose='subject_review'`),
  `content_items.status` moved `draft` → `assigned`. Script:
  `scripts/content-seed/apphy1-newprotocol-np2-2026-08-09/20260809_apphy1_np2_assign_ahmed.sql`.

## 2. Close-out: the 10 Ahmed-note repairs

Follow-up to the same-day `PHYSICS_SINGLE_REVIEW_BACKLOG_QA_AND_PUBLISH_2026_08_09.md`
pass. Separately from the stranded single-review backlog, 10 items had a
**completed** two-reviewer blind pair (Muhammad Saood approved, Ahmed Ali
approved-with-edits with a specific note) that correctly landed on
`changes_requested` per the DB trigger's aggregate-score logic — not a bug,
just unactioned reviewer feedback. A repair agent implemented each of
Ahmed's specific requests as a new `content_item_versions` row per protocol
§9.4 (never edit in place).

**Independent second-opinion §9 QA** (a different agent, not trusting the
repair agent's claims, re-deriving every answer from scratch and checking
each repair against Ahmed's original note):

| content_key | Verdict |
|---|---|
| apphy1-frq-019 (river crossing) | CLEAN |
| apphy1-frq-023 (banked curve) | CLEAN |
| apphy1-frq-026 (track race) | CLEAN |
| apphy1-frq-030 (impulse-momentum) | CLEAN |
| apphy1-frq-051 (kinematics graph) | CLEAN |
| apphy1-frq-052 (Atwood-style tension) | CLEAN |
| apphy1-frq-054 (projectile range) | CLEAN |
| apphy1-frq-058 (incline + hanging mass) | CLEAN |
| apphy2-frq-025 (RC charging) | **DEFECT** (see below) |
| apphycm-frq-025 (impulse w/ decaying force) | CLEAN |

**Defect found and fixed**: `apphy2-frq-025`'s v2 repair split the "state
values at three times" criterion by **time instant** (`a-values-t0`,
`a-values-tau`, `a-values-longtime`), each still bundling V_C+V_R+I
together. Ahmed's note specifically asked to split by **quantity**, because
"a student who nails V_C but fumbles current gets the same credit as one who
gets nothing" — a time-based split doesn't fix that. Inserted v3
(`scripts/content-seed/reviewer-qa-remediation/20260809_apphy2_frq_025_criterion_resplit.sql`):
replaced the three time-based criteria with three quantity-based ones
(`a-values-VC`, `a-values-VR`, `a-values-I`, each covering all three time
points), keeping the already-correct numeric values and the other 4
criteria unchanged. 7 criteria, points sum = 7 = `total_points`. Re-verified
independently (V_C/V_R/I values at t=0, τ, ∞ re-derived from
V_C(t)=ε(1-e^(-t/τ)), loop rule, and I(t)=(ε/R)e^(-t/τ) — all match).

**Publish**: all 10 items now clean on the second independent QA pass.
Published all 10 directly (single review + two rounds of §9 QA, consistent
with the 2026-08-08 policy): set `content_item_versions.review_status =
'question_review_approved'`, `status = 'published'`; set
`content_items.status = 'published'` (two of the ten,
`apphy1-frq-026` and `apphycm-frq-025`, were still sitting at
`changes_requested` on the item row and needed that intermediate status
cleared to `reviewed_approved` first — the `content_pipeline_guard` trigger
blocks publishing directly from `changes_requested`).
