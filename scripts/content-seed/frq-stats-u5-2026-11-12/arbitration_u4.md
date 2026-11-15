# Unit 4 seed arbitration, round 1 (2026-11-12). All ten seeds were flagged; one patch loop at library level.
Rulings (each applied to the pattern library so seeds and variants inherit):
- XBAR_PROB (4.1, 4.6, GPT): ACCEPT. Criterion prescribed a z-score; now accepts a direct normal calculation.
- PROC_ID (4.2, 4.4, 4.7, 4.9, GPT+DeepSeek): ACCEPT. An Identify part must not require a reason; criterion now only names the procedure. Dropped from 4.2 and 4.7 (criteria cap) where the prompt now asks only for conditions.
- COND_RANDOM bundled randomization with the 10% condition (GPT+DeepSeek): ACCEPT. Split into COND_RANDOM and COND_TEN. 4.7/4.9 variants rewritten from experiments to independent random samples so the 10% check applies.
- Population wording (4.2 both checkers; 4.4 GPT): ACCEPT. Parameters now name the sampled population (checkouts this month; cans filled in the shift; company's bulbs in stores).
- 4.2 part (c) interpretation belongs to 4.3 (GPT): ACCEPT. Replaced by the 4.2.A t versus z critical value explanation (T_STAR). 4.7 (c) likewise replaced by the 4.7.C point estimate (POINT_EST).
- CI_WIDTH required a larger t* only (4.3, 4.8 GPT): ACCEPT. Now accepts the higher-confidence reasoning; fix made concrete.
- P_INTERPRET 'a mean gain greater than 0' misstated the extreme region (4.5 both checkers): ACCEPT. Now states the sample result 'or greater' (or either direction).
- TEST_STAT bundled the test statistic with df, and 4.10 required a given df (4.5, 4.10): ACCEPT. Test statistic only.
- P_DECISION fix said reject only when p < alpha (4.5, 4.10 GPT): ACCEPT. 'less than or equal to'.
No flag was rejected.

# Round 2 (second patch loop; a deviation from the one-loop policy, flagged in the report). Flagged: 4.1, 4.5, 4.7, 4.9, 4.10; five others accepted.
- 4.1 DeepSeek: its own solution omitted independence; rubric correct. Part (b) prompt now says 'by checking the conditions' so the ask is explicit. (Edit = new draft, re-checked.)
- 4.5, 4.10 GPT, p-value interpretation: ACCEPT. A test-statistic form (t at least about 2.86) is equivalent; the extreme-region text now states both.
- 4.7 GPT, point estimate: ACCEPT. Evidence no longer requires showing the subtraction.
- 4.9 GPT, group sizes for the 10% condition: ACCEPT. Stems now state the group populations (thousands of fields per fertilizer; 200 students per method).
- 4.10 GPT, conclusion beyond the students studied: ACCEPT. Random assignment without random sampling: conclusion now limited to the students in the study; null worded as no treatment effect.

# Variant diff-check round 1 (7 of 10 accepted first pass; 4.4, 4.6, 4.8 flagged: all real defects introduced by the changed context)
- 4.4 variant: parameter said all clinic patients but the sample came from this month's patients (both checkers). ACCEPT: parameter restricted to patients seen this month.
- 4.6 variant: 'exceeds by less than 2' means 0 < difference < 2, the rubric computed difference < 2 (both checkers, recomputed 0.0355 vs 0.0369). ACCEPT: prompt reworded to 'the difference is less than 2 minutes' (variant only; the accepted parent is unchanged).
- 4.8 variant: causal wording ('the program does not change') in an observational comparison (both checkers). ACCEPT: claim reworded to 'have the same mean'.
