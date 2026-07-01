# Cramapple Documentation

## Authority Order

When documents conflict, use this order:

1. Approved decisions and approvals in `docs/activity_log/`.
2. Approved task scope in `docs/tasks/`.
3. Canonical product documents in `docs/product/`.
4. Approved team-charter and operating documents.
5. Current architecture, curriculum, marketing, and economics documents when created.
6. `legacy/` files (early `Blueprint_*` planning docs, formerly loose at repo root) as speculative historical inputs only.

Material contradictions should be surfaced to David Bloom, Product Owner, rather than silently resolved.

## Synchronization Rule

Every project document retained in this workspace must also be committed and
pushed to `david-bloom/Cramapple`. Local-only documents are not durable
source-of-truth records. Temporary renders, caches, editor files, and
operating-system metadata are excluded.

## Document Formats

- Markdown (`.md`) in GitHub is the default and canonical project-document
  format.
- Google Docs may be used as a collaboration or backup copy. Accepted changes
  must return to the canonical Markdown file.
- Word (`.docx`) is an exception for a specific recipient, submission, print, or
  layout requirement. It should be generated from a canonical source and not
  maintained independently.

The universal rule is defined in
`team_charter/AI_COLLABORATION_RULES.md`.

## Master Backlog

- `MASTER_TODO.md`: Canonical index of active tasks, proposed follow-on work,
  research, launch gates, and deferred scope. A backlog entry does not approve
  execution.

## Folders

- `product/`: Vision, product doctrine, and later product requirements.
- `product/CONTENT_QUANTITY_AND_DISTRIBUTION.md`: Approved-direction AP Biology
  topic matrix, inventory definition, and quantity targets.
- `product/CONTENT_AUTHORING_MODEL_EXPERIMENT.md`: Controlled comparison of the
  tutor-first baseline and alternative AI-led authoring models.
- `architecture/`: Canonical system architecture, technical boundaries, and later detailed technical designs.
- `architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`: Proposed operating procedure for sources, rights, validation, release, monitoring, revalidation, retirement, rollback, and audit.
- `architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`: Authoring
  firewall, failure-card policy, prompt composition, MCQ/FRQ contracts, and
  multi-subject logical boundaries.
- `architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md`: Proposed architecture
  for structured visuals, governed diagrams, accessibility equivalence,
  learner-created graphs, and renderer validation.
- `legal/`: Draft terms, privacy, and other user-facing legal copy.
- `seo/`: Search and answer-engine strategy, page plans, and AP Biology content
  packages for marketing expansion.
- `teaching/`: Canonical pedagogy, diagnostics, instructional policy, and learning-system designs.
- `team_charter/`: Roles, approval boundaries, task workflow, and agent rules.
- `activity_log/`: Durable approvals, decisions, and meaningful project activity.
- `tasks/`: Approved and proposed work.
  - `TASK-0008`: Clean proprietary exemplar replacement.
  - `TASK-0009`: Schema-governance reconciliation.
  - `TASK-0010`: Grader confidence and calibration.
  - `TASK-0011`: Handwritten graph-capture research.
