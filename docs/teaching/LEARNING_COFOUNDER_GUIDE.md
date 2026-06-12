# Cramapple: The Learning Co-Founder's Guide

*For Orly Bloom | June 2026 | Working Draft v0.1*

---

This document is your orientation to Cramapple's learning system. It explains what students experience, why we built it that way, where the content and quality come from, and what you own as the person responsible for making the teaching actually work.

After reading this, you should be able to explain in your own words why Cramapple will work — and specifically why it will work better than just asking ChatGPT for help.

You'll also get a map to two more detailed design documents at the end. They go deeper than this one, but once you've read this, they'll make sense.

---

## Part 1: The One Premise

Everything in Cramapple follows from one idea:

**The goal is points earned per hour of study time remaining.**

Not mastery. Not comprehensive coverage. Not a good grade on every topic. Just: given the hours a student has left before the exam, what's the fastest way to get them more points?

This sounds obvious when you say it out loud, but most test prep doesn't actually work this way. Khan Academy covers everything. Kaplan follows a curriculum. A tutor teaches whatever the student brings to the session. These approaches have value, but none of them are specifically designed to answer the question: *what is the highest-value thing this particular student could work on in the next hour?*

Cramapple is.

That one premise changes almost every design decision we've made:

- We make students attempt a question **before** we teach them anything, because the attempt tells us exactly where their points are bleeding.
- We grade **criterion by criterion**, not holistically, because the rubric is the map to the points.
- We repair the **specific gap** that lost the point, not the whole topic.
- We track whether the repair **actually stuck** by testing them again later.
- When a student is spending too much time on one hard skill, we offer them a way to **move on and come back**, because one skill consuming an hour might cost them three other skills they could have gained.

Every piece of the system — the learning loop, the teaching interventions, the grading, the escalation when students get stuck — exists to serve that premise. When you're evaluating any part of Cramapple, the question to ask is always: *does this actually help a student earn more points per hour?* If the answer is no, it doesn't belong.

---

## Part 2: What Students Actually Experience

Here's how Cramapple works from inside a real session.

### Meet Maya

Maya is a junior. AP Biology exam in twelve days. She's been studying off and on but she's anxious — she knows she has gaps, she's just not sure which ones matter most. She opens Cramapple and starts a session.

Cramapple runs a quick calibration: a few questions across different topic areas to get a read on where she is. Based on that, it surfaces her highest-value target: **free-response questions on experimental interpretation**. The long FRQs are worth 9 points each, and her calibration suggests she's currently earning about 5. There are 4 points on the table.

She starts.

---

### Step 1: The Cold Attempt

Cramapple shows Maya a question:

> *A researcher treats two groups of bacteria with an antibiotic. Group A is wild-type. Group B carries a mutation in a membrane protein. After 24 hours, Group B shows significantly higher survival rates. Explain how natural selection could account for the difference in survival rates between the two groups.*

> **[EDITORIAL NOTE — before finalizing: clarify that this is not an actual AP Biology FRQ. Real FRQs are multi-part questions — a single stimulus or scenario followed by several sub-questions (a), (b), (c) each testing a different skill. This example is a standalone single-response item used to keep the walkthrough simple. The guide should make that distinction explicit so Orly isn't confused when she encounters actual FRQs, and so she doesn't think Cramapple works question-by-question through a multi-part FRQ as a single unit.]**

The question is just the question. No hint. No guidance. No "here's what the rubric wants." Cramapple tells her the format (written response, complete sentences), how to submit, and nothing else.

This feels counterintuitive — why not help her first? Because **the cold attempt is the most valuable diagnostic tool in the system.** What Maya writes before she's been taught anything tells us exactly what she already knows, where her reasoning breaks down, and what kind of gap we're dealing with. Once we help her, that information is gone. The attempt is contaminated.

Maya writes:

> *"Because Group B has a mutation that protects it from the antibiotic, those bacteria survive and reproduce while Group A dies. Over time, the resistant bacteria take over the population."*

She submits.

---

### Step 2: The Score

Cramapple evaluates her response against the actual rubric criteria, one by one. The rubric for this question has four points:

| Criterion | What it requires | Maya's result |
|---|---|---|
| Identifies variation | States that variation in antibiotic resistance exists in the population *before* treatment | ❌ Missing — she describes the mutation but doesn't establish pre-existing variation |
| Links variation to differential survival | Explains that individuals with the resistance trait survive at higher rates | ✓ Earned |
| Mechanism of heritability | States that resistant bacteria reproduce and pass the trait to offspring | ✓ Earned (implied clearly enough) |
| Change in allele frequency | Explains that the frequency of the resistance trait increases across generations | ❌ Missing |

