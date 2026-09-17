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
- A **glossary for bots** (AP terms + FRQ task words, each tied to how Cramapple
  teaches/grades it) — cheap top-of-funnel AEO surface. (See Addendum.)
- FAQ blocks, tables, and concise answer capsules for AEO.
- Internal linking that pushes authority from the pillar page into supporting
  pages.

## What To Defer

- Broad "best AP prep" pages.
- Large cross-subject content factories.
- General comparison pages that do not convert.
- Tools or calculators before the subject stack is credible.
- AI "summarize with AI" share buttons (HubSpot tested and shelved them:
  citations rose but visibility stayed flat).

## Recommended URL Pattern

- `/ap-biology`
- `/ap-biology/unit-3-cellular-energetics`
- `/ap-biology/unit-6-gene-expression-and-regulation`
- `/ap-biology/unit-7-natural-selection`
- `/ap-biology/frq-tips`
- `/glossary` (bot-facing AP glossary)

## AEO Rules

- **Server-side render / pre-render every marketing page. AI bots do not execute
  JavaScript** — content that renders client-side may be invisible to them. The
  canonical facts we most want cited (score distributions, exam format, unit
  weights, FRQ rubric points) must be present in the raw HTML. **Action: verify
  our Lovable/React marketing pages are SSR/pre-rendered, not client-only.**
- Lead with the answer; keep paragraphs to one question at a time.
- Make pages fast — pre-rendering/speed materially increased AI crawls and
  citations in the HubSpot experiments.
- Use tables where the data is factual and stable; use FAQ blocks for student
  questions; keep entity names consistent across pages.
- Some content is for humans and bots, some just for humans, some just for bots —
  design each page for its real audience (the glossary is a bot-first page).
- Validate any hyped tactic against our own logs/data before scaling it
  (llms.txt was a dead end — ~97% of llms.txt files get zero requests).
- Make the content specific enough that AI engines can cite it directly.

## Off-Site: Mentions and Reddit

- **Mention-building over pure link-building.** LLMs are recency-biased, so
  favor **fresh** placements over already-winning pages, and **volume of
  medium-authority mentions** over a single prestige link.
- **Reddit is a community to co-own, not a feed to post into.** The r/APStudents
  bet stays central and gets deeper: aim for genuine community programming
  (helpful cadence, AMAs, recognized contributors), not link-drops. HubSpot's
  citations doubled by co-moderating their own subreddit.

## Ownership

- A single named owner (or a small dedicated pod, per HubSpot's "Project
  Lighthouse") is accountable for **both SEO and AEO**. The risk is leaving it
  unowned, not under-staffing it — HubSpot ran the program with two people.

## Success Metrics (reframed 2026-09)

Primary (co-equal):

- **AI-qualified sign-ups** — conversions attributed to `chatgpt.com`,
  `perplexity.ai`, and other AI referrers in GA4.
- **AI citation share** — of a fixed set of AP test queries run monthly in
  ChatGPT/Perplexity, the share that cite Cramapple vs. competitors.

Supporting (not the headline):

- Organic sessions from long-tail AP terms, pages indexed, referring domains,
  r/APStudents presence.

> Rationale: traffic is no longer a reliable growth metric. Track the channel
> that converts — HubSpot's AI-qualified leads rose 1,850% while blog traffic
> fell. Evaluate a dedicated AEO measurement tool (HubSpot used, then acquired,
> Xfunnel) once the surface is large enough to measure.

## Working Assumption

SEO/AEO should support conversion, not replace it. The conversion funnel still
depends on the homepage, the signup flow, and the score-maximization story.

---

## Addendum — 2026-09-17: AI Search Experiment Findings

Trigger: Aja Frost (ex-HubSpot, now Mercury), *"Inside 12 months of AI search
experiments,"* guest post on Kyle Poyar's *Growth Unhinged* (2026-09-16). Full
findings, cited people/companies, and the comparison to this plan are in
[`docs/seo/research/2026-09-17-ai-search-experiments-poyar.md`](../seo/research/2026-09-17-ai-search-experiments-poyar.md).

HubSpot rebuilt around AI search via a weekly-experiment pod and became the #1
most-visible CRM in AI search, with AI-qualified leads up 1,850%. Highest-value
adopts for Cramapple, in order:

1. **SSR / HTML-first** — AI bots don't run JavaScript; verify our marketing
   pages aren't client-rendered (biggest technical finding for us).
2. **Glossary for bots** — cheap TOFU page type; HubSpot's citation share went
   1.97% → 3.2%.
3. **Page speed / pre-rendering** — drove +1,600% AI crawls, +~40% citations.
4. **Mention-building** — fresh + volume of mid-DR beats one prestige link.
5. **Reddit as co-owned community** — deepens (not replaces) our r/APStudents bet.
6. **Measure citation share + AI-qualified sign-ups**; validate tactics on our
   own data first (llms.txt was a dead end).

Correction: an earlier draft of these docs mis-attributed a "semantic triples /
+642%" result to this article. That figure is from a separate HubSpot post
(Amanda Sellers) we have not read directly; it is not part of this article and
has been removed from the plan.
