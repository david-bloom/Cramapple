# Cramapple Learning and Curriculum System

**Canonical planning draft | June 10, 2026 | v0.6**

## Document Status

This is a working canonical reference for Cramapple's teaching and curriculum methodology. It defines the unified learning-state model, question-archetype adaptations, intervention modes, escalation behavior, calibration moves against known AI-grading failure modes, and the research and source authorities that ground each design decision.

This document covers the complete normal learning path and establishes the boundary with the companion `LEARNING_SYSTEM_STUCK.md` document. The companion specifies the detailed Sideways, Apart, Down, Move On, and Park behavior used when ordinary intervention is not producing progress. Stuck behavior is an escalation level inside the unified per-skill learning state machine, not a separate mutually exclusive system.

Statements labeled Decision reflect the current direction. Statements labeled Hypothesis require testing. Items labeled Open remain unresolved.

This document operates under `TEACHING_AND_PEDAGOGY_DESIGN.md`, which holds the governing pedagogical contract and research framing. Where the documents overlap, `TEACHING_AND_PEDAGOGY_DESIGN.md` governs principles and evidence claims; this document governs the operational learning loop.

*Changelog. v0.6 (June 2026) adopts the unified learning-state model; separates cold, coached, and exam orientation; adds discriminating probes and evidence-weighted escalation; makes post-help success provisional until independent confirmation; adds schedule-aware Move On and Park behavior; tracks intervention effectiveness by skill and task type; corrects AP Biology exam facts; and clarifies that anonymous student responses are used to improve Cramapple. v0.5 added the Subject Waitlist mechanism. v0.4 added Student-Supplied Questions and Landing Pages. v0.3 reframed integrity signals as coaching. v0.2 added calibration moves and academic AI grading sources.*

## Purpose

Cramapple needs one consistent teaching methodology that applies across every question, every session, every student. The methodology must be:

- Research-grounded — every teaching activity should be traceable to either established cognitive science, College Board guidance, or documented AP teacher practice.

- Deterministic in shape — the student should recognize the structure of any interaction within two sessions, because that structure is itself a metacognitive skill we are transferring.

- Adaptive in content — the methodology applies to MCQ, quantitative, data-analysis, and FRQ archetypes; what changes is the content within each step, not the steps themselves.

- Articulable — Orly, advisors, hired experts, and tutors should be able to read this document and understand exactly what Cramapple teaches, how, and why.

Cramapple does not need to explain the methodology to students. The methodology is the architecture beneath the experience. Students see a clean, predictable loop. The research and source structure lives in this document.

## 1. Teaching Premise

Cramapple optimizes for points gained per hour of remaining study time. The teaching system is built on a single premise:

*The most reliable way to earn the next AP exam point is to teach the student what that point is testing, have them attempt it, score the attempt against the actual rubric criteria, and repair the specific gap that lost the point.*

This is the structural commitment underlying every design decision in this document. The methodology is not a curriculum in the traditional sense. It is a unified learning-state model that preserves the sequence from attempt through diagnosis, teaching, independent transfer, and scheduled confirmation while adapting support to the evidence.

## 2. Source Authorities

Cramapple's teaching methodology draws on four distinct bodies of authoritative work. Each contributes specific design decisions to the system. This section names what each authority provides and where it does not.

### 2.1 The College Board

The College Board is the official authority on what the AP exam tests, how it is scored, and how skilled AP teachers are trained to teach toward it. Cramapple adopts the College Board's public taxonomies directly rather than inventing parallel ones.

The publicly available authorities include the AP Biology Course and Exam Description (CED), which contains a Course Framework, an Instructional Section, and sample exam questions; released free-response questions with scoring guidelines and annotated sample student responses; and the Course-at-a-Glance, which specifies skill spiraling and pacing.

The most operationally important elements Cramapple adopts from the CED are the Six Science Practices with their multiple-choice-section weight ranges and the FRQ archetype definitions with their per-question focus areas. Cramapple uses these taxonomies in content classification, teaching, and recommendation logic without presenting them as the answer to a cold diagnostic item.

**The Six Science Practices (AP Biology, 2025-26 CED):**

| # | Science Practice | Official MCQ-Section Weight Range |
| --- | --- | --- |
| 1 | Concept Explanation — explain biological concepts, processes, and models | 25–33% |
| 2 | Visual Representations — analyze visual representations of biological concepts | 16–24% |
| 3 | Questions and Methods — determine scientific questions and methods | 8–14% |
| 4 | Representing and Describing Data | 8–14% |
| 5 | Statistical Tests and Data Analysis | 8–14% |
| 6 | Argumentation — develop and justify scientific arguments using evidence | 20–26% |

Concept Explanation (Practice 1) and Argumentation (Practice 6) together account for 45–59% of the multiple-choice-section science-practice weighting. They do not account for that share of the entire exam. Cramapple uses the ranges as prioritization inputs rather than fixed item quotas.

**The FRQ Archetypes (AP Biology):**

| FRQ | Official Focus Area | Official Points | Official Per-Question Time |
| --- | --- | --- | --- |
| 1 | Interpret and Evaluate Experimental Results (long) | 9 | Not prescribed |
| 2 | Interpret and Evaluate Experimental Results with Graphing (long) | 9 | Not prescribed |
| 3 | Scientific Investigation (short) | 4 | Not prescribed |
| 4 | Conceptual Analysis (short) | 4 | Not prescribed |
| 5 | Analyze Model or Visual Representation (short) | 4 | Not prescribed |
| 6 | Analyze Data (short) | 4 | Not prescribed |

The College Board provides 90 minutes for the six-question free-response section but does not prescribe a time budget for each question. Cramapple may recommend practice pacing, but it must label that pacing as product guidance rather than an official exam rule.

The College Board also operates paywalled, audit-gated resources: AP Classroom (unit guides, progress checks, question bank), the Teaching and Assessing video modules where master AP educators model instructional strategies, AP Summer Institutes (paid teacher training), and the AP teacher community. Orly should obtain audit-approved access where possible, as these resources inform expert validation and content authoring workflows that Cramapple cannot derive from public sources alone.

The published released scoring guidelines plus annotated sample student responses are the most operationally valuable public artifact. Each released FRQ comes with point-by-point commentary explaining why a response earned or missed each criterion. That is the closest the College Board comes to publishing a teaching standard for grading itself.

### 2.2 Academic Research on Test Preparation

The cognitive science of test preparation, instructional scaffolding, and short-window study has a substantial peer-reviewed literature. Cramapple draws on four streams.

The 2025 Hao et al. meta-analysis in Review of Educational Research is the most current synthesis of experimental studies on test preparation for large-scale educational tests. It finds that test prep does improve performance, but that effects vary with design. The single largest moderator is alignment with the assessed skills and constructs. This is the academic finding most directly supportive of Cramapple's canonical-content commitment.

Older meta-analyses on coaching for cognitive ability tests find consistent but modest effects, with overall effect sizes around d = 0.27. Coaching combined with practice produces larger effects than practice alone; prior test-taking experience amplifies coaching effects.

The worked-example and faded-scaffolding literature (Sweller, Renkl, Atkinson, and others) finds medium-to-large effect sizes for worked examples followed by progressively faded versions, particularly for novices. Effect sizes for procedural and conceptual knowledge in physics are around d = 0.7 and d = 0.58 respectively. The literature also flags the expertise reversal effect: worked examples that help novices can slow more advanced learners.

The retrieval-practice and spaced-repetition literature (Karpicke, Roediger) establishes that testing oneself on material produces substantially stronger retention than re-reading, particularly when retrieval is distributed over time. PEDAGOGY.docx contains the deeper treatment.

### 2.3 Academic Research on AI Essay Grading

