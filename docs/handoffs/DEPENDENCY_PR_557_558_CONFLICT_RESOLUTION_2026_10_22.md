# Dependency PRs #557 and #558 — conflict resolution

Date: 2026-10-22 (America/New_York)

David explicitly requested resolving conflicts and merging [#557](https://github.com/david-bloom/Cramapple/pull/557) and [#558](https://github.com/david-bloom/Cramapple/pull/558). This is a bounded dependency-maintenance repair; it does not change product scope or authorize separate service/configuration changes.

## Repair and verification

- Continued each existing Dependabot branch and merged current `main` into it, without rewriting history.
- #557: resolved the manifest/lockfile conflict by retaining React 19.3.1 and updating React DOM to 19.3.1. Preserved Playwright 1.64.1. Resolution commit: `65c26ada2cde701b54e28ba4c49236dd3fb33523`. All six GitHub checks passed; merged as `5ed4f4a0`.
- #558: merged `main` after #557, preserving React/React DOM 19.3.1 and Playwright 1.64.1 while retaining Vite 8.3.4. Package-resolution commit: `b6f0a1ce`.
- Each resolved dependency set passed `npm ci --ignore-scripts --no-audit --no-fund`, all 12 existing web tests, `npm run build`, `npm ls react react-dom vite playwright`, and `git diff --check`.
- The final dependency diffs contain only the intended React DOM and Vite updates; previously merged React/Playwright updates remain intact.

## Checkpoint and next action

At this checkpoint #557 is merged; #558's resolution is pushed and fresh GitHub checks are pending. Codex owns waiting for all checks, merging #558 at its verified head without bypassing branch protections, verifying both PRs report merged, and returning the clean local checkout to updated `main`. The PR merge records govern final merge state after this checkpoint. No further owner approval is required for these requested merges.

Afterward, resume the visitor-tracking session with a Production-only baseline from existing PostHog events. Keep automatic pageview/autocapture/replay settings and analytics configuration unchanged unless separately authorized under TASK-0060.
