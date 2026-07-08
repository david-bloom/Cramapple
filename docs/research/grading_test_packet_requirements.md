# Grading Test Packet Requirements

**Status:** draft operational standard
**Audience:** AI preparing grading-test packets for review or execution
**Purpose:** define the minimum information required to assemble a valid grading test packet without forcing the reviewer to restate fixed boilerplate

## 1. Purpose

This document defines what must exist before a grading test can be prepared.
It is written so an AI packet-preparer can:

- assemble a complete packet from a compact request,
- ask only for the details that actually vary by test, and
- keep the rest of the packet standardized.

The packet-preparer should only need clarification on:

1. how questions are distributed by type,
2. how questions are distributed by difficulty,
3. how questions are distributed by module,
4. which subject the packet is for, and
5. any special instructions.

If any of those are missing, the AI should ask for them before generating the packet.

## 2. Packet Definition

A grading test packet is the complete, machine-usable set of inputs needed to run one grading experiment.
It must contain:

- a subject scope,
- a question inventory,
- a distribution plan,
- a rubric or contract reference,
- the expected input format for each item,
- the scoring or evaluation target,
- any special handling rules, and
- an execution-ready manifest.

The packet is not complete until all required fields below are present.

## 3. Required Inputs

### 3.1 Subject

Required.

The packet must state the subject explicitly.

Examples:

- Biology
- Statistics

If the subject is not known, the packet cannot be prepared.

### 3.2 Question Type Distribution

Required.

The packet must say how many questions belong to each type.

Examples:

- MCQ: 20
- FRQ: 12
- Hand-drawn FRQ: 12

If a subject has a known FRQ subtype taxonomy, the packet should preserve it.

Example:

- FRQ (short): 10
- FRQ (long, investigative_task): 1

If a test includes multiple types, the packet must preserve the per-type counts.

### 3.3 Difficulty Distribution

Required.

The packet must say how questions are distributed across difficulty levels.

Recommended levels:

- Easy
- Medium
- Hard

If the project uses a different taxonomy, the packet must declare it explicitly and use it consistently.

### 3.4 Module Distribution

Required.

The packet must state how questions are distributed across modules or content areas.

Examples:

- Unit 1
- Unit 4
- Unit 7
- Graphical Displays
- Regression

If the subject has a known module taxonomy, the packet should use that taxonomy rather than inventing new labels.

### 3.5 Special Instructions

Required when present.

The packet must capture any special instructions that affect selection, ordering, labeling, validation, or grading behavior.

Examples:

- keep MCQs lookup-table only,
- include boundary cases,
- avoid reused prompts,
- preserve item order,
- exclude rubric text from drawers,
- route ambiguous items for human review,
- use only one response image per item.

If there are no special instructions, the packet should say `none`.

## 4. Standardized Fields

The AI should not ask the user to restate the following unless the defaults are genuinely unknown.

### 4.1 Supported Question Types

Default supported types:

- MCQ
- FRQ
- Hand-drawn FRQ

### 4.2 Default FRQ Subtypes

Use a subtype when it changes how the item should be generated, stored, or graded.

Recommended starting subtypes:

- standard
- investigative_task
- multi_focus

AP Statistics should use `investigative_task` for Question 6-style prompts that intentionally span multiple concepts or stages of reasoning.

### 4.3 Default Difficulty Taxonomy

Default taxonomy:

- Easy
- Medium
- Hard

### 4.4 Default Module Taxonomy

Use the subject-specific module taxonomy already established in the research corpus or prompt library.
If no taxonomy exists, the packet-preparer should request it once and then cache it for later runs.

### 4.5 Default Evaluation Contract

Every item should reference a 4-part grading contract unless a different contract is explicitly required.

Default contract slots:

1. representation or answer form,
2. labels or required contextual identifiers,
3. geometry, values, or evidence placement,
4. completeness or task-specific boundary cue.

If the packet uses another contract shape, the packet must name it explicitly.

## 5. Packet Assembly Rules

The AI preparing the packet should follow these rules:

1. Confirm subject first.
2. Confirm question-type distribution.
3. Confirm difficulty distribution.
4. Confirm module distribution.
5. Capture special instructions.
6. Build the manifest from those values.
7. Fill in all standardized defaults.
8. Ask no extra questions unless a required field is missing or contradictory.

The AI should not ask for fields that can be safely standardized.

## 6. What The AI Should Ask For

The AI should only ask questions when one of these is unknown:

- subject,
- question-type counts,
- difficulty counts,
- module counts,
- special instructions.

If the user has already supplied any of those, the AI should reuse them.

## 7. What The AI Should Not Ask For

The AI should not ask the user to restate:

- file format preferences,
- standard output format,
- generic rubric boilerplate,
- default scoring contract wording,
- standard validation steps,
- standard naming conventions,
- whether the packet should be machine-readable.

Those are controlled by the packet template.

## 8. Minimum Packet Output

A valid packet output must include:

- packet name,
- subject,
- item list or item slots,
- counts by type,
- counts by difficulty,
- counts by module,
- special instructions,
- evaluation contract,
- version or date,
- reviewer-facing notes if needed.

## 9. Review Gate

Before a packet is used for grading, the AI should verify:

- the counts sum correctly,
- the subject matches the intended corpus,
- the module taxonomy is consistent,
- the difficulty buckets are not mixed,
- special instructions are preserved,
- the contract shape matches the intended grading task,
- no item is missing from the manifest.

## 10. Recommended Interaction Pattern

If the user asks for a new grading test packet, the AI should respond with a short form like:

- Subject?
- Question type distribution?
- Difficulty distribution?
- Module distribution?
- Special instructions?

After those are provided, the AI should generate the packet without further back-and-forth unless a contradiction appears.

## 11. User Role Boundary

For content generation for grading experiments, the user's role is limited to:

- procuring hand-drawn responses when a test needs them, and
- answering the five setup questions listed in this document.

The user is not expected to restate packet boilerplate, schema defaults, or standard grading-contract text unless a test intentionally deviates from the default template.
