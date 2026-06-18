# Cramapple Vision and Problem Statement

**Canonical reference draft | June 9, 2026 | v0.3**

## Document Status

This document is a working canonical reference for Cramapple. It records the current business and product direction for review. It is not a finished business plan, technical specification, curriculum guide, or go-to-market plan.

Statements labeled **Decision** reflect the current direction. Statements labeled **Hypothesis** require testing. Items labeled **Open** remain unresolved.

This document and the project's GitHub operating records are the durable source of truth. Earlier `Blueprint_*` documents are retained as speculative inputs and do not override approved decisions recorded here or in the project logs.

## 1. Strategic Thesis

Cramapple is a score-optimization system for Advanced Placement (AP) exams. It helps students use limited study time to earn more exam points through guided topic selection, efficient instruction, targeted practice, and criterion-level feedback.

The initial product is built for AP Biology. The design center is a student with approximately ten days before the exam who is ready to buckle down but does not know how to allocate the remaining time. Some students may use Cramapple during the school year, but the urgent cram window determines the product's priorities.

**Decision:** Cramapple will optimize for points gained per hour of remaining study time, not comprehensive subject mastery.

**Hypothesis:** "Maximize your time and your score" is the clearest expression of the customer promise. This language must be tested with students and parents.

## 2. The Problem

### 2.1 Students Do Not Know What to Study Next

AP students face a finite exam, a large curriculum, and limited time. Near the exam, the practical question is not "How do I learn all of biology?" It is "What should I do next to improve my score?"

Students commonly:

- Re-read familiar material because it feels productive.
- Spend too long on low-value details.
- Avoid topics they find difficult without understanding their score impact.
- Misjudge what they know and what they can explain under exam conditions.
- Practice without receiving feedback tied to individual rubric points.
- Lose points because an answer is vague, incomplete, unsupported, or fails to explain a mechanism.

### 2.2 Existing Alternatives Are Poorly Optimized for the Cram Window

General AI tools can explain concepts but may fabricate facts, grade inconsistently, or provide answers without reliable alignment to the current exam. Review books and videos provide content but do not continuously decide what the individual student should do next. Human tutors can provide high-quality guidance but are expensive, difficult to schedule, and inconsistent in their familiarity with current scoring expectations.

Most alternatives optimize for content coverage, access to explanations, or tutoring. Cramapple will optimize for the student's next available exam point.

### 2.3 The Hardest Feedback Is Often the Most Valuable

AP Biology includes substantial free-response work. Students need to know not only whether an answer is generally correct, but which scoring criteria it satisfies, which it misses, and what minimum change would earn the next point.

Automated free-response grading is difficult. It is also central to the value of Cramapple and therefore belongs in the minimum viable product (MVP).

## 3. Target Customer and Buyer

### 3.1 Primary User and Buyer

The primary user and expected primary buyer is an AP student who:

- Wants to move from a likely 3 to a 4, or from a likely 4 to a 5.
- Has limited time and wants efficient, direct guidance.
- Is willing to practice actively rather than only consume summaries.
- Wants help understanding what earns points on the exam.

The product must also support students who purchase earlier in the school year, without allowing that broader use case to dilute the cram-first experience.

### 3.2 Secondary Buyer

A parent may purchase Cramapple for a student. Parents need a distinct value proposition centered on purposeful preparation, visible progress, and reduced conflict over studying.

A parent portal is not part of the initial MVP. If developed, it should be a motivational and progress tool, not a surveillance tool. It may show activity, topics covered, performance, and recommended next actions while protecting the student's conversational privacy. Access, notification, consent, age gating, and data policy require legal and product review before implementation.

## 4. The Solution

### 4.1 What Cramapple Is

Cramapple is a self-service study system that works with the student to identify the highest-value use of available study time.

It allows the student to:

- Choose any AP Biology module or subtopic.
- Identify areas of uncertainty.
- Take an optional quick diagnostic.
- Learn a topic efficiently.
- Practice with multiple-choice, quantitative, data-analysis, and free-response questions.
- Submit an answer and receive criterion-level grading.
- Bring a question from school, homework, a study guide, or another source.
- Review a record of activity, performance, errors, and recommended next actions.

Cramapple respects student choice but actively guides it. A student may roam freely, while Cramapple can recommend a higher-value prerequisite, cross-cutting skill, or weakness before the selected topic.

### 4.2 What Cramapple Is Not

Cramapple is not:

- A complete AP Biology course.
- A replacement for a teacher.
- A general-purpose chatbot.
- A homework answer generator.
- A guarantee of a particular AP score.
- An official College Board product or scoring service.
- A live tutoring marketplace in the MVP.