A second academic stream is more recent and directly relevant: empirical studies of large language model grading of student writing. This literature has matured rapidly in the last two years and now informs specific design decisions about how Cramapple grades FRQs.

Tate et al. (2024) compared GPT-3.5 and GPT-4 holistic scoring of approximately 1,800 secondary student essays against human raters. Findings: weighted Cohen's Kappa with humans was around .52 for GPT-3.5 and .58 for GPT-4, while human-human agreement was around .79–.82. AI was more internally consistent than humans (AI-AI exact agreement above 80% vs human-human at 43%). AI was within one point of human scores 89% of the time vs humans at 74%. AI compressed the range (fewer extreme scores) and was less consistent with humans on English Learner writing. Conclusion: appropriate for low-stakes formative use, not summative.

Seßler et al. (2025) tested LLMs on multidimensional scoring of German essays evaluated by 37 teachers across 10 criteria. LLMs gave systematically higher scores than teachers, particularly on content quality. A companion paper found that simplified rubrics performed as well as detailed rubrics for three of four LLMs — a cost-control finding.

Zacharis & Papadakis (2025) compared ChatGPT-4o against two faculty raters on 91 Greek essays using a 9-criterion rubric. Human-human ICC was .884; AI-human ICCs were .279–.406. AI inflated scores by 2.7–3.3 points on a 90-point scale, compressed variance (SD 8.4 vs human 10.7–11.5), and exhibited proportional bias (over-scored weak essays, under-scored strong ones). Grade-band agreement was 40–51%. Principal component analysis suggested AI captured a narrower construct of writing quality than humans.

The consensus across this literature: AI grading is appropriate for formative, low-stakes use under human oversight. Cramapple's use case is squarely within the formative-prep window the literature endorses. The literature also identifies specific failure modes that any AI grading system inherits and must design against. These are catalogued in Section 5.5.

### 2.4 AP Teacher Practice

A fourth source of teaching authority is the body of practice developed by experienced AP teachers, articulated in public-facing materials by AP teacher trainers, tutoring practices, and AP teacher-bloggers. While less formally peer-reviewed than the academic literature, it has high operational value because it has been developed and refined against the actual exam by people who score AP responses.

Four practices recur across credible AP teacher sources:

- **Command-verb decoding. **Students underline the command verbs (explain, calculate, identify, justify, predict) before writing. The verb determines what kind of evidence the rubric awards points for.

- **Rubric-criterion internalization. **Students self-grade and peer-grade against the actual rubric. The repetition builds an internal model of what does and does not earn a point.

- **Scoring precision. **Concise responses that hit each rubric criterion directly outscore long, discursive responses that bury the criterion. Train students to write to the rubric, not around it.

- **Pattern recognition. **FRQ types repeat across exam years. Master teachers train students to recognize the archetype within seconds and to deploy the corresponding response structure.

## 3. Unified Learning-State Model

Every Cramapple interaction uses one recognizable state model:

**Orient → Cold Attempt → Evaluate → Diagnose → Teach → Independent Retry → Confirm Transfer → Schedule Retrieval**

The path branches when evidence is uncertain, ordinary teaching is ineffective, the learner elects to move on, or the remaining exam schedule makes further work low value. “Stuck” is an escalation level within this model for one skill and task type; it is not a label applied to the student.

### 3.1 Orient Without Leaking the Answer

Orientation has three modes:

| Mode | Use | Information Shown Before Attempt |
| --- | --- | --- |
| Cold | Diagnosis, baseline, delayed retrieval, and confirmation | Task format, command verb when already visible in the prompt, response mechanics, available tools, and accessibility instructions |
| Coached | Guided practice after the cold attempt or when the learner explicitly requests help first | Relevant concept, rubric opportunities, strategy, common traps, or worked structure |
| Exam | Timed or exam-simulation practice | Only information available under the intended exam conditions |

Cold orientation must not name the tested concept, reveal the misconception represented by a distractor, enumerate hidden rubric criteria, identify the required formula, or summarize the data trend. Those disclosures can improve coached performance while destroying the diagnostic value of retrieval.

**Decision:** Cold mode is the default for diagnostic, confirmation, and delayed-review attempts. Coached mode begins after an attempt, through an explicit learner choice, or under a documented attempt-first exception. Exam mode is used for realistic rehearsal.

### 3.2 Cold Attempt

The learner does the work before substantive teaching. For FRQs, Cramapple captures the response and relevant work. For MCQ, it captures the choice and may request a brief explanation or confidence rating when the additional interruption is worthwhile. For quantitative work, it captures intermediate steps where feasible.

The attempt records question version, skill and task classification, assistance level, timing, confidence, and any solution exposure. A response completed after substantive help is not a cold attempt.

### 3.3 Evaluate

Cramapple evaluates the response criterion by criterion and distinguishes the observed result from its interpretation. The evaluation may identify points or criteria earned, evidence present or absent, contradictions, calculation outcomes, and the smallest observable gap. Scores remain estimates unless tied to validated scoring packages.

The grading pipeline should use structured intermediate outputs and preserve source, rubric, prompt, model, and policy versions. Hidden model reasoning is not treated as authoritative evidence; learner-visible rationales must cite the response and applicable criterion.

### 3.4 Diagnose With Competing Explanations

A miss does not reveal its cause. Cramapple maintains a short list of plausible explanations and uses the least costly discriminating probe that can separate them.

| Possible Cause | Discriminating Evidence | Likely Route |
| --- | --- | --- |
| Performance slip | Learner self-corrects on a near-identical check without conceptual help | Brief Tighten and later confirmation |
| Task-language or expression gap | Concept is demonstrated in another form, but the requested operation or response construction fails | Tighten |
| Missing prerequisite | Learner fails a simpler precursor task required for the target | Step Down |
| Integration or working-memory overload | Atomic components are correct in isolation, but the integrated task fails | Step Apart |
| Coherent misconception or framing sensitivity | Prerequisites and components are present, but a stable wrong model or surface-triggered pattern persists | Step Sideways |
| Representation gap | Prose understanding succeeds while graph, table, model, or diagram interpretation fails | Representation translation, then retry |
| Content or grading uncertainty | Source, rubric, classification, or evaluation is ambiguous | `content_uncertain`; do not update mastery and create review evidence |

Diagnosis is a ranked hypothesis with confidence, not a declaration about the learner. When the evidence is weak, Cramapple says what it observed and chooses a reversible next step.

### 3.5 Teach and Independent Retry

Teaching uses the least revealing intervention likely to restart productive work. Tighten and Show are ordinary interventions; Sideways, Apart, and Down are escalation interventions defined in `LEARNING_SYSTEM_STUCK.md`.

Every teaching intervention ends with a new, independently completed task. Success on a scaffolded step is evidence that the intervention helped, not evidence that the target skill is mastered.

### 3.6 Confirm Transfer

Immediate success after teaching receives one of three evidence states:

- **Supported success:** correct while using prompts, decomposition, a worked example, or a recently taught prerequisite.
- **Immediate independent transfer:** correct on a new structurally related task without substantive help.
- **Confirmed retention:** independent success again after an appropriate delay and preferably with changed surface features.

Only immediate independent transfer can close the current interaction as a provisional success. Confirmed retention is required before Cramapple presents the skill as stable improvement. A later failure reopens the learner-model estimate without erasing the prior observation.

### 3.7 Schedule Retrieval or Move On

After an independent retry, Cramapple schedules delayed review based on fragility, days remaining, exam value, assistance, prior history, and available study opportunities. The learner can always choose **Move on and return later** after a scored attempt or intervention. That action preserves the evidence, creates a revisit obligation when useful, and prevents one skill from consuming the session.

## 4. Ordinary Intervention and Confirmation Modes

