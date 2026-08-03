# AP Statistics — TASK-0016 Phase B (Claude) — 2026-07-08

Phase B has two halves. **Claude executed the credential-free half in full**; the
live transcription bake-off is built turnkey and waits only on gateway creds.

## Done and verified (no credentials needed)

| Artifact | What it is | Verified |
| --- | --- | --- |
| `statistics_item_keys.json` | Per-item deterministic keys + ECF templates for the 5 AP Statistics gold-set items, grounded in the real item content | — |
| `validate_keys.py` | Validates the keys with zero API calls | **8/8 canonical integrity, 3/3 ECF templates correct** |
| `../AP_STATISTICS_VERIFICATION_PROFILE.json` | The subject verification profile (did not exist before) — declares the deterministic layer + key payload | — |
| `transcription_bakeoff_protocol.md` | Preregistered bake-off protocol (the hand-drawn gate) | — |
| `bakeoff_capture_corpus.jsonl` | Hand-authored, rights-clean formula items to hand-draw (hard→easy across Physics C / Calc / Stats / Econ), each with per-line ground-truth reference transcriptions + `human_grades_correct` | 9 refs parse cleanly |
| `bakeoff_runner.mjs` | Turnkey gateway runner (sibling of `scripts/vercel-gateway-check/hand_drawn_graph_benchmark_run.mjs`): image→model transcription→records for the scorer; `--dry-run` perfect-arm smoke mode | **pipeline smoke test PASS** |
| `capture_sheet.html` | Printable MathML sheet of the 7 items to hand-copy (2-D fractions/radicals/exponents) → photograph one per file, named by `item_key` | 9/9 MathML well-formed |
| `generate_trace_images.py` + `trace_images/` + `captures_manifest.json` | Synthetic matplotlib-xkcd 2-D renders of the 7 items (stand-in until real handwriting is captured) | 7 images rendered |
| `../../scripts/vercel-gateway-check/transcription_bakeoff_live.mjs` | Live vision-transcription runner (gateway); emits records for the scorer | executed |
| `records_*.jsonl` + `bakeoff_report.md` | **Live run results (2026-07-09):** 3 vision models, 9/9 lines faithful, 0 silent corruption — on synthetic renders (optimistic upper bound) | — |
| `bakeoff_scorer.py` | Credential-free transcription-fidelity scorer | **self-test PASS** |
| `bakeoff_selftest_summary.json` | Scorer self-test output | — |

### What the keys prove

The three multi-part items are real ECF cascades: **MOD3** (standard error →
CI bounds **and** t-statistic), **MOD6** (pooled SE → two-sample t), **MOD7**
(total probability → Bayes posterior). Running the authored templates through the
shared `ecf_engine.py`, a wrong root value (e.g. the classic `s/n` vs `s/√n`
standard-error error) docks exactly one point and every downstream part computed
correctly on the student's own wrong value earns full ECF credit — e.g. MOD3
scores **3/4**, not 1/4. MOD5 is fully conceptual (all ABSTAIN → LLM grader);
MOD8 is the known no-dataset corpus defect (numeric claims isolated, symbolic
slope structure only).

### What the bake-off scorer measures

The gating metric for the hand-drawn path: **silent-corruption rate on correct
work** — how often perception produces a parseable-but-wrong transcription that
would make the checker flag correct work as wrong. Equivalent-but-different forms
count as faithful (not corruption); unparseable input counts as a safe ABSTAIN.
The self-test confirms the scorer separates all four outcomes correctly.

## Live run executed 2026-07-09 (synthetic renders) — real-handwriting run is the remaining gate

With gateway creds obtained, the live bake-off ran end to end against **synthetic
xkcd-rendered** images: `openai/gpt-5.5`, `google/gemini-2.5-flash`, and
`anthropic/claude-haiku-4-5` each transcribed **9/9 lines faithfully, 0 silent
corruption** (`bakeoff_report.md`). That validates the full pipeline and sets an
**optimistic upper bound** — clean 2-D renders, not human handwriting. The
operating number still requires the human-captured photo corpus below.

The bake-off is wired end to end — corpus → runner → scorer all built and
run. Only two things remain for the *gating* (real-handwriting) run, and neither
is a code task:

1. **Capture (human):** print `bakeoff_capture_corpus.jsonl`'s `prompt_to_draw`
   items, hand-write the responses, photograph them, and build a captures
   manifest (`{item_key: image_path}`). A human then confirms each
   `reference_lines` transcription matches what was actually drawn (blind to any
   model output, per the protocol).
2. **Run (credentialed):** with `AI_GATEWAY_API_KEY`/`VERCEL_OIDC_TOKEN` set,
   run the runner for each arm, then the scorer:
   ```
   node bakeoff_runner.mjs --arm transcription --captures captures.json --out t.jsonl
   node bakeoff_runner.mjs --arm direct        --captures captures.json --out d.jsonl
   python3 bakeoff_scorer.py t.jsonl   # + d.jsonl
   ```

This session has **no gateway credentials and no hand-drawn *formula* image
corpus** (the repo's HDR images are graphs, not derivations), so the measured
silent-corruption number cannot be produced here. **It is not fabricated or
estimated** (integrity rule). Everything that does not require the vision model
or captured images is done.

## How to run (credential-free — all verified this session)

```
python3 validate_keys.py                 # keys: 8/8 integrity, 3/3 ECF
python3 bakeoff_scorer.py                 # scorer self-test (mechanics)
node   bakeoff_runner.mjs --dry-run       # pipeline smoke test (perfect arm) -> records
python3 bakeoff_scorer.py bakeoff_records.jsonl   # scores the dry-run: all FAITHFUL, validates every reference parses
```

## Handoffs this produces

- **To Codex (Phase A):** `statistics_item_keys.json` + the verification profile
  are the concrete payload Engine 1/3 grades against — real content, not a stub.
- **To Learning Quality:** two boundary-contract questions to adjudicate (MOD3
  z\*=1.96 vs t\*=2.045; MOD6 two-tailed sign convention) — see the profile's
  `open_boundary_contract_questions`.
- **To Phase C:** extend keys from these 5 items to the full 100-FRQ +
  10-investigative launch corpus (bounded authoring), then adjudicate the gold set.

**Tier: development.** Real content, verified mechanics; not an adjudicated gold
set and no learner-facing claim (Lesson 7 — the gold set remains the launch gate).
