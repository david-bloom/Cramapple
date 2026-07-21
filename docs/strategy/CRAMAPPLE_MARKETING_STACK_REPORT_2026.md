# Cramapple Marketing Stack Recommendation

**Prepared for:** David Bloom  
**Date:** July 19, 2026  
**Decision horizon:** First 90 days, followed by scale readiness  
**Operating constraint:** $250/month initial acquisition budget; one two-hour work session on Sunday; brief weekday checks

## Executive recommendation

Cramapple should not buy a large “all-in-one” marketing platform. At this stage, the best stack is a thin automation layer around the tools already in place:

- **Lovable + Vercel** for landing pages and conversion experiments.
- **Supabase** as the customer, attribution, consent, trial-entitlement, and referral system of record.
- **Stripe** as the revenue source of truth.
- **PostHog Cloud Free** for funnel analytics, feature flags, experiments, surveys, and carefully limited session replay.
- **Loops Free** for product-triggered email and lifecycle journeys.
- **Buffer Free** for scheduled Instagram and TikTok publishing; Reddit participation should remain human.
- **Canva Free + CapCut Free** for reusable visual and short-form video production.
- **Make Free**, used only for low-risk cross-tool workflows. Critical customer and revenue workflows should be built in Supabase Edge Functions and scheduled jobs.
- **Native ad-platform automation** rather than a paid third-party media optimizer.
- **A small referral system built in Supabase and Stripe**, with a separate tutor/creator affiliate track. Do not buy affiliate software until the program has enough active partners to justify it.

This stack should cost **$0 in incremental software at launch**, excluding the existing infrastructure and advertising spend. A sensible first paid upgrade would be Buffer Essentials for two channels (roughly $10/month when priced at $5 per channel on annual billing) or Make Core at $12/month, but only when a documented workflow is constrained by the free plan.

The paid-channel order should be:

1. **Reddit contextual test** for high-intent AP conversations.
2. **Instagram/Meta test**, separating student creative from parent-purchaser creative.
3. **TikTok paid only after the budget is larger**; use TikTok organically during the first 90 days.

The most important build is not an ad tool. It is a clean measurement spine from first visit through activated trial, payment, and referral. Without it, a “strong CAC” cannot be trusted and automation will simply make uncertain decisions faster.

## What the existing strategy implies

The [Cramapple vision](../product/CRAMAPPLE_VISION.md) defines the product as AP score optimization rather than generic tutoring. Its sharpest promise is points gained per hour, with criterion-level FRQ feedback, the minimum fix needed for the next point, and a next-best-action recommendation. That positioning is materially more distinctive than “AI tutor.”

The [competitor assessment](COMPETITORS.rtf) identifies the key alternatives correctly:

- Tutors provide personalized feedback but cost hundreds of dollars and create scheduling friction.
- Fiveable is the most relevant direct threat because it already offers AI-assisted FRQ grading and broad AP coverage.
- Albert offers depth of practice but not criterion-level FRQ repair or next-best-action guidance.
- Khan Academy is the free default, but it is primarily a content and practice library rather than a point-optimization system.

The [economics model](Cramapple_Financial_Model.xlsx) and [economics narrative](ECONOMICS.rtf) establish a $39.99 one-time price per subject, estimated contribution before acquisition of roughly $30–34 per customer, and a long-run blended CAC target below $15. Because access is purchased once per subject, this is not a subscription-LTV business. Every marketing system should therefore report **paid subject purchases**, not “subscribers,” and paid acquisition should be judged against the contribution from the initial transaction.

### Financial-model audit warning

The workbook’s strategic assumptions are usable, but several calculated outputs should not be used for decisions until repaired:

- The inference-cost formulas reference the wrong rows and currently calculate to zero.
- Contribution-margin formulas reference blank or incorrect rows.
- Per-user revenue and CAC rows reference the wrong cells, creating impossible values.

The narrative estimate of $30–34 contribution is directionally reasonable, but the spreadsheet should be corrected before budget automation is allowed to use its outputs.

## A necessary funnel decision: do not offer a seven-day unlimited public trial

