# Research Note — Inside 12 Months of AI Search Experiments (HubSpot)

**Date:** 2026-09-17
**Prepared by:** Bloom Insights
**Source article:** Aja Frost, *"Inside 12 months of AI search experiments"* — guest post on
Kyle Poyar's *Growth Unhinged*, published 2026-09-16.
(https://www.growthunhinged.com/p/hubspot-ai-search-experiments)
**Read from:** primary source (owner-supplied PDF of the article). Supersedes the first draft of
this note, which was reconstructed from search excerpts and mis-attributed a "semantic triples /
+642%" finding that belongs to a *different* HubSpot article, not this one.

---

## 1. Author and who is cited

- **Author: Aja Frost** — former marketing/SEO leader at HubSpot; now Director of Growth Marketing
  at **Mercury**. She ran the program described here.
- **Host: Kyle Poyar** — publishes *Growth Unhinged*; wrote the intro, did not write the piece.
- **Project Lighthouse pod:** Victor Pan, Bradley Sanders, Amanda Kopen.
- **Also thanked (Global Growth & Paid):** Rory Hope, Karolina Bujalska-Exner, Christina Clark,
  Justine Gavriloff, Nancy Harnett, Justin Champion.
- **Companies / tools named:** HubSpot, Mercury, **Ahrefs** (llms.txt stat), **Botify** (SpeedWorkers
  pre-rendering), **Xfunnel** (AEO measurement tool HubSpot used, then acquired), Reddit, OpenAI,
  Google, ChatGPT, Bing. Sponsor: Metronome (a Stripe product). Related Poyar pieces reference
  **Clay, Glean, Rippling, Lovable** and co-author **Casey Hill**.

**Related articles worth reading next:** "Is AI talking about your product in the right way?" (Clay/
Glean/Rippling/Lovable; Poyar + Casey Hill); "How to use AI agents for marketing"; "40 ICP marketing
plays." Separately, a distinct HubSpot post ("How simple semantics increased our AI citations by
642%," attributed to Amanda Sellers) covers semantic triples — a *different* source we have not yet
read directly (domain blocked); treat that figure as unverified.

## 2. The provocation

HubSpot's blog traffic "fell off a cliff" after Google's late-2024 algorithm change and the decline
went viral. Frost's counter: part of the drop was *intentional* (they'd stopped chasing
non-converting terms like "best OOO messages"), and the real move was to rebuild the growth engine
around **AI search** — a brand-new channel no one had figured out yet. "Every headwind is a tailwind
if you turn around."

**Program:** a dedicated experimental pod ("Project Lighthouse") — two AI-curious SEOs pulled off
normal work, daily standups, weekly shipped experiments.
**Headline outcome:** HubSpot became the **#1 most-visible CRM in AI search**, and **AI-qualified
leads rose 1,850%**.

## 3. The experiments and findings (as reported)

