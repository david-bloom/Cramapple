# More help gap fill: Biology and Physics 1 practice MCQs (2026-10-16)

Metadata only; the questions, votes and keys stay in the untracked `batch_bio/` and `batch_phy1/` folders. Nothing was written to any database.

**Scope (owner, 2026-10-16):** the topics with zero practice MCQs in Biology (2.2, 2.4, 2.5, 2.9) and Physics 1 (1.1, 1.3, 2.2): 2 seeds per topic and 3 variants per seed. Biology 2.10 (one MCQ) was not included. Gap confirmed against Production the same day (Biology topics hold only their Open Hand worked example; Physics 1 topics hold nothing).

**Method:** generate-and-select, protocol v0.6 section 0 (`scripts/vercel-gateway-check/teaching_pipeline/seed_pipeline.mjs`), standard profile: authors GPT-6.1 then Claude Opus 5.5, four non-author checker families, author-family veto, 3-gram similarity gate, no hand edits. Planted-defect controls: 6 of 6 caught before generation. Variants inherit the seed's labels.

**Result:** 13 of 14 seeds accepted; 39 of 39 variants accepted (52 new MCQs).
- Biology: 8 of 8 seeds, 24 of 24 variants. Seed 2.2 slot A needed round 2.
- Physics 1: 5 of 6 seeds, 15 of 15 variants. **Escalated: topic 1.3 slot B** (skill 3.C, justify with data), all four candidates failed (two at solve, two at audit). Topic 1.3 still gets seed A plus 3 variants (4 MCQs).
- Labels: skill validated for 12 of 13 seeds (Biology 2.5 slot B: practice only). Difficulty is `provisional_model` for all (11 Medium, 1 Easy); it is not an author target.

**Cost:** 774 gateway calls, 3.83M input and 1.13M output tokens. Dollar cost is not metered by the pipeline; estimated at about $12 to $18 from the Biology pilot's $0.22 to $0.31 per accepted item. Check the Vercel dashboard for the actual figure.

**Tooling change:** `seed_pipeline.mjs` now produces only the missing variants for a finished slot when `--variants` is raised later (it used to skip finished slots and silently make no variants).

**Not done:** blind re-judge sample; Development load; Production load (Hard-Gate, needs an APPROVAL row); post-load selector check and gap re-query.
