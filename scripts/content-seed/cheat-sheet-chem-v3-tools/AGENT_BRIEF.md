# Agent brief: Cheat Sheet v3 drafts for AP Chemistry (one unit or half-unit per agent)

You are drafting the new-format Cheat Sheet text for a set of published AP Chemistry topics. This is DRAFT WORK ONLY: your output is files in your own folder. Read this whole brief first.

## Hard rules
- Write ONLY inside your assigned folder (named in your prompt), under `scripts/content-seed/`. Do not edit any other file.
- No git commands (no add, commit, branch, switch, push). The parent session commits.
- No Supabase CLI, no database or network access of your own. All source data is already in your folder's `source_snapshot.json`.
- Never print, read aloud or copy the gateway key. The checker script reads it itself.
- Author the text yourself, in this session. Do not ask a model to write or "fix" the text for you. The checker models only check.
- No new facts: every fact and number comes from the topic's published fields, its published worked example, its reference entries or the CED excerpt in the checker. If a table needs a fact that is not in those sources, keep it only if it is standard chemistry that is certain, and list it in your report under NEW. Do not invent exam statistics or scoring claims.
- Do not touch anything about Physics, Biology, Statistics, Calculus or Precalculus.

## Read first (about 10 minutes)
1. `docs/product/CHEAT_SHEET_GUIDELINES_2026_11_21.md` (the guidelines).
2. `scripts/content-seed/cheat-sheet-unit1-v3-2026-11-21/UNIT_1_V3_DRAFTS.md` and `proposed.json` (the finished Unit 1 exemplars: study the shape of every card type) and its `CHECKER_RESULTS.md` (the defects the checkers found, listed below).
3. Your folder's `source_snapshot.json`: per topic the current fields (`ex`: core, wsu, hp, am, cpl, pb, qt), the published worked example (`w`: question, weak, strong), `hooks` and `ref` (reference entries). `qt` is the old recap: it is retired, do not carry it over.

## What to produce, per topic: the `proposed.json` shape
`{ "<topic code>": { "title": "...", "core_idea": "...", "what_students_need_to_understand": "...", "how_this_becomes_points": "...", "common_point_loss": "Weak: ...", "answer_move": "Full credit: ...", "practice_bridge": "...", "hook": "..." (only if the snapshot has a published hook for that topic, verbatim) } }`
Do NOT include `quick_take`. Fields and jobs (one job per card):
- `core_idea` (Know, at most 360 characters): terse bullets (`- `): what is true, notation strings, scope exclusions ("Not tested: ..." only where the CED excerpt states an exclusion). No definitions of basic terms a student already knows. Keep a definition only where the topic's reasoning needs it.
- `what_students_need_to_understand` (Know mechanism, at most 360 characters): a small table (`| a | b |` rows, the first row is the header, no separator row) or at most two bullets of relationship. A plain intro line (its own paragraph, blank line after it) is fine. It must be NEW information (the mechanism, a decision table, a conversion map, a comparison), never a restatement of the rule in the steps.
- `how_this_becomes_points` (Score steps, at most 320 characters): 2 or 3 numbered steps (`1. `), the procedure, direction-neutral where the rule is.
- `common_point_loss` (Score "Weak"): starts with `Weak:`. The losing answer in one or two lines (from the published weak answer, shortened), then which step it breaks ("It skips step 2: ..."). Not a restated rule.
- `answer_move` (Score "Full credit"): starts with `Full credit:`. A compact model answer whose `(1)`, `(2)`, `(3)` labels match the steps (use only labels for steps the answer really demonstrates). From the published point-attaining answer, shortened. Recompute every number yourself.
- `practice_bridge` (Link): ONE line to where the same idea is used next (another topic or unit) or the one fact that makes this topic matter later. Never restate the rule.
- Unicode for notation: superscripts and subscripts (², ⁻, ₂, ×, ≈, →, Δ) instead of `^` and `_`. LaTeX stays in Reference.
- Formulas: state them in the Know table or bullets only when the formula IS the recall content; otherwise use words (the Reference entries carry the LaTeX).

Format rules: every paragraph is all marker lines (`- `, `1. `, `| a | b |`) or all plain, never mixed; separate paragraphs with a blank line; a structured paragraph in a capped field needs at least 2 lines.

## The test for every card
Same concept may appear in several cards or topics only when each appearance does a different job (state it, use it in a table, demonstrate it, apply it elsewhere). It is redundant only when two places make the same claim, in the same situation, for the same purpose. For each card ask: what can the student do or recognise now that the rest of the sheet did not give them? If nothing, merge or cut.

