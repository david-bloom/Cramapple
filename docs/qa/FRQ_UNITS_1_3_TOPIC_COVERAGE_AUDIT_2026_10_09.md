# FRQ topic coverage audit, Units 1-3, all subjects (2026-10-09)

Read-only audit of Production (`pcntajvbdfqhbeewmdry`). Nothing was written to any database.
Question asked by the Product Owner: which Unit 1-3 topics have no published FRQ, by subject and unit.
"Units 1-3" follows the runbook: Physics 2 = registry units 9-11, Physics C: E&M = 8-10.

## Method
- Population: 572 FRQs with item status `published` and a published version. Topic list: `app.taxonomy_topics` (617 topics, 10 subjects).
- A topic is covered when at least one published FRQ has it as its **primary** topic.
- Primary topic source, in order:
  1. A recorded topic cell (`app.content_item_cells`, active, on the published version): 233 FRQs (Calculus AB 81, Statistics 69, Biology 72, Chemistry 11). Calculus AB's cells are `provisional_model`; Statistics' and Biology's are `validated`.
  2. For the other 339 FRQs: the topic probe from the Units 1-3 runbook, unchanged (`scripts/vercel-gateway-check/subject_label_probe.mjs --mode=serving`). Three families (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol), two samples each, student-visible text only, closed CED topic list. Accepted at 5 of 6. 0 failed calls, 339/339 got six votes. Cost $8.26.
  3. Below 5 of 6: read against the CED topic text where the item could change a "missing" result (6 items, tagged `ced_text_tiebreak` in the evidence); otherwise left without a topic.
- Probe results are an audit only. They were not written as labels or cells.

## Result: topics with no FRQ