Maya earned **2 of 4 points**.

The score panel shows her each criterion, what she earned, and what she missed. Not a number and a vague comment. Not "good effort, but missing some detail." The specific criteria, in plain language, with her response as the reference point.

This matters for two reasons. First, it's useful — she knows exactly what cost her points, not just that she didn't do well enough. Second, it's how AP readers actually score FRQs. Every real AP exam response gets evaluated against criteria like this. We're training her to think in rubric criteria, because that's the skill that earns points on exam day.

---

### Step 3: The Diagnosis

Before showing Maya what to do next, Cramapple makes a judgment call about *why* she missed those criteria.

Looking at her response: she understands the outcome of natural selection (resistant bacteria take over the population). But she skipped two steps in the mechanistic chain — variation exists *before* selection acts on it, and allele frequency is the population-level measure of what actually changed. These aren't knowledge gaps, exactly. She knows what natural selection does. She just didn't articulate the mechanism completely.

This is a **Tighten** situation, not a **Show** situation. The difference matters:

- **Tighten** is for when the student has the underlying concept but wrote an incomplete or imprecise response. They need a targeted repair — a push on the specific gap, not a reteach of the whole idea.
- **Show** is for when the student is missing actual knowledge or a method. They need to see how a correct response is built, step by step.

Giving Maya a full worked example of natural selection would treat her like she doesn't understand the concept — she does. What she needs is a focused prompt on the two criteria she missed.

---

### Step 4: The Repair

Cramapple shows her two specific gaps and gives her a focused prompt for each:

**Gap 1 — Variation:** *"You describe the mutation as if it appeared because the antibiotic was present. But natural selection can only act on variation that already existed. How would you rewrite the opening to establish that some bacteria already had this trait before the antibiotic was introduced?"*

**Gap 2 — Allele frequency:** *"You said the resistant bacteria 'take over' — that's the right idea. But the rubric wants the population-level mechanism: what specifically changes across generations? Try to name it."*

She doesn't get the answer. She gets the specific question she needs to answer to earn each criterion. There's a meaningful difference between those two things: the answer ends the thinking, the question restarts it.

She tries again.

---

### Step 5: The Independent Retry

Maya rewrites her response:

> *"Within the bacterial population, there was already variation in antibiotic resistance before treatment began — some individuals carried the membrane mutation and some did not. When the antibiotic was introduced, individuals with the mutation survived at higher rates and reproduced, passing the mutation to offspring. Over successive generations, the frequency of the resistance allele increased in the population."*

All four criteria. She got it.

But Cramapple doesn't just say "great job" and move on. This success after being helped is **provisional**. She got two targeted prompts that pointed directly at the gaps. She's demonstrated she can write the correct response when she knows what she's missing — not that she would have written it independently on the exam.

So Cramapple gives her a **transfer question**. Same skill, different surface content. Not antibiotic resistance — maybe pesticide resistance in insects, or beak variation in birds. No hints. She has to do it cold.

She does. She earns all four criteria on the first try, independently.

*Now* the repair is confirmed.

---

### Step 6: The Lock

Cramapple schedules a check-in. In about 48 hours, it will resurface a question testing the same skill. Not to reteach her — to verify that the improvement survived the gap. If she nails it, the system treats that as strong evidence she's retained it. If she misses it, it reopens the diagnosis without pretending the earlier success didn't happen.

This is called the **Lock** — it's what separates a tutoring session from a learning system. Most tutoring feels good in the moment and fades. The Lock creates a lightweight but real test of whether something actually stuck, and it schedules that test at the right time before the exam.

---

### What Maya experienced

From her perspective: she tried a question, got clear feedback on exactly what she missed, worked on just those pieces, proved she could do it independently on a new question, and has a scheduled return to confirm it stuck. Total time: probably 12–15 minutes. She earned 2 more points on that skill type.

She didn't sit through a lecture on natural selection. She didn't do a worksheet. She didn't read a chapter. She found the specific gap, fixed it, and proved she could do it independently. That's the loop.

---

## Part 3: When Students Get Stuck

The loop in Part 2 works most of the time. But sometimes it doesn't. A student misses the same criteria repeatedly. The repair doesn't transfer. Something deeper is going on.