## 5. The Core Product Experience

### 5.1 Joint Guidance

Cramapple and the student continuously decide together where the student's remaining study time can earn the most additional exam points.

At the beginning of a session, Cramapple should understand:

- The student's available time.
- The module or topic the student wants to address.
- The student's confidence or uncertainty.
- Whether the student wants instruction, practice, answer review, or a combination.
- Relevant evidence from prior activity.

The student remains in control. Cramapple explains its recommendation instead of silently redirecting the student.

Example:

> You can work on cell communication. Before you start, consider a five-minute check on experimental design. Your recent answers show that interpreting controls is costing you points across several modules.

### 5.2 Optional Calibration

A full diagnostic is optional. When useful, Cramapple offers a short calibration check of approximately three to five questions. It combines self-reported uncertainty with observed performance.

The system should be able to identify both:

- A student who lacks confidence but performs well.
- A student who feels confident but cannot yet earn the relevant rubric points.

### 5.3 Session Length

Cramapple should fit the time the student actually has. Initial session modes to test are:

- **Quick:** approximately 15 minutes.
- **Focused:** approximately 30 minutes.
- **Buckle Down:** approximately 60 minutes.

These are product hypotheses, not fixed pedagogical prescriptions. The appropriate time commitment and session structure must be learned through student use.

### 5.4 Activity Record and Next Best Action

Each session should update a private student record containing:

- Modules and subtopics covered.
- Instruction completed.
- Questions attempted.
- Rubric points earned and available.
- Error types and recurring misconceptions.
- Confidence where collected.
- Time spent.
- Recommended next action and the reason for it.

The record exists to improve guidance, show progress, and help the student resume quickly. It should not become a vanity dashboard dominated by streaks or activity for its own sake.

## 6. Teaching and Scoring Model

### 6.1 Point-Level Teaching

Cramapple teaches students how exam responses earn or lose individual points. Feedback should distinguish between knowing the underlying biology and expressing it with the specificity, evidence, calculation, or mechanism the question requires.

Cramapple should not claim that one answer is literally an AP score of 3, 4, or 5. A single response does not determine a final AP score. Instead, response-level feedback may explain:

- The rubric points earned.
- The exact criteria missed.
- The minimum fix needed to earn the next point.
- A stronger response consistent with a student targeting a higher overall score.
- A complete, realistic top-level response.

Cramapple may provide an estimated AP score range or readiness estimate when it has sufficient evidence across relevant content, skills, and question formats. The estimate should:

- Identify the evidence and assumptions supporting it.
- State its confidence and important coverage gaps.
- Be labeled as a Cramapple estimate, not an official College Board score or guarantee.
- Explain the specific knowledge, skills, rubric criteria, or practice results most likely to move the student toward the next score range.
- Be recalibrated as new student evidence and expert-scored validation data become available.

Any "estimated 3," "targeting a 4," or "targeting a 5" language is Cramapple guidance. The product should prefer ranges and qualified language when the evidence does not support a precise estimate.

### 6.2 Free-Response Grading

For every graded free response, Cramapple should return:

1. The score as points earned out of points available.
2. The criteria satisfied.
3. The criteria not satisfied.
4. Evidence from the student's response supporting each judgment.
5. The smallest improvement likely to earn the next point.
6. A concise improved answer.
7. A complete high-quality answer.
8. An error classification.
9. A recommended next action.

Likely error classifications include:

- Missing knowledge.
- Incorrect mechanism.
- Insufficient specificity.
- Unsupported claim or missing evidence.
- Misread question.
- Data interpretation error.
- Formula setup error.
- Arithmetic or unit error.
- Contradiction within the response.

### 6.3 Learning Principles

The initial pedagogy will emphasize:

- Retrieval and active practice over re-reading.
- Immediate, criterion-level feedback.
- Short instruction connected directly to an exam task.
- Worked examples for quantitative and procedural skills.
- Interleaving after foundational weaknesses are identified.
- Error logging and targeted remediation.
- Transfer to unfamiliar scenarios, graphs, experiments, and models.
- Student agency combined with explicit recommendations.

These principles require expert review and user testing. They should not be treated as sufficient merely because they sound educationally plausible.

## 7. Student-Provided Questions

Students frequently arrive with a specific question from class, homework, a review packet, or an online discussion. Cramapple must allow students to type, paste, photograph, or upload that question and request one of four modes:

- Teach me.
- Give me a hint.
- Check my work.
- Show me the solution.

### 7.1 Canonical Comparison

Cramapple compares the submitted question with the approved canonical set of concepts, skills, question archetypes, solving methods, and scoring patterns.

