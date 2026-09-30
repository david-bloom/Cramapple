# REFERENCE EXAMPLE ONLY (not built). Shows the exact shape every variant file must follow.
from sympy import symbols, limit, sqrt, Rational, oo
from vlib import M, fmt

x, h = symbols("x h", real=True)

VARIANTS = [
    # Original 018: filling a hole left by a cube difference (x^3 - 8)/(x - 2), answer 12.
    # This variant changes the numbers (x^3 - 27)/(x - 3) AND the context (a per-unit cost model).
    M("018-v1", "018", "easy", "Continuous Unit Cost at a Production Level",
      "A company models its cost per unit, in dollars, when q hundred units are made as C(q) = (q^3 - 27)/(q - 3) for q != 3, and C(3) = m. For what value of m is C continuous at q = 3?",
      ("27",
       "Since q^3 - 27 = (q - 3)(q^2 + 3q + 9), C(q) = q^2 + 3q + 9 for q != 3. As q approaches 3 this approaches 9 + 9 + 9 = 27, and continuity requires m to equal that limit."),
      [("18",
        "This factors q^3 - 27 as (q - 3)(q^2 + 9), dropping the middle term 3q. Expanding (q - 3)(q^2 + 9) gives q^3 - 3q^2 + 9q - 27, not q^3 - 27."),
       ("0",
        "Substituting q = 3 gives 0 in the numerator, but the denominator is also 0. The form 0/0 is indeterminate, so the limit must be found by simplifying first."),
       ("No such value of m exists.",
        "The denominator is 0 at q = 3, but the factor q - 3 cancels. The limit exists, so a value of m matching it does exist.")],
      calc=lambda: fmt(limit((x**3 - 27) / (x - 3), x, 3)),
      wrong_calcs=[lambda: fmt(limit((x - 3) * (x**2 + 9) / (x - 3), x, 3)), None, None],
      change="numbers: 8 and 2 -> 27 and 3; context: pure function -> per-unit production cost"),
]