When that happens, Cramapple escalates.

The instinct most tutors and teachers have when a student is stuck is to explain more — more detail, more slowly, more thoroughly. That instinct is often wrong. Not because the student needs less explanation, but because **more explanation of the same concept doesn't fix a different kind of problem.** There are three distinct reasons a student might keep missing the same thing, and they each need a different response.

---

**Step Sideways — for a persistent misconception**

The student has a stable wrong model. They keep applying it because it feels right to them. More explanation of the correct concept bounces off the wrong model. What works instead is a **contrasting case** — a situation where the wrong model clearly fails, forcing the student to see the contradiction.

*Example:* A student who keeps treating natural selection as intentional ("bacteria developed resistance *in order to* survive") won't be fixed by explaining natural selection again. They need a case that breaks their mental model: what happens to a species when the environment changes faster than they can "try to adapt"? What does that reveal about whether the organism has any say in the matter?

---

**Step Apart — for an integration problem**

The student can do each component of a task correctly in isolation, but falls apart when they have to put it all together. This is a coordination and working memory problem, not a knowledge gap.

*Example:* A student who can correctly identify what a graph is showing, and can correctly apply a statistical reasoning principle, but can't write a coherent response that does both at once. You break the task into pieces, confirm each piece independently, then put it back together on a parallel problem.

---

**Step Down — for a missing foundation**

The student is missing a prerequisite concept that everything else depends on. Explaining the target skill won't work until the foundation is in place.

*Example:* A student who doesn't have a solid model of gene expression trying to answer questions about how mutations affect protein function. You have to go back and build the missing piece before the target skill becomes reachable.

---

**How Cramapple chooses**

Rather than applying these moves in a fixed order, Cramapple uses short diagnostic probes — quick targeted questions designed to distinguish which problem is actually happening. Does the student pass a prerequisite check? Then it's probably not a foundation problem. Do they nail the components in isolation? Then integration is the likely issue.

Cramapple recommends a path, but the student can choose. If Cramapple suggests Step Down and the student says "I understand that, I'd rather try a different angle," that's a valid choice. We track what actually works and adjust. The student is a co-designer of their own repair, not a subject being processed.

When escalation is consuming too much time, the student can choose **Move On** — set the skill aside, continue with the session, come back to it when there's time. One skill running over budget can cost them three others. The exam is a time management problem as much as a knowledge problem.

---

## Part 4: Where Content Comes From

Everything in Parts 2 and 3 depends on one thing being true: **the questions, rubrics, and teaching interventions are actually good.**

A great learning loop with bad content is worse than useless. It teaches students to answer Cramapple's questions rather than AP Biology exam questions. It marks gaps as mastered when they're not. It calibrates students for an exam that doesn't exist.

This section covers where content comes from and how we make sure it's right.

---

### The College Board is the ground truth

AP Biology is defined by the College Board. They publish the Course and Exam Description (CED), which contains the six Science Practices, the learning objectives, the unit structure, and sample questions. They publish released free-response questions every year — with complete scoring guidelines and annotated sample student responses that show exactly why each response earned or missed each criterion.

These materials are the closest thing Cramapple has to a specification. When we write a question, we check it against the CED. When we write a rubric, we align it to how AP readers actually score. When we build a teaching intervention, we look at what the scoring guidelines say about common errors.

There's also a tier of College Board materials behind an access gate — AP Classroom, the Teaching and Assessing AP Biology video modules, AP Summer Institutes. These are available to registered AP teachers. You'll need to get access. The Teaching and Assessing videos in particular are valuable: they show master AP teachers modeling how to teach toward specific Science Practices. That knowledge can't be derived from the public materials alone.

---

### AP tutors and teachers

The College Board tells us *what* the exam tests. Experienced AP Biology tutors and teachers tell us *how students actually fail at it* — the specific misconceptions, the common incomplete responses, the gaps that repeat year after year across hundreds of students.

That pattern knowledge is irreplaceable. No amount of reading the CED gives you the lived experience of watching 200 students answer the same FRQ and seeing the exact ways they miss points.

Cramapple will work with qualified AP Biology tutors to:
- Validate that our questions are testing what we think they're testing
- Review our rubrics for accuracy and completeness
- Identify the most common student errors on each FRQ archetype
- Check that our teaching interventions make sense for the specific errors students actually make