```

AP Biology: 10 of 22 Unit 1-3 topics have no FRQ
  Unit 1 (Chemistry of Life): 4 of 7 missing -> 1.2, 1.4, 1.5, 1.6
  Unit 2 (Cells): 4 of 10 missing -> 2.2, 2.4, 2.5, 2.9
  Unit 3 (Cellular Energetics): 2 of 5 missing -> 3.1, 3.3

AP Calculus AB: 11 of 32 Unit 1-3 topics have no FRQ
  Unit 1 (Limits and Continuity): 7 of 16 missing -> 1.1, 1.2, 1.3, 1.4, 1.5, 1.9, 1.12
  Unit 2 (Differentiation: Definition and Fundamental Properties): 4 of 10 missing -> 2.1, 2.2, 2.5, 2.7
  Unit 3 (Differentiation: Composite, Implicit, and Inverse Functions): 0 of 6 missing -> 

AP Calculus BC: 13 of 32 Unit 1-3 topics have no FRQ
  Unit 1 (Limits and Continuity): 8 of 16 missing -> 1.1, 1.2, 1.3, 1.4, 1.5, 1.9, 1.12, 1.15
  Unit 2 (Differentiation: Definition and Fundamental Properties): 4 of 10 missing -> 2.1, 2.3, 2.6, 2.10
  Unit 3 (Differentiation: Composite, Implicit, and Inverse Functions): 1 of 6 missing -> 3.5

AP Chemistry: 18 of 28 Unit 1-3 topics have no FRQ
  Unit 1 (Atomic Structure and Properties): 8 of 8 missing -> 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8
  Unit 2 (Compound Structure and Properties): 5 of 7 missing -> 2.1, 2.2, 2.3, 2.4, 2.5
  Unit 3 (Properties of Substances and Mixtures): 5 of 13 missing -> 3.3, 3.5, 3.8, 3.11, 3.12

AP Physics 1: 8 of 19 Unit 1-3 topics have no FRQ
  Unit 1 (Kinematics): 1 of 5 missing -> 1.1
  Unit 2 (Force and Translational Dynamics): 5 of 9 missing -> 2.1, 2.2, 2.3, 2.4, 2.6
  Unit 3 (Work, Energy, and Power): 2 of 5 missing -> 3.1, 3.3

AP Physics 2: 14 of 21 Unit 1-3 topics have no FRQ
  Unit 9 (Thermodynamics): 4 of 6 missing -> 9.2, 9.3, 9.5, 9.6
  Unit 10 (Electric Force, Field, and Potential): 4 of 7 missing -> 10.1, 10.2, 10.3, 10.4
  Unit 11 (Electric Circuits): 6 of 8 missing -> 11.1, 11.2, 11.3, 11.4, 11.6, 11.7

AP Physics C: E&M: 4 of 13 Unit 1-3 topics have no FRQ
  Unit 8 (Electric Charges, Fields, and Gauss's Law): 3 of 6 missing -> 8.1, 8.2, 8.5
  Unit 9 (Electric Potential): 0 of 3 missing -> 
  Unit 10 (Conductors and Capacitors): 1 of 4 missing -> 10.2

AP Physics C: Mechanics: 11 of 20 Unit 1-3 topics have no FRQ
  Unit 1 (Kinematics): 2 of 5 missing -> 1.1, 1.4
  Unit 2 (Force and Translational Dynamics): 7 of 10 missing -> 2.1, 2.2, 2.3, 2.4, 2.5, 2.7, 2.8
  Unit 3 (Work, Energy, and Power): 2 of 5 missing -> 3.1, 3.5

AP Precalculus: 23 of 44 Unit 1-3 topics have no FRQ
  Unit 1 (Polynomial and Rational Functions): 6 of 14 missing -> 1.1, 1.2, 1.3, 1.4, 1.8*, 1.12
  Unit 2 (Exponential and Logarithmic Functions): 6 of 15 missing -> 2.1, 2.3, 2.4, 2.6, 2.7, 2.9
  Unit 3 (Trigonometric and Polar Functions): 11 of 15 missing -> 3.1, 3.2, 3.3, 3.4, 3.5, 3.8, 3.9, 3.11, 3.12, 3.13, 3.15

AP Statistics: 14 of 40 Unit 1-3 topics have no FRQ
  Unit 1 (Exploring One-Variable Data and Collecting Data): 1 of 13 missing -> 1.1
  Unit 2 (Probability, Random Variables, and Probability Distributions): 2 of 12 missing -> 2.2, 2.7
  Unit 3 (Inference for Categorical Data: Proportions): 11 of 15 missing -> 3.1, 3.4, 3.5, 3.6, 3.8, 3.9, 3.10, 3.11, 3.12, 3.13, 3.14

* = an unresolved FRQ (no 5-of-6 agreement) leans toward this topic
```

Totals: 126 of 271 Unit 1-3 topics have no FRQ.

## Caveats
- Only the primary topic counts. An FRQ that also exercises a second topic does not cover it here.
- Calculus AB coverage rests on `provisional_model` cells, not validated ones.
- AP Precalculus 1.8: the only FRQ leaning there (`apprecalc-frq-np2-010`) mixes three unrelated topics and was left without a primary topic.
- Evidence: `docs/qa/evidence/frq_units13_audit_2026_10_09/` (raw votes per model, resolved primary topics, report JSON).

## Written to Production (APPROVAL-0143, 2026-10-09)
181 of these probe labels (Units 1-3 only) were written as `validated` primary topic cells. Two were held because the
probe topic contradicts the item's unit label: `apcalcbc-frq-u13-015` (3.6 vs Unit 2) and `apprecalc-frq-np2-004`
(3.10 vs Unit 2). Both topics have other FRQs with written cells (`apcalcbc-frq-u13-020`; `apprecalc-frq-015`,
`-034`, `-035`), so the database also shows 126 missing topics.

**Update, same day:** both held items were resolved from the official course and exam description PDFs in `subject packs/` and written: `apcalcbc-frq-u13-015` → 3.6 (parts b-c, 5 of 9 points, are FUN-3.F higher-order derivatives) and `apprecalc-frq-np2-004` → 3.10 (4 of 6 points in Unit 3). 183 cells in total. Their serving labels still give primary unit 2.
