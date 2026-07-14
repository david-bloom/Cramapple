# AP Biology Multi-Model QA Pass — Findings (partial run, 2026-07-14)

**Status:** ⚠️ **Partial / incomplete run.** The cascade hit the account **monthly spend limit** mid-run
(111 of 242 agents completed; 131 errored on the cap). Pre-review only — nothing published; QA-pass ≠
launch approval; a Bio tutor still gates G4A/G4B.
**Run:** Opus 4.8 primary + Sonnet 5 escalation, over 50 MCQ + 21 Long FRQ + 50 Short FRQ (121 items).
**Design:** `docs/product/AP_BIOLOGY_MULTIMODEL_QA_PASS_DESIGN_2026_07_13.md`.

## Two problems with this run (read before trusting numbers)

1. **Cascade design flaw (mine):** escalation to Sonnet triggered on the *overall* verdict, which flags
   on curriculum tags. Because the corpus has a pervasive non-CED tagging problem (94/111 items), **~all
   121 items escalated** — defeating the cost saving and doubling the run to 242 agents. Fix for next
   time: escalate only on *content-dimension* uncertainty (factual/answer_key/exam_relevance), never on
   `overall`.
2. **Spend limit:** the monthly cap was hit mid-run, so Sonnet second-opinions mostly failed and the
   GREEN/YELLOW/RED tiering in the raw output is **not trustworthy**. The salvage below uses the **111
   completed Opus verdicts only**, with curriculum tags separated out.

## Salvaged content-quality map (111 Opus verdicts; tags excluded)

| Item type | Reviewed | Content-clean | Content issue | Exam issue (e.g. no task verb) | Not run (spend limit) |
|-----------|--------:|-----:|-----:|-----:|-----:|
| MCQ | 50 | **37** | 3 | 10 | 0 |
| Long FRQ | 21 | 2 | 12 | 7 | 0 |
| Short FRQ | 50 | 0 | 34 | 6 | **10** |

"Content-clean" = GREEN *candidate* (Sonnet confirmation never ran). MCQs are the healthiest tier.

## The dominant finding: short FRQs are systematically incomplete

**~85% of reviewed short FRQs (34/40) have no posed question and/or no point allocation** — the `stem`
describes a scenario and the item supplies canonical answers, but it **never asks the student anything**
and carries no rubric/points. This is an *authoring gap*, not a grading nuance: these items cannot be
administered or scored as written. This is corpus-wide, not incidental — likely a re-authoring task
(write prompts + point structure), not a QA tweak.

## Real biology errors Opus caught (high-value; verify with the tutor)

- `APBIO-MCQ-007` — keyed rationale **inverts heat of vaporization** (claims it "drives rapid
  evaporation"; it resists it).
- `APBIO-FRQ-L-017` — **mislabels HER2 as "EGF receptor"**; HER2/ErbB2 does not bind EGF.
- `APBIO-FRQ-L-004` — wrong worked codon/translation example.
- `APBIO-FRQ-L-019` / `L-020` — pedigree-probability error; misuse of concordance/Falconer heritability
  on a continuous trait (height).
- `APBIO-FRQ-S-004` — **glycolysis ATP count wrong** (states 2 gross; it's 4 gross / 2 net).
- `APBIO-FRQ-S-032` — GLUT called a "channel" protein (it is a **carrier**).
- `APBIO-FRQ-S-022` — noncompetitive inhibitor mischaracterized.
- `APBIO-FRQ-S-038` — ATP-synthase/electron-flow coupling error.
- `APBIO-FRQ-S-001` — canonical-answer-2 omits aquaporins for RBC water transport (from pilot).

These are specific, subtle, correct catches — evidence the pass works when it runs.

## Other systemic findings

- **Long-FRQ point allocation:** several claim `total_points=8` but imply ~10–15 scoreable elements with
  no per-part allocation (`L-009/010/014/021`) — rubric-structure defect.
- **94 items need CED tag normalization:** tags use non-CED `"module N"` or mis-numbered topics. A **bulk
  metadata fix**, separate from content review (route to a tag-normalization lane).

## Bottom line for the publish decision

The corpus is **not publish-ready as-is**. Even before the tutor: the short-FRQ "no prompt" defect is
systemic (needs re-authoring), long/short FRQs carry scattered real biology errors, and tags need bulk
normalization. MCQs are in the best shape (37/50 content-clean). This *raises* the confidence that
gating publication behind review was correct — and gives the eventual tutor a defect-prioritized corpus.

## What did NOT complete / next steps (all gated on the spend limit)

- **10 short FRQs (S-041…050)** never got an Opus verdict; **the other ~133 corpus items** were out of
  this batch; **no Sonnet confirmations** landed.
- Cannot run more model work until the monthly limit is raised (claude.ai/settings/usage) or resets.
- Recommendation when budget allows: **do not re-run Opus** (its verdicts here are high quality — reuse
  them); if a confirmation pass is wanted, use **Sonnet-only** (cheaper) with the fixed escalation logic;
  and treat the short-FRQ prompt gap as re-authoring, not QA.
