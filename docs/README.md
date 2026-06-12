# Cramapple Documentation

## Authority Order

When documents conflict, use this order:

1. Approved decisions and approvals in `docs/activity_log/`.
2. Approved task scope in `docs/tasks/`.
3. Canonical product documents in `docs/product/`.
4. Approved team-charter and operating documents.
5. Current architecture, curriculum, marketing, and economics documents when created.
6. Root-level `Blueprint_*` files as speculative historical inputs only.

Material contradictions should be surfaced to David Bloom, Product Owner, rather than silently resolved.

## Synchronization Rule

Every project document retained in this workspace must also be committed and
pushed to `david-bloom/Cramapple`. Local-only documents are not durable
source-of-truth records. Temporary renders, caches, editor files, and
operating-system metadata are excluded.

## Master Backlog

- `MASTER_TODO.md`: Canonical index of active tasks, proposed follow-on work,
  research, launch gates, and deferred scope. A backlog entry does not approve
  execution.

## Folders

- `product/`: Vision, product doctrine, and later product requirements.
- `architecture/`: Canonical system architecture, technical boundaries, and later detailed technical designs.
- `architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`: Proposed operating procedure for sources, rights, validation, release, monitoring, revalidation, retirement, rollback, and audit.
- `teaching/`: Canonical pedagogy, diagnostics, instructional policy, and learning-system designs.
- `team_charter/`: Roles, approval boundaries, task workflow, and agent rules.
- `activity_log/`: Durable approvals, decisions, and meaningful project activity.
- `tasks/`: Approved and proposed work.
