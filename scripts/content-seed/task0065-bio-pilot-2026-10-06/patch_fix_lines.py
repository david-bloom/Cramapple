"""TASK-0065: rewrite fix lines as actions (David, 2026-10-06: "Fix lines must be actions; rewrite the 25").

Scope: the 25 batch items blocked by C3 only for fix lines that state a fact (batch_c3_blocked.json).
Every fix line in those items was reviewed; lines that already tell the student what to do are left alone.
Only the text after "Fix: " changes. Each old fix must match exactly. The same edit is applied to
SCOPE_UNITS_1-3.json and the item's subject file, which hold identical copies.
"""
import json, glob, sys
B = "docs/research/open_hand_teaching_batch_2026_10_06"
R = {  # (item, choice): (old fix, new fix)
 ("ap-calculus-ab:1.5","B"): ("the limit of f^2 is (limit of f)^2 = 4.", "square the limit of f before you add: (-2)^2 = 4, not -4."),
 ("ap-calculus-ab:1.6","C"): ("the correct factors are (x - 5)(x + 2).", "expand your factors to check them before you cancel; x^2 - 3x - 10 = (x - 5)(x + 2)."),
 ("ap-calculus-ab:1.7","B"): ("the denominator after rationalizing is sqrt(x) + 4 = 8, so the limit is 1/8.", "keep the whole factor sqrt(x) + 4 after rationalizing, and substitute x = 16 into all of it."),
 ("ap-calculus-ab:1.7","D"): ("simplify first, then decide.", "when substitution gives 0/0, rewrite the expression (factor or rationalize) and substitute again before deciding."),
 ("ap-calculus-ab:2.1","B"): ("velocity is the derivative of s, not s itself.", "differentiate s(t) first, then substitute t = 2."),
 ("ap-calculus-ab:2.1","D"): ("s'(t) = 3t^2 - 2, so s'(2) = 10.", "differentiate every term, including -2t, before you substitute t = 2."),
 ("ap-chemistry:1.4","C"): ("a ratio that changes means the proportions are variable, so it is a mixture.", "compute the X:Y mass ratio for each sample, and call the powder a mixture if the ratio changes."),
 ("ap-chemistry:2.1","D"): ("equal electronegativity means a nonpolar bond with no partial charges.", "check that the two atoms differ in electronegativity before you assign any partial charge."),
 ("ap-chemistry:2.4","A"): ("compare radii; very different sizes mean interstitial.", "compare the two radii, and rule out a pair in which one atom is much smaller than the other."),
 ("ap-chemistry:2.4","C"): ("a size gap this large indicates interstitial placement.", "compare the two radii before calling a pair substitutional; pick a pair whose radii are close."),
 ("ap-chemistry:2.6","B"): ("the molecule is a single averaged structure with identical bonds.", "draw both resonance forms, then describe the real molecule as their average, with two identical bonds."),
 ("ap-chemistry:2.6","C"): ("the averaged bonds have partial double-bond character.", "count the bonds across both resonance forms and share the double bond equally between the two positions."),
 ("ap-chemistry:3.3","B"): ("the large molar volume belongs to gases.", "check whether a property actually separates solids from liquids before you use it; save large molar volume for gases."),
 ("ap-chemistry:3.3","C"): ("gas particles are far apart and move independently; that is not the case here.", "check particle spacing before you call anything gas-like; glass particles touch, as in a solid."),
 ("ap-chemistry:3.6","D"): ("the ideal model neglects particle volume and attractions.", "explain a deviation from ideal behavior with particle volume or attractions, the two things the ideal model ignores."),
 ("ap-statistics:1.10","C"): ("forward-looking data collection is prospective.", "check whether data are collected going forward or looked up from the past before you call a study retrospective."),
 ("ap-statistics:1.2","B"): ("a continuous variable measures a quantity; labels written as numbers do not.", "ask whether the number measures an amount; if it is a label, classify the variable as categorical."),
 ("ap-statistics:1.8","C"): ("the whisker ends at an actual data point inside the fence.", "end the whisker at the largest actual data value inside the fence, not at the fence itself."),
 ("ap-statistics:1.8","D"): ("Q3 is the end of the box, not the whisker.", "compute the upper fence, Q3 + 1.5 × IQR, then extend the whisker past Q3 to the largest value inside it."),
 ("ap-statistics:2.1","A"): ("compare proportions, or find the group totals first.", "compare percents as percents, and find each group's total before you compare counts."),
 ("ap-statistics:2.1","B"): ("equal bar heights say nothing about group size.", "read each bar as 100% of its own group, and look for the group counts before you compare sizes."),
 ("ap-statistics:2.11","C"): ("ask which region the question wants.", "shade the region the question asks about (above 700) before you read off a percent."),
 ("ap-statistics:2.12","A"): ("the CLT makes the shape approximately normal for large n.", "for a large sample size, describe the distribution of sample means as approximately normal, whatever the population's shape."),
 ("ap-statistics:2.12","D"): ("24/√64 = 3.", "divide σ by √n, not by n: 24/√64 = 3."),
 ("ap-statistics:2.4","B"): ("if your answer is above 1, the denominator is wrong.", "check that every probability is between 0 and 1, and divide by the total number of marbles."),
 ("ap-statistics:3.5","B"): ("'different from' means two-sided.", "use ≠ in Hₐ whenever the claim is that the proportion is 'different from' a value."),
 ("ap-statistics:3.5","D"): ("the sample result is used later in the test statistic.", "write the hypotheses with the claimed value, 0.22, and save the sample result for the test statistic."),
 ("biology:1.2","A"): ("phosphorus plus nitrogen points to nucleic acids.", "when an analysis shows both N and P but no S, choose a nucleic acid over a protein."),
 ("biology:1.2","B"): ("N and P together signal nucleotides.", "check for N and P before you choose a lipid; triglycerides contain only C, H and O."),
 ("biology:1.2","C"): ("check which elements the molecule class actually contains.", "list the elements each molecule class contains and match them to the analysis; cellulose has only C, H and O."),
 ("biology:1.5","D"): ("saturated means filled with hydrogen, with straight chains; unsaturated chains are kinked.", "count the double bonds in each chain, and predict that the fat with none (more hydrogen, straight chains) packs into a solid."),
 ("biology:1.6","B"): ("DNA is A-T and C-G.", "pair A with T, never U, when you write a DNA strand."),
 ("biology:2.6","A"): ("channels do not set the direction.", "find the side with the higher concentration and predict flow through the open channel toward the lower side."),
 ("biology:2.6","C"): ("protein-assisted is not the same as active.", "decide active or passive from the gradient direction, not from whether a protein is involved."),
 ("biology:2.6","D"): ("blocked without a protein, passable with one.", "when an ion crosses a membrane, look for the channel or carrier protein that lets it through."),
 ("biology:3.1","A"): ("lower the barrier, do not fill it.", "describe the enzyme as lowering the barrier from 75 to 40 kJ/mol, never as adding energy."),
 ("biology:3.1","C"): ("catalysts do not change energy released.", "keep the energy released (30 kJ/mol) separate from the activation energy, the only value the enzyme changes."),
 ("biology:3.1","D"): ("binding is temporary.", "describe enzyme binding as temporary, with the enzyme unchanged and reusable after the reaction."),
 ("biology:3.4","A"): ("track where each product is made.", "list what the light reactions make, then pick the products the Calvin cycle uses in the stroma."),
 ("biology:3.4","B"): ("water is split in the light reactions and CO2 is used in the Calvin cycle.", "sort each molecule into input or product before you answer; water and CO2 are inputs."),
 ("biology:3.4","D"): ("photosynthesis carries electrons with NADPH.", "look for NADPH in photosynthesis, and save NADH and FADH2 for cellular respiration."),
 ("biology:3.5","A"): ("oxygen's role is final electron acceptor.", "trace oxygen to the end of the electron transport chain, where it accepts electrons, not to ATP synthase."),
 ("biology:3.5","B"): ("use oxygen at the end of the electron transport chain.", "place glycolysis in the cytosol, where it runs without oxygen, before you link oxygen to ATP production."),
 ("biology:3.5","C"): ("oxygen accepts electrons, which lets the chain keep pumping.", "give oxygen the job of accepting electrons at the end of the chain, and look elsewhere for the pumped protons."),
}
the25 = set(json.load(open("scripts/content-seed/task0065-bio-pilot-2026-10-06/the25.json")))
assert {k for k, _ in R} <= the25, {k for k, _ in R} - the25
assert {k for k, _ in R} == the25, the25 - {k for k, _ in R}
files = [f"{B}/SCOPE_UNITS_1-3.json"] + sorted(set(glob.glob(f"{B}/*_u*.json") + [f"{B}/ap-statistics.json"]))
done = {f: 0 for f in files}
for f in files:
    raw = open(f).read(); data = json.loads(raw); changed = False
    for it in data:
        k = f'{it["subject_key"]}:{it["topic_code"]}'
        for c in it["choices"]:
            if (k, c["choice_key"]) in R:
                old, new = R[(k, c["choice_key"])]
                tail = "Fix: " + old
                assert c["rationale"].endswith(tail), (f, k, c["choice_key"], c["rationale"][-120:])
                c["rationale"] = c["rationale"][: -len(old)] + new
                done[f] += 1; changed = True
    if changed:
        indent = 1 if raw.startswith("[\n ") and not raw.startswith("[\n  ") else 2
        open(f, "w").write(json.dumps(data, indent=indent, ensure_ascii=False) + ("\n" if raw.endswith("\n") else ""))
print({f.split("/")[-1]: n for f, n in done.items() if n}, "total", sum(done.values()), "for", len(R), "fix lines")
