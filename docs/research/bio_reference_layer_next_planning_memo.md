# Bio Reference Layer Planning Memo

**Status:** Draft for planning review  
**Date:** 2026-06-18  
**Context:** FRQ02 reference-layer spike follow-up

## Bottom Line

The recent reference-layer tests do not support exemplar-heavy retrieval or
online flywheel volume as the main path to faster grading. They do support a
different conclusion: the current bottleneck is more likely rubric-boundary
precision and grader orchestration than raw reference volume.

The gateway decision is not in doubt. Vercel AI Gateway is now the default
routing path, and the remaining question is which model/prompt/boundary
combination gives us the best speed-quality tradeoff on the grader path.

The newest SP-1 summary sharpens that direction further: the dominant open
issue is still FRQ02-C2 boundary precision, and the next immediate check should
extend the same error-vs-reviewer-note diagnostic to FRQ02-C1, FRQ02-C3, and
FRQ02-C4 before we spend more effort on architecture changes. That keeps the
follow-up path anchored in rubric precision instead of raw context volume.

## What The Evidence Says

- The gated prompt got worse on strict C2 agreement and increased both cost and
  latency. That points away from “more prompt” as a general solution.
- The oracle-boundary diagnostic found that scored precedents carry some
  calibration signal, but the retrieved-exemplar design was too slow and too
  fragile to ship as-is.
- The 100-answer flywheel validated the harness, but it did not improve final-50
  agreement or reduce FRQ02-C2 under-credit. That rejects this specific
  retrieval/prompt shape as a production speed lever.
- The recurring errors cluster around a boundary-definition issue, not a
  missing-facts issue. In other words, we likely need sharper criterion gates,
  not more context.

## Working Conclusion

The most promising direction is a compact boundary-contract memory plus a fast
primary grader with escalation. Raw exemplar retrieval and volume-based
flywheels should be treated as diagnostics, not the core production strategy.

The new next-protocol smoke test also confirms the gateway path is operational
across OpenAI, Anthropic, and Google model IDs, but it is explicitly smoke-test
only. It is useful as a wiring check, not as evidence for promotion or kill
decisions.

## Implications

1. Keep Vercel AI Gateway as the routing default and use it to compare models
   cheaply.
2. Move effort from reference volume into boundary definitions, decision gates,
   and short evidence extraction.
3. Evaluate compact boundary memory separately from exemplar retrieval.
4. Use fast-primary-plus-escalation as the leading production candidate.
5. Before any broader architecture decision, run the boundary diagnostic on
   FRQ02-C1, FRQ02-C3, and FRQ02-C4 so the C2 result is interpreted in the full
   rubric context.

## Recommended Next Step

Run a follow-up experiment suite that tests:

1. Compact boundary memory versus no memory.
2. Fast primary model arms versus `gpt-5.5` control.
3. Direct boundary-gate fixes on the FRQ02-C2 ambiguity cluster.
4. Provider/model swaps through Vercel AI Gateway under identical prompts.
5. The same boundary-vs-reviewer-note diagnostic on FRQ02-C1, FRQ02-C3, and
   FRQ02-C4 before any promotion decision.

The goal is not to prove that memory is useful in general. The goal is to find
the smallest change that improves speed without creating new grading mistakes.
