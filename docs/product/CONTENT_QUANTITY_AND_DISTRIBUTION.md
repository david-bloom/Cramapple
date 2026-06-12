# Cramapple Content Quantity and Distribution

**Status:** Approved direction; Learning Quality review and delivery planning remain
**Owner:** Orly Bloom, Learning Quality Owner
**Decision Owner:** David Bloom, Product Owner
**Related Task:** TASK-0005 / CONTENT-001A
**Date:** 2026-06-12

## Purpose

This document defines the initial AP Biology question-bank quantity target and
the inventory-counting rule. It corrects the earlier Claude analysis, which used
an incorrect 48-topic total and contained an internally inconsistent unit table.

The current official AP Biology Course and Exam Description contains 60 topics
across eight units. Cramapple uses those official public topic identities as its
content-coverage taxonomy. Official question text and scoring material remain
excluded from authoring and AI-versioning inputs.

Source:
[AP Biology Course and Exam Description, Course Framework V.1, 2025](https://apcentral.collegeboard.org/media/pdf/ap-biology-course-and-exam-description.pdf).

## Inventory Unit

One inventory item is:

- one MCQ; or
- one independently delivered and answered FRQ prompt.

A stimulus, scenario, rubric criterion, answer choice, subpart, teaching
explanation, transfer item, or complete package does not create an additional
inventory count unless it is delivered as a separate MCQ or FRQ prompt.

Every counted item still requires its complete governed rubric and teaching
package. Inventory count measures learner-facing question capacity, not
authoring workload.

## Approved Planning Targets

For each of the 60 official topics:

- at least 10 approved MCQs;
- at least 5 approved short-FRQ prompts.

For each of the eight units:

- four long-FRQ stimulus packages;
- two independently deliverable long-FRQ prompts per package;
- eight counted long-FRQ prompts per unit.

These are planning targets Cramapple will work to meet or exceed. They are not
an automatic claim that every target will be complete at beta launch. Any
shortfall must be visible in the coverage matrix and included in the Product
Owner's launch decision.

## Corrected Bank Size

| Inventory type | Calculation | Initial target |
| --- | --- | ---: |
| MCQs | 60 topics x 10 | 600 |
| Short-FRQ prompts | 60 topics x 5 | 300 |
| Long-FRQ prompts | 8 units x 4 packages x 2 prompts | 64 |
| **Total** |  | **964** |

The earlier Claude total of 784 was incorrect because it used 48 topics.

A possible mature-bank target of 15 MCQs and 10 short-FRQ prompts per topic,
while retaining 64 long-FRQ prompts, would contain 1,564 inventory items. That
mature quantity is a planning scenario, not yet a separate release requirement.

## Unit Distribution

| Unit | Official topics | MCQs | Short FRQs | Long FRQs | Total |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1. Chemistry of Life | 7 | 70 | 35 | 8 | 113 |
| 2. Cells | 10 | 100 | 50 | 8 | 158 |
| 3. Cellular Energetics | 5 | 50 | 25 | 8 | 83 |
| 4. Cell Communication and Cell Cycle | 6 | 60 | 30 | 8 | 98 |
| 5. Heredity | 5 | 50 | 25 | 8 | 83 |
| 6. Gene Expression and Regulation | 8 | 80 | 40 | 8 | 128 |
| 7. Natural Selection | 12 | 120 | 60 | 8 | 188 |
| 8. Ecology | 7 | 70 | 35 | 8 | 113 |
| **Total** | **60** | **600** | **300** | **64** | **964** |

## Official Topic Coverage Matrix

The MCQ and short-FRQ target applies independently to every row.

| Topic | Official topic name | MCQ target | Short-FRQ target |
| --- | --- | ---: | ---: |
| 1.1 | Structure of Water and Hydrogen Bonding | 10 | 5 |
| 1.2 | Elements of Life | 10 | 5 |
| 1.3 | Introduction to Macromolecules | 10 | 5 |
| 1.4 | Carbohydrates | 10 | 5 |
| 1.5 | Lipids | 10 | 5 |
| 1.6 | Nucleic Acids | 10 | 5 |
| 1.7 | Proteins | 10 | 5 |
| 2.1 | Cell Structure and Function | 10 | 5 |
| 2.2 | Cell Size | 10 | 5 |
| 2.3 | Plasma Membrane | 10 | 5 |
| 2.4 | Membrane Permeability | 10 | 5 |
| 2.5 | Membrane Transport | 10 | 5 |
| 2.6 | Facilitated Diffusion | 10 | 5 |
| 2.7 | Tonicity and Osmoregulation | 10 | 5 |
| 2.8 | Mechanisms of Transport | 10 | 5 |
| 2.9 | Cell Compartmentalization | 10 | 5 |
| 2.10 | Origins of Cell Compartmentalization | 10 | 5 |
| 3.1 | Enzymes | 10 | 5 |
| 3.2 | Environmental Impacts on Enzyme Function | 10 | 5 |
| 3.3 | Cellular Energy | 10 | 5 |
| 3.4 | Photosynthesis | 10 | 5 |
| 3.5 | Cellular Respiration | 10 | 5 |
| 4.1 | Cell Communication | 10 | 5 |
| 4.2 | Introduction to Signal Transduction | 10 | 5 |
| 4.3 | Signal Transduction Pathways | 10 | 5 |
| 4.4 | Feedback | 10 | 5 |
| 4.5 | Cell Cycle | 10 | 5 |
| 4.6 | Regulation of Cell Cycle | 10 | 5 |
| 5.1 | Meiosis | 10 | 5 |
| 5.2 | Meiosis and Genetic Diversity | 10 | 5 |
| 5.3 | Mendelian Genetics | 10 | 5 |
| 5.4 | Non-Mendelian Genetics | 10 | 5 |
| 5.5 | Environmental Effects on Phenotype | 10 | 5 |
| 6.1 | DNA and RNA Structure | 10 | 5 |
| 6.2 | DNA Replication | 10 | 5 |
| 6.3 | Transcription and RNA Processing | 10 | 5 |
| 6.4 | Translation | 10 | 5 |
| 6.5 | Regulation of Gene Expression | 10 | 5 |
| 6.6 | Gene Expression and Cell Specialization | 10 | 5 |
| 6.7 | Mutations | 10 | 5 |
| 6.8 | Biotechnology | 10 | 5 |
| 7.1 | Introduction to Natural Selection | 10 | 5 |
| 7.2 | Natural Selection | 10 | 5 |
| 7.3 | Artificial Selection | 10 | 5 |
| 7.4 | Population Genetics | 10 | 5 |
| 7.5 | Hardy-Weinberg Equilibrium | 10 | 5 |
| 7.6 | Evidence of Evolution | 10 | 5 |
| 7.7 | Common Ancestry | 10 | 5 |
| 7.8 | Continuing Evolution | 10 | 5 |
| 7.9 | Phylogeny | 10 | 5 |
| 7.10 | Speciation | 10 | 5 |
| 7.11 | Variations in Populations | 10 | 5 |
| 7.12 | Origins of Life on Earth | 10 | 5 |
| 8.1 | Responses to the Environment | 10 | 5 |
| 8.2 | Energy Flow Through Ecosystems | 10 | 5 |
| 8.3 | Population Ecology | 10 | 5 |
| 8.4 | Effect of Density on Populations | 10 | 5 |
| 8.5 | Community Ecology | 10 | 5 |
| 8.6 | Biodiversity | 10 | 5 |
| 8.7 | Disruptions in Ecosystems | 10 | 5 |

## Coverage and Exam Weighting

The bank target is topic-complete rather than proportional to exam weighting.
Exam weighting governs practice-exam assembly and recommendation priority, not
whether a lower-weight topic deserves enough inventory for focused study.

Each item has one primary official topic and may have additional topic, science
practice, task, representation, difficulty, and intended-use tags. Only the
primary topic receives inventory credit for the topic target.

## Launch and Reporting Rule

Before beta or production launch, report:

- approved inventory against target by topic and question form;
- diagnostic-candidate inventory by topic;
- representation, difficulty, science-practice, and task coverage;
- incomplete topics and the learner experience affected by each gap;
- authoring and validation throughput required to close the gaps.

The Product Owner may approve a launch below the planning target after Learning
Quality review. A launch exception does not lower or redefine the target.