## Lessons from Unit 1 (defects the two checker models found; do not repeat them)
- Hedge as the source hedges: "supports" not "means" (a constant composition ratio supports purity), "generally" for trends with known exceptions (N to O ionization energy), "tend to" for analogies. Say "other things equal" in comparison tables.
- Do not broaden an exclusion. Quote the CED exclusion's scope exactly (assigning quantum numbers to electrons is not assessed; writing configurations of aufbau exceptions is not assessed).
- Do not overgeneralize a rule: "reach a noble-gas configuration" fails for some group 13 and all transition-metal ions; "different groups do not share a charge" is too absolute (say "never assume they share one").
- Arithmetic and rounding: recompute. The published example 18.945 (Mg-24 product) should round to 18.946; published examples can contain slips. If a published worked example has an error, use the corrected value and list the slip in your report as a SOURCE DEFECT (do not silently inherit it, do not edit the Production row).
- A ratio is not a count: do not turn relative values into absolute ones without a valid constraint (PES heights are ideally proportional to electron counts; scale to counts a subshell can hold).
- Steps and Full credit must correspond: if the Full-credit answer does not demonstrate a step, fold that step into another or drop it.
- Weak must really break the step it names.

## Process
1. Author all topics in `proposed.json`. Keep a short working list of anything uncertain.
2. `python3 -I scripts/content-seed/cheat-sheet-chem-v3-tools/validate.py <your folder>` until it prints `PROBLEMS: 0`.
3. Write `<your folder>/plants.json`: 2 to 4 planted defects as `[{"t":"<topic>","k":"<field>","a":"<exact text now present>","b":"<wrong replacement>"}]`. Make them realistic (an inverted table cell, a wrong exponent in the arithmetic, a wrong subshell count). Spread across different topics.
4. Run the checkers once, from the repo root: `python3 -I scripts/content-seed/cheat-sheet-chem-v3-tools/check_unit.py <your folder> run` (two models, clean and planted copies, 3 topics per call, about two minutes; run it in the foreground with a long timeout or in the background and wait). The script prints one line per call (flagged topics) and writes raw output to `<folder>/check_out/`. If a model prints `NO JSON`, rerun just those topics: `... check_unit.py <folder> rerunN "3.1;3.2"` (each topic its own call).
5. Read `check_out/*run_plant*.json` to confirm BOTH models caught the planted defects (a control that is not caught means that model's clean pass is not trustworthy for that area; say so). Read `check_out/*run_clean*.json`: for every finding, arbitrate against the sources yourself: is it a real defect (fix it in `proposed.json`), a style suggestion (apply if it is faithful to the source and cheap, otherwise leave and say so), or a checker mistake (say why). Do not accept or reject by severity label.
6. After fixes, rerun the changed topics (clean only): `check_unit.py <folder> recheckN "<topic>;<topic>"`. Repeat until both models are clean on the final text of every topic you changed, or a remaining finding is a documented, reasoned disagreement. A final text that was never rechecked must be named as such.
7. Regenerate your drafts file and write results (see Output).

## Output (all inside your folder)
- `proposed.json` (final text), `plants.json`, `check_out/` (raw, written by the script).
- `DRAFTS.md`: a readable file with one section per topic: its title, then each field in a fenced block labelled Know / Score steps / Weak / Full credit / Link / Hook (same layout as `UNIT_1_V3_DRAFTS.md`). Generate it from `proposed.json` with a short python script so the two cannot drift.
- `CHECKER_RESULTS.md`: controls (what was planted, whether each model caught it), the real defects found and how each was fixed, suggestions applied or left, the final status per topic (which topics were rechecked clean by both models and which were not), what the checkers cannot show (the sources are treated as truth; derived facts judged as chemistry only), and the words-a-student-sees total (printed by validate.py).
- Your final reply to the parent: (1) a 5-line summary, (2) the topics NOT clean on both models at the end, (3) NEW items (facts not in the sources) with the topic and the exact line, (4) SOURCE DEFECTS found in the published fields or worked examples (topic, field, what is wrong, the corrected value), (5) any topic where the new format does not fit (say why), (6) gateway cost reported by the script lines, (7) files written.

## Cost and etiquette
The gateway costs about $0.10 per topic across the runs; do not run more rounds than the process above needs. If a topic is a poor fit for Weak and Full credit (no calculation, conceptual only), still produce a short concrete model answer from the published worked example, and say so.