Selecting the right intervention is pedagogically consequential and consumes scarce study time. Cramapple therefore uses the least revealing intervention supported by the evidence, then requires an independent retry.

### 4.1 Tighten

Used when the student has the underlying concept but missed the rubric language, skipped a causal step, or wrote imprecisely. The student needs a small, targeted correction, not a re-teach.

In practice: Cramapple identifies the specific gap in the response and prompts the student to attempt the missing piece. For a causal-explanation FRQ where the student's chain skipped a mechanism step, Cramapple may render an inline bracket marker (a "[...]" placeholder) at the exact location of the gap and pose a Socratic prompt that points at the missing token.

**Example. **Student writes: "High heat causes the cell to lose its function." Cramapple renders: "High heat [...] causes the cell to lose its function." Prompt: "You named the stressor and the outcome. The rubric wants the mechanism. What happens to the tertiary protein bonds when kinetic energy exceeds baseline limits?"

*Source: Blueprint_Teaching draft (Logic-Gap Protocol and Bracket Marker UI). One specific UI expression of the vision's commitment to "smallest improvement likely to earn the next point." The sentence-level visual highlighting approach is also the convergent UX across competitive AI feedback tools (GPTZero, EssayGrader), validating the direction.*

### 4.2 Show

Used when the student is missing knowledge, missing a method, or has a misconception. The student needs to see how a high-scoring response is constructed, then practice it.

Show is a faded worked-example sequence. The student first sees a complete worked example with all steps shown and annotated against the rubric criteria. Then a faded version of the same problem with the last step removed. Then a parallel problem on the same skill with different surface content, which the student solves independently.

**Example. **For a chi-square calculation the student missed: Cramapple shows a complete worked example with each step labeled (state hypothesis → compute expected values → compute chi-square statistic → compare to critical value → state conclusion). Then a problem with the conclusion step removed. Then a parallel problem on different content.

*Source: Sweller, Renkl, Atkinson, and the cognitive load / worked-example literature. Meta-analytic effect sizes around d = 0.6–0.7 for procedural and conceptual knowledge. Fading the last step first ("backward fading") is the empirically preferred pattern.*

*Decision: Show defaults to a three-step sequence (full → faded → parallel). The number of faded intermediate steps is a Hypothesis to be tested with usage data.*

### 4.3 Stretch

Used when the student earned the point cleanly. Same skill, slightly harder context, different unit content. The goal is to confirm that the win was a real skill acquisition and not pattern-matching to a familiar surface, and to build transfer.

Stretch is a confirmation mode rather than a Repair mode. It tests transfer after an apparently clean success.

*Source: Worked-example literature on near and far transfer (Rayner et al., Renkl); the College Board's explicit design intent in the CED that science practices "spiral throughout the course."*

### 4.4 Selection Logic

The default mapping from error classification to Repair mode is:

| Diagnosis | Default Repair Mode |
| --- | --- |
| Insufficient specificity / missing rubric language | Tighten |
| Skipped causal step / logic gap | Tighten (with bracket marker) |
| Unsupported claim / missing evidence | Tighten |
| Missing knowledge | Show |
| Incorrect mechanism | Show |
| Formula setup error | Show (with faded worked example) |
| Data interpretation error | Show |
| Misread question | Tighten (re-read prompt, point at command verb) |
| Arithmetic / unit error | Tighten (point at the specific step) |
| Contradiction within response | Tighten (surface both claims) |
| Point earned cleanly | Stretch confirmation |

The error classification is only the starting hypothesis. Before selecting an escalation move, Cramapple uses direct evidence where feasible:

- Fail a prerequisite probe: prefer Step Down.
- Pass atomic components but fail recomposition: prefer Step Apart.
- Show a coherent misconception or framing-sensitive pattern while prerequisites and components remain available: prefer Step Sideways.
- Lack decisive evidence: offer Sideways as the reversible default and preserve the learner's choice between Apart and Down.
- Encounter ambiguous source, rubric, or grading evidence: enter `content_uncertain`, withhold learner-model updates, and create validator-review evidence.

Time-on-task, confidence, and typing behavior may adjust confidence but do not determine the route by themselves. The learner can request a more explicit explanation, choose Move On, or return later.

## 5. The Lock and Calibration

### 5.1 The Lock — Spaced Retrieval

An independent retry can close the current interaction provisionally. The Lock tests whether the improvement survives delay and changed surface features.

After teaching and an independent retry, the underlying skill and task type are registered in the learner's retrieval queue. Supported success normally returns sooner than immediate independent transfer. The learner encounters a different item that requires the same operation without duplicating the intervention's surface form.

The Lock does not translate a repaired point automatically into durable performance. It creates the opportunity to observe retention. The 10-day window supports meaningful same-session transfer and one or more delayed checks when enough time remains.

Lock is also what enables the next-best-action engine's recommendations. When Cramapple recommends a session focused on a specific weakness, it is selecting from the Lock queue rather than from generic curriculum coverage.

The detailed schedule-aware deferral formula is defined in `LEARNING_SYSTEM_STUCK.md`. Ordinary review starts with working windows of approximately 24 hours after supported or fragile success and 48–72 hours after clean independent transfer, compressed as the exam approaches.

### 5.2 Grading Validation Metrics

No single agreement statistic is sufficient to establish grading quality. Weighted Cohen's Kappa can be useful for ordinal total-score agreement, but it does not reveal which rubric criteria are being missed, whether errors are directionally biased, or how performance varies across learner groups and question types.

The grading launch gate must therefore use a metric suite on a held-out set scored by qualified human reviewers:

- criterion-level precision, recall, and exact agreement;
- total-point exact agreement and mean absolute error;
- weighted Kappa where the scoring scale and sample support it;
- over-scoring and under-scoring rates;
- disagreement severity and adjudication outcomes;
- subgroup and response-style error analysis;
- coverage and accuracy when the grader abstains or returns `content_uncertain`.

**Decision:** the separate grading design owns final thresholds. A weighted-Kappa target around .60 may be tested as an initial hypothesis for ordinal total scores, but it is not by itself a launch decision and is not treated as equivalent to a competitor's differently reported metric.

### 5.3 Known Failure Modes and Calibration Moves

Three peer-reviewed studies of AI essay grading (Tate 2024, Seßler 2025, Zacharis & Papadakis 2025) document a consistent set of failure modes that any LLM-based grader inherits. Cramapple's grader will exhibit these by default. The calibration architecture must address them explicitly.

#### Range compression

Universal finding across all three empirical studies. AI grades cluster toward the middle of the scale, with fewer extreme scores than humans assign. In Zacharis 2025, AI scores had a standard deviation of 8.4 vs humans at 10.7–11.5 on the same 90-point rubric. In Tate 2024, AI gave fewer 1s and 6s than humans on a 1–6 scale. This compresses the discriminative power of the score.

**Design move: **Anchor examples included in the rubric package. For each FRQ archetype, the grader is given two to three worked examples spanning the score range — a full-credit response, a middle-credit response, and a low-credit response — annotated against the rubric criteria. This widens the implicit reference range the model considers when scoring.

#### Score inflation

Documented in all three empirical studies. AI assigns systematically higher scores than human raters. Zacharis 2025 measured 2.7–3.3 points of inflation on a 90-point scale. Seßler 2025 found LLMs gave higher scores than 37 German teachers across 10 criteria, particularly on content quality. Tate 2024 found GPT-4 means above human means.

**Design move: **Test for inflation explicitly in the launch validation. Compare the distribution of Cramapple grader scores to known distributions of human scores on the same released FRQs. If a consistent positive bias is detected, calibrate it down via prompt adjustment or post-hoc correction before launch.

#### Proportional bias (regression to the mean)

