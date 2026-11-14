"""Author mirrored AB/BC implicit-relation behavior questions for topic 5.12."""
from pathlib import Path
import json

H = Path(__file__).resolve().parent
out = ["# AP Calculus AB and BC Unit 5 topic 5.12 — Exploring Behaviors of Implicit Relations", "DRAFT. Author-in-session 2026-11-14. Identical content for separate AB and BC packs. CED FUN-4.D.1, FUN-4.E.1–2."]

def add(family, skill, cases):
    assert len(cases) == 4
    for i, (stem, choices, check, wrong) in enumerate(cases):
        assert len(choices) == 4 and len(wrong) == 3
        ident = f"N-5.12-{family}"
        if i == 0:
            out.extend(["---", f"## Seed {ident} (new) — Topic 5.12 Exploring Behaviors of Implicit Relations", f"**Skill:** {skill}", "", stem, ""])
        else:
            out.extend(["", f"**{ident}-v{i}.** {stem}", ""])
        out.extend([f"- **A. {choices[0]}**", *[f"- {letter}. {choice}" for letter, choice in zip("BCD", choices[1:])], "", f"Check: {check}", "Rationales: " + " ".join(f"{letter}: {reason}" for letter, reason in zip("BCD", wrong))])

cases = []
for a in (1, 2, 3, 4):
    stem = f"For the implicit relation x²+xy+y²={3*a*a}, find all points where its tangent is horizontal. Which reasoning confirms that the derivative is defined at those points?"
    choices = [f"({a},−{2*a}) and (−{a},{2*a}); y'=−(2x+y)/(x+2y), whose denominator is nonzero at both points.", f"({2*a},−{a}) and (−{2*a},{a}); these make the numerator of y' zero.", f"({a},{2*a}) and (−{a},−{2*a}); these make the numerator of y' zero.", f"({a},−{2*a}) only; the negative-x point cannot have a horizontal tangent."]
    check = f"Implicit differentiation gives y'=−(2x+y)/(x+2y). Horizontal tangents require y=−2x and x+2y≠0. Substitution gives 3x²={3*a*a}, so x=±{a} and y=∓{2*a}. The denominator equals −3x, nonzero at both points."
    wrong = ["These are the vertical-tangent points where the denominator is zero, not horizontal tangents.", "The stated points do not satisfy the relation or the zero-numerator condition.", "The equation has both signs of x, and the derivative denominator is nonzero at each resulting point."]
    cases.append((stem, choices, check, wrong))
add("A", "find both horizontal critical points of an implicit relation", cases)

cases = []
for x, y, radius in ((3, 4, 5), (5, 12, 13), (8, 15, 17), (7, 24, 25)):
    r2 = radius*radius
    y3 = y*y*y
    stem = f"On the upper branch of x²+y²={r2}, evaluate d²y/dx² at ({x},{y}) and use its sign to describe the branch's local concavity there."
    choices = [f"d²y/dx²=−{r2}/{y3}; the upper branch is concave down.", f"d²y/dx²=+{r2}/{y3}; the upper branch is concave up.", f"d²y/dx²=−1/{y}; the upper branch is concave down.", f"d²y/dx²=−{x}/{y}; the upper branch is concave down."]
    check = f"From 2x+2yy'=0, y'=−x/y. Differentiating again gives 2+2(y')²+2yy''=0, hence y''=−(x²+y²)/y³=−{r2}/{y3} at ({x},{y}). Because y>0, the branch is concave down."
    wrong = ["The second derivative is negative on the upper half of the circle; this sign is reversed.", "Differentiating y' requires the (y')² term, which produces the circle-radius numerator rather than just 1.", "This is the first derivative y', not the second derivative y''."]
    cases.append((stem, choices, check, wrong))
add("B", "differentiate an implicit circle twice and infer concavity", cases)

cases = []
for a in (1, 2, 3, 4):
    stem = f"Near (0,{a}), the ellipse x²+4y²={4*a*a} defines an upper-branch function y(x). Find y'' at x=0 and use it to classify the point (0,{a}) on that branch."
    choices = [f"y''(0)=−1/{4*a}; (0,{a}) is a local maximum of the upper branch.", f"y''(0)=+1/{4*a}; (0,{a}) is a local minimum of the upper branch.", f"y''(0)=−1/{a}; (0,{a}) is a local maximum of the upper branch.", f"y''(0)=0; (0,{a}) is neither a maximum nor a minimum."]
    check = f"Differentiate to get 2x+8yy'=0, so y'(0)=0. Differentiate again: 2+8[(y')²+yy'']=0. At (0,{a}), y''=−2/(8·{a})=−1/{4*a}<0, making this stationary point a local maximum on the upper branch."
    wrong = ["The sign is negative, so the upper branch has a local maximum, not a minimum.", "This misses the factor 4 multiplying y² in the original relation.", "A horizontal tangent can still be a maximum; the implicit second derivative is nonzero and negative."]
    cases.append((stem, choices, check, wrong))
add("C", "use an implicit second derivative to classify a branch extremum", cases)

src = "\n\n".join(out) + "\n"
B = H.parent / "apcalcbc-harder-seeds-u5-t5_12-2026-11-14"
B.mkdir(exist_ok=True)
for folder in (H, B):
    (folder / "source_draft.md").write_text(src)
    json.dump({f"N-5.12-{f}": {"skill": skill} for f, skill in (("A", "horizontal implicit critical points"), ("B", "circle second derivative and concavity"), ("C", "ellipse second derivative and maximum"))}, open(folder / "seed_map.json", "w"), indent=2)
    json.dump({"retire": []}, open(folder / "retire_keys.json", "w"), indent=2)
print("wrote 12 mirrored implicit-relation questions")
