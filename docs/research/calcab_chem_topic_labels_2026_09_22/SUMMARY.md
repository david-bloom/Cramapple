# AP Calculus AB and AP Chemistry topic-label proposal — overnight run D

## Outcome

Completed a Chemistry-first, 241-item proposal using only the two verified 2026-2027 closed lists. Production remained read-only and no coverage labels were written. Exact valid prompt_json.topic codes were recovered first; all remaining rows were selected from the registry.

## Reproducibility and counts

- Run start / Production snapshot: 2026-09-23T02:16:46.266Z (UTC)
- Run end: 2026-09-23T02:23:32.947Z (UTC)
- Model identifier: Codex GPT-5-class local/in-session
- Production project ref: pcntajvbdfqhbeewmdry
- Filter: latest version_num per content_item_id where status=published and subject_key in (ap-calculus-ab, ap-chemistry)
- AP Calculus AB source version: 33b4408b-0ecc-4c7a-b0b1-612db81164a1 (81 topics)
- AP Chemistry source version: cbe3116f-6ef5-410c-b535-e9fb711c4c2c (91 topics)
- Published items: 241; existing governed coverage labels: 0; count drift: 0
- Recovered: 106; derived: 135; content_disagrees: 0; signal_conflicts: 8
- Split by subject/type: {"ap-calculus-ab frq":{"recovered":20,"derived":42},"ap-calculus-ab mcq":{"recovered":0,"derived":60},"ap-chemistry frq":{"recovered":37,"derived":14},"ap-chemistry mcq":{"recovered":49,"derived":19}}
- Maximum version_num by item: {"apcalcab-frq-001":1,"apcalcab-frq-002":1,"apcalcab-frq-003":2,"apcalcab-frq-004":3,"apcalcab-frq-005":3,"apcalcab-frq-006":3,"apcalcab-frq-007":3,"apcalcab-frq-008":3,"apcalcab-frq-009":3,"apcalcab-frq-010":3,"apcalcab-frq-011":3,"apcalcab-frq-012":4,"apcalcab-frq-015":3,"apcalcab-frq-016":3,"apcalcab-frq-017":1,"apcalcab-frq-018":1,"apcalcab-frq-019":1,"apcalcab-frq-020":1,"apcalcab-frq-022":1,"apcalcab-frq-023":1,"apcalcab-frq-024":2,"apcalcab-frq-025":2,"apcalcab-frq-026":2,"apcalcab-frq-027":1,"apcalcab-frq-028":1,"apcalcab-frq-030":1,"apcalcab-frq-031":1,"apcalcab-frq-032":1,"apcalcab-frq-033":1,"apcalcab-frq-034":1,"apcalcab-frq-035":1,"apcalcab-frq-036":1,"apcalcab-frq-np2-001":1,"apcalcab-frq-np2-002":1,"apcalcab-frq-np2-003":1,"apcalcab-frq-np2-004":1,"apcalcab-frq-np2-005":1,"apcalcab-frq-np2-006":1,"apcalcab-frq-np2-007":1,"apcalcab-frq-np2-008":2,"apcalcab-frq-np2-009":1,"apcalcab-frq-np2-010":1,"apcalcab-frq-u13-001":1,"apcalcab-frq-u13-002":2,"apcalcab-frq-u13-003":1,"apcalcab-frq-u13-004":1,"apcalcab-frq-u13-005":1,"apcalcab-frq-u13-006":2,"apcalcab-frq-u13-007":1,"apcalcab-frq-u13-008":1,"apcalcab-frq-u13-009":1,"apcalcab-frq-u13-010":1,"apcalcab-frq-u13-011":1,"apcalcab-frq-u13-012":1,"apcalcab-frq-u13-013":1,"apcalcab-frq-u13-014":1,"apcalcab-frq-u13-015":1,"apcalcab-frq-u13-016":1,"apcalcab-frq-u13-017":1,"apcalcab-frq-u13-018":2,"apcalcab-frq-u13-019":1,"apcalcab-frq-u13-020":1,"apcalcab-mcq-001":1,"apcalcab-mcq-003":1,"apcalcab-mcq-005":1,"apcalcab-mcq-006":1,"apcalcab-mcq-007":1,"apcalcab-mcq-008":1,"apcalcab-mcq-009":1,"apcalcab-mcq-010":1,"apcalcab-mcq-011":1,"apcalcab-mcq-012":2,"apcalcab-mcq-013":1,"apcalcab-mcq-014":2,"apcalcab-mcq-015":2,"apcalcab-mcq-016":2,"apcalcab-mcq-017":1,"apcalcab-mcq-018":1,"apcalcab-mcq-019":2,"apcalcab-mcq-020":2,"apcalcab-mcq-021":1,"apcalcab-mcq-022":1,"apcalcab-mcq-023":1,"apcalcab-mcq-024":1,"apcalcab-mcq-025":1,"apcalcab-mcq-026":1,"apcalcab-mcq-027":1,"apcalcab-mcq-028":1,"apcalcab-mcq-029":1,"apcalcab-mcq-030":1,"apcalcab-mcq-031":1,"apcalcab-mcq-032":1,"apcalcab-mcq-033":1,"apcalcab-mcq-034":1,"apcalcab-mcq-035":1,"apcalcab-mcq-036":2,"apcalcab-mcq-037":1,"apcalcab-mcq-038":1,"apcalcab-mcq-039":1,"apcalcab-mcq-040":2,"apcalcab-mcq-041":1,"apcalcab-mcq-042":1,"apcalcab-mcq-043":1,"apcalcab-mcq-044":2,"apcalcab-mcq-045":2,"apcalcab-mcq-046":1,"apcalcab-mcq-047":2,"apcalcab-mcq-050":2,"apcalcab-mcq-060":1,"apcalcab-mcq-070":1,"apcalcab-mcq-080":1,"apcalcab-mcq-090":1,"apcalcab-mcq-np2-001":2,"apcalcab-mcq-np2-002":1,"apcalcab-mcq-np2-003":1,"apcalcab-mcq-np2-004":1,"apcalcab-mcq-np2-005":2,"apcalcab-mcq-np2-006":2,"apcalcab-mcq-np2-007":2,"apcalcab-mcq-np2-008":1,"apcalcab-mcq-np2-009":1,"apcalcab-mcq-np2-010":1,"apchem-frq-l-002":2,"apchem-frq-l-003":5,"apchem-frq-l-004":3,"apchem-frq-l-005":4,"apchem-frq-l-006":2,"apchem-frq-l-010":5,"apchem-frq-l-011":4,"apchem-frq-l-012":2,"apchem-frq-l-013":3,"apchem-frq-l-014":4,"apchem-frq-l-016":4,"apchem-frq-l-017":3,"apchem-frq-l-020":2,"apchem-frq-l-021":3,"apchem-frq-l-022":3,"apchem-frq-l-023":3,"apchem-frq-l-024":3,"apchem-frq-l-025":3,"apchem-frq-l-026":3,"apchem-frq-l-027":3,"apchem-frq-l-028":3,"apchem-sfrq-002":3,"apchem-sfrq-003":3,"apchem-sfrq-004":3,"apchem-sfrq-005":4,"apchem-sfrq-007":4,"apchem-sfrq-008":3,"apchem-sfrq-009":3,"apchem-sfrq-010":2,"apchem-sfrq-014":4,"apchem-sfrq-015":4,"apchem-sfrq-016":3,"apchem-sfrq-018":3,"apchem-sfrq-019":3,"apchem-sfrq-021":3,"apchem-sfrq-022":3,"apchem-sfrq-023":3,"apchem-sfrq-024":4,"apchem-sfrq-026":3,"apchem-sfrq-027":4,"apchem-sfrq-028":2,"apchem-sfrq-029":2,"apchem-sfrq-030":4,"apchem-sfrq-031":3,"apchem-sfrq-032":4,"apchem-sfrq-033":3,"apchem-sfrq-034":3,"apchem-sfrq-035":3,"apchem-sfrq-036":3,"apchem-sfrq-037":3,"apchem-sfrq-038":3,"apchem-mcq-001":2,"apchem-mcq-003":2,"apchem-mcq-004":1,"apchem-mcq-005":2,"apchem-mcq-006":2,"apchem-mcq-007":2,"apchem-mcq-008":2,"apchem-mcq-009":1,"apchem-mcq-010":1,"apchem-mcq-011":2,"apchem-mcq-012":3,"apchem-mcq-013":1,"apchem-mcq-014":4,"apchem-mcq-015":1,"apchem-mcq-016":2,"apchem-mcq-017":2,"apchem-mcq-018":3,"apchem-mcq-019":2,"apchem-mcq-020":2,"apchem-mcq-021":2,"apchem-mcq-022":2,"apchem-mcq-023":2,"apchem-mcq-024":3,"apchem-mcq-025":2,"apchem-mcq-026":2,"apchem-mcq-027":2,"apchem-mcq-028":2,"apchem-mcq-029":2,"apchem-mcq-030":4,"apchem-mcq-031":1,"apchem-mcq-032":1,"apchem-mcq-033":3,"apchem-mcq-034":2,"apchem-mcq-035":3,"apchem-mcq-036":1,"apchem-mcq-037":3,"apchem-mcq-038":2,"apchem-mcq-039":3,"apchem-mcq-040":1,"apchem-mcq-041":1,"apchem-mcq-042":3,"apchem-mcq-043":3,"apchem-mcq-044":2,"apchem-mcq-045":1,"apchem-mcq-046":3,"apchem-mcq-047":1,"apchem-mcq-048":1,"apchem-mcq-049":3,"apchem-mcq-051":2,"apchem-mcq-052":2,"apchem-mcq-053":2,"apchem-mcq-054":1,"apchem-mcq-055":3,"apchem-mcq-056":2,"apchem-mcq-057":3,"apchem-mcq-058":1,"apchem-mcq-059":3,"apchem-mcq-060":1,"apchem-mcq-061":2,"apchem-mcq-062":3,"apchem-mcq-063":3,"apchem-mcq-064":1,"apchem-mcq-065":1,"apchem-mcq-066":2,"apchem-mcq-067":2,"apchem-mcq-068":4,"apchem-mcq-069":3,"apchem-mcq-070":2}

