"""Author mirrored AB/BC applied optimization questions for topic 5.11."""
from pathlib import Path
import json

H = Path(__file__).resolve().parent
out = ["# AP Calculus AB and BC Unit 5 topic 5.11 — Solving Optimization Problems", "DRAFT. Author-in-session 2026-11-14. Identical content for separate AB and BC packs. CED FUN-4.C.1."]

def add(family, skill, cases):
    assert len(cases) == 4
    for i, (stem, choices, check, wrong) in enumerate(cases):
        assert len(choices) == 4 and len(wrong) == 3
        ident = f"N-5.11-{family}"
        if i == 0:
            out.extend(["---", f"## Seed {ident} (new) — Topic 5.11 Solving Optimization Problems", f"**Skill:** {skill}", "", stem, ""])
        else:
            out.extend(["", f"**{ident}-v{i}.** {stem}", ""])
        out.extend([f"- **A. {choices[0]}**", *[f"- {letter}. {choice}" for letter, choice in zip("BCD", choices[1:])], "", f"Check: {check}", "Rationales: " + " ".join(f"{letter}: {reason}" for letter, reason in zip("BCD", wrong))])

cases = []
for r in (2, 3, 4, 5):
    k = r ** 3
    stem = f"An open-top cylindrical tank must contain {k}π cubic meters. Its circular base and curved side use the same material. What radius and height minimize the material area, and what does that result mean for the tank?"
    choices = [f"Radius {r} m and height {r} m; this is the least material area among positive dimensions holding {k}π m³.", f"Radius 1 m and height {k} m; this is the least material area.", f"Radius {2*r} m and height {r/4:g} m; this is the least material area.", f"Radius {3*r} m and height {r}/9 m; this is the least material area."]
    check = f"From πr²h={k}π, h={k}/r² and S(r)=πr²+{2*k}π/r. S'(r)=2πr−{2*k}π/r² vanishes only at r³={k}, so r={r} and h={r}. The area tends to infinity at both positive-domain ends, so this is the global minimum."
    wrong = ["These dimensions meet the volume requirement, but the area derivative is negative at radius 1, so a larger radius uses less material.", "Doubling the optimal radius keeps the volume but increases area; the area derivative is positive there.", "Tripling the optimal radius makes a much wider, shallower tank and increases material area."]
    cases.append((stem, choices, check, wrong))
add("A", "solve and interpret a constrained global surface-area minimum", cases)

cases = []
for fence in (120, 144, 168, 192):
    x, y = fence // 6, fence // 4
    area = x*y
    stem = f"A farmer has {fence} meters of fencing for a rectangular field and one interior fence parallel to the two shorter sides, making two pens. The interior fence spans the field's width. What field dimensions give the greatest total enclosed area, and what is that area?"
    choices = [f"Width {x} m, length {y} m; maximum total area {area} m².", f"Width {fence//4} m, length {fence//8} m; total area {fence*fence//32} m².", f"Width {fence//12} m, length {3*fence//8} m; total area {fence*fence//32} m².", f"Width {fence//4} m, length {fence//4} m; total area {fence*fence//16} m²."]
    check = f"With width w and length l, 3w+2l={fence}. Thus A(w)=w({fence}−3w)/2, 0<w<{fence/3:g}. The quadratic is concave and A'=({fence}−6w)/2=0 at w={x}; l={y}, giving {area} m²."
    wrong = ["This feasible width lies past the vertex of the concave area function, so its area is smaller.", "This feasible width lies before the vertex, so its area is smaller.", "A square of those dimensions requires more fencing once the interior divider is included."]
    cases.append((stem, choices, check, wrong))
add("B", "maximize area with an interior fence and interpret field dimensions", cases)

cases = []
for a, b, c in ((100, 2, 10), (120, 3, 8), (80, 2, 12), (90, 3, 10)):
    price = (a + b*c)//(2*b)
    quantity = a-b*price
    profit = (price-c)*quantity
    stem = f"A shop can sell q={a}−{b}p items per week when each sells for p dollars, where demand is positive. The variable cost is ${c} per item and there is no fixed cost. Which price maximizes weekly profit, and what maximum profit does the model predict?"
    choices = [f"Price ${price}; maximum profit ${profit} per week.", f"Price ${a//(2*b)}; maximum profit equals revenue, so ${a*a//(4*b)} per week.", f"Price ${c}; maximum profit $0 per week.", f"Price ${a//b}; maximum profit $0 per week."]
    check = f"Profit is P(p)=(p−{c})({a}−{b}p). Its derivative is {a+b*c}−{2*b}p, which is zero at p={price}; the second derivative is −{2*b}<0. Then q={quantity} and P={profit}. This price lies in the feasible positive-demand interval."
    wrong = ["This maximizes revenue p·q but ignores the per-item cost, so it does not maximize profit.", "Pricing at marginal cost gives zero profit, while the interior critical price gives positive profit.", "At this price demand is zero, so profit is zero rather than maximal."]
    cases.append((stem, choices, check, wrong))
add("C", "maximize and interpret profit under a linear demand and cost model", cases)

src = "\n\n".join(out) + "\n"
B = H.parent / "apcalcbc-harder-seeds-u5-t5_11-2026-11-14"
B.mkdir(exist_ok=True)
for folder in (H, B):
    (folder / "source_draft.md").write_text(src)
    json.dump({f"N-5.11-{f}": {"skill": skill} for f, skill in (("A", "open-top cylinder minimum area"), ("B", "two-pen fence maximum area"), ("C", "linear-demand maximum profit"))}, open(folder / "seed_map.json", "w"), indent=2)
    json.dump({"retire": []}, open(folder / "retire_keys.json", "w"), indent=2)
print("wrote 12 mirrored applied optimization questions")
