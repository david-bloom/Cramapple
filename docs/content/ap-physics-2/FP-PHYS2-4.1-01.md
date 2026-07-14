# Fact Pack FP-PHYS2-4.1-01 — DC Circuits: Ohm's Law and Power

**Pack ID:** FP-PHYS2-4.1-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** PHYS2
**Applies to:** [PHYS2]
**Unit / Topic:** Electric Circuits — Ohm's law, series/parallel resistance, and
electrical power *(confirm exact official unit/topic id against the current AP
Physics 2 CED before Approved)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — established public-domain physics in
original wording
**Status note:** Illustrative Draft. NOT production content, NOT calibration
evidence.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4.

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

In a DC circuit, voltage drives current through resistance. Ohm's law relates the
three. In a **series** connection the same current flows through each element and
resistances add; in a **parallel** connection each branch has the same voltage and
the reciprocals of resistance add. Power is the rate at which electrical energy is
delivered or dissipated.

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- **Ohm's law:** `V = I·R`.
- **Power:** `P = I·V = I²·R = V²/R`.
- **Series:** `R_total = R₁ + R₂ + …`; current is the same in each element.
- **Parallel:** `1/R_total = 1/R₁ + 1/R₂ + …`; voltage is the same across each
  branch.

### E3 — method `teaching_after_attempt` (grading_only, authoring_brief)

Ordered procedure:

```text
1. Identify series vs. parallel groupings; reduce to an equivalent resistance.
2. Use V = I·R on the whole circuit to find total current.
3. Work back into the network: same current in series, same voltage in parallel.
4. Use P = I·V (or I²R, V²/R) for power where asked.
5. Check units (V, A, Ω, W).
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** series and parallel resistance rules are swapped.
- **Response signal:** adds reciprocals for a series circuit, or sums resistances
  directly for a parallel circuit.
- **Discriminating probe:** ask whether the current or the voltage is shared.
- **Repair move:** "Series adds resistances (same current); parallel adds
  reciprocals (same voltage)."
- **Minimum fix:** apply the correct combination rule for the topology.

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the student believes current is "used up" and is
  smaller after a resistor in a simple series loop.
- **Response signal:** assigns different currents to elements in one series loop.
- **Repair move:** "Current is the same everywhere in a single series loop; it is
  the voltage that drops across each resistor."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "equivalent resistance combined correctly"

- **Required evidence:** the response reduces the network with the correct
  series/parallel rule before applying Ohm's law.
- **Accepted:** any correct reduction consistent with the circuit topology.
- **Insufficient:** a numeric answer using the wrong combination rule; treating a
  parallel branch as series or vice versa.

## Views

- **authoring_view:** E1–E6, full fields.
- **learner_view:** E1, E2, E3 (post-attempt); excludes E4–E6 pre-attempt.
- **grading_view:** E2, E4, E5, E6.