## Measured invariants

| Invariant | Measured result |
| --- | ---: |
| Every item has exactly one proposed_topic_code | 241 / 241 |
| Every proposed code exists in the stated closed list | 0 invalid |
| proposed_unit matches registry topic unit | 0 mismatches |
| Recovered code equals parsed prompt_json.topic | 0 failures |
| Recovered rows reconcile to expected counts | 106 |
| Items outside the two subjects | 0 |
| Packet differences from Production at extraction | 0 |

## Lowest-confidence sampling handle

1. apcalcab-mcq-045 — low; The stem/rubric centers on numerical reasoning from a differential equation when the registry omits the author signal 7.5, which most directly matches Reasoning Using Slope Fields. Runner-up 7.7. Author signal conflict.
2. apcalcab-mcq-046 — low; The stem/rubric centers on a population differential-equation model when the registry omits the author signal 7.9, which most directly matches Exponential Models with Differential Equations. Runner-up 7.1. Author signal conflict.
3. apcalcab-mcq-050 — low; The stem/rubric centers on an applied definite integral for arc length when the registry omits the author signal 8.13, which most directly matches Using Accumulation Functions and Definite Integrals in Applied Contexts. Runner-up 8.4. Author signal conflict.
4. apcalcab-frq-015 — low; The stem/rubric centers on volume of revolution about the x-axis, which most directly matches Volume with Disc Method: Revolving Around the x- or y-Axis. Runner-up 8.12.
5. apcalcab-frq-025 — low; The stem/rubric centers on selecting among algebraic, trigonometric, infinite-limit, squeeze, and IVT procedures, which most directly matches Selecting Procedures for Determining Limits. Runner-up 1.16.
6. apcalcab-frq-026 — low; The stem/rubric centers on selection among product, inverse, chain, and quotient derivative procedures, which most directly matches Selecting Procedures for Calculating Derivatives. Runner-up 2.8.
7. apchem-sfrq-008 — low; The stem/rubric centers on molar solubility in pure water and with a common ion, which most directly matches Common-Ion Effect. Runner-up 7.11.
8. apchem-sfrq-029 — low; The stem/rubric centers on Mg(OH)2 solubility and the common-ion effect, which most directly matches Common-Ion Effect. Runner-up 7.11.
9. apcalcab-frq-008 — medium; The stem/rubric centers on net accumulation from inflow minus outflow and intervals of increase, which most directly matches Using Accumulation Functions and Definite Integrals in Applied Contexts. Runner-up 6.5. Author signal conflict.
10. apchem-sfrq-007 — medium; The stem/rubric centers on the ΔG=ΔH−TΔS favorability crossover, which most directly matches Gibbs Free Energy and Thermodynamic Favorability. Runner-up 9.1. Author signal conflict.