Matching should be semantic and structural, not merely textual. A question with different values, organisms, or surface details may still match an approved archetype if it tests the same concepts through the same reasoning structure.

### 7.2 Confidence Behavior

When classification confidence is high, Cramapple identifies the topic and proceeds using the approved solving method.

When confidence is moderate, it asks for confirmation:

> This appears to be a Unit 3 cellular energetics question about how a proton gradient drives ATP production. Does that seem right?

When confidence is low or required context is missing, Cramapple asks for the diagram, preceding text, answer choices, or another clarification. It should not invent missing information.

Student confirmation clarifies context but does not make the question authoritative.

### 7.3 Isolation and Ownership

A student-provided question:

- May be answered using approved canonical knowledge and methods.
- May inform the student's private activity and error record.
- Does not enter the canonical content library automatically.
- Does not become approved, accurate, reusable, or owned by Cramapple merely because it was uploaded.

Similarity increases confidence in the solving method. It does not prove that the submitted question is correct, complete, appropriate for AP Biology, or legally reusable.

## 8. Content Integrity and Trust Model

Cramapple's value depends on accurate content, defensible grading, and visible limits. A prompt instructing an AI not to hallucinate is not a trust architecture.

### 8.1 Canonical Content System

The canonical system should include:

- The AP Biology module and subtopic taxonomy.
- Approved factual and explanatory source material.
- Exam skills and public weighting information.
- Cramapple-authored question archetypes and practice questions.
- Structured scoring criteria.
- Acceptable concepts and answer variants.
- Common misconceptions and insufficient-answer patterns.
- Contradictions that invalidate a point.
- Formula, unit, calculation, graph, and diagram rules.
- Expert-approved sample responses.
- Source, version, reviewer, and approval records.

### 8.2 Question and Rubric Packages

The AI should not be asked to grade a free response through an unconstrained general instruction. Each approved question requires a structured package containing:

- Question text and assets.
- Module, subtopic, and skill.
- Question type and expected reasoning path.
- Points available.
- Independent criterion for each point.
- Acceptable evidence and equivalent language.
- Insufficient and contradictory response patterns.
- Approved examples at multiple quality levels.
- Source citations.
- Version and approval status.

The system evaluates criteria independently, checks for contradictions, and reports uncertainty.

### 8.3 Human Validation

David Bloom, co-founder, Chief Executive Officer, and Product Owner, has final responsibility for product quality and release decisions. Orly Bloom, co-founder and Vice President of Learning, leads curriculum quality, content, teaching, and expert validation.

Paid tutors and subject experts will create Cramapple's original question packages. Separate qualified reviewers will validate scientific accuracy, teaching quality, exam alignment, and grading behavior. Authors do not approve their own work. Expert sign-off is a launch gate. If the responsible experts do not approve the content and grading behavior, the product does not launch.

The initial bank will use all 60 official public AP Biology topics. Each topic
targets at least ten approved MCQs and five approved short-FRQ prompts. Each
unit additionally targets four long-FRQ stimulus packages with two
independently deliverable prompts per package. One MCQ or one delivered FRQ
prompt counts as one inventory item. Cramapple may use AI to create candidate
versions from questions it owns or fully licenses for derivative and model use.
Each variant is a new artifact and requires a complete rubric, teaching
package, provenance, and independent validation.

Approval of content alone is insufficient. Before launch, Cramapple should test AI grading against responses independently scored by experts and establish an acceptable level of criterion-by-criterion agreement.

### 8.4 Source and Intellectual Property Boundaries

Cramapple will align its original content to the publicly available AP Biology course framework, exam structure, and skills. Cramapple will pay qualified tutors and subject experts to independently author original questions and complete rubric packages from approved coverage briefs.

Official College Board questions and scoring materials will not be used as question seeds, adaptation targets, few-shot examples, or generative-AI inputs, and will not be reproduced commercially without written permission or legal approval. Authorized humans may review public materials for abstract exam alignment where legally permitted, but commissioned work must be independently expressed and supported by approved sources.

Cramapple should create independently authored questions and scoring criteria, validated by experts familiar with AP expectations. Legal review is required before launch regarding copyright, trademarks, product claims, student uploads, and use of official materials.

## 9. MVP Scope: AP Biology

### 9.1 Included

The AP Biology MVP includes:

- Eight modules and their approved subtopics.
- Guided roaming across the curriculum.
- Optional quick calibration.
- Efficient topic instruction.
- Original practice questions in relevant exam formats.
- Automated criterion-level free-response grading.
- Multiple-choice and quantitative feedback.
- Student-provided text and image questions.
- Semantic and structural matching to canonical question archetypes.
- A student activity and performance record.
- A recommendation for the next best action.
- Clear uncertainty and escalation behavior.