This isn't a one-time review before launch. It's an ongoing relationship. Every time our calibration data shows a pattern we can't explain, a tutor can often tell us immediately why it's happening.

---

### Content Cramapple authors

Most of Cramapple's question bank will be content we create. Released College Board FRQs are valuable but limited — there are only so many of them, and students often see them in class before they reach Cramapple.

We need a library of Cramapple-authored questions that:
- Test the same skills and criteria as official questions
- Are varied enough that students don't see repeating surface content in the repair and lock cycles
- Cover the full range of difficulty — some questions should be achievable, some should push hard
- Include worked examples and rubrics usable in Show mode

This authorship pipeline is partly your work and partly your oversight. You'll set the quality standard, review what's produced, and make the call on what's ready to go in front of real students.

---

### Student-supplied questions

Students can paste in any AP Bio question they're stuck on — from class, a practice test, a prep book — and get teaching tailored to it. This is one of Cramapple's most powerful features and a major way students will find us: they'll share the experience with friends who are stuck on the same question.

These student-supplied questions create a quality challenge. Cramapple is working with content it hasn't seen before, from sources it can't verify. It has to:
- Categorize the question (what skill is this actually testing?)
- Grade the response with appropriate confidence, given it may not have an official rubric
- Teach toward it without pretending more certainty than it has

When confidence is high — because the question closely matches a known type, or because the student's answer makes the gap obvious — the loop runs normally. When confidence is lower, Cramapple says so. It doesn't fake precision it doesn't have.

Some resolved student-supplied questions may eventually become public pages that help other students find Cramapple. That publishing decision is entirely separate from the individual learning interaction, and it requires a quality and safety review before anything goes public.

---

### The quality gate

Not everything that could be a Cramapple question should be. The quality gate asks:

- **Is this aligned with the actual AP Biology exam?** Not just "is it about biology" — does it test a skill and criterion the College Board actually awards points for?
- **Is the rubric accurate?** If we're going to tell a student they missed a criterion, are we right?
- **Is the teaching content valid?** If we show a student how to earn the point, is our worked example actually correct?
- **Has a qualified human reviewed it?** AI can draft content but should not certify itself.

You are the quality gate for Cramapple's content. Not the only reviewer — we'll work with tutors — but the person who sets the standard and makes the final call. Nothing should reach a student session without passing your bar.

---

## Part 5: What Makes Teaching and Grading Good or Bad

Cramapple uses AI to grade student responses and select teaching interventions. Researchers have studied AI grading extensively — it's capable of a quality level that's genuinely useful for formative practice like this. But AI also has predictable failure modes that, left unaddressed, would undermine everything the learning loop is designed to do.

You need to know what these failures look like, because recognizing bad grading and bad teaching is a core part of your job.

---

### The four failure modes of AI grading

Researchers have compared AI essay grading to expert human grading across multiple studies. The results are remarkably consistent. AI grading fails in four specific, predictable ways:

**1. Range compression**

AI grades cluster in the middle. It gives fewer very high scores and fewer very low scores than human graders do. Strong students get underscored; weak students get overscored. The grades become less useful because they're less discriminating.

*What this means for Cramapple:* a student who writes an excellent response should see that clearly. A student who writes a weak one should too. We address this by giving the AI grader anchor examples at each score level — a full-credit response, a mid-range response, a low-credit response — which widens the range it considers when scoring.

**2. Score inflation**

AI grades systematically too high. Across multiple studies, AI scores averaged 2–3 points higher than expert human scores on the same responses. Students get false confidence. Gaps look smaller than they are.

*What this means for Cramapple:* we test for this explicitly before launch. If we see systematic inflation, we calibrate it down before any student sees a score. We can't tell students they've earned points they haven't.

**3. Proportional bias**

The inflation isn't uniform — it's worse for weak students and smaller for strong ones. AI drags everyone toward the middle, over-rewarding students who struggle and slightly shortchanging students who excel.

*What this means for Cramapple:* same fix as range compression — anchor examples and pre-launch calibration. This is a fairness issue. A student who's struggling needs to see clearly that they're struggling so they'll do the work. False generosity isn't kindness; it's a disservice.

**4. Generic, rubric-recycled feedback**

This is the most common AI grading failure in practice. The AI reads the rubric and parrots phrases from it back at the student, without engaging with what the student actually wrote. The feedback sounds relevant but isn't specific. Students feel this — they perceive it as low quality, and they're right.

