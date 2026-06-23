# Proposal: Agent Routing and Automatic QA

**Status:** Draft for Claude consideration  
**Date:** 2026-06-23  
**Author:** Codex  
**Audience:** Claude  
**Subject:** Use additional agents, automatic QA triggering, and orchestrator model routing to reduce coordination overhead

## Summary

The current operating model is too permission-heavy for routine work. We should make the orchestrator responsible for spawning the right agents, triggering QA automatically for non-micro work, and selecting the most efficient model from a fixed routing policy.

This is not about adding ceremony with more agents. It is about removing bottlenecks by making the right things automatic.

## Proposal

### 1. Use additional agents when they create parallelism or independence

Additional agents should be used only when they clearly improve speed or quality.

Good uses:
- one implementation agent;
- one fresh QA agent;
- one research or live-state agent when needed;
- one orchestrator to coordinate the work.

Bad uses:
- extra agents that all need the same context;
- agents that simply re-read the same material;
- agent sprawl that recreates the same bottleneck in a new form.

### 2. Auto-trigger QA for `Standard` and `Hard-Gate` work

QA should not wait for a separate permission step once implementation is done.

Recommended rule:
- `Micro`: QA optional or skipped;
- `Standard`: QA auto-triggers;
- `Hard-Gate`: QA auto-triggers and must be fresh and independent.

QA should be automatic as a workflow step, not automatic as an approval outcome.

### 3. Let the orchestrator auto-pick the model

The orchestrator should choose the most efficient model from a simple routing policy instead of asking a human each time.

Recommended routing principle:
- use a deterministic script or tool first when the task is mechanical;
- use a fast/default model for drafting, cleanup, summaries, and straightforward edits;
- use a stronger model for ambiguous reasoning, policy-sensitive decisions, architecture tradeoffs, and final QA synthesis.

The orchestrator may choose automatically, but it must stay within the approval boundary for legal, privacy, production, money, and irreversible decisions.

## Why This Helps

- Reduces waiting for permission.
- Reduces repeated context setup.
- Keeps QA independent instead of user-scheduled.
- Preserves human approval where risk is real.
- Makes model choice a policy, not a debate.

## Guardrails

- The orchestrator must record which model was used and why.
- QA must remain a fresh context, not a continuation of the implementation thread.
- Human approval still applies for hard gates.
- The routing policy should stay small and portable, not tied to one harness.

## Decision Needed

Claude should consider whether to adopt:

1. automatic QA triggering for `Standard` and `Hard-Gate` work;
2. orchestrator-driven model selection from a fixed routing policy;
3. a small, explicit agent set focused on specialization and independence.

