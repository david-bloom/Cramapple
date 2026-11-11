# Parent-first brand and purchase plan

- **Status:** DRAFT PROPOSAL — strategy and requirements, not approval to change Production
- **Date:** 2026-11-11
- **Product Owner:** David Bloom
- **Area:** Marketing, acquisition, checkout, student activation
- **Tier for this document:** Standard (read-only strategy and documentation). Implementing payment, privacy, authentication, email, or Production changes is Hard-Gate work.

## 1. The shift

The parent is the primary **customer and payer**. The student is the primary **user and learner**. Marketing should help a parent decide whether Cramapple will make their child's study time more productive, then let that parent initiate access and payment for the student. The app should still speak directly to the student.

**Brand promise:** Give your student the tools and coaching to turn study time into points on class tests and, especially, the AP exam.

**Plain-language explanation:** Cramapple shows students what earns credit, lets them practice one unit at a time, explains missed points, and gives them a useful next step. It helps them use the time they have; it does not guarantee a score or replace a teacher or tutor.

The emotional job for the parent is to replace *“I hope they're studying the right things”* with *“I can see why this practice is worth their time.”* The functional job is to make buying access for the right student simple and trustworthy. Student agency remains important: the student chooses when and what to practice after access is set up.

### Current-state anchor

- The seven-day, one-subject **no-card trial** is live. A new student enters an emailed code at `/start`, chooses a subject, and gets seven days of access. The 72-hour sample is on hold; card-trial admission is off. Source: [no-card trial Production closeout](../handoffs/SESSION_CLOSE_2026_11_10_NO_CARD_TRIAL_LIVE_IN_PRODUCTION.md). The first real pay-now checkout after the card-trial switch was still unverified in that record; do not describe the checkout end-to-end as certified.
- Today's parent payment route is initiated by the student using **Ask a parent to pay** on `/checkout`. The parent receives a link and pays as a separate payer. The proposed parent-first route below is a new entry and orchestration path, not a claim that it already exists. Source: [purchase funnel spec](../product/PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md) and [checkout QA](../qa/CHECKOUT_FLOW_QA_2026_10_06.md).
- Live marketing review on 2026-11-11 covered the homepage, About, study-guide hub and subject landing pages, `/start`, pay-now checkout before email entry, Contact, Terms, and Privacy. It did not submit an email, create a parent link, or pay. The live page observations below must be rechecked before editing the Lovable marketing project.
- Before this proposal, the docs index had no parent-first brand-plan entry. This strategy document does not supersede payment, trial, privacy, or design decisions.

## 2. Positioning and messaging

| Audience | What they need to know | Message and action |
| --- | --- | --- |
| Parent, primary buyer | Will this help my child, what will they actually do, what does it cost, who gets access, and can I trust it? | “Help your AP student make study time count.” Show one question, feedback, next action, price, refund, and student handoff. Primary action: **Choose subjects for my student**. |
| Student, primary user | Can I understand this, improve, and stay in control of my work? | “See what earns the point. Practice. Fix what you missed.” Entry through the app, a parent invitation, or the existing student trial. |
| Tutor/teacher, influencer | Is the material aligned and is the feedback educationally sound? | Explain rubric alignment, content review, limitations, and how to flag an error. Do not imply College Board endorsement. |

### Messaging hierarchy

1. **Outcome:** Make study time count on unit tests and the AP exam.
2. **Mechanism:** Practice AP-style MCQs and FRQs; see exactly what earned or lost points; get the next step.
3. **Effort:** One unit at a time, in short sessions that fit a school week. “15 minutes a day” describes a suggested use pattern, not a proven guarantee.
4. **Proof:** A readable, real question → student response → rubric feedback → revised answer. Use verified content counts and dated subject coverage only.
5. **Commercial clarity:** Seven-day no-card trial is free and does not auto-charge. A later purchase is one-time at the displayed price; state the exact access term approved for sale.
6. **Trust:** Who built/reviews the material, what happens when grading is wrong, how student data is handled, how refunds work, and how to reach support.

**Voice:** Address the parent on marketing and checkout pages as “you” and the learner as “your student.” Address the learner as “you” inside the app. Be warm and specific; avoid fear about AP scores, guilt about parenting, guaranteed outcomes, or unsupported “AI tutor” claims. Keep the current Cramapple visual system; this is an audience and journey shift, not permission to invent a new identity. Source: [current architecture/design decisions](../product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md).