Zacharis 2025 demonstrated via Bland-Altman analysis that AI over-scored weak essays and under-scored strong essays, with a statistically significant negative regression slope. The AI effectively regresses all performances toward the middle. This is a fairness issue: weaker students are rewarded beyond merit, stronger students are not recognized for their excellence.

**Design move: **Detect this pattern in validation via Bland-Altman regression slope on the held-out set. If significant, the calibration response is the same anchor-example approach as for range compression — giving the model explicit examples at the extremes reduces its tendency to pull toward the center.

#### Generic, rubric-recycled feedback

The dominant qualitative failure mode in the literature. Multiple studies note that AI feedback is "valued for coverage" but undermined by being "largely generic" — often recycling phrases from rubric descriptors without specific essay-grounded evidence. Students perceive this as low quality even when scores are accurate.

**Design move: **The Repair-Tighten bracket-marker pattern and the criterion-specific minimum-fix language are explicit defenses against this. Every piece of feedback must quote or reference evidence from the student's actual response, not just paraphrase the rubric. Generic feedback is a bug to catch in evaluation, not a stylistic preference.

#### English Learner / equity bias

Tate 2024 documented worse AI-human agreement for English Learner writing (.40–.43 weighted Kappa) than non-EL writing (.51–.52). AP Biology FRQs are less language-dependent than English essays, so the effect is likely smaller in our domain, but it is not zero.

**Design move: **Validation must include responses from English Learners, and inter-rater agreement should be reported separately for EL and non-EL populations. If a meaningful gap exists, this is a launch blocker, not a release note.

### 5.4 Dual-Pass Grading for High-Value FRQs

The academic literature suggests that two independent grading passes followed by adjudication of disagreements may improve accuracy. For the two 9-point long-form FRQs, the inference cost may be worth it. For 4-point short FRQs (FRQ 3–6), single-pass grading may be sufficient.

*Hypothesis: dual-pass for FRQ 1 and FRQ 2, single-pass for FRQ 3–6. Validate against the complete metric suite.*

## 6. Adaptation by FRQ Archetype

The unified state model does not change across question archetypes. What changes is the task representation, evaluation contract, likely discriminating probes, and intervention menu.

### 6.1 FRQ 1 — Interpret and Evaluate Experimental Results (long, 9 pts)

The longest and highest-value FRQ. Tests Science Practice 6 (Argumentation) heavily. Dual-pass grading default.

- **Cold orientation:** Identify the response parts and visible command verbs without naming the experimental variables, biological mechanism, or rubric answers. Coached orientation may later surface the design elements and criterion structure.

- **Repair: **For an argumentation gap, default to Tighten with a focus on the claim–evidence–reasoning structure. For an experimental-design misreading, default to Show with a worked example of the design analysis.

### 6.2 FRQ 2 — Interpret and Evaluate Experimental Results with Graphing (long, 9 pts)

Tests Science Practices 4 and 5. Requires the student to construct a graph with proper axes, units, and scaling. Dual-pass grading default.

- **Cold orientation:** Provide the graphing workspace and response mechanics without selecting axes, scale, trend, or interpretation. Coached orientation may later enumerate applicable graph criteria.

- **Repair: **For a mechanical error, Tighten with a direct correction. For a misinterpretation, Show with a parallel data set worked out.

### 6.3 FRQ 3 — Scientific Investigation (short, 4 pts)

- **Cold orientation:** Surface only the requested operation and response mechanics. Coached orientation may contrast valid hypotheses, controls, and measurement methods after the attempt.

- **Repair: **Show is the default — most errors here are missing method knowledge rather than missing language.

### 6.4 FRQ 4 — Conceptual Analysis (short, 4 pts)

Tests Science Practice 1 (Concept Explanation) most directly. The most common short FRQ archetype.

- **Cold orientation:** Preserve the command verb already visible in the prompt but do not name the tested concept or reveal a criterion checklist. Coached orientation may do so after the attempt.

- **Repair: **For a missing-mechanism gap, default to Tighten with the bracket marker. For a missing-concept gap, default to Show. The D→E→P scaffold (Define → Explain → Predict) from the Blueprint_Teaching draft is the natural response structure here.

### 6.5 FRQ 5 — Analyze Model or Visual Representation (short, 4 pts)

- **Cold orientation:** Ensure the visual is legible and identify the requested operation without interpreting the visual. Coached orientation may teach how to read the representation after the attempt.

- **Repair: **For a misread visual, default to Show with the reading move worked out. For a correct read but weak articulation, default to Tighten.

### 6.6 FRQ 6 — Analyze Data (short, 4 pts)

- **Cold orientation:** Identify the response format and visible command verb without stating the trend, prediction, units, or expected explanation.

- **Repair: **For a missed trend, Show. For a missed explanation, Tighten if the student has the concept and Show if not.

## 7. Adaptation for Multiple-Choice

MCQ accounts for 50% of the exam score. The volume is substantial and the misconception diagnosis on a missed MCQ is high-yield because distractors are designed to surface common confusions.

- **Cold orientation:** Do not state the tested concept or distractor trap before a diagnostic, confirmation, or delayed-review attempt. After submission, coached feedback may name the concept and explain why each distractor is attractive.

- **Attempt: **Student selects an answer. The optional "why" field is critical — it is what makes Repair targeted rather than generic.

- **Score: **Right or wrong, plus an explanation of why each distractor was constructed. Even a correct answer is an opportunity to teach the trap.

- **Repair: **For a chosen distractor that maps to a known misconception, Show with a worked example of the misconception's correct alternative. For an apparent misread, Tighten by pointing at the keyword the student missed.

## 8. Student-Supplied Questions and Landing Pages

This is the highest-value interaction Cramapple has, and the primary acquisition channel. When a student pastes in a question they are actually stuck on — homework, a practice exam, a prep book — they have a real problem and have explicitly chosen Cramapple over ChatGPT. The flow that handles this moment is both a teaching moment for the individual student and a content artifact for SEO and AEO acquisition.

### 8.1 The Dual Purpose

Every resolved student-supplied question can serve two functions. First, it teaches the individual student using the unified learning loop adapted for an externally provided question. Second, if it passes source, quality, rights, and identity checks, it may become an anonymous public landing page. Internal anonymous improvement use and public publication are separate decisions.

The dual purpose raises the quality bar on every student-supplied interaction. Generic, rubric-recycled feedback — the dominant failure mode in the AI grading literature (Section 5.3) — was already a pedagogical problem. With landing pages, it is also a marketing problem. Pages with weak teaching do not rank, do not get cited, do not acquire. Criterion-specific, evidence-grounded evaluation and teaching make both the student moment and any approved public page useful.

### 8.2 Intake: Matching, Confidence, and Portfolio Check

Before Cramapple does anything, it categorizes the question through three layered checks:

- **Known-question match. **Is this question in Cramapple's existing corpus? Released FRQs, Cramapple-authored questions, prior student-supplied questions. Exact match or high-similarity match triggers high-confidence treatment.

- **Portfolio check. **Does this question fall within the set of subjects Cramapple covers? This is intentionally broader than the student's currently enrolled subject. A Bio-enrolled student can paste a chemistry question; if chemistry is in Cramapple's portfolio, that triggers a different flow than if it is not.

- **Categorization. **Which subject, Science Practice (or equivalent for non-Bio), Unit, and archetype does the question most plausibly map to? This becomes the seed for mode-appropriate orientation and evaluation.

Each check produces a confidence score. The combined confidence drives the rest of the flow. Cramapple surfaces the categorization to the student for confirmation: *"This looks like an AP Bio Conceptual Analysis question about gene regulation. Sound right?"* The student can correct or confirm. The act of categorizing is itself pedagogically valuable — it trains the student in archetype recognition, a skill they need on exam day.

