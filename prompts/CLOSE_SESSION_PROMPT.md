# Close Session Prompt

```text
Before ending this session, write a clear handoff so the next agent can resume
without re-triage.

Use GitHub docs as the source of truth. If the session changed durable project
state, record it in the relevant task doc, activity log, decision log, or
handoff packet before closing.

Report the session closeout in this order:

1. Current task or issue.
2. What changed this session.
3. What was verified.
4. What remains open.
5. Open blockers or risks.
6. Files changed or checked.
7. Commands, queries, or tests run, with results.
8. Approval state and whether any owner approval is still required.
9. Exact next step for the next session.
10. Anything that must not be touched next session.

If the work is not ready to resume cleanly, create or refresh a handoff packet
with:

- task;
- current source;
- approval state;
- live/tool state;
- files/systems affected;
- open risks/blockers;
- do-not-touch scope;
- next expected output;
- recommended prompt for the next agent.

If the work is ready to resume, end with a short restart note that names the
single best next action.

Do not claim completion unless the relevant GitHub records and verification are
up to date.
Do not skip recording blockers just because they are inconvenient.
Do not leave the session without naming the next owner and next step.
Follow branch-hygiene R4 (AI_COLLABORATION_RULES.md §In-Progress Drafts and Branches): commit-and-push a checkpoint before closing; if the session is interrupted, record an explicit dirty-state handoff (a stash is not durable) — never leave silent orphaned changes.
```