### Candidate copy to test

| Element | Candidate copy |
| --- | --- |
| Headline | Help your AP student turn study time into points. |
| Subhead | Cramapple gives them focused practice, clear feedback on every missed point, and a next step they can use on the next test and the AP exam. |
| Primary CTA | Choose subjects for my student |
| Secondary CTA | See how Cramapple works |
| Offer line | Start with one subject free for seven days. No card, no automatic charge. Buy access later if it helps. |

The copy is a proposal. Test comprehension and factual support before publication, especially “every missed point” and any implied breadth of class-test coverage.

## 3. Ten observations turned into a work plan

| # | Observation from the 2026-11-11 review | Parent-first response | Priority |
| --- | --- | --- | --- |
| 1 | Homepage and About speak almost entirely to the student. | Rewrite the hero, About, and main CTAs for a parent evaluating a purchase; keep student voice in the app. | P0 |
| 2 | “Know what earns the point” explains the mechanism more than the family's problem. | Connect point-by-point feedback to productive study time, confidence about what to practice next, and class-test/AP relevance. | P0 |
| 3 | The FRQ demo is concrete but makes a parent do the interpretive work. | Show a three-frame example: work submitted, point missed, improved response/next action. Explain grading review and error reporting. | P1 |
| 4 | About has little visible evidence of who built or checks the material. | Add named, verified team experience, review method, source dates, and correction process. Use only substantiated testimonials. | P1 |
| 5 | Parent pay is discoverable mainly as a FAQ answer and a student checkout action. | Create a visible parent route and a parent-initiated purchase flow; keep the current student routes. | P0 |
| 6 | Trial, purchase, and “full year” language are spread across pages. | Use one offer explanation everywhere: seven-day no-card trial; no automatic charge; optional pay-now purchase; exact approved access term and bundle rules. | P0 |
| 7 | Subject-to-checkout handoffs can lose the intended subject; AP Statistics linked to a Biology checkout in the live review. | Audit every CTA and preserve subject, offer, promo, and allowed attribution fields through the journey; repeat the selection on the next screen. | P0 |
| 8 | Some study-guide details are stale or inconsistent (for example the 2026 Biology date, Statistics navigation, and “Spring 207” on Physics). | Set a current-year and availability review for every subject page. Never invite a parent to buy or trial a subject described as unavailable. | P0 |
| 9 | The public Privacy page is marked draft, and student-content use is hard to judge quickly. | Complete privacy/counsel review and add a short parent-facing data explanation beside invitation and payment. | P0 before new parent data capture |
| 10 | The seven-day refund is buried in Terms; Contact gives no response expectation. | Surface the approved refund rule and a working support route near the price and receipt; state a realistic reply window. | P1 |

P0 means fix before broad parent-directed acquisition or a new parent checkout launch. The order within P0 is: accuracy and offer truth → working handoff → parent journey → campaign traffic.

## 4. Marketing site plan

### Homepage

- Lead with the parent promise and a phone-readable product proof block, not a generic stock image or an unqualified score claim.
- Show **Choose subjects for my student** as the primary action. Keep **Student? Start your free trial** visible but secondary.
- Explain the product in three steps: pick a subject and goal; practice with rubric-based feedback; use the next step on the next study session.
- Give an honest offer summary near the first CTA and a compact pricing/FAQ section lower on the page.
- Show a parent-facing example of what the student sees. Do not promise a parent dashboard or access to private answers unless that feature is built and approved.

### Subject and study-guide pages

- Keep educational articles useful to students and search visitors, then add a clearly marked **For parents** decision module with subject coverage, a real example, trial/buy choices, and the exact next-screen destination.
- Review every page against the current exam year and current Cramapple availability. Label “available now” and “coming soon” accurately.
- Preserve the subject and campaign context into the parent flow. Do not send a Statistics parent to Biology or a trial CTA to a pay-now first screen.

### Trust and support pages

- Expand About with verifiable team and quality-process details; describe limits and correction pathways candidly.
- Make refund, support, privacy, and student-data summaries easy to find from the offer and checkout. Keep full legal text linked, with counsel-approved language.
- Build a concise parent FAQ: what the student gets, what happens after seven days, how access is activated, whether a parent account is required, what the purchase covers, refund timing, and what information a parent can see.

### Acquisition and campaign implications

