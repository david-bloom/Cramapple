"""Compact author-in-session optimization setup questions for AB and BC."""
from pathlib import Path
import json
H=Path(__file__).resolve().parent
out=["# AP Calculus AB and BC Unit 5 topic 5.10 — Optimization setup", "DRAFT. Author-in-session 2026-11-13. Identical content for separate AB and BC packs. CED FUN-4.B.1."]
def add(fam,skill,cases):
    assert len(cases)==4
    for i,(stem,ch,check,wrong) in enumerate(cases):
        assert len(ch)==4 and len(wrong)==3
        ident=f"N-5.10-{fam}"
        if i==0:out.extend(["---",f"## Seed {ident} (new) — Topic 5.10 Introduction to Optimization Problems",f"**Skill:** {skill}","",stem,""])
        else:out.extend(["",f"**{ident}-v{i}.** {stem}",""])
        out.extend([f"- **A. {ch[0]}**",*[f"- {z}. {v}" for z,v in zip("BCD",ch[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{z}: {v}" for z,v in zip("BCD",wrong))])
cases=[]
for L,unit in [(40,"meters"),(60,"feet"),(80,"meters"),(100,"feet")]:
    stem=f"A rectangular pen borders a straight river, so no fence is needed along the river. Exactly {L} {unit} of fence covers the other three sides. If x is the width perpendicular to the river, which single-variable area function and physical domain should be optimized?"
    ch=[f"A(x)=x({L}−2x), with 0<x<{L/2:g}.",f"A(x)=x({L}−x), with 0<x<{L}.",f"A(x)=x({L}−4x), with 0<x<{L/4:g}.",f"A(x)=2x({L}−2x), with 0<x<{L/2:g}."]
    check=f"Two widths use 2x of the {L} units of fence, leaving river-parallel length {L}−2x. Area is width times that length, and both must be positive."
    wrong=["Only one perpendicular side is subtracted; the enclosure requires two fenced widths.","This subtracts four widths as if all sides used equal fence, contrary to the three-sided constraint.","The factor 2 counts two copies of the area rather than the single rectangle's area."]
    cases.append((stem,ch,check,wrong))
add("A","eliminate a dimension and enforce a three-sided fencing constraint",cases)
cases=[]
for S,unit in [(12,"inches"),(18,"centimeters"),(24,"inches"),(30,"centimeters")]:
    if S==24:
        stem="An open-top box is made by cutting x-by-x squares from the four corners of a 24-inch square sheet and folding up the flaps. Among boxes with positive height and base dimensions, which cut size produces the greatest volume, and what is that volume?"
        ch=["Cut x=4 inches; the maximum volume is 1,024 cubic inches.","Cut x=12 inches; the maximum volume is 0 cubic inches.","Cut x=6 inches; the maximum volume is 864 cubic inches.","Cut x=8 inches; the maximum volume is 512 cubic inches."]
        check="The domain is 0<x<12, and V=x(24−2x)². Its derivative is (24−2x)(24−6x), so the interior critical point is x=4; V(4)=4(16)²=1,024, while volume tends to zero at both domain boundaries."
        wrong=["A cut of 12 leaves zero base dimensions and is outside the positive-volume domain.","The stated volume at x=6 is correct, but V'(6)<0 and it is smaller than V(4).","The stated volume at x=8 is correct, but it is smaller than V(4)."]
    else:
        stem=f"An open-top box is made by cutting an x-by-x square from every corner of a square sheet with side {S} {unit}, then folding up the flaps. Which volume function and allowable positive x interval give the optimization problem?"
        ch=[f"V(x)=x({S}−2x)² for 0<x<{S/2:g}.",f"V(x)=x({S}−x)² for 0<x<{S}.",f"V(x)=x({S}−2x) for 0<x<{S/2:g}.",f"V(x)=({S}−2x)² for 0<x<{S/2:g}."]
        check=f"Each base side loses x at each end, becoming {S}−2x; the folded height is x. A positive base requires x<{S/2:g}."
        wrong=["A base side loses two cut lengths, not one; this overstates the base and domain.","This omits one base dimension and has area units rather than volume units.","This gives base area but omits the height x needed for volume."]
    cases.append((stem,ch,check,wrong))
add("B","construct a box-volume objective and physical interval from corner cuts",cases)
cases=[]
for caps,capcost,sidecost,vol in [(2,1,1,100),(1,1,1,64),(2,2,1,54),(1,1,2,200)]:
    capword="two circular caps" if caps==2 else "one circular base and no top"
    stem=f"A cylindrical container must hold {vol}π cubic units. It has {capword}. Material for each circular face costs {capcost} currency units per square unit, and material for the curved side costs {sidecost} per square unit. If r>0 is the radius and h is height, which cost function of r alone should be minimized?"
    term=caps*capcost;side=2*sidecost*vol
    ch=[f"C(r)={term}πr²+{side}π/r, for r>0.",f"C(r)={term}πr²+{sidecost*vol}π/r, for r>0.",f"C(r)={term}πr²+{side}πr, for r>0.",f"C(r)={term}πr²+{side}π/r, for r>{vol}."]
    check=f"The volume constraint πr²h={vol}π gives h={vol}/r². Face cost is {term}πr²; curved-side cost is {sidecost}(2πrh)={side}π/r. Any r>0 gives a positive h."
    wrong=["The curved area is 2πrh; dropping its factor 2 undercounts side material.","Substituting h=V/(πr²) makes the curved cost proportional to 1/r, not r.","Radius has no lower bound of the numerical volume; every positive radius yields a positive height."]
    cases.append((stem,ch,check,wrong))
add("C","eliminate cylinder height under a volume constraint and weight material costs",cases)
src="\n\n".join(out)+"\n";(H/"source_draft.md").write_text(src)
B=H.parent/"apcalcbc-harder-seeds-u5-t5_10-2026-11-13";B.mkdir(exist_ok=True);(B/"source_draft.md").write_text(src)
for p in (H,B):
    json.dump({"N-5.10-A":{"skill":"three-sided fence area and domain"},"N-5.10-B":{"skill":"open-top box volume and domain"},"N-5.10-C":{"skill":"cost-weighted cylinder objective"}},open(p/"seed_map.json","w"),indent=2)
    json.dump({"retire":[]},open(p/"retire_keys.json","w"),indent=2)
print("wrote 12 shared optimization-setup questions")