### 9.2 Excluded or Deferred

The MVP does not require:

- Additional AP subjects.
- A parent portal.
- Parent-funded incentives.
- Live tutoring.
- A fixed ten-day curriculum for every student.
- An official AP score prediction.
- Guaranteed score improvement.
- Broad social, classroom, or teacher-management features.

## 10. Extensible Product Architecture

AP Biology is the sole launch subject. Natural sciences are the intended expansion category because the group is commercially coherent and easy to communicate, even though the exams are not structurally identical.

The architecture should follow:

> One Cramapple engine, multiple exam packs.

### 10.1 Shared Engine

The shared platform should provide:

- Guided roaming and next-action recommendations.
- Source-grounded instruction.
- Question delivery and answer capture.
- Criterion-level scoring.
- Student-question intake and classification.
- Activity, proficiency, and error records.
- Content versioning, approval, and audit trails.
- Confidence handling and quality monitoring.

### 10.2 Exam Pack

Each subject requires its own:

- Curriculum taxonomy.
- Approved source library.
- Exam blueprint and weighting.
- Question formats and archetypes.
- Rubric schemas.
- Formula and calculation rules.
- Graph, diagram, notation, and unit conventions.
- Common misconceptions.
- Expert validation.

Adding a subject should primarily require a new exam pack. Some subjects may also require reusable platform extensions, such as chemical notation, symbolic mathematics, vector diagrams, or specialized graph grading.

The Biology MVP should not be burdened with speculative abstractions for every future science. Shared capabilities should be generalized when Biology proves the need, while data structures and ownership boundaries should avoid hard-coding Biology-specific assumptions into the core engine.

## 11. Market Position

### 11.1 Category

Cramapple will initially position itself as score optimization rather than AI tutoring.

Tutoring is crowded and broad. Score optimization is narrower, more urgent, and more closely aligned with the cram-window job:

> Help me decide what to study, teach me what matters, show me how points are awarded, and tell me what to do next.

### 11.2 Differentiation

Cramapple aims to differentiate through:

- A points-per-hour orientation.
- Guided student choice rather than a rigid course.
- Criterion-level free-response feedback.
- The "minimum fix for the next point."
- A validated, versioned canonical content system.
- The ability to teach from student-provided questions.
- Continuous recommendations based on actual performance.

The defensible product is not the chat interface. It is the combination of the canonical content system, question archetypes, structured scoring packages, validated grading behavior, student error model, and next-action logic.

## 12. Business Model and Go-to-Market

### 12.1 Pricing Hypothesis

Cramapple will be sold as a one-time service rather than a recurring subscription.

Initial pricing hypotheses are:

- One subject: $39.99.
- Two subjects: $69.99.
- Three subjects: $89.99.
- Unlimited subjects: $99.00.

Only the single-subject offer is relevant to the Biology-only launch. Bundles should not be sold until additional subjects meet the same quality standard. Pricing, discount depth, duration of access, refunds, and any parent add-on remain open to testing.

### 12.2 Launch Sequence

The current launch sequence is:

- **August 2026:** AP Biology beta intended to test onboarding, instruction, grading, guidance, and school-year use.
- **Fall 2026:** Improve the canonical content system, collect qualitative evidence and social proof, and measure learning behavior.
- **Winter 2026-2027:** Paid early access and operational refinement.
- **Spring 2027:** Primary commercial push for the AP Biology exam season.

August is a learning launch, not proof that Cramapple has already found product-market fit.

### 12.3 Evidence

Cramapple is unlikely to have credible first-year proof of causal improvement in final AP scores. Social proof can support marketing, but it is not sufficient evidence of product quality.

The first year should measure:

- Pre- and post-practice performance.
- Rubric points earned over time.
- Expert-AI grading agreement.
- Estimated-score calibration against expert-scored student work and later observed outcomes when available.
- Accuracy by module, skill, and question type.
- Error recurrence and remediation.
- Retention after a delay.
- Student completion and return behavior.
- Recommendation acceptance and resulting performance.
- Content disputes and confirmed errors.
- Student and parent-reported value.

## 13. Team and Operating Model

### 13.1 Founding Team

- **David Bloom, co-founder, Chief Executive Officer, and Product Owner:** Overall product direction, scope, priorities, business responsibility, and final accountability for quality and launch decisions.
- **Orly Bloom, co-founder and Vice President of Learning:** Curriculum quality, content, teaching design, and expert validation.
- **Micah Bloom, co-founder and Vice President of Marketing and Go-to-Market:** User acquisition, positioning, brand, and commercialization.
- **Naama Bloom, advisor:** Brand, marketing, entrepreneurship, and strategic counsel.
- **Strategy Advisor:** Works with David and the co-founders to develop plans, challenge assumptions, evaluate alternatives, and support business decisions. This is an advisory role and does not independently approve product scope, execution, risk, or launch.

