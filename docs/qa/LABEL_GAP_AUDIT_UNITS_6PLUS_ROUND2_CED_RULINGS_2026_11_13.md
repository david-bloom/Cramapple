# Label gap fill Units 6+, round 2: CED-text rulings on the vote splits (2026-11-13)

Owner approved in chat ("Yes, arbitrate", 2026-11-13). Reviewed 14 items (9 two-way ties, 5 below 5 of 6 votes). Ruled and written: **13**. Left unlabeled: `apchem-frq-l-026` (CED reading: 8.9, but its stored label is held for `rubric_preflight_failure`, which stays held pending an owner decision; I had counted it among the ties in the Stage 3 report because the hold check had not run for it).
Rules: item text and part prompts read against the topic text in `docs/product/*_CED_FACT_PACK.md`; the topic that the central ask matches wins; required units are those the votes named (or the CED text needs); existing validated cells and labels are never changed (`apphycm-mcq-014` and `-041` already have validated labels: cell only, label untouched). Non-validated cells are replaced by a new validated cell (old cell kept, non-primary, superseded). Voters' reasoning is in `stage3/round2_review.txt`.

| Item | Votes | Ruling | Units | Cell | Label | Reason |
|---|---|---|---|---|---|---|
| APBIO-HDG-2026-GRAPH-010 | {'8.3': 4, '8.4': 2} | **8.4** | [8] | insert | insert_validated | forage biomass as a limiting resource for population size is LO 8.4.A (density and resource availability, carrying capacity); 8.3 covers birth/death rates and growth equations, not asked |
| apcalcab-frq-020 | {'6.5': 2, '6.4': 2} | **6.4** | [2, 5, 6] | replace_nonvalidated (replaces 6.5 x None [provisional_model]) | insert_validated | g is defined as an accumulation function; the tangent line needs g prime from the Fundamental Theorem and g(2), g(x)=3 evaluate it (6.4); only part (c) interprets behavior (6.5) |
| apcalcab-frq-022 | {'8.11': 2, '8.4': 2} | **8.4** | [6, 8] | insert | insert_validated | region between two curves is the base of every part and part (b) asks its area (8.4); the volume parts split between washer (8.11) and cross sections (8.7), so no single volume topic dominates |
| apcalcab-frq-np2-005 | {'6.5': 2, '6.4': 3} | **6.4** | [5, 6] | replace_nonvalidated (replaces 6.5 x None [provisional_model]) | insert_validated | derivative of an accumulation function and evaluating it are FTC work (6.4, parts a and c); only the local-maximum justification (b) is 6.5 behavior |
| apcalcab-frq-np2-006 | {'6.2': 4, '8.2': 2} | **6.2** | [6] | promote_in_place | insert_validated | trapezoidal sum from tabular data is the whole task; trapezoidal approximation sits in 6.2; motion context is only the setting (8.2 would require position-velocity-acceleration reasoning) |
| apchem-frq-l-028 | {'9.8': 4, '9.10': 2} | **9.8** | [4, 9] | insert | insert_validated | galvanic cell anode/cathode, line notation, standard Ecell, net reaction, electron flow are 9.8; Nernst appears in one part (e) only (9.10) |
| apchem-sfrq-029 | {'8.11': 2, '7.11': 2} | **7.11** | [7, 8] | insert | insert_validated | the one calculation is molar solubility from Ksp (7.11); pH effect (8.11) is qualitative (the CED excludes computing solubility as a function of pH) and the common ion is 7.12 |
| apchem-sfrq-031 | {'4.8': 2, '8.1': 2} | **4.8** | [4] | insert | insert_validated | CED 4.8 text: Bronsted-Lowry donor/acceptor, water dual role, conjugate pairs; 8.1 is pH, pOH and Kw, none asked |
| apchem-sfrq-033 | {'8.8': 2, '8.4': 2} | **8.8** | [4, 8] | insert | insert_validated | CED 8.8 text: the conjugate acid reacts with added base and the conjugate base with added acid, which is exactly parts (a) to (c) |
| apphy1-mcq-016 | {'7.3': 2, '7.1': 2} | **7.3** | [7] | insert | insert_validated | CED 7.3: maxima, minima and zeros of displacement, velocity and acceleration in harmonic motion; asks where speed is a maximum |
| apphy2-frq-032 | {'15.3': 2, '15.2': 2} | **15.3** | [15] | insert | insert_validated | CED 15.3: photon emission and absorption match the energy difference between states, represented on energy-level diagrams; reverse-transition absorption is asked |
| apphycm-mcq-014 | {'6.4': 3, '6.3': 2} | **6.4** | [5, 6] | insert | kept (validated) | zero net external torque therefore constant angular momentum is the 6.4 statement; dL/dt = 0 follows |
| apphycm-mcq-041 | {'7.1': 2, '7.2': 2} | **7.2** | [7] | insert | kept (validated) | CED 7.2: omega, period and frequency of a spring oscillator; asks omega = sqrt(k/m) |

## Flags
- `apchem-sfrq-031`: unit on record 8, CED places it in 4.8 (Unit 4 only). Held before (not served), so no served item moves.
- `apcalcab-frq-020` and `apcalcab-frq-np2-005`: provisional cell 6.5 replaced by validated 6.4 (same unit).
- Judgment calls where the CED does not settle it cleanly: `apcalcab-frq-020`, `-np2-005` (6.4 vs 6.5), `apcalcab-frq-022` (8.4 vs 8.11), `apchem-sfrq-029` (7.11 vs 8.11), `apchem-frq-l-028` (9.8 vs 9.10). All stay within one unit, so serving gating is unchanged by the choice.
