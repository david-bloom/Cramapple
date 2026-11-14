# Rulings: structured explainers, remaining subjects (2026-11-13)
Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro over all 362 reshaped topics. Control: a planted number change in BC 1.1 was flagged by both models.
- 11 sol "table has no separator row" findings (AB 2.1, 2.6, 2.7, 5.2-5.6; BC 7.3; Precalculus 1.12): not defects, renderer convention is first row = header.
- Biology 7.2 (sol): bullets dropped the "because" link. Real; reverted to original prose.
- Biology 7.10 (sol): "then" imposed a sequence. Real; reverted to original prose.
- BC 5.12 (kimi): dropped "Even outside a related-rates or tangent-line problem". Real; restored.
- BC 5.11 (kimi): "may never be shown" weakened the conditional. Real; reverted to original prose.
- Precalculus 1.13 (sol): "Do not describe... or cite..." as blanket prohibition. Not a defect; same prohibition as "not describing ... or citing".
- Re-check of the four fixed topics: both models clean.
Source defect (not changed here): AP Calculus AB 5.6 (and likely 5.7-5.9, 5.11) lost second-derivative primes (f'' reads f').
