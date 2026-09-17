# Cramapple SEO and AEO Strategy

**Status:** Working strategy for marketing expansion  
**Date:** 2026-06-23  
**Last updated:** 2026-09-17 (AI-search-experiment findings — see §Addendum)

## Purpose

This strategy translates the external SEO/AEO report into a Cramapple-specific
plan. The goal is not to compete on broad head terms like "AP exam prep." The
goal is to own the long-tail queries where students are already expressing high
intent and where Cramapple's score-maximization point of view is most valuable.

## Strategic Thesis

1. Broad AP prep terms are dominated by entrenched incumbents.
2. Cramapple can win by focusing on long-tail, high-intent, subject-specific,
   unit-specific, and FRQ-specific queries.
3. AI answer engines prefer content that is structured, direct, and easy to
   cite.
4. The strongest early wedge is AP Biology, because the product, pedagogy, and
   current content all align there.

## What to Prioritize

- Subject pillar pages for AP Biology first.
- Unit pages for the highest-value AP Biology units.
- FRQ strategy pages with answer-first formatting.
- FAQ blocks, tables, and concise answer capsules for AEO.
- Internal linking that pushes authority from the pillar page into supporting
  pages.

## What To Defer

- Broad "best AP prep" pages.
- Large cross-subject content factories.
- General comparison pages that do not convert.
- Tools or calculators before the subject stack is credible.

## Recommended URL Pattern

- `/ap-biology`
- `/ap-biology/unit-3-cellular-energetics`
- `/ap-biology/unit-6-gene-expression-and-regulation`
- `/ap-biology/unit-7-natural-selection`
- `/ap-biology/frq-tips`

## AEO Rules

- Lead with the answer.
- Keep paragraphs to one question at a time.
- **Express the facts you want AI to repeat as semantic triples** —
  terse subject–predicate–object bullets, not prose. Apply to the claims we most
  want cited: score distributions, exam format, unit weights, and FRQ rubric
  points. (Highest-lift tactic in the 2026-09 HubSpot experiments — see Addendum.)
- Use tables where the data is factual and stable.
- Use FAQ blocks for student questions.
- Keep entity names consistent across pages.
- Ship the "everything bagel," not one ingredient: triples + schema
  (FAQ/Article/Breadcrumb JSON-LD) + structure + third-party mentions together.
- Make the content specific enough that AI engines can cite it directly.

## Ownership

- A single named owner is accountable for **both SEO and AEO**. One dedicated
  person is enough to move the channel (Docebo runs it with one); the risk is
  leaving it unowned, not under-staffing it.

## Success Metrics (reframed 2026-09)

Primary (co-equal):

- **AI-discovery-attributed sign-ups** — conversions from `chatgpt.com`,
  `perplexity.ai`, and other AI referrers in GA4.
- **AI citation share** — of a fixed set of AP test queries run monthly in
  ChatGPT/Perplexity, the share that cite Cramapple vs. competitors.

Supporting (not the headline):

- Organic sessions from long-tail AP terms, pages indexed, referring domains,
  r/APStudents presence.

> Rationale: traffic is no longer a reliable growth metric. AI visitors convert
> at multiples of organic (reported 6x at Webflow; our own report assumed 4.4x),
> so a smaller AI-referred cohort can outproduce a larger organic one.

## Working Assumption

SEO/AEO should support conversion, not replace it. The conversion funnel still
depends on the homepage, the signup flow, and the score-maximization story.

---

## Addendum — 2026-09-17: AI Search Experiment Findings

Trigger: Kyle Poyar (Growth Unhinged), *"What HubSpot learned from running AI
search experiments."* Full findings, source citations, and the comparison to
this plan are in
[`docs/seo/research/2026-09-17-ai-search-experiments-poyar.md`](../seo/research/2026-09-17-ai-search-experiments-poyar.md).

What changed above, and why:

- **Semantic triples** added as a required AEO primitive — the HubSpot experiment
  (Amanda Sellers) tied a **+642%** citation lift and **+58%** more AI mentions to
  rewriting key facts as triple-formatted bullets.
- **Metrics reframed** away from a traffic headline toward AI-discovery
  conversions and citation share (Docebo: AI = 12.7% of high-intent leads, +429%
  YoY; Webflow: 10% of sign-ups, ChatGPT converting ~6x Google).
- **Named ownership** added (one owner for SEO + AEO).

What we deliberately did **not** change: our r/APStudents / community bet stays
central. The article is B2B, where vendor-comparison behavior dominates; our
buyers are students, and Reddit is the most-cited third party in AP AI answers.

Template follow-up (engineering, separate workstream): add a `triples` block type
to `UnitContent` (`src/content/<subject>/units.ts`) so score/format/rubric facts
render as machine-liftable bullets and can carry their own schema — same
"content, not engineering" pattern as the existing block types.