- Build parent-intent creative around a recognizable moment: a student spends time studying but cannot tell which answers earn credit. Show the actual feedback and next action, then invite the parent to choose a subject for their student.
- Test parent-oriented search and social landing pages separately from student-oriented acquisition. A parent ad must land on a parent page; a subject ad must retain the subject and any stated offer. Do not send a “free trial” click to a pay-now first screen.
- Give tutors and teachers an evidence page they can share with families, centered on the method and its limits, without implying endorsement.
- Carry approved attribution fields through the marketing-to-app and marketing-to-checkout handoffs. Report parent-initiated, student-direct, and student-to-parent paths separately so a channel is judged on verified purchase **and** student activation, not clicks alone.
- Interview parents before scaling spend. The [October 31 conversion review](../handoffs/CONVERSION_REVIEW_HOME_AND_SUBJECT_LANDING_PAGES_2026_10_31.md) found paid traffic reaching landing pages but little checkout engagement; its trial-era funnel figures are historical after the November no-card launch.

## 5. Proposed parent-initiated purchase flow

**Design principle:** The parent starts and controls the commercial transaction. The student owns the learning account and work. Parent payment does not make the parent the learner or grant access to the student's private responses.

```text
Parent landing / subject page
  → Choose subject(s) for my student
  → Identify student (email) and payer (parent email)
  → Review subject(s), exact one-time price, access term, refund, and who gets access
  → Pay with parent method (Stripe-hosted or approved wallet/card flow)
  → Verified payment → student entitlement and student invitation
  → Parent receipt/status; student code sign-in and first practice
```

### Screen-by-screen contract

| Step | Parent sees and does | Student/system result |
| --- | --- | --- |
| 1. Choose | Select one to three supported subjects. Subject-specific links arrive preselected. Show current availability and the server-authoritative bundle price. | No student account or Stripe session is created merely by browsing subjects. |
| 2. Recipient | Enter the student's email and the parent's email separately. Explain: “Your student uses this email to sign in. Your receipt and payment updates go to you.” If the student already has an account, preserve that identity. | Do not expose whether a student account exists before an appropriately protected step. Validate and rate-limit recipient entry. Handle duplicate/pending orders without granting twice. |
| 3. Review | Show subject names, exact total today, approved access duration, whether any promotion applies, refund terms, and a clear statement that the parent is buying for the student. Require the payer's applicable consent at the final action. | The server re-quotes the catalog and applies the correct promo. The student must acknowledge applicable Terms at activation/sign-in. |
| 4. Pay | Offer the payment methods actually available on that device, with card fallback. Stripe presents the parent as payer. Do not require a Cramapple parent account to pay. | The payer's payment method must not be mapped to the student for later charges. A redirect alone never grants access. |
| 5. Confirm | Show **Payment received / setting up access** until the verified webhook grants the entitlement; then show **Your student can sign in**. Send the parent a receipt and the student an invitation or access notice. | Webhook processing is idempotent. If payment succeeds but provisioning is delayed, give a durable pending state, support path, and reconciliation rather than asking for another payment. |
| 6. Activate | Parent sees what happens next and can resend the student invitation within abuse limits. | Student verifies the intended email with a code, accepts applicable terms, sees the purchased subjects, and starts a first focused practice session. Their saved work is retained if they already used the trial. |

### Trial branch within the same parent journey

The current free trial starts with the **student's own email/code** and one chosen subject; it is not presently a parent-created account. For a parent-led trial entry, first offer **Send my student a free-trial invitation** (no payment and no card). The student still verifies their email and starts the trial. The parent can later buy access from a parent-facing link or page that carries the chosen subject but verifies the student's identity safely. Do not silently create a trial for an unverified student email, consume that email's one trial, or promise that a parent can see learning data.

After the seven days, access pauses and nothing is charged automatically. A parent may buy the same subject for that student; the student returns to the same account and saved work. If the parent chooses to buy immediately, use the pay-now path above and avoid presenting a trial as a required step.

### Existing alternatives remain

- **Student direct purchase:** student chooses subjects and pays themself. Keep it functional and clearly labeled.
- **Ask a parent to pay:** student starts checkout and sends the existing parent link. Keep this for a student who discovers Cramapple first.
- **Parent initiated purchase:** new primary marketing route. It must work even if the student has never visited Cramapple.

The three paths must resolve to one student entitlement model and one truthful price/offer contract. Parent-initiated purchase should not be implemented by simulating a signed-in student or reusing a student session.

