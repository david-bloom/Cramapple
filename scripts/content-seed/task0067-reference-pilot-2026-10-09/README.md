# TASK-0067 / TASK-0066 Phase B pilot — unit reference entries and memory hooks

**Batch:** `task0067-reference-pilot-2026-10-09`. **Scope:** AP Statistics Unit 1, AP Chemistry Unit 4
(`DECISION-0105` R1–R4). **Environment:** Development only. Production is a Hard Gate.

## Provenance (protocol v0.6 §3.2 rule 3)

| Role | Model id | Family | Note |
| --- | --- | --- | --- |
| Extractor (not an author: extraction from the CED pages + fact pack) | `anthropic/claude-sonnet-5.5` | Anthropic | smoke 3/3 |
| Checker 1 | `google/gemini-3.5-flash` | Google | menu slot B; smoke 3/3 |
| Checker 2 | `openai/gpt-6-sol` | OpenAI | menu slot A (scope-sensitive subjects); smoke 3/3 |
| Own-family veto (reject-only) | `anthropic/claude-opus-5.5` | Anthropic | smoke 3/3 |

**Pick made by the Claude session on 2026-10-09 from the live gateway roster, pending the Product
Owner's ratification** (§2.1 says the PO picks; David had said "go ahead and start the implementation
branch" and was not present for the pick). Neither checker shares the extractor's family.

## Method

1. `extract.py`: one call per unit with the CED unit pages (`pdftotext -layout`, Stats pp. 28–59,
   Chem pp. 79–94) and the fact-pack section. Output `out/candidates_*.json`.
2. `check.py`: both checkers judge every entry (a factual, b topic codes, c CED-required, d caution) and
   every hook (e expansion, f admissible). A flag is re-sampled once; only a repeated flag counts. Both
   must accept; then the veto may reject. Six planted controls per unit must all be rejected.
3. `load.py`: accepted rows → `out/load_*.sql`, applied with `supabase db query --linked -f` (no retyping).
   At most 8 hooks published across the pilot.

## Results

(filled after the run)