*What this means for Cramapple:* every piece of feedback must engage with the student's actual response. This is a bug we actively hunt for, not a stylistic preference.

---

### What good feedback looks like

Here's the same criterion miss, handled two ways:

**Generic (bad):**
> "Your response does not fully explain the mechanism of natural selection. Consider including more detail about how traits are passed on and how populations change over time."

**Specific (good):**
> "You named the stressor (the antibiotic) and the outcome (resistant bacteria take over). The rubric awards a point for the population-level mechanism: what specifically changes across generations? The word you're looking for is in your last sentence — you've almost named it."

The good version quotes the student's response, points at the exact location of the gap, and gives a push without giving away the answer. A student reading it knows exactly what to do next. A student reading the generic version knows approximately nothing.

If you read the feedback on a student response and can't tell whether it was generated looking at that student's specific words or copy-pasted from a template, that's a problem.

---

### Human validators

AI grading isn't self-correcting. When the AI makes a consistent mistake, it will keep making that mistake unless a human catches it.

Validators are the humans in Cramapple's quality loop. Their job is to review cases where the grading seems off — where the AI's assessment doesn't match what a qualified person would say. A validator looks at the student's response, the rubric, the AI's evaluation, and the teaching intervention shown, and makes corrections.

Those corrections are valuable: they update the system. A validated correction becomes a reference example. Over time, the AI gets better at the cases that were previously tripping it up.

Who are validators? Initially: you, and the AP Biology tutors we work with. Over time, we'll build a pipeline that samples cases for human review on an ongoing basis, focusing on the cases where the system is least certain.

What triggers a validator review:
- The AI flags that it's uncertain about its own grading
- A student challenges a grade
- The system detects a pattern — a particular question consistently graded much higher or lower than expected
- A tutor spots something during content review

---

### The calibration loop

Cramapple doesn't launch with perfect grading and stay static. It launches with grading good enough to be useful for formative practice, and it gets better from real use.

The improvement cycle:
1. Students attempt questions. AI grades them.
2. Some responses get sampled for expert review. Validators look at them and correct errors.
3. Corrections feed back into rubric packages, teaching content, and AI grading configuration.
4. The system gets better at the specific cases it was getting wrong.

This means the quality of teaching and grading is partly a function of the quality of review. The more accurately validators identify real errors, the faster the system improves. Sloppy validation — approving AI grades that are subtly wrong — doesn't help anyone.

Before launch, there will also be a pre-launch calibration run: we'll grade a set of responses with known scores (from released AP materials and expert-scored work), compare our results, and fix systematic errors before any real student sees them. You'll be part of that process.

---

## Part 6: Your Role as Learning Co-Founder

You have a full life — college applications, a job, everything else — and this document isn't asking you to add a second job on top of it. What it is asking is that you be Cramapple's most important voice on whether the teaching actually works.

Dad handles the operational weight: managing the build, coordinating with engineers, running the business side, and keeping everything moving. Your role is different. It's about expertise and judgment — the things only you can provide because you're close to the subject, close to the age of our students, and close to what good teaching actually feels like. Every area below is a partnership. You bring the judgment; we work through it together.

---

**Content quality**

The most important thing you can do for Cramapple's quality is develop a clear sense of what a good question and a good rubric look like — and say something when something feels off.

That doesn't mean reviewing everything. It means being a reliable voice when content comes across your desk: does this question actually test what it says it tests? Does this feedback make sense to a student? Would a real AP Biology teacher be comfortable with this rubric? You don't need to be the expert on every detail — tutors will handle the deep verification. But your instinct is something no one else on the team has, and it's worth a lot.

In practice, Dad will flag the things that most need your eyes. You respond when you can, with whatever reaction you have — including "this seems fine" and "something feels off, not sure why." Both are useful.

---

**Tutor relationships**

Cramapple needs a small set of AP Biology tutors and teachers who can validate the teaching design and content — people with real classroom experience who know exactly how students fail on each FRQ type.

You don't need to manage these relationships yourself. What you can contribute is your own network and instinct for who would be good. If you know an AP Biology teacher whose class you respected, or a tutor who actually helped you, that's a lead worth sharing. Dad will handle outreach and coordination, but your read on who knows their stuff matters.

---

**Grading calibration**

Before Cramapple launches, we'll run a calibration exercise: grade a set of student responses with known scores, compare our AI results to the right answers, and identify what the AI is getting wrong. You'll participate in that — not as the only reviewer, but as one of the people whose judgment we test against.