Cramapple’s design center is a student who may have only ten days before an exam. An unlimited seven-day trial could provide most of the urgent use case before payment.

The recommended public offer is therefore an **activation-limited free score check**, not a time-only trial:

1. A short diagnostic or topic selection.
2. One representative FRQ submission.
3. Criterion-level feedback showing what earned credit.
4. One “minimum fix for the next point.”
5. A personalized next-action plan.
6. A paywall to unlock the full subject pack.

This lets the product prove its differentiated value before asking for $39.99 while preserving a reason to buy. A separate, invitation-only beta cohort can receive full free access for research and testimonials. That cohort must be tagged separately so its behavior never contaminates paid-funnel conversion metrics.

## The measurement spine

### Why it is needed

Ad platforms will report their own versions of conversions. Stripe will report purchases. Supabase will know who activated. These systems will disagree unless Cramapple creates one event and attribution contract.

The minimum event taxonomy should be:

| Funnel stage | Canonical event | Why it matters |
|---|---|---|
| Acquisition | `landing_view` | Establishes eligible traffic and source |
| Consideration | `demo_started` | Measures whether the differentiated proof is being consumed |
| Intent | `signup_started` | Separates landing-page failure from registration failure |
| Trial | `trial_started` | Primary early ad-optimization event |
| Activation | `first_response_graded` | The real “aha” moment; more valuable than an account creation |
| Value | `repair_completed` | Shows that students acted on feedback rather than merely viewed it |
| Retention | `returned_day_2` and `returned_day_7` | Indicates that the trial created ongoing value |
| Monetization | `checkout_started` | Identifies checkout friction |
| Revenue | `purchase_completed` | Stripe-verified purchase; revenue source of truth |
| Advocacy | `referral_shared` | Measures referral participation |
| Referral outcome | `referred_trial_started`, `referred_purchase` | Separates sharing from productive referrals |