Founder time commitments remain open. The operating plan must be realistic about school, family, and other obligations. The CEO expects to cover unowned work, but the business should define explicit owners and launch gates rather than rely indefinitely on informal slack.

### 13.2 Expert Operating Model

Cramapple will pay qualified tutors and subject experts to create original question packages and will use separate qualified experts to validate them. Detailed workflows must define:

- Who may draft content.
- Who reviews scientific accuracy.
- Who reviews exam alignment.
- Who validates rubric scoring.
- What constitutes approval.
- How disagreements are resolved.
- How content is versioned, updated, or retired.
- How authors are compensated and assign or license commissioned work.
- How originality, source disclosure, restricted-material exclusion, and author-validator independence are enforced.

## 14. Major Risks

The principal risks are:

- **Grading validity:** Automated feedback may sound persuasive while awarding criteria incorrectly.
- **Hallucination and drift:** The model may depart from approved content or scoring logic.
- **Copyright and trademark:** Official or student-provided materials may be used beyond permitted boundaries.
- **False precision:** Estimated score or readiness language may imply more certainty than the evidence supports. Estimates require transparent evidence thresholds, confidence language, calibration, and prominent non-official labeling.
- **Content scale:** Expert validation may become the bottleneck for coverage and expansion.
- **Seasonality:** Demand is concentrated around AP exam dates.
- **Weak urgency in fall:** The school-year study-aid customer may behave differently from the target crammer.
- **Student trust:** Excessive redirection, generic explanations, or incorrect grading could destroy credibility quickly.
- **Economics:** AI, image processing, expert review, support, refunds, and acquisition costs may not fit a low one-time price.
- **Minor privacy:** Student records, uploaded work, parent purchasing, and any future parent access require careful policy and legal review.

## 15. Immediate Workstreams

The vision should be supported by four separate canonical reference documents:

1. **Learning and Curriculum System:** Pedagogy, module taxonomy, question design, rubric packages, expert review, and efficacy measurement.
2. **Technical Architecture:** Canonical content storage, retrieval, grading pipeline, confidence system, activity model, privacy, and low-code implementation.
3. **Marketing and Go-to-Market:** Student and parent value propositions, brand, acquisition channels, launch calendar, messaging tests, and social proof.
4. **Economics and Operating Plan:** Pricing, cost model, staffing, expert workflow, launch budget, metrics, and subject expansion gates.

## 16. Open Questions and Decisions Pending

- Final customer-facing positioning and tagline.
- Whether students select a target score.
- What evidence thresholds, confidence language, and calibration standards Cramapple requires before showing an estimated score range.
- The appropriate number, length, and composition of sessions.
- The precise recommendation algorithm for "next best action."
- The minimum expert-AI scoring agreement required for launch.
- The size and coverage required of the canonical question bank.
- Handling of low-confidence or disputed grades.
- Duration of access under a one-time purchase.
- Final Biology pricing and refund policy.
- The role and timing of a parent product.
- Legal boundaries for official questions, scoring materials, student uploads, trademarks, and claims.
- Which natural science follows Biology and what capability gates expansion.

## 17. Vision

Cramapple's immediate goal is to become the most trusted way for an AP Biology student with limited time to decide what to study, understand what matters, practice under exam-like conditions, and learn exactly how to earn the next point.

The longer-term vision is to become the score-optimization system for AP natural sciences: one trusted engine that helps students make better use of scarce study time across Biology, Environmental Science, Chemistry, and Physics through subject-specific, expert-approved exam packs.

Cramapple succeeds when the student closes a session knowing more than the answer to the last question. The student should understand what the question tested, why points were earned or lost, and what action is most likely to improve performance next.

## Reference Sources

- College Board, AP Biology Exam: https://apcentral.collegeboard.org/courses/ap-biology/exam
- College Board, AP Biology Course and Exam Description: https://apcentral.collegeboard.org/courses/ap-biology/course
- College Board, Score Setting and Scoring: https://apcentral.collegeboard.org/courses/how-ap-develops-courses-and-exams/score-setting-and-scoring
- College Board, Copyright and Trademark Guidelines: https://privacy.collegeboard.org/copyright-trademark/guidelines
- Federal Trade Commission, COPPA Frequently Asked Questions: https://www.ftc.gov/business-guidance/resources/complying-coppa-frequently-asked-questions