This is a contained exercise, not an ongoing daily task. It might be a few sessions of sitting with Dad and going through responses together, saying "this grade seems too high" or "this feedback doesn't address what the student actually wrote." That kind of input — grounded in your sense of what good feedback looks like — is exactly what we need.

After launch, we'll build out a more formal validator pipeline. Your involvement will scale with what makes sense at the time.

---

**Student testing**

Before Cramapple goes live more broadly, real students will try it. You'll help recruit some of those testers — friends, classmates, people you think would give honest reactions — and we'll watch together what happens.

What we're listening for isn't whether they get the right answers. It's:
- Where does the loop feel confusing or frustrating in practice?
- Does the feedback actually tell them what to do differently, or does it feel like noise?
- Are the escalation moves (when students get stuck) helpful, or do they feel arbitrary?
- Would a real student stick with it, or would they bail?

You're the best person in the room to answer those questions, because you're closest to the experience. You don't need to run the session — Dad will do that. Your job is to watch and say what a real student would think.

---

**The quality voice**

After launch, the most durable part of your role is being the person who asks: is this actually helping students earn more points? Not in theory — concretely, for real students working on real skills.

That question will come up in occasional conversations with Dad as we look at how students are using the product. It doesn't require a lot of time, but it requires real engagement — reading what you're shown, reacting honestly, and pushing back when something doesn't seem right. That's the ongoing ask: not a large time commitment, but a genuine one.

---

## Part 7: Reading the System Docs

Two documents go much deeper on what you've read here. They're detailed and technical, written for engineers and product designers — but now that you have the framing, they should be navigable.

---

### LEARNING_SYSTEM.md

This is the main design document for Cramapple's learning loop.

**Sections to prioritize:**
- **Section 3** — the full step-by-step structure of the loop in precise terms, including the diagnostic table (what different error patterns suggest and what the system does about them)
- **Sections 4.1 and 4.2** — Tighten and Show in detail, with examples
- **Section 5.3** — the AI grading failure modes in full technical detail; read this after Part 5 of this document and it will all make sense
- **Section 6** — how each FRQ archetype is handled differently
- **Section 8** — student-supplied questions and the quality gate

**Key terms you'll encounter:**
- *Assessable skill target* — the specific skill being tested, defined narrowly enough to diagnose (e.g., not "natural selection" but "explaining allele frequency change using a population-level mechanism")
- *Cold / Coached / Exam mode* — how much information the student gets before attempting
- *Independent transfer* — success on a new question without any help, as opposed to success right after being coached
- *Lock* — the scheduled delayed check to verify that the repair stuck
- *Content_uncertain* — the flag the system raises when rubric or source evidence is ambiguous and the AI shouldn't update its model of the student

**What to flag:** anything in the teaching interventions or diagnostic logic that doesn't match what you'd expect from a real student experience. The system docs describe intended behavior; you're the check on whether that intended behavior would actually work.

---

### LEARNING_SYSTEM_STUCK.md

This covers the escalation protocol in detail. Read Part 3 of this document first, then the system doc.

**Sections to prioritize:**
- **Sections 2–3** — how the system measures whether a student is actually stuck vs. just having a bad attempt (it's more nuanced than a miss counter)
- **Section 4** — the diagnostic probe logic and how the system picks between Sideways, Apart, and Down
- **Sections 6 and 8** — Move On and Park mechanics, including how the system decides when to resurface a deferred skill given the days remaining before the exam
- **Section 7** — the confirmation ladder: the difference between "got it right after coaching" and "actually retained it"

**What to flag:** the escalation moves are described abstractly in the system doc. If any of them feel like they wouldn't actually help a real student in the situation described, that's worth raising. The tutor review before launch is specifically designed to catch this — your instincts are part of that review.

---

### A note on reading these documents

When something doesn't make sense, the most useful response is a specific question: "In Section 3.4, it says the system does X when it sees Y — why wouldn't it just do Z instead?" That kind of question is exactly the feedback that improves the design. General reactions ("this seems complicated") are harder to act on than specific disagreements.

You'll also notice that the system docs flag a lot of open items — design decisions not yet finalized, thresholds that need calibration, research questions that need answering. Those open items are where your input matters most. You have the judgment to push them forward. That's why you're the Learning Co-Founder.

---

*Document owner: David Bloom. Learning Co-Founder: Orly Bloom.*
*Working Draft v0.1 — June 2026*