### 8.3 Clarification Prompts

Two specific failure modes trigger a clarification prompt rather than a flat decline. The student gets one round to fix the issue before Cramapple proceeds or declines.

**Relevance failure. **The question appears outside the current scope or in a different subject. Example prompt: "This looks more like a chemistry question. Was that intentional? Some AP Bio questions touch on biochemistry, so I want to make sure I'm reading it right." The student confirms, redirects, or refines.

**Completeness failure. **The question references a figure, data table, or passage that was not included. Example prompt: "This question mentions a graph I don't see. Want to paste the figure or describe what it shows?" Common cause: OCR errors on photographed questions, or partial copy-paste from a multi-part FRQ.

One clarification round is the limit. If the student does not resolve the issue, Cramapple proceeds with appropriately hedged confidence or politely declines. Forced clarification loops degrade the experience and are not pedagogically useful.

### 8.4 The Four Modes

When the question is resolved, Cramapple offers the student a mode choice consistent with the vision's Section 7 commitment. Each mode uses the unified state model differently:

| Mode | Learning Behavior |
| --- | --- |
| Teach Me | Coached orientation followed by explanation, a worked example where useful, faded support, and an independent transfer attempt. |
| Hint | A bounded cue while the learner is attempting the question; it must not convert a later coached answer into cold-performance evidence. |
| Check My Work | Evaluate the submitted answer, diagnose likely gaps, teach selectively, and request an independent retry. |
| Show Solution | Show and explain a solution, then offer a fresh independent attempt. Lowest initial retrieval value, but supported honestly. |

Surfacing the mode choice is itself a demonstration that Cramapple is more pedagogically considered than ChatGPT. ChatGPT gives whatever you asked for; Cramapple makes the meta-choice visible because the meta-choice has learning consequences.

### 8.5 Confidence-Modulated Learning Flow

When the student picks Check My Work (or Teach Me, or any mode that runs the full or partial loop), the four-beat shape stays constant but every beat is modulated by the matching confidence:

- **Orientation and evaluation become confidence-aware. **High confidence (matched known question) uses the validated source and rubric package. Moderate confidence surfaces the scoring assumption. Low confidence avoids precise score claims and becomes more conversational. Cold mode never reveals answer-bearing criteria before the attempt.

- **Score uses an inferred rubric. **The Score panel honestly presents the source of the rubric. "Based on AP Biology rubric patterns for Conceptual Analysis FRQs, here's how this would likely be evaluated." Not "You earned 3 of 4 points" with false precision.

- **Repair adapts to confidence. **High confidence runs Repair normally. Moderate makes the diagnostic hedged. Low confidence becomes more conversational and offers the student multiple framings.

Honesty about confidence is a competitive advantage. ChatGPT presents everything with the same confident tone whether the underlying answer is right or wrong. Cramapple's willingness to say "I'm moderately confident this is about gene regulation; the rubric pattern suggests three criteria" is both pedagogically more useful and brand-differentiating.

### 8.6 Two Flow Variants: Enrolled vs. Visitor

The same question paste produces different flows depending on whether the user is an enrolled student or a landing-page visitor. The matching matters for handling subject-portfolio edge cases.

#### Enrolled student

A student who has purchased Cramapple for a specific subject pastes a question. Four cases:

- Question matches enrolled subject → standard flow with the four modes.

- Question matches a different subject in Cramapple's portfolio → Cramapple answers the question and offers a subject expansion. The teaching does not get withheld; the upsell sits alongside. Functional intent: "I'll teach you this one, and if you'd like ongoing coverage of [other subject], you can extend your package."

- Question is outside Cramapple's portfolio entirely → polite decline plus waitlist offer per Section 8.7. "This looks like [French/music theory/etc.]. I'm not built for that subject yet. Want me to let you know when I am?"

- Question fails relevance/completeness check → clarification prompt per Section 8.3.

#### Landing page visitor

A visitor arrives via search engine, AEO citation, or social share to a specific landing page. They see the original question and Cramapple's teaching. Then they may ask their own question. Three cases:

- Question matches any subject in Cramapple's portfolio → Cramapple answers normally and makes the broader portfolio visible. "I covered this; here are the other subjects I teach if you're prepping for more than one AP exam."

- Question is outside Cramapple's portfolio entirely → polite decline plus waitlist offer per Section 8.7.

- Question fails relevance/completeness check → clarification prompt.

The asymmetry between enrolled and visitor is important. The enrolled student is paying and has chosen a subject; their off-topic question is an upsell moment. The visitor has chosen nothing yet; their off-topic question is a discovery moment. Both are handled gracefully; neither is treated as a failure.

### 8.7 Subject Waitlist: Capturing Demand for Unsupported Subjects

Every off-portfolio decline is a moment of genuine intent. The visitor or student has a real question on a real subject, has chosen Cramapple over the alternatives, and we have to say no. Letting that moment end with a flat decline wastes both the relationship and the demand signal. The waitlist mechanism turns the decline into a soft yes and captures three distinct pieces of value at once: a future customer, a marketing contact, and a product-prioritization data point.

#### Functional intent

When a question fails the portfolio check (the subject is not one Cramapple covers), the decline message includes an explicit offer: notification when Cramapple launches that subject. The student provides phone or email — their choice, lower friction than requiring both — and the contact goes into a per-subject waitlist. When Cramapple launches the subject, the waitlist receives an announcement. The promise is specific and bounded: we will tell you when we have this; we will not flood you with unrelated marketing.

#### What gets collected

