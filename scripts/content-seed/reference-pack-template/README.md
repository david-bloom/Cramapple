# Reference-pack pipeline template — copy this forward

**Purpose.** These are the canonical pipeline scripts for `app.unit_reference_entries` and
`app.topic_memory_hooks`. Copy this directory's `.py` files into a new batch directory
(`scripts/content-seed/<subject>-reference-<units>-<date>/`) and run from there. Every batch keeps its own
copy so its artifacts stay honest about what produced them; this directory is the baseline those copies
start from.

**Why it exists.** Before 2026-10-10 each batch copied scripts from the previous batch, so prompt lessons
were lost whenever a session picked the wrong ancestor. The units 1-3 run across nine subjects hit two
prompt defects that had already been diagnosed once. A single baseline fixes that.

**Depth matters.** `gateway.py` finds the gitignored AI-Gateway key at `parents[3]`, i.e. it assumes the
script sits at `scripts/content-seed/<batch>/gateway.py`. Running these from anywhere else fails with a
missing `.env.local`.

## What these scripts enforce beyond the first pilot

| Change | Reason |
|---|---|
| `extract.py` — admissible source rules | The extractor was mining **Exclusion/Boundary Statements**, **SUGGESTED SKILL** and practice lists, **"Preparing for the AP Exam"**, and **ILLUSTRATIVE EXAMPLES** as if they were course content. Seven entries in the units 1-3 run had no learning-objective or essential-knowledge basis at all and could only be dropped. Only LO/EK statements under Required Course Content may be the basis for an entry; a boundary statement may still be quoted in a `caution` on an entry that has its own LO/EK basis. |
| `extract.py` — `ced_evidence` must cite an LO or EK code | Those seven cited a boundary statement or a skill instead. No citable code now means the entry is inadmissible. |
| `extract.py` / `check.py` — ownership wording | "The topic that first requires it" was read as *earliest mention*, which produced most of the ownership escalations and five Product Owner overrides. Now: the topic whose own LO/EK requires the entry **as stated**, and never a `topic_codes` entry preceding the owner. See protocol §1.1. |
| `extract.py` — hook `caution` required | The AP Statistics BINS hook was correct in every other respect and was rejected twice for a missing caution. |
| `check.py` — check (b) and (c) text | So the checkers enforce the same two rules symmetrically rather than the session discovering them in escalations. |
| `check.py` — hook controls | A hook control counts as caught only when its planted hook is rejected while its correct entry is accepted; entry and hook verdicts are independent. |
| `load.py` — pre-load schema guard | An accepted row with `owner_topic_code` 3.3 and `topic_codes` `{3.4}` passed all three models, hit the database check constraint, and because the load is one transaction **the whole batch silently wrote nothing**. The guard refuses and names such rows. |
| `load.py` — `correction_note` passthrough | So a Product-Owner-directed correction is distinguishable in `source_note` from a stateless re-extraction. |

## Verification of the admissible-source fix (2026-10-10)

Re-extracted two units that had produced inadmissible entries under the old prompt, against the same CED
pages and fact-pack sections:

| Unit | Previously produced | Under the fixed prompt |
|---|---|---|
| Physics C: E&M unit 8 | "Limit on discrete-charge force calculations" (Topic 8.1 boundary statement) | gone; 31 entries, 0 citing a non-LO/EK section |
| Calculus AB unit 2 | "Calculator answers: rounding" ("Preparing for the AP Exam"), "Keep notation precise" (Skill 4.C plus an invented rule) | both gone; 16 entries, 0 citing a non-LO/EK section |

Every entry in both runs cites a recognisable LO or EK code. Note that code style differs by subject —
`1.5.A.2` in the sciences, `CHA-2.A.1` / `FUN-3.B.1` in Calculus — so any automated evidence check must
accept both.

The re-extractions were a prompt test only. Nothing from them was loaded to any database, and the existing
batches were not re-run or re-keyed.