| # | Experiment | What they did | Result |
|---|---|---|---|
| 1 | **llms.txt** | Published llms.txt with tracking "easter eggs"; watched logs; submitted to Bing/Google | **Failed** — no crawls, no ingestion. Ahrefs: **97% of llms.txt files get zero requests.** Lesson: validate with your own data before scaling a hyped tactic. |
| 2 | **Hyper-specific vertical content** | 141 AI-generated pages (industry × use-case, e.g. "CRM for [use case]"), built on case studies, heavy QA for hallucinations | ChatGPT bot alone = 15K crawls in weeks; citations started ~16%, rose to **92% cited, +49% visibility.** Rolled out in DE/ES/FR/JP. Lesson: **crawls → citations → visibility**, in sequence. |
| 3 | **Teaching bots our pricing** | Pricing page was JS-rendered (AI bots can't execute JS), so LLMs quoted stale third-party prices. Wrote plain, bot-structured HTML blog posts describing each product's pricing | Accuracy improved for **5 of 6 products** in ~2 months; Sales Hub dropped (fixed by correcting third-party sites). |
| 4 | **Glossary for bots** | 50 SSR, HTML-first glossary pages (term + definition + example + 1–2 sentences tying it to a HubSpot product) | Visibility **+35%** awareness-stage, **+26%** consideration/decision; overall citation share **1.97% → 3.2%.** Expanded to 5 languages. |
| 5 | **AI share buttons** ("summarize with AI") | Neutral "Summarize the content at URL" button on lead-magnet pages | Citation rate **+29%** (7/8 URLs), but visibility flat → **shelved.** |
| 6 | **Serving bots fast** | Botify SpeedWorkers pre-rendering; load speed cut 6.4x to ~0.1s | AI-bot crawls **+1,600%**, traditional crawlers **+30%**, citations **+~40%**, AI referral traffic **+6%.** (Citations and traffic don't move proportionately.) |
| 7 | **Mention-building** (not link-building) | Paid flat fees for brand mentions | Learnings: (a) **fresh posts beat already-winning posts** (LLMs are recency-biased) and are cheaper; (b) **quantity of low/mid-DR mentions beat one high-DR mention**; (c) valued a mention via AI-influenced ARR ÷ mentions. |
| 8 | **Cracking Reddit** | Co-moderated the existing r/HubSpot: content calendar, AMAs, "HubSpot champions," no spam | Community **+61.7% YoY**, HubSpot mentions across Reddit **7x**, citations **doubled.** Insight: activity spikes in r/HubSpot lifted positive mentions *across* Reddit. |

**Guiding philosophy that emerged:** some content is for humans and bots, some just for humans,
some just for bots. HubSpot later acquired **Xfunnel** (their measurement tool) and launched a
HubSpot AEO product in April.

## 4. How this compares to our current plan

**Already aligned:** answer-first structure, FAQ schema, tables, entity consistency, and — crucially
— the **Reddit / r/APStudents** bet. Frost's Reddit result is strong external validation, and it
*sharpens* our play: the win came from **co-moderating and programming the community**, not from
posting answers. Upgrade our Reddit line from "be a good contributor" to "own/co-run the community."

**New / underweighted — worth adopting (highest value first):**
1. **SSR / HTML-first is a hard requirement, not a nice-to-have.** AI bots don't execute JavaScript.
   If Cramapple's unit/FRQ/score pages render client-side (Lovable/React SPA), **AI engines may not
   see the content at all.** This is the single most important technical finding for us — verify
   our marketing pages are server-side rendered or pre-rendered, and that canonical facts (score
   data, exam format, unit weights) are in the raw HTML.
2. **Build a "glossary for bots."** An AP glossary (key terms + FRQ task words like *justify,
   analyze, evaluate*), each with a definition, an example, and a sentence tying it to how Cramapple
   teaches/grades it. Cheap, TOFU, and it nearly doubled HubSpot's citation share.
3. **Page speed / pre-rendering** materially increases AI crawls and citations. Make marketing pages
   fast and crawlable.
4. **Mention-building mechanics:** favor **fresh** placements and **volume of mid-DR** mentions over
   one prestige link — LLMs are recency-biased. Reframe our "best AP prep resources" outreach this way.
5. **Measurement:** adopt an AEO measurement tool and track **citation share** and **AI-qualified
   sign-ups** as first-class metrics (HubSpot: AI-qualified leads +1,850%).
6. **Test discipline:** validate any hyped tactic (e.g. llms.txt) against our own logs before
   investing. Don't build llms.txt on faith.

**Don't bother (yet):** AI "summarize" share buttons — HubSpot shelved them (citations up, visibility
flat).

## 5. Plan changes adopted (this session)

1. Elevated **SSR / HTML-first + crawlable canonical facts** to a required AEO rule, with a technical
   verification action against our Lovable/React marketing pages.
2. Added a **glossary-for-bots** page to the priority build list.
3. Rewrote the **mention-building** guidance (fresh + volume of mid-DR) and **deepened the Reddit
   play** to community co-ownership.
4. Reframed success metrics to **AI citation share** and **AI-qualified sign-ups**; added a note to
   evaluate an AEO measurement tool.
5. Added a **test-with-own-data** rule (the llms.txt lesson).

See `docs/proposals/2026-06-23-seo-aeo-strategy.md` for the applied edits.
