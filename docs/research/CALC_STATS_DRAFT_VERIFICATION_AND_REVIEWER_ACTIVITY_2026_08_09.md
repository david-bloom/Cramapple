# Calc AB / Statistics §9 verification, and reviewer-activity check — 2026-08-09

**Trigger:** Owner follow-up to the draft-backlog reassignment (Calc AB → Abdul Hanan, Statistics →
Shazia Fazal): "Run the verification pass on calc and stats. Are there any questions assigned to
reviewers who haven't logged in for 3 or more days?" Then, after an initial login-based answer:
"Redo the activity assessment by looking at review activity, not login activity."

## 1. §9 independent re-derivation QA

**Method:** 4 parallel background agents — 1 for the 23 AP Calculus AB items, 3 for the 48 AP
Statistics items (17/16/16 split) — each independently re-solved every FRQ rubric criterion and
MCQ answer key from scratch against `app.mcq_choices` / `app.frq_criteria`, per protocol §9.

| Batch | n | Clean | Defects |
|---|---:|---:|---:|
| AP Calculus AB | 23 | 22 | 1 |
| AP Statistics batch 1 | 17 | 16 | 1 |
| AP Statistics batch 2 | 16 | 16 | 0 |
| AP Statistics batch 3 | 16 | 15 | 1* |

\* One of batch 3's findings, `APSTAT-MOD8-H001`, is **not actually part of today's Statistics
assignment** — the QA agent traced its `content_review_assignments` row to `created_at =
2026-07-29`, assigned to a different reviewer (Jill Schmidlkofer), a full 11 days before today's
batch. It's a stale pre-existing assignment that happened to fall inside the query's status filter,
not a new-assignment item. Left out of scope; noted as a separate follow-up below.

**In-scope net result: Calc AB 22/23 clean, Statistics 47/48 clean.**

### Confirmed defects (both fixed — see §2)

1. **`apcalcab-mcq-037`** — answer key had the local min/max backwards. Given
   f′(x)=x³−3.2x²−1.1x+2.4 on [−2,4] with real roots ≈ −0.910, 0.796, 3.313: f′ changes
   negative→positive at −0.910 (a local **minimum**) and positive→negative at 0.796 (the actual
   local **maximum**). The stored key marked −0.910 correct; the two choices' rationales were
   also swapped (each described the sign-change direction belonging to the other choice).
2. **`APSTAT-MOD7-H002-INV`** (FRQ) — stem under-specified relative to its own rubric. It gave
   only 2 of the ≥4 facts needed to build the 3×2 contingency table `contingency_table` /
   `chi_square_test` / `probability_analysis` / `contextual_interpretation` all require: no
   anxiety-group sizes (row marginals) and no medium-anxiety STEM rate. A student following the
   stem's own instructions could not construct a determinate table, so all four criteria were
   ungradable against a unique correct answer. The rubric's point structure itself (4×1pt) was
   internally consistent — only the stem was missing data.

### Out-of-scope follow-up (not fixed this pass)

- **`APSTAT-MOD8-H001`** — stem claims a concrete 25-student (hours-studied, test-score) dataset
  and asks the student to compute r and a regression equation from it, but `stimulus` is empty and
  no data table exists anywhere for the item. Its own `frq_criteria` already acknowledge "ships
  without a data table" and grade method-only/ABSTAIN — the stem was simply never updated to match.
  This belongs to a different, older (2026-07-29) assignment to Jill Schmidlkofer, not to today's
  Shazia Fazal batch, so it's flagged for a separate remediation pass rather than fixed here.

## 2. Repairs applied

`scripts/content-seed/reviewer-qa-remediation/20260809_calc_stats_draft_batch_qa_repair.sql` —
edit-in-place (both items are unreviewed drafts with no decision on record to preserve, matching
the discipline already applied to the physics draft batch earlier today):

- `apcalcab-mcq-037`: flipped `is_correct` between the `−0.910` and `0.796` choices and corrected
  both rationales to describe the sign change each choice actually represents.
- `APSTAT-MOD7-H002-INV`: added explicit, internally consistent counts to the stem — 200
  low-anxiety / 200 medium-anxiety / 100 high-anxiety students (summing to the stated 500), and a
  55% STEM-pursuit rate for the medium-anxiety group (low 80%, high 40% were already given). This
  now yields a unique 3×2 table, a clean chi-square result (χ² ≈ 52.2, df=2, p < 0.0001 — an
  unambiguous rejection of independence for pedagogical clarity), and computable conditional
  probabilities. No `frq_criteria` point values needed to change.

Both re-verified post-fix: `apcalcab-mcq-037`'s only `is_correct=true` choice is now `0.796`; the
Statistics FRQ stem now carries the full data set matching what its rubric asks for.

**23/23 Calc AB and 48/48 in-scope Statistics items are now clean and safe for Abdul Hanan and
Shazia Fazal to begin reviewing.**

## 3. Reviewer activity: login vs. real review activity

The first pass answered "3+ days inactive" using `auth.users.last_sign_in_at`, which flagged Adil
Abbasi, Sarah Sohail, Jill Schmidlkofer, and Shazia Fazal. Owner asked to redo this using actual
review activity instead — `app.content_review_decisions.submitted_at`, the timestamp of a
reviewer's last real tutor/reader decision — since login timestamps don't reliably reflect whether
someone is working their queue (sessions can persist without a fresh sign-in event).

| Reviewer | Last login (days ago) | Last review decision (days ago) | Pending assignments |
|---|---:|---:|---:|
| Jill Schmidlkofer | 9.7 | **9.0** | 2 |
| Shazia Fazal | 7.8 | **3.0** | 79 |
| Sarah Sohail | 14.2 | **1.7** | 32 |
| Chisom Anuba | 1.5 | 1.5 | 8 |
| Ahmed Ali | 1.4 | 0.3 | 213 |
| Adil Abbasi | 15.8 | **0.0** | 13 |
| Abdul Hanan | 0.0 | 0.0 | 20 |

**By actual review activity, only two reviewers clear the 3-day threshold: Jill Schmidlkofer (9.0
days idle, 2 pending) and Shazia Fazal (exactly 3.0 days idle, 79 pending).** Adil Abbasi and Sarah
Sohail looked stale by login alone (15.8 and 14.2 days) but have both submitted review decisions
very recently (0.0 and 1.7 days) — login timestamp is not a trustworthy staleness signal on this
platform and the login-based answer given earlier in this thread should be disregarded in favor of
this one.

**Actionable:** Shazia Fazal is the reviewer to watch — she's sitting right at the 3-day mark with
the largest pending queue of anyone by a wide margin (79, including today's new 48-item Statistics
batch), so continued inactivity from here would mean a large, newly-verified batch stalls.