- Contact method (phone or email, student's choice).

- Requested subject (inferred from the categorization in Section 8.2; confirmed by the student).

- Timestamp.

- Source (enrolled-student vs landing-page-visitor, used for downstream segmentation).

- Whether the contact is the student's own or a parent's (relevant to age and consent handling — see below).

Nothing else. No personal demographic data, no school information, no payment context. The minimal-collection posture is consistent with Section 13 and reduces compliance surface.

#### Age and Consent Handling

Cramapple may not know the age of a landing-page visitor. The waitlist flow therefore requires counsel-reviewed age, notice, and parental-consent handling before launch. A possible low-friction pattern is to let a user provide their own contact or a parent's contact with an age confirmation, but this document does not declare that pattern legally sufficient.

#### How the data is used

Three distinct uses:

- **Subject prioritization. **Aggregate waitlist counts by subject become an evidence-based prioritization signal for the product roadmap. If AP Chemistry has 5,000 waitlist entries and AP Music Theory has 80, the roadmap reflects that. This converts the qualitative "what should we build next" question into a quantitative ranking driven by real demand.

- **Launch marketing. **When a subject launches, the corresponding waitlist receives an announcement. Conversion from a waitlist that signed up specifically for that subject should outperform cold marketing by a large margin — these are users who explicitly raised their hand.

- **Adjacent-subject upsell. **Enrolled students who signed up for a waitlist on a different Cramapple-covered subject (the upsell case in Section 8.6) can be re-engaged when they finish their current subject. The waitlist entry is itself a high-intent buying signal.

Each communication includes a clear unsubscribe mechanism per CAN-SPAM and standard practice. The waitlist is a contractual promise (we said we'd tell you when X launches), not a general marketing channel; we honor that distinction.

#### Operational implications

The mechanism requires three pieces of infrastructure to ship at launch: a waitlist data model (per-subject table with the fields listed above), a simple form attached to the off-portfolio decline flow, and a launch-announcement pipeline tied to subject release. None of these are heavy lift; the work is making sure they actually fire from the right moments in the user flow. The reporting side — aggregate waitlist counts by subject, surfaced to the roadmap process — is a small admin view that becomes the input to release planning.

*Decision: subject waitlist ships at MVP launch. Form collection is contact-of-user-or-parent with explicit age check. Subject prioritization based on waitlist counts becomes a standing input to release planning.*

*Open: exact form copy and counsel-approved age and consent pattern; the cadence of internal reporting on waitlist counts; whether waitlist entries also feed into customer-development conversations (e.g., interview prospects who signed up for the same not-yet-launched subject).*

### 8.8 Quality Gate for Landing Page Publishing

Not every student-supplied question produces a landing page. A quality gate sits between the resolved question and publication, mirroring the quality framework Cramapple uses for canonical Orly-authored questions.

- **Above quality threshold: **Cramapple answers the student normally and may publish the question and teaching as a landing page after source, quality, and identity checks.

- **Below quality threshold: **Cramapple may still answer the student (they get value) but does not publish a page. Low-quality questions, malformed questions, or questions Cramapple's confidence cannot support are not exposed publicly.

- **Borderline: **Queued for review. Orly or a content reviewer assesses; possibly edits the rendered version for relevance and quality before publication.

The quality gate protects the SEO and AEO surface from low-quality content and preserves Cramapple's pedagogical credibility. Before publication, the system also performs a deterministic sweep for the signed-in user's full proper name and known first-name/last-name combinations. Matches are removed or held for review. Terms and conditions prohibit submission of personal or confidential information and govern residual edge cases. This control is deliberately narrow and does not imply that Cramapple can detect every possible identifier.

### 8.9 Landing Page Experience

A landing page renders the question, Cramapple's coached explanation and criterion guidance, and the teaching interaction selected for publication. The visitor sees the value before any paywall. Two interactive surfaces follow:

- **"Have another question?" **The visitor can paste their own question. One free question without signup. This is the trial.

- **"Want to put this lesson to the test?" **A second, related question on the same skill that uses the teaching the visitor just received. The visitor applies the lesson immediately. If Cramapple can show outcomes ("students who took the test got it right 73% of the time"), the conversion lever is stronger.

The "put this lesson to the test" surface is the more pedagogically interesting of the two. It demonstrates that Cramapple's teaching produces transferable skill, not just an answer to a single question. This is the structural argument against ChatGPT — generic AI gives you the answer; Cramapple gives you the skill, and proves it on a second question.

**Disclosure. **A simple note at the point of submission states: "We use anonymous responses and questions to improve Cramapple and help other students." Public pages do not intentionally identify the originating student. Publication is separate from internal anonymous improvement use and is subject to the quality and signed-in-name sweep above.

### 8.10 The Share Loop

One free question per share. The student or visitor who shares the landing page to social (Discord, group chat, Snapchat, Instagram, TikTok, X) earns one additional free question. The mechanic is intentionally simple: testable conversion, predictable inference cost, easy to communicate.

Some users will game the system (fake shares, throwaway accounts). The marginal inference cost of an extra free question is low enough that gaming is acceptable. The signal value of even a gamed share — an additional URL in social — is positive for the acquisition surface. ECONOMICS.docx should model the marginal cost of share-unlocked questions against the conversion-to-paid rate; that economic analysis is separate from this document but flagged here as the relevant downstream artifact.

### 8.11 Anti-Scraping

Landing pages are the content moat and need protection from bulk extraction without introducing user friction. The vision is: search engines (Google, Bing) crawl freely so SEO works; answer engines (ChatGPT, Perplexity, Gemini, Claude) can index responsibly; known training scrapers and competitor bulk-extractors are blocked; the typical student never sees a challenge.

Functional requirements (implementation belongs to engineering and infrastructure):

- No CAPTCHA. The annoyance cost is greater than the protection value for our use case.

- Invisible challenge for suspicious traffic (Cloudflare Turnstile or equivalent). Fires only on bot-like signals; legitimate users never see it.

- Rate limiting per IP and per session. Bulk access patterns get throttled.

- robots.txt explicitly allowing major search crawlers and denying known training scrapers. This list moves; Orly and engineering should maintain it.

- The gating itself — one free question, share-to-unlock — acts as a natural anti-bulk-extraction mechanism. The product economics already limit how much value any single visitor can extract.

### 8.12 Lock Integration

For enrolled students, student-supplied questions enter the Lock queue only when confidence is high enough to identify the underlying Science Practice and Unit. Low-confidence questions do not feed the next-best-action engine — using a misclassified question to drive future recommendations would degrade the diagnostic.

For landing page visitors who have not enrolled, there is no Lock queue. The interaction is one-off (or two-off, with the bonus question). Conversion to enrollment is what creates a Lock queue going forward.

### 8.13 The Voice of the Coaching Prompt

*Note: the specific tone and language used in coaching prompts (including the "are you taking a shortcut" / cheating-aware prompt referenced in Section 10.5) is a brand and marketing deliverable, not a methodology decision. This document specifies the functional intent — peer-tone, non-preachy, treats the student as a peer making a choice rather than a subject being policed. Final language belongs to the brand-and-marketing workstream.*

## 9. Research and Source Linkage

Every meaningful teaching activity in Cramapple maps to at least one authoritative source. The table below catalogs the principal mappings.

| Cramapple Activity | Authority | Mechanism | Source |
| --- | --- | --- | --- |
| Cold orientation followed by coached criteria | AP teacher practice + retrieval research | Cold attempts preserve diagnostic value; coached rubric instruction then improves scoring precision | AP Biology CED; retrieval-practice literature; documented AP teacher practice |
| Adoption of CED Science Practices verbatim | College Board | Each exam question maps to at least one Science Practice; teaching aligned to assessed constructs produces meaningful score effects | AP Biology CED (2025–26); Hao et al. (2025) |
| Adoption of FRQ archetype taxonomy | College Board | Each FRQ has a defined focus and weighting; pattern recognition by archetype is documented expert-tutor practice | AP Biology CED; AP teacher community practice |
| Command-verb decoding | AP teacher practice | The visible command verb identifies the requested operation without revealing hidden content; deeper criterion teaching follows the attempt | Documented AP teacher practice; AP Biology CED |
| 9-element criterion-level feedback | College Board + academic research | Released scoring guidelines are criterion-by-criterion; assessment-for-learning produces stronger formative effects than holistic grading | AP Biology released scoring guidelines; Black & Wiliam tradition |
| Multi-step rubric-aligned chain-of-thought grading workflow | Academic research + competitive industry standard | Rubric-aligned CoT prompting outperforms single-prompt grading; the architecture every credible grading product converges on | QwenScore+ (2026); Seßler et al. (2025); Tate et al. (2024); Fiveable AI Transparency disclosure |
| Anchor examples in rubric package | Academic research + AP reader training | Studying scored examples at multiple quality levels widens the model's implicit reference range; addresses range compression and proportional bias | Zacharis & Papadakis (2025); Tate et al. (2024); College Board AP reader training practice |
| Multi-metric grading validation | Academic research and Cramapple quality policy | Criterion agreement, total-point error, directional bias, subgroup error, abstention coverage, and weighted Kappa where appropriate reveal different failure modes | Tate (2024); Seßler (2025); Zacharis (2025); final thresholds owned by grading design |
| Pre-launch calibration against systematic biases | Academic research | Inflation, compression, and proportional bias are documented across all empirical studies; detection requires explicit Bland-Altman analysis on a validation set | Zacharis & Papadakis (2025) Bland-Altman; Seßler (2025); Tate (2024) |
| Dual-pass grading for long-form FRQs | Academic research | Two independent passes with adjudication of disagreements improves agreement with expert raters on high-value items | Tate (2024) robustness check; Roundtable (2025); Tate human-double-scoring benchmark |
| Tighten mode (bracket marker for logic gaps) | Cramapple-original (Blueprint_Teaching draft) + competitive convergence | Surfacing the missing token at its exact location produces targeted self-explanation; sentence-level highlighting is the convergent UX across all AI feedback tools | Blueprint_Teaching; Renkl self-explanation; GPTZero and EssayGrader UX patterns |
| Show mode (faded worked examples) | Academic research | Studying a worked solution before generating one reduces extraneous cognitive load; progressive fading triggers self-explanation | Sweller; Renkl & Atkinson (2003); Crissman meta-analysis |
| Stretch mode (post-success transfer) | Academic research + College Board | Near and far transfer require novel surface context; CED designs Science Practices to spiral across units | Rayner et al. (2013); AP Biology Course at a Glance |
| Lock (spaced retrieval at 24–72 hours) | Academic research | Distributed retrieval produces substantially stronger retention than re-reading or massed practice | Karpicke (2008); Roediger & Karpicke retrieval-practice literature |
| Optional "why" field on MCQ | Academic research | Metacognitive articulation improves self-knowledge and grading-accuracy calibration | PEDAGOGY.docx (metacognition section); confidence-calibration literature |
| Joint guidance (Cramapple proposes, student controls) | Vision commitment + academic research | Student agency combined with explicit recommendation produces stronger engagement than pure direction or pure choice | CRAMAPPLE_VISION.md (Section 5.1); self-determination theory |
| Deterministic loop shape across questions | Cognitive load theory + cognitive apprenticeship | Predictable structure reduces extraneous cognitive load and transfers a metacognitive sequence to the student | Cognitive load theory; Collins, Brown, Newman cognitive apprenticeship |
| Time-on-task and typing pattern as coaching signals | Cramapple product hypothesis + behavioral-signal research | Behavioral metadata can qualify confidence and detect low-evidence attempts, but cannot reliably diagnose the learning cause by itself | Vision parent-incentive mechanism; keystroke-dynamics research |
| Anonymous response data improves Cramapple for the next student | Approved Cramapple operating posture | Anonymous responses support grading calibration, intervention evaluation, content improvement, prompt/model evaluation, and teaching-policy refinement | Vision content strategy; validation and learning-system evaluation requirements |

*This table is a living artifact. As the methodology evolves, every new teaching activity should be added here with its authority, mechanism, and source citation. If an activity cannot be linked to an authority, that itself is a flag.*

## 10. UX Expression

The student does not see internal state labels. They see a stable sequence of interaction zones with the amount of guidance determined by cold, coached, or exam mode.

- Orientation panel (top). In cold mode it contains only task mechanics and visible command-language guidance. In coached mode it may expand to concepts, criteria, and strategy. In exam mode it is absent unless required for accessibility or interface operation.

- Attempt area (middle). Text input for FRQ, choice selector plus optional reasoning field for MCQ, calculation workspace for quantitative.

- Score panel (slides in after submit). The 9-element feedback structure for FRQ, formatted as a per-criterion list with the satisfied/missed status visually distinct.

- Repair button (single primary action after Score). Labeled "Let's get this point" or similar. Opens the Repair mode the diagnosis selected. The student can override.

The visual consistency does double duty: it teaches the metacognitive sequence by repetition, and it makes the product feel deterministic in a category where generic AI tools feel chatty and unpredictable.

### 10.1 Effort and Coaching Signals

Cramapple is a teaching system, not a school grading authority. It does not need to police originality as if it were adjudicating academic misconduct. Behavioral signals may qualify diagnostic evidence and support neutral coaching, but parent access is limited to approved progress aggregates under the future parent entitlement.

Where the teacher-tool category is built on a defensive integrity posture (catch the cheaters, prove the originality), Cramapple takes a coaching posture (effort is a learning signal; "cheating" is a moment to coach about exam reality; parents have a stake). This is a deliberate differentiation from the incumbent feature set.

#### Three signals

**Time-on-task. **How long the learner spends on each attempt, captured automatically. Timing qualifies the evidence but does not establish mastery, effort, guessing, or a specific learning cause. A fast incorrect response may be a slip, guess, misread, or existing misconception; a slow incorrect response may reflect productive effort, distraction, accessibility needs, or missing knowledge. Routing requires response evidence or a discriminating probe.

**Typing pattern. **Keystroke metadata during Attempt — pauses, backspaces, deletion patterns, paste events, and sustained rhythm. These are low-confidence provenance and effort signals. They may prompt a neutral coaching check or reduce the evidentiary weight of an attempt, but they do not prove authorship or determine an instructional route.

**Text-pattern detection. **Automated authorship or AI-text indicators are not treated as reliable learner diagnoses. If used at all, they are tertiary signals for a neutral provenance check and require strong corroboration before affecting learner evidence.

#### Three uses

**In-product coaching prompts. **When the signals fire strongly — paste event, near-zero typing time, suspiciously polished text — Cramapple surfaces a prompt at the moment of submission. The functional intent is peer-voice, non-preachy: a friend catching a slip, not a system surveilling behavior. The prompt acknowledges the reality (you cannot take this shortcut on the actual exam) and treats the student as a peer making a choice. Specific tone and language belong to the brand-and-marketing workstream; this document specifies the functional intent only.

The student can dismiss the prompt and proceed. The signal is calibrated to fire rarely and only on strong patterns. Repeated triggers downweight the response in the diagnostic but do not block participation.

**Diagnostic input. **Responses that show strong paste signals are downweighted in the next-best-action engine. If Cramapple thinks the response is not the student's actual reasoning, it should not treat the resulting performance as a measurement of the student's actual proficiency. The student still gets their grade and feedback; the system just does not update its model of the student based on a response it has reason to think did not come from them.

**Future parent visibility. **A paid parent entitlement may expose approved account-progress aggregates after relationship, entitlement, consent, and visibility checks. The learner sees exactly what is shared. Raw answers, private interactions, and unsupported causal claims remain excluded.

*Decision: time-on-task and basic paste/typing summaries may be captured at launch as evidence qualifiers. They do not choose Tighten, Show, Sideways, Apart, or Down without task evidence. Parent visibility remains a future entitlement and must show the learner exactly what is shared.*

*Open: thresholds for "strong signal" calibration on real student data; specific design of the parent-facing rollup; whether to license a third-party AI-detection API or build an in-house perplexity check.*

## 11. Out of Scope for This Document

- **Content authoring workflow. **How questions, rubrics, and worked examples are written, reviewed, and approved by Orly and hired experts.

- **Calibration / diagnostic. **Vision Section 5.2 commits to an optional 3–5 question calibration. The design is a separate workstream.

- **Efficacy measurement. **How Cramapple measures whether the teaching is working — pre/post performance, retention checks, expert-AI agreement, recommendation acceptance.

- **Legal privacy policy. **Section 12 names the operating posture on student response data. The legal document with full privacy policy language is a separate workstream owned by counsel.

## 12. Open Items

- The exact return-interval algorithm for the Lock queue. Working defaults are 24 hours for missed points and 48–72 hours for Stretch-confirmed points. Requires student data to validate.

- The number of intermediate fade steps in the Show mode (between full worked example and parallel problem). Default is one. May need to be two for higher-complexity quantitative work.

- Number and selection of anchor examples per FRQ archetype. Working assumption: three (high, middle, low) per archetype. May need adjustment based on calibration testing.

- Whether dual-pass grading is worth the cost for FRQ 3–6 (short FRQs). Default is single-pass; revisit if validation shows weak agreement on shorter items.

- Thresholds for the time-on-task and typing-pattern coaching signals. To be calibrated on real student data post-launch.

- Specific design of the parent-facing effort rollup. Ships with the version that includes the vision's parent-incentive mechanism.

- Whether to add broader sentence-level visual treatment to the Score panel on top of the committed bracket-marker pattern. The bracket marker (specific token at the gap) is structurally different from full sentence-level coloring (used by GPTZero, EssayGrader for AI-detection and feedback respectively); worth testing whether the additional visual treatment improves comprehension or adds noise.

- Whether to license a third-party AI-detection API (e.g., GPTZero) or build an in-house perplexity-based check for the text-pattern tertiary signal. Cost and accuracy comparison to be run before launch.

- How to handle FRQ archetypes where the student's response is partially correct across multiple criteria simultaneously. Working assumption: address the highest-value missed criterion first.

- The first-session onboarding screen design — how much to explain about the loop without making the product feel academic.

- Quality-score threshold for landing-page publishing. Should match Orly's canonical-question threshold, but the exact numeric value needs setting.

- Confidence thresholds for high / moderate / low confidence in student-supplied-question intake. Calibration requires real data from the first cohort.

- Default mode for landing-page visitors who paste a bonus question. Working assumption: surface the four modes and let them pick. Alternative: default to Check My Work to demonstrate the full learning flow. Testable.

- Specific anti-scraping implementation (Cloudflare Turnstile vs alternatives) and the maintained list of allowed and blocked crawlers. Owned by engineering and infrastructure; flagged here as a dependency.

- ECONOMICS.docx update for marginal acquisition cost per share-unlocked question and conversion-to-paid rate. Should follow once Section 8 is locked.

## 13. Data and Improvement

Cramapple is a learning system that improves through expert-reviewed evidence from real use. This section names the operating posture on student responses: what Cramapple uses, what it excludes, and how internal improvement differs from public publication.

### 13.1 Posture

Cramapple uses anonymous or deidentified student responses and associated outcomes to improve its grading, teaching, content, evaluation sets, prompts, model configurations, and intervention-routing policies. Expert reviewers validate sampled cases and disagreements so improvement is not based only on the system grading itself.

Student-provided questions and responses may also be considered for public anonymous landing pages under Section 8. That publication decision is separate from internal improvement use and requires additional source, quality, rights, and identity checks.

### 13.2 The Disclosure

The product should use direct language at signup and at relevant contribution points:

> We use responses anonymously to improve Cramapple's grading and teaching and help other students.

The Terms and Conditions prohibit submitting personal or confidential information and define the permitted improvement uses. Counsel owns final consent, age, retention, deletion, and jurisdiction-specific requirements.

### 13.3 What We Use, What We Do Not

- **We use, after anonymization or deidentification: **student responses, MCQ choices, optional reasoning, grader evaluations, validator corrections, intervention histories, independent retries, delayed outcomes, and bounded behavioral evidence such as attempt timing.

- **We exclude from improvement datasets: **student names, account identifiers, payment data, parent identifiers, and direct contact information.

- **We separate public publication: **internal anonymous use does not make a response public. Publication requires the Section 8 quality gate and a deterministic sweep for the signed-in user's full proper name and reasonable first-name, last-name, and combined-name variants. Matches are removed or held for review.

- **We retain uncertainty: **a grader output is not automatically ground truth. Validator decisions, source versions, and adjudication status travel with evaluation examples.

### 13.4 Legal and Policy Boundary

This design document does not claim compliance before counsel review and implementation verification. Counsel owns the Privacy Policy, Terms and Conditions, age and parental-consent rules, retention and deletion rights, international requirements, and vendor data-processing terms.

### 13.5 Operating Implication

The evaluation corpus grows through released materials, authored validation cases, and anonymous real student responses sampled for expert review. Validator corrections can improve rubric packages, teaching content, prompt and model configurations, prerequisite maps, and route-selection policies.

**Decision:** Cramapple explicitly uses anonymous student responses to improve Cramapple. Public publication remains separately gated.

## References

#### College Board (Public)

- AP Biology Course and Exam Description, effective Fall 2025. https://apcentral.collegeboard.org/media/pdf/ap-biology-course-and-exam-description.pdf

- AP Biology Course at a Glance. https://apcentral.collegeboard.org/media/pdf/ap-biology-course-at-a-glance.pdf

- AP Biology released free-response questions and scoring guidelines. https://apcentral.collegeboard.org/courses/ap-biology/exam

#### College Board (Audit-Gated)

- AP Classroom (unit guides, progress checks, question bank).

- Teaching and Assessing AP Biology video modules. Available via AP Classroom.

- AP Summer Institutes (subject-specific paid teacher training).

#### Academic Research — Test Preparation

- Hao, Z., Baird, J.-A., El Masri, Y., & Double, K. (2025). The Impact of Test Preparation on Performance of Large-Scale Educational Tests: A Meta-analysis of Experimental Studies. Review of Educational Research.

- Karpicke, J. D. (2008). The critical importance of retrieval for learning.

- Sweller, J. Cognitive load theory and worked-example research.

- Renkl, A., & Atkinson, R. K. (2003). Structuring the transition from example study to problem solving.

- Hardison, C. M., & Sackett, P. R. (2008). Use of writing samples on standardized tests: Susceptibility to rule-based coaching.

- Kalyuga, S., Ayres, P., Chandler, P., & Sweller, J. (2003). The expertise reversal effect.

- Hausknecht et al. (2007). Retesting in selection: A meta-analysis of coaching and practice effects.

#### Academic Research — AI Essay Grading

- Tate, T. P., Steiss, J., Bailey, D., Graham, S., Moon, Y., Ritchie, D., Tseng, W., & Warschauer, M. (2024). Can AI provide useful holistic essay scoring? Computers and Education: Artificial Intelligence, 7, Article 100255.

- Seßler, K., Fürstenberg, M., Bühler, B., & Kasneci, E. (2025). Can AI grade your essays? A comparative analysis of large language models and teacher ratings in multidimensional essay scoring. LAK 2025.

- Seßler, K., et al. (2025). Do we need a detailed rubric for automated essay scoring using large language models?

- Zacharis, G., & Papadakis, S. (2025). Can AI grade like a human? Validity, reliability, and fairness in university coursework assessment. Educational Process: International Journal, 19, e2025591.

- QwenScore+ (2026). Explainable AI for Education: Enhancing Essay Scoring via Rubric-Aligned Chain-of-Thought Prompting.

- LLM Agents at the Roundtable (2025). Multi-perspective dialectical reasoning framework for essay scoring.

#### AP Teacher Practice

- Sinica Education AP tutoring methodology (command-verb decoding, scoring precision).

- teachingapscience.com (peer-grading practices, FRQ teaching in AP science classrooms).

- Sparkl AP tutoring methodology (rubric language internalization).

- Fitchburg State University AP Summer Institute teacher materials.

#### Competitive Scan

- Fiveable AI Transparency disclosure (March 2026). fiveable.me/ai-transparency

- EssayGrader.ai feature documentation. essaygrader.ai

- GraderAI / ai-essay-grader.com feature documentation.

- GPTZero AI-detection technology and writing-replay feature. gptzero.me

- CoGrader feature documentation. cograder.com

#### Cramapple Internal

- CRAMAPPLE_VISION.md (v0.2, June 2026) — Sections 5, 6, 7, 8 inform this document.

- PEDAGOGY.docx — research foundation for retrieval, spacing, interleaving, metacognition, AI tutoring.

- Blueprint_Teaching (draft, June 2026) — D→E→P scaffold and Logic-Gap Protocol referenced in Tighten mode.

- COMPETITORS.docx — consumer AP prep competitive landscape (Fiveable, Albert, Kaplan, Khan).

- ECONOMICS.docx — pricing and unit economics that constrain inference cost per Repair.

*Document owner: David Bloom, CEO and Product Owner. Curriculum authority: Orly Bloom, VP Learning.*

*Next review: After expert pedagogy review and the first grading-validation runs against the complete metric suite.*