## Judgment calls

- Valid author codes were retained unless content plainly disagreed; none of the 106 recovered rows showed a plain content mismatch.
- Exact topic hints in modules/taxonomy_refs were treated as corroboration, not recovery, and were accepted only when the code exists in the current closed list and the content agrees.
- Author hints 7.5 (Euler method), 7.9 (logistic model), and 8.13 (arc length), plus Chemistry 7.13, are absent from the supplied closed lists. The proposal selects the nearest permitted topic, marks low confidence, records an alternative, and requires human review.
- Multi-topic FRQs were assigned to the topic most emphasized by the rubric; genuine adjacent-topic ties carry an alternative and needs_human=true.
- Eight unit/topic-level conflicts were resolved from assessed content and the current closed lists rather than weaker legacy signals; every conflict is flagged and requires human review.

## Open questions

- **D-001 — apcalcab-frq-003:** proposed 4.2; author unit/topic signal conflicts with closed-list selection Disposition: Independent QA and Product Owner review required before use.
- **D-002 — apcalcab-frq-004:** proposed 4.6; author unit/topic signal conflicts with closed-list selection Disposition: Independent QA and Product Owner review required before use.
- **D-003 — apcalcab-frq-008:** proposed 8.3 vs 6.5; author unit/topic signal conflicts with closed-list selection Disposition: Independent QA and Product Owner review required before use.
- **D-004 — apcalcab-frq-015:** proposed 8.9 vs 8.12 Disposition: Independent QA and Product Owner review required before use.
- **D-005 — apcalcab-frq-025:** proposed 1.7 vs 1.16 Disposition: Independent QA and Product Owner review required before use.
- **D-006 — apcalcab-frq-026:** proposed 3.5 vs 2.8 Disposition: Independent QA and Product Owner review required before use.
- **D-007 — apcalcab-mcq-016:** proposed 8.1; author unit/topic signal conflicts with closed-list selection Disposition: Independent QA and Product Owner review required before use.
- **D-008 — apcalcab-mcq-045:** proposed 7.4 vs 7.7; author unit/topic signal conflicts with closed-list selection Disposition: Independent QA and Product Owner review required before use.
- **D-009 — apcalcab-mcq-046:** proposed 7.8 vs 7.1; author unit/topic signal conflicts with closed-list selection Disposition: Independent QA and Product Owner review required before use.
- **D-010 — apcalcab-mcq-050:** proposed 8.3 vs 8.4; author unit/topic signal conflicts with closed-list selection Disposition: Independent QA and Product Owner review required before use.
- **D-011 — apchem-sfrq-007:** proposed 9.3 vs 9.1; author unit/topic signal conflicts with closed-list selection Disposition: Independent QA and Product Owner review required before use.
- **D-012 — apchem-sfrq-008:** proposed 7.12 vs 7.11 Disposition: Independent QA and Product Owner review required before use.
- **D-013 — apchem-sfrq-029:** proposed 7.12 vs 7.11; invalid original 7.13 Disposition: Independent QA and Product Owner review required before use.

## QA handoff

This is a proposal requiring independent AI cross-model QA and Product Owner approval under DECISION-0055 before any label serves. No qa_findings.csv or qa_report.md was created. Production was read-only.
