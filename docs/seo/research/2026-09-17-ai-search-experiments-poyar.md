# Research Note — AI Search Experiments (Poyar / HubSpot)

**Date:** 2026-09-17
**Prepared by:** Bloom Insights
**Source article:** Kyle Poyar, *"What HubSpot learned from running AI search experiments,"* Growth Unhinged
(https://www.growthunhinged.com/p/hubspot-ai-search-experiments)
**Status:** Research input to the Cramapple SEO/AEO plan. Not a strategy change on its own —
see "Plan changes adopted" below for what actually moves.

> Sourcing note: the Growth Unhinged and HubSpot blog domains are blocked by our egress proxy,
> so the specifics below were reconstructed from search-indexed excerpts and secondary coverage,
> not a full read of the primary article. Figures are quoted as reported; re-verify against the
> primary sources before citing externally.

---

## 1. The author and who he cites

- **Kyle Poyar** — founder of Growth Unhinged (ex-OpenView Partners); B2B GTM, PLG, and pricing;
  ~85k+ readers. His recent through-line: **traffic is no longer a reliable growth metric; AI
  discovery is a real acquisition channel now.**
- **Amanda Sellers** — HubSpot, head of EN blog strategy. Ran the semantic-triples experiment.
- **Elena Verna** — growth advisor (ex-HubSpot/Amplitude/Miro). Wrote "Company blogs are no longer
  worth the investment"; the piece Poyar is partly reacting to.
- **Valeriia Frolova** — Docebo. Runs both SEO and AEO as a team of one.
- **Companies cited:** HubSpot, Docebo, Webflow, ChatGPT/OpenAI.

**Related Poyar articles worth reading next:** "Traffic is no longer a reliable growth metric";
"How to turn ChatGPT into your best pipeline source" (AI discovery playbook); "The best growth
tactics of 2025"; "The GTM channels I'm betting on in 2026."

## 2. The provocation

The viral "HubSpot's blog traffic is collapsing" narrative is the wrong frame. It is not decline —
it is a **platform shift**: buyers increasingly ask AI (ChatGPT) for recommendations instead of
clicking blue links. Chasing organic sessions optimizes a dying metric. The job is to be the
**cited, recommended source inside AI answers**.

## 3. The experiments and findings

| Source | What they did | Result (as reported) |
|---|---|---|
| HubSpot (Sellers) | Rewrote key facts on target pages from prose into **bulleted lists of semantic triples** (subject–predicate–object), on top of an "everything bagel" of schema, backlinks, and structure | **+58%** mentions of HubSpot in AI answers; **+642%** times HubSpot pages were cited by AI |
| Docebo (Frolova) | One person owning SEO **and** AEO together | AI discovery = **12.7% of high-intent leads, up 429% YoY** |
| Webflow | Treated AI discovery as a tracked channel | **10% of signups** from AI discovery, **4x YoY**; **ChatGPT traffic converts ~24%, ~6x** Google |

**The tactics that generalize:**
1. **Semantic triples** — express the facts you want AI to repeat as terse, atomic
   subject–predicate–object bullets, not paragraphs. This is the single most concrete, highest-lift
   tactic in the piece.
2. **The "everything bagel"** — triples alone don't do it; pair with schema, structure, and
   third-party mentions/backlinks.
3. **Own-site source of truth** — put every fact you want engines to know on your own pages.
4. **Measure discovery, not traffic** — attribute conversions/leads to AI referrers; expect a much
   higher conversion rate than organic.
5. **Ownership** — a single dedicated owner can move the needle.

## 4. How this compares to our current plan

**Already aligned (no change needed):**
- Answer capsules / answer-first structure, FAQ schema, tables, entity consistency, third-party
  authority (Reddit/Quora), freshness/year-in-URL, and tracking `chatgpt.com` / `perplexity.ai`
  referrers are all in the strategy report and the template (`UnitContent` enforces the `lede`
  answer block and auto-generates FAQ/Article/Breadcrumb JSON-LD).
- Our "AI visitors convert ~4.4x" claim is directionally confirmed and arguably conservative next
  to Webflow's ~6x.

**New / underweighted in our plan — worth adopting:**
- **Semantic triples as a required content primitive.** We have answer capsules and bullet lists
  but do not yet mandate atomic triple-formatted facts for the specific claims we want cited
  (score data, exam format, unit weights, FRQ rubric points). This is the biggest concrete gap.
- **Metric reframing.** Our 90-day scorecard still leads with "500+ organic sessions/month."
  The article argues that is the wrong headline metric. AI-discovery-attributed sign-ups and
  citation share should be co-equal primary metrics, not a side check.
- **Named AEO ownership.** Our plan describes the work but assigns no owner. Docebo shows one
  person is enough; name one.

**Where we should NOT over-rotate (divergence):**
- The article is **B2B**. Cramapple is **B2C/student**, where the most-cited third party is
  **r/APStudents**, not vendor-comparison behavior. Our existing Reddit/community bet stays central;
  the article underweights it because its audience buys differently. Keep it.
- "Blogs are dead" does not translate to "unit/FRQ pages are dead." Our long-tail student pages ARE
  the AEO surface; they are not the traffic-chasing corporate blog Verna is describing.

## 5. Plan changes adopted (this session)

1. Added **semantic triples** to the AEO rules and the new-page launch checklist as a required
   primitive for citable facts, and flagged a template follow-up: add a `triples` block type to
   `UnitContent` so score/format/rubric facts render as machine-liftable bullets with schema.
2. Reframed success metrics: **AI-discovery-attributed sign-ups** and **AI citation share** promoted
   to primary; raw organic sessions demoted to a supporting indicator.
3. Assigned a **single AEO owner** (to be named) accountable for both SEO and AEO, per the
   Docebo one-person model.

See `docs/proposals/2026-06-23-seo-aeo-strategy.md` for the applied plan edits.
