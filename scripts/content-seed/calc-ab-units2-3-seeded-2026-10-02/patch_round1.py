#!/usr/bin/env python3
"""Round-1 patch (2026-10-02): five hand-verified rationale/choice defects found by the two-model audit. Applied IN PLACE to the exported
JSON (letters are fixed) and mirrored into units23.py as a record. Each substitution must match exactly once per file."""
import json, sys
SUBS = [
 ("Has the correct slope −1/4 but takes (2, 2) as the point of tangency, swapping the coordinates of (2, 1/2).",
  "Has the correct slope −1/4 but uses 2 as the y-coordinate of the point of tangency instead of 1/2."),
 ("Subtracts f(h) = h³ where f(2) = 8 belongs. The quotient is (8 + 12h + 6h²)/h, which grows without bound, so the limit does not exist.",
  "Subtracts f(h) = h³ where f(2) = 8 belongs. The quotient is (8 + 12h + 6h²)/h, which tends to +∞ as h → 0⁺ and to −∞ as h → 0⁻, so the limit does not exist."),
 ("Subtracts V(h) = 4h² where V(5) = 100 belongs. The quotient is (100 + 40h)/h, which grows without bound, so the limit does not exist.",
  "Subtracts V(h) = 4h² where V(5) = 100 belongs. The quotient is (100 + 40h)/h, which tends to +∞ as h → 0⁺ and to −∞ as h → 0⁻, so the limit does not exist."),
 ("Uses −cos(3x) as the derivative of sin(3x) (sign error).",
  "Uses −3cos(3x) as the derivative of sin(3x): keeps the inner factor 3 but gets the sign wrong."),
 ("h is continuous at x = 1 but not differentiable there because the one-sided derivatives differ.",
  "h is continuous at x = 1 but not differentiable there because the slopes of the two pieces differ."),
 ("h is not continuous at x = 1 (left limit 1, h(1) = 3), so the first claim is false; the one-sided derivatives 2 and 1 are not what decides this.",
  "h is not continuous at x = 1 (left limit 1, h(1) = 3), so the first claim is false. Comparing the slopes of the two pieces is not the test: the jump already rules out differentiability."),
]
for f in sys.argv[1:]:
    s = open(f).read(); n_total = 0
    for old, new in SUBS:
        a = json.dumps(old, ensure_ascii=False)[1:-1] if f.endswith(".json") else old
        b = json.dumps(new, ensure_ascii=False)[1:-1] if f.endswith(".json") else new
        c = s.count(a)
        if f.endswith("units23.py") and c != 1: raise SystemExit(f"{f}: expected 1 match, got {c} for {old[:50]!r}")
        s = s.replace(a, b); n_total += c
    open(f, "w").write(s); print(f, "substitutions:", n_total)