## 6. Implementation requirements and gates

1. **Product decision:** Confirm the exact paid access term and bundle rules, the primary parent CTA, whether a parent may invite a trial, and whether any parent account/status page is in scope. Do not invent “full year” or perpetual access in copy.
2. **Technical design:** Extend the existing parent payer/learner separation and server-authoritative pricing; define a parent-created order and recipient validation. Reuse verified webhook, entitlement, refund, and reconciliation contracts where they fit. Review the [purchase funnel spec](../product/PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md) against the current pay-now backend before implementation.
3. **Privacy and counsel:** Review parent/student email collection, age/consent handling, invitation copy, Terms acknowledgment, retention, parent access boundaries, and the public Privacy page. No new parent progress visibility by implication.
4. **Email and support:** Verify invitation, receipt, payment-status, refund, and resend behavior in the test environment and real inboxes. A parent must know whether their student actually has access.
5. **QA:** Cover new student, existing student, trial-to-paid, expired trial, duplicate email/order, wrong recipient, invalid email, promo, 1/2/3 subjects, mobile wallet/card, delayed webhook, failed payment, refund, and returning on another device. Test the parent and student on separate devices. A real Production payment and publish require their own approval and record.
6. **Content QA:** Verify every public claim, subject availability, dated exam fact, CTA destination, price, refund statement, and support link before campaign launch.

## 7. Measurement and research

At low traffic, report **counts first** and rates second. Do not interpret a few purchases as proof of a message winner. Keep PostHog coarse; do not send names, emails, answers, grades, or rubric details into growth analytics. Source: [UX monitoring and research v1](UX_MONITORING_AND_USER_RESEARCH_V1.md).

Track the parent journey as distinct coarse states: parent landing → subject chosen → parent checkout viewed → checkout started → verified purchase → student invitation delivered → student activated → first graded response → later return. Keep student direct and ask-parent paths as separate entry labels, while Stripe/Supabase remain the authority for purchase and access. Reconcile event names with the current attribution plan before adding events; the no-card trial closeout says trial-to-purchase measurement is still open.

Research questions for 5–8 parents of AP students, using a phone prototype and one real product example:

1. What do you think Cramapple will help your student do this week?
2. What evidence would make you trust its feedback enough to pay?
3. Can you tell what happens after seven days and who is charged?
4. Can you buy for your student without accidentally creating an account for yourself?
5. After payment, can you tell whether your student has access and what they should do next?

Use comprehension and task success as launch criteria: parents can explain the offer and access term without help; parents can complete the intended recipient/payment path; students can activate and reach a first graded response. Record failures verbatim and repair the interface before spending to drive more traffic.

## 8. Rollout sequence

| Phase | Deliverable | Exit evidence |
| --- | --- | --- |
| A. Trust and truth | Fix stale/incorrect pages, broken subject handoffs, offer language, privacy status, and visible refund/support summary. | Page-by-page link/copy audit on mobile and desktop; approved legal text; current prices/availability match the server. |
| B. Parent message | Parent-led homepage, subject decision modules, proof walkthrough, About/FAQ. | Parent comprehension interviews; verified claim inventory; no hidden or unsupported feature promise. |
| C. Parent purchase | Parent-created order, payer/learner separation, confirmation and student activation. | Test-environment end-to-end matrix and independent QA, including separate parent/student devices and payment failure recovery. |
| D. Controlled release | Reviewable Lovable changes, backend release, transactional email checks, then a small parent traffic cohort. | Required Product Owner approvals, monitored Production checkout and entitlement, support readiness, rollback plan. |
| E. Learn | Compare parent-led and existing paths on verified purchases, activation, first graded response, and support issues. | Counts and qualitative findings; choose the next iteration from evidence. |

## 9. Decisions requested from David before implementation

1. Is **“Choose subjects for my student”** the primary homepage action, with the student trial as secondary?
2. Should a parent be able to send a no-card trial invitation, or should the first parent-led release be pay-now only?
3. What exact paid access term and bundle promise should be displayed at every purchase point?
4. Is a parent purchase-status page needed, or are receipt and invitation/status emails sufficient for the first release?
5. Who approves the parent-facing privacy, age/consent, and student-data explanation before publication?

These are proposed product decisions. This document authorizes no live checkout, pricing, legal-text, analytics, or email change.