Every anonymous visit should capture first-touch and last-touch values for `utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, landing page, referrer, and ad click IDs. On account creation, those values should be persisted to Supabase. On purchase, a Stripe webhook should attach the transaction and entitlement to the same acquisition record.

Do not send answer text, grades, weaknesses, uploaded work, school information, or private learning behavior to advertising platforms. Server-side conversion events should contain only the minimum permitted identifiers and commercial events required for measurement.

### Recommended tool: PostHog Cloud Free

**Why:** It combines product analytics, web analytics, experiments, feature flags, surveys, and session replay around a single event model. This prevents a solo operator from maintaining GA4, a separate product-analytics tool, a replay tool, and an A/B testing tool. Its current free tier includes 1 million analytics events, 5,000 replays, 1 million feature-flag requests, and 1,500 survey responses per month: <https://posthog.com/pricing>.

**Deployment effort:** Medium, about one focused implementation day plus QA. The work is event design and identity reconciliation, not merely pasting a script.

**Ongoing effort:** Low once dashboards and anomaly alerts exist.

**Privacy configuration:**

- Use anonymous marketing-page events by default.
- Disable session replay on authentication, checkout, uploads, and the student learning application at launch.
- If replay is later enabled on marketing pages, require consent, mask all inputs, and sample sessions.
- Retain private learning analytics in Supabase; send PostHog only coarse product events and non-sensitive properties.

**Options considered:**

| Option | Cost at launch | Strength | Weakness | Decision |
|---|---:|---|---|---|
| PostHog | $0 within free tier | One event model for funnel, experiments, flags, surveys | Requires thoughtful setup; replay needs privacy discipline | **Recommend** |
| GA4 + Google Tag Manager | $0 | Standard marketing reporting and ad ecosystem familiarity | Poorer product-funnel ergonomics; more configuration; easy to create a noisy event model | Acceptable alternative |
| Microsoft Clarity | $0 and already installed | Heatmaps and replay | Not a revenue or product source of truth; replay risk on student flows | Keep only on consented marketing pages or remove |
| Lovable/Flock analytics | Included | Basic site operations | Insufficient as the acquisition source of truth | Treat as operational telemetry only |

## Advertising and acquisition layer

### Platform reality for a teenage audience

Meta permits advertisers to include teens based only on age and location; it does not permit teen targeting by interests, behaviors, gender, or off-platform activity: <https://www.facebook.com/help/980264326141711/>. TikTok similarly restricts detailed targeting for US audiences under 18 and recommends awareness-oriented objectives for that group: <https://ads.tiktok.com/help/article/about-advertising-to-people-under-the-age-of-18?lang=en>.

This means creative and context—not microscopic audience settings—must do most of the targeting. It also means parent-purchaser campaigns should be separate from student campaigns.

### 1. Reddit Ads: first paid experiment

**Why needed:** Students use Reddit to ask specific, urgent questions about AP classes, FRQs, grading, and exam preparation. Reddit can target communities, interests, and keywords, providing contextual intent that teen restrictions reduce on other platforms. Reddit describes community, keyword, and interest targeting here: <https://www.business.reddit.com/learning-hub/articles/everything-about-audience-targeting-reddit>.

**Recommendation:** Run one conversion campaign with one tightly defined contextual audience and three creative variants. Use a native Reddit-style post that demonstrates one scoring misconception and the “minimum fix for the next point.” Optimize initially to `trial_started` or `first_response_graded`, not purchase, because purchase volume will be too low for stable learning.

**Budget:** $175–200 for the first test, with a $25–75 reserve for extension of a promising creative or a small Meta comparison. Do not create multiple campaigns that compete for the same tiny budget.

**Automation:** Use Reddit lowest-cost automated bidding and hard daily/lifetime caps. Reddit now supports automated bidding across conversion and traffic objectives: <https://www.business.reddit.com/blog/brand-autobidding-launch>.

**Operating effort:** Low for paid ads, but community activity must remain human. Do not automate promotional Reddit posts or replies. Spend part of the weekday check-in answering genuine questions without links.

### 2. Instagram/Meta: second paid experiment

**Why needed:** Instagram is strong for short demonstrations, parent reassurance, and retargeting eligible adult visitors. Meta’s Advantage+ budget and placements can allocate spend automatically across placements: <https://www.facebook.com/business/ads/meta-advantage-plus/budget>.

**Recommendation:** Run two messaging tracks, but not necessarily at the same time:

- **Student message:** “You knew the biology. Here is the one sentence that lost the FRQ point.” Broad teen age/location targeting; no personalized retargeting.
- **Parent message:** “Purposeful AP preparation without another tutoring schedule.” Target adults, send them to a parent-specific landing section, and emphasize visible progress, one-time pricing, and the ask-a-parent purchase path.

Use 9:16 vertical video, Advantage+ placements, and a single campaign budget. Automate spend only after server-side purchase and activated-trial events are verified.

### 3. TikTok: organic now, paid later

**Why defer paid:** TikTok requires ad-group daily budgets above $20 and recommends roughly $30/day for North American web-conversion campaigns. Its own conversion guidance often assumes much larger learning budgets: <https://ads.tiktok.com/help/article/about-lifetime-budgets> and <https://ads.tiktok.com/business/en-GB/how-it-works/budgeting>. A $250 monthly budget cannot give TikTok enough time and conversions to learn reliably while also funding other tests.

**Recommendation:** Use TikTok as an organic hook laboratory. The best-performing organic videos can later become Spark Ads or paid creative once monthly media spend is at least $1,000–1,500 and the activated-trial-to-purchase conversion rate is known.

### Native optimization versus third-party ad optimizer

| Option | Typical fit | Cost/effort | Decision |
|---|---|---|---|
| Native Meta, Reddit, and TikTok automation | Early-stage and modest spend | Included; low deployment | **Recommend** |
| Revealbot/Madgicx-style optimizer | Multiple campaigns and several thousand dollars monthly spend | Adds subscription and rule maintenance | Defer |
| Custom Ads API automation | Mature internal data and substantial spend | High engineering and governance effort | Defer |

No third-party optimizer can overcome inadequate conversion volume. At $250/month, better instrumentation and creative produce more value than another optimization subscription.

## Lifecycle email and lightweight CRM

### Why it is needed

A free trial introduces a delay between acquisition and revenue. Students may start late at night, abandon after a difficult question, forget to return, or need a parent to pay. Email is the owned channel that recovers this intent without paying for another impression.

### Recommended tool: Loops Free

Loops is designed for software-product lifecycle and transactional email. Its free plan currently supports up to 1,000 subscribed contacts and 4,000 sends per month with the full feature set, plus a branded footer: <https://loops.so/pricing>.

**Recommended initial journeys:**

1. Welcome and “complete your first score check.”
2. Abandoned activation after 24 hours.
3. First graded response recap, without including sensitive answer content in email.
4. Repair-completed encouragement and next action.
5. Trial limit reached: unlock full AP Biology.
6. Ask-parent handoff with a parent-safe summary and purchase link.
7. Purchase onboarding.
8. Referral request after a second successful session or a positive survey response.

**Deployment effort:** Medium. The email templates are easy; the important work is reliable event triggers, consent state, suppression, and parent/student separation.

**Ongoing effort:** Low. Review journey conversion monthly, not daily.

**Options considered:**

| Option | Current entry cost | Strength | Weakness | Decision |
|---|---:|---|---|---|
| Loops | $0 to 1,000 subscribers/4,000 sends | Product-event orientation; transactional plus lifecycle | Paid tier jumps to $49/month | **Recommend for first 90 days** |
| Brevo | $0 with 300 daily emails; Starter from $9/month | Lower-cost scale, CRM and multi-channel automation | Broader interface and more operational complexity | Best budget fallback after Loops free tier |
| Customer.io | From $100/month | Excellent complex behavioral journeys | Excessive for current scale and budget | Defer |
| Custom Supabase email logic | Vendor send cost only | Full control | Templates, deliverability, preferences, and reporting become maintenance work | Use only for security-critical transactional messages |

Brevo’s current plan details are published at <https://help.brevo.com/hc/en-us/articles/208589409-About-Brevo-s-pricing-plans>; Customer.io pricing is at <https://customer.io/pricing>.

## Organic social production and scheduling

### Recommended tool: Buffer Free

**Why:** It supports Instagram and TikTok scheduling, an AI assistant, a content queue, and up to three channels. The free plan currently allows ten queued posts per channel; Essentials is $5 per channel per month when billed annually: <https://buffer.com/pricing>.

**Recommendation:** Connect Instagram and TikTok. Use the third connection for YouTube Shorts if the same vertical videos are reused. Do not use a scheduler for Reddit community engagement.

**Alternative:** Metricool Free allows one brand and 20 scheduled posts per month and adds competitor tracking; the $25/month Starter plan offers unlimited publishing and broader analytics: <https://metricool.com/pricing/>. Metricool becomes preferable if paid-social reporting and cross-network competitor analysis save enough Sunday time to justify $25/month.

### Content production: Canva Free + CapCut Free

Create a small reusable system rather than asking AI to generate unrelated posts every week:

- Three 9:16 video templates.
- Two carousel templates.
- One “FRQ point lost / minimum fix” series.
- One “what to study next” series.
- One founder/family-story series.
- One parent-reassurance series.

Use real product output and anonymized, approved examples. Do not publish AI-generated student testimonials, fake score gains, or claims that one response predicts an official AP score.

**Build/buy decision:** Buy no generative video-avatar tool initially. At this stage, genuine screen recordings, founder voiceover, and student-informed language are more credible than polished synthetic presenters. Canva Pro can be added only if the brand kit and resizing features demonstrably remove production time.

## Automation and orchestration

### Recommended architecture

Use the most reliable system closest to each event:

- **Supabase database triggers / Edge Functions / scheduled jobs:** trial entitlements, referral attribution, lifecycle trigger creation, daily metric aggregation, anomaly alerts.
- **Stripe webhooks:** payment, refund, and entitlement events.
- **PostHog:** experiments, audience analysis, and non-sensitive behavioral alerts.
- **Native ad-platform rules:** budget caps, automatic placement, and bidding.
- **Make:** low-risk cross-tool convenience such as adding a weekly summary to a sheet, notifying the founder, or passing approved content between tools.

Make’s free plan provides 1,000 credits/month with a 15-minute minimum interval; Core is $12/month for 10,000 credits and minute-level schedules: <https://www.make.com/en/pricing>. n8n Cloud begins at €20/month billed annually for 2,500 executions: <https://n8n.io/pricing/>. n8n offers more logic flexibility, but it introduces another production service and is unnecessary while Supabase already handles the critical backend.

### Automation maturity ladder

1. **Weeks 1–4: observe.** Automation produces dashboards and alerts. A human approves all creative and budget changes.
2. **Weeks 5–8: guardrails.** Native rules pause overspend, enforce caps, and flag broken conversion tracking. New creative still requires approval.
3. **Weeks 9–12: bounded optimization.** Automation may move budget among already approved creatives within a fixed campaign budget.
4. **After proof:** Automation may generate drafts, schedule approved content patterns, and adjust budgets within a predefined CAC envelope. It may not invent claims, reply autonomously to students, or publish unreviewed educational advice.

### Hard guardrails

- Daily platform spend caps must exist outside any optimizer.
- Never increase a campaign budget by more than 20–30% in one automated change.
- Stop if server-side conversion tracking becomes stale or event counts diverge materially from Stripe/Supabase.
- Optimize to `first_response_graded` until purchases are frequent enough to serve as the platform event.
- Calculate predicted paid CAC as `cost per activated trial ÷ activated-trial-to-paid rate`.
- Initial target: predicted paid CAC at or below $15–20.
- Hard ceiling: pause and review when predicted paid CAC exceeds $25 after a meaningful minimum sample.
- Do not automatically kill creative after only a few clicks; the budget is too small for rapid-fire statistical decisions.

## Referral and affiliate system

### Why it is needed

At the current budget, 100 paid customers cannot come primarily from advertising. Referral must be part of the funnel architecture, not a later widget.

### Build the beta version

Use Supabase to create referral codes and attribution records, and pass the referral identifier into Stripe Checkout metadata. Reconcile successful referrals only after the refund window. Stripe supports customer-facing promotion codes, eligibility controls, expiration dates, and redemption limits: <https://docs.stripe.com/billing/subscriptions/coupons>.

Build two distinct programs:

#### Student/parent “refer a friend”

- Friend receives $5 off the first subject purchase.
- Referrer receives a $10 credit toward a future Cramapple subject or, for verified adult purchasers, a small post-refund-window reward.
- During the free beta, referrals can unlock an additional approved practice/feedback experience rather than cash.
- Add anti-abuse rules: no self-referrals, one reward per referred household/payment method, purchase must survive the refund window, and a monthly reward cap.

Because many users are minors, cash or gift-card rewards to students require legal, tax, platform-policy, and parental-consent review. Product credit is operationally safer, though its immediate value is limited until multiple subjects are available.

#### Tutor/creator affiliate

- Unique code and link for each approved partner.
- 20% commission ($8 at $39.99), matching the existing economics hypothesis.
- Monthly reconciliation after the refund window.
- Position Cramapple as between-session practice that preserves expensive tutor time for higher-value instruction.
- Require disclosure of the affiliate relationship.

### When to buy affiliate software

Consider Rewardful, Tolt, or FirstPromoter only when at least one of these is true:

- More than 25 active partners need a portal.
- Manual reconciliation takes more than one hour per week.
- Monthly referred revenue exceeds roughly $2,000.
- Multi-touch commission disputes become frequent.

Before those thresholds, a paid affiliate platform would consume budget to automate a program that has not yet demonstrated supply or conversions.

## Privacy, consent, and marketing to minors

### Why this is a stack component

Cramapple serves minors and holds learning records. Marketing data separation is therefore part of the acquisition architecture, not merely a legal-page task.

The FTC’s edtech policy emphasizes limits on commercial use of children’s data under COPPA: <https://www.ftc.gov/system/files/ftc_gov/pdf/Policy%20Statement%20of%20the%20Federal%20Trade%20Commission%20on%20Education%20Technology.pdf>. Most AP students are over 13, but state privacy laws, platform teen policies, contractual promises, and the presence of occasional younger users still require counsel.

Before adding ad pixels or lifecycle tools:

- Obtain a targeted legal review of age gating, consent, behavioral advertising, referral rewards, and parent purchase flows.
- Maintain a separate marketing profile from the private learning record.
- Store consent version and timestamp in Supabase.
- Default optional advertising and replay storage to denied until the user makes a choice where required.
- Do not create ad audiences from grades, topics missed, uploaded answers, or other educational records.
- Ensure vendors are listed accurately in the privacy policy and configured for minimum retention.
- Keep replay completely off the student practice application during the first 90 days.

A consent manager such as CookieYes or Termly can be evaluated after counsel defines the jurisdictions and signals that must be supported. A home-built banner that does not actually prevent tags from firing is not adequate.

## Live funnel audit

The live site already has several strong assets:

- Clear “maximum score in minimal time” positioning.
- A product demonstration centered on the next FRQ point.
- One-time purchase differentiation.
- Parent purchase and ask-a-parent pathways.
- A credible founder/family origin story.
- Microsoft Clarity and Lovable/Flock analytics already present.

Before paid traffic, correct the following:

1. **The live CTA does not currently present a free trial.** `/signup` is titled “Get Cramapple — One-time purchase” and begins with subject selection. Paid ads promising a trial would create message mismatch.
2. **Canonical and Open Graph URLs point to the Lovable prototype domain**, not `cramapple.com`. This damages attribution consistency and search canonicalization.
3. **The site claims a Twitter/X account that does not yet exist.** Remove `@cramapple` metadata until the account is controlled.
4. **Product availability is inconsistent.** The canonical vision says AP Biology is the sole launch subject, while the live signup page marks AP Statistics available and the homepage promotes future Physics subjects and bundles.
5. **Pricing is inconsistent with the vision.** The homepage lists Unlimited at $159.99 while the vision’s initial hypothesis lists $99. This may reflect a later decision, but the source of truth should be reconciled.
6. **A visible typo (“exam dday”) appears in the core method section.** Correct it before buying traffic.
7. **Tracking is already duplicated.** Clarity and Lovable/Flock are present; adding PostHog without a tag and data map would create redundant collection and conflicting counts.
8. **The public structured-data offers include products that are not all currently available.** Only purchasable offers should be represented as current offers.

## 90-day target math

One hundred paid subject purchasers at $39.99 represents $3,999 in gross sales.

With $250/month for three months, total paid spend is $750:

- If all 100 customers were attributed to that spend, blended CAC would be $7.50.
- At a more realistic early paid CAC of $15, paid media would produce about 50 purchasers; the other 50 would need to come from referrals, organic content, founder network, or tutor/creator partners.
- At a 20% activated-trial-to-paid rate, 100 purchasers require 500 activated trials.
- At a 30% rate, they require about 334 activated trials.

Therefore, **100 paid customers is an excellent stretch outcome, not the correct primary operating commitment**. A better 90-day decision target is:

- Instrumentation reconciles to Stripe within 5%.
- 150–300 activated trials.
- 25–50 paid customers as the base range; 100 as upside.
- Activated-trial-to-paid conversion of at least 20%.
- Predicted paid-channel CAC below $20, with a path below $15.
- At least 20% of activated trials from referral or organic sources by day 90.
- At least ten tutor/creator conversations and three active tracked partners.

If Cramapple reaches 100 paid purchasers while meeting the quality and refund thresholds, the acquisition system is ready for materially higher spend.

## Recommended 90-day rollout

### Days 1–14: make the funnel measurable

- Define the free score-check entitlement and separate full-access beta cohort.
- Reconcile the website’s subject availability, pricing, canonical URLs, metadata, schema, and typo.
- Implement the canonical event taxonomy in Supabase and PostHog.
- Persist first-touch and last-touch UTMs through signup and payment.
- Implement Stripe purchase/refund reconciliation.
- Build the founder dashboard and daily anomaly alert.
- Complete privacy/legal review before firing optional marketing pixels.

**Paid media:** $0. Preserve the budget until the funnel is testable.

### Days 15–30: activate and recover trials

- Launch Loops and the first five lifecycle messages.
- Add the parent handoff flow.
- Add a one-question activation survey and post-value referral prompt.
- Create six reusable content templates and schedule the first two weeks in Buffer.
- Recruit the first five beta referrers or tutors using manual codes.

**Paid media:** Optional $50 smoke test only after all events reconcile.

### Days 31–60: run the first channel experiment

- Run one Reddit campaign with three approved creatives.
- Use one landing-page message and one activation event.
- Hold targeting and the page constant long enough to learn which creative angle works.
- Publish two short-form videos and one carousel per week on Instagram/TikTok.
- Answer two relevant Reddit questions per week without promotional automation.
- Conduct five student interviews from activated and abandoned trials.

**Paid media:** Approximately $200–250 for the month.

### Days 61–90: validate transfer and referral

- Put 70–80% of the month’s budget into the best proven creative/channel.
- Use the remainder for a Meta/Instagram parent-message test.
- Add bounded native budget rules.
- Launch the production referral ledger and tutor/creator commission reconciliation.
- Compare referred, organic, Reddit, and Meta cohorts on activation, purchase, refunds, and usage cost—not clicks alone.
- Decide whether the next dollar belongs in paid media, referrals, or creator partnerships.

**Paid media:** $250, allocated by demonstrated predicted paid CAC.

## Weekly operating cadence

### Sunday: two hours

| Time | Activity | Output |
|---:|---|---|
| 15 min | Review the one-page scorecard | Identify exceptions, not vanity metrics |
| 20 min | Approve pauses and budget changes | Campaigns remain inside CAC and spend guardrails |
| 45 min | Batch creative from one weekly insight | Two videos, one carousel, and variants |
| 15 min | Schedule Instagram/TikTok | One week of approved content queued |
| 15 min | Review lifecycle and referral exceptions | Failed sends, attribution disputes, refund issues |
| 10 min | Write two high-value Reddit/community responses | Authentic community presence |

### Weekday check-in: up to 20 minutes

- Confirm spend cap and tracking health.
- Respond to genuine student or parent questions.
- Review only alerts: broken funnel, unusual refunds, negative comments, or a campaign at the hard CAC ceiling.
- Avoid making daily creative or targeting changes; small campaigns need time to accumulate signal.

## Final build-versus-buy decisions

| Component | Build | Buy/use | Recommendation now |
|---|---|---|---|
| Landing pages | Lovable/Vercel | — | Keep and iterate |
| Customer and attribution record | Supabase | — | Build; this is core data |
| Revenue and checkout | Existing Stripe integration | Stripe | Keep; use webhooks as source of truth |
| Analytics and experiments | Event contract and server joins | PostHog Free | Buy/use |
| Lifecycle email | Event triggers | Loops Free | Buy/use |
| Social scheduling | Content templates | Buffer Free | Buy/use |
| Creative | Cramapple examples and repeatable formats | Canva/CapCut Free | Hybrid |
| Cross-tool automation | Critical flows in Supabase | Make Free for convenience | Hybrid |
| Ad optimization | Guardrail definitions | Native platform automation | Buy/use native; no specialist SaaS |
| Student/parent referral | Supabase ledger and Stripe metadata | — | Build minimal version |
| Tutor affiliate portal | Manual reporting initially | Rewardful/Tolt/FirstPromoter later | Defer purchase |
| Consent | Consent state and tag gating | CMP chosen after legal review | Hybrid; do not improvise |
| Executive reporting | Supabase aggregate view | PostHog dashboard and email alert | Build thin layer |

## The first three decisions to make

1. Approve the activation-limited “free score check” instead of an unlimited public trial.
2. Approve PostHog + Supabase as the canonical acquisition measurement spine, with no replay on student learning pages.
3. Approve the channel sequence: Reddit paid first, Meta/Instagram second, TikTok organic until budget and conversion volume increase.

Once those are decided, the stack can be deployed without committing Cramapple to expensive tools or a high-maintenance marketing operation.

