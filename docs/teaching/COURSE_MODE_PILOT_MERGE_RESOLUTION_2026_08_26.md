# Course Mode pilot — merge-conflict resolution playbook (#125 · #126 · #127)

DATE: 2026-08-26. Prepared from the actual branch contents (`origin/main` +
`origin/claude/course-mode-review-xwpizb` #125 +
`origin/claude/course-mode-pilot-load-release-ucvs4a` #126 +
`origin/claude/course-mode-pilot-load-release-o65xog` #127).

**Why this exists:** #125 and #126 both add a `template_id` to the 1.9×4.B slot-frame, with
**different values**, and both regenerate the load. Dev is already released under #126's value
(`slotframe_4b_compare`). This playbook resolves every overlap toward the values already live on
Dev, so the merged `main` matches the released pilot.

## The exact overlaps (verified)

| File | #125 | #126 | #127 | Resolution |
|---|---|---|---|---|
| `scripts/course_mode_stats_generator/slot_frames.py` | adds `template_id="slotframe_u1_9_compare_justify"` (line ~234) | adds `template_id="slotframe_4b_compare"` (line ~234) | — | **keep #126** (`slotframe_4b_compare`) |
| `scripts/course_mode_stats_generator/build_load_sql.py` | unchanged | adds load-scoped invariant (`_f4_loaded_civ`) | — | **keep #126** |
| `scripts/course_mode_stats_generator/out/f4_load_DRAFT.sql` + `out/*.json` | regenerated (u1_9 id + global invariant) | regenerated (4b_compare id + scoped invariant) | — | **keep #126** (matches Dev) |
| `docs/teaching/COURSE_MODE_PILOT_FINISH_NEXT_STEPS_2026_08_25.md` | §7.1/[B] edits | — | banner edits | **keep BOTH** (additive; hand-merge) |

Everything else is independent: #125's §7.1 spec + D8 docs merge clean; #127's confirm-transfer
migration/function/tests + new docs are new files. #126 touches **only** the three generator/load
paths above (no docs).

`slot_frames.py` differs between #125 and #126 **only** at the 4B `template_id` line — so taking
#126's whole file is exactly "keep everything, use `slotframe_4b_compare`".

## Recommended order: #126 → #125 → #127

`--ours` below = the branch you are merging **into** (your integration branch / `main`);
`--theirs` = the PR being merged. Adjust if your host merges in a different direction.

### Merge 1 — #126 (clean)
Brings the correct generator + load. No conflicts expected (`mergeable_state: clean`).

### Merge 2 — #125
Conflicts to expect, and how to resolve:
```sh
# keep the generator + load already in main (from #126):
git checkout --ours -- scripts/course_mode_stats_generator/slot_frames.py
git checkout --ours -- scripts/course_mode_stats_generator/out/

# COURSE_MODE_PILOT_FINISH_NEXT_STEPS_2026_08_25.md: keep BOTH sides' additions
#   (open it, keep #125's §7.1/[B] notes AND the existing banner; delete only the
#    <<<< ==== >>>> markers). It is additive on both sides.
git add scripts/course_mode_stats_generator/slot_frames.py \
        scripts/course_mode_stats_generator/out/ \
        docs/teaching/COURSE_MODE_PILOT_FINISH_NEXT_STEPS_2026_08_25.md
```
All of #125's other files (`COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md`, the D8 /
re-derivation records, `STATUS_AND_HANDOFF`, etc.) merge cleanly — accept them as-is.

### Merge 3 — #127
Only one conflict:
```sh
# COURSE_MODE_PILOT_FINISH_NEXT_STEPS_2026_08_25.md: again keep BOTH sides' additions
git add docs/teaching/COURSE_MODE_PILOT_FINISH_NEXT_STEPS_2026_08_25.md
```
The confirm-transfer migration, `student-session-items` change, tests, and the new docs are new
files — no conflict.

## Verify after all three merges

```sh
# 1) The wrong 4B id must be GONE everywhere:
git grep -n slotframe_u1_9_compare_justify   # expect: no matches

# 2) The correct 4B id present in the generator + load:
grep -n slotframe_4b_compare scripts/course_mode_stats_generator/slot_frames.py
grep -c slotframe_4b_compare scripts/course_mode_stats_generator/out/f4_load_DRAFT.sql   # >= 1

# 3) The load-scoped invariant is the one in place:
grep -c _f4_loaded_civ scripts/course_mode_stats_generator/build_load_sql.py             # > 0

# 4) Generator harness green (from scripts/course_mode_stats_generator/):
#    generator PASS · slot_frames ok · loader --check 200/0
#    (run the repo's usual generator/QA entrypoint, e.g. emit_pilot.py + build_load_sql.py --check)
```

Optional belt-and-suspenders: confirm the merged `out/f4_load_DRAFT.sql` matches #126's exactly,
since Dev was loaded from it:
```sh
git diff origin/claude/course-mode-pilot-load-release-ucvs4a -- \
  scripts/course_mode_stats_generator/out/f4_load_DRAFT.sql   # expect: no diff
```

## Notes
- **No Dev re-load or re-release is needed.** Dev already carries `slotframe_4b_compare` on all 20
  4B items and the matching release row; this reconciliation only makes the repo source of truth
  agree with what is live.
- The 4B **questions are byte-identical** across the two ids (only provenance metadata differs), so
  the D8 SME sign-off is unaffected by choosing `slotframe_4b_compare`.
- §7.1(b) from #125 is **doc/decision only** — no code path depends on the 4B id choice, so keeping
  #126's id does not weaken the guess-floor decision.
