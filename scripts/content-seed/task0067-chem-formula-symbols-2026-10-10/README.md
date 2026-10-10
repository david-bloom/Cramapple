# AP Chemistry formula symbol definitions — format pass (`task0067-chem-formula-symbols-2026-10-10`)

**Why:** every AP Chemistry `formula` reference entry (46) was bare LaTeX with no symbol meanings or units. The
Reference Pack protocol (§4, "define every symbol … state required units") asks for both. The extraction schema had
said "formula: LaTeX only", so this was a pipeline gap rather than a per-row defect. Product Owner: "Go ahead with 5"
(fix the extraction prompt, then re-run every Chemistry formula entry through the pipeline), 2026-10-10.

**Pipeline change** (`extract.py`, `check.py` here; carry forward to future batches):
- extraction: formula `items` are REQUIRED, one `{label: symbol, meaning: what it is + units}` per symbol; use
  conditions go in `caution`; titles and owners are kept exactly in this re-extraction;
- checking: `a_factual` fails a formula with any undefined or extra symbol, a wrong meaning, or a wrong unit.

**Run:** stateless re-extraction of the 46 formulas (`out/only_fmt_u<n>.json` = title + owner + CED evidence), then
both checkers (Gemini 3.5 Flash, GPT-6 Sol) and the Haiku 5.5 reject-only veto, with a flag re-sampled once
(`run_all.sh`, round label 9). The roster was smoke-tested 3/3 today. Controls (`controls_fmt_u3.json`, verified against CED
3.4.A.1, 3.7, 3.13.A.1): R as the Rydberg constant, A = εbc missing b, molarity in mol/kg. **3/3 caught.**

**Result:** 44 accepted; 2 kept their current version (not accepted): Unit 1 "Coulomb's law" and Unit 8
"Conjugate pair: Ka, Kb and Kw". `upsert.py` writes accepted rows in place, matched on the unique key (subject,
owner topic, kind, title). The ids differ between environments, so ids are not used. This keeps topic tags and any
linked hook unchanged and appends `fmt=<batch>:<candidate>` to `source_note`. `out/update_formulas.sql` (md5
`bd80feab…`, 44 updates) was applied to Development and then Production. Production matches 37 rows; the 7
Unit 8 updates match nothing until Unit 8 is loaded.

**Verified:** formulas with symbol definitions, Development 44/46, Production 37/38; QA checks 4–7 ok in both;
`get_topic_point_guides` serves the new `items` (3.4: ideal gas law, mole fraction).

**Display:** the `/question` pane already renders formula `items`. Lesson Notes, the compact pane, the Unit
reference text and Copy notes render them only after the Lovable change sent 2026-10-10 (Preview; needs a publish).

**Cost:** $2.77 at gateway list prices (from `out/logs_*`, not committed).
