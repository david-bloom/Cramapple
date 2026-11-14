# AP Calculus AB and BC Unit 5 topic 5.10 — Optimization setup

DRAFT. Author-in-session 2026-11-13. Identical content for separate AB and BC packs. CED FUN-4.B.1.

---

## Seed N-5.10-A (new) — Topic 5.10 Introduction to Optimization Problems

**Skill:** eliminate a dimension and enforce a three-sided fencing constraint



A rectangular pen borders a straight river, so no fence is needed along the river. Exactly 40 meters of fence covers the other three sides. If x is the width perpendicular to the river, which single-variable area function and physical domain should be optimized?



- **A. A(x)=x(40−2x), with 0<x<20.**

- B. A(x)=x(40−x), with 0<x<40.

- C. A(x)=x(40−4x), with 0<x<10.

- D. A(x)=2x(40−2x), with 0<x<20.



Check: Two widths use 2x of the 40 units of fence, leaving river-parallel length 40−2x. Area is width times that length, and both must be positive.

Rationales: B: Only one perpendicular side is subtracted; the enclosure requires two fenced widths. C: This subtracts four widths as if all sides used equal fence, contrary to the three-sided constraint. D: The factor 2 counts two copies of the area rather than the single rectangle's area.



**N-5.10-A-v1.** A rectangular pen borders a straight river, so no fence is needed along the river. Exactly 60 feet of fence covers the other three sides. If x is the width perpendicular to the river, which single-variable area function and physical domain should be optimized?



- **A. A(x)=x(60−2x), with 0<x<30.**

- B. A(x)=x(60−x), with 0<x<60.

- C. A(x)=x(60−4x), with 0<x<15.

- D. A(x)=2x(60−2x), with 0<x<30.



Check: Two widths use 2x of the 60 units of fence, leaving river-parallel length 60−2x. Area is width times that length, and both must be positive.

Rationales: B: Only one perpendicular side is subtracted; the enclosure requires two fenced widths. C: This subtracts four widths as if all sides used equal fence, contrary to the three-sided constraint. D: The factor 2 counts two copies of the area rather than the single rectangle's area.



**N-5.10-A-v2.** A rectangular pen borders a straight river, so no fence is needed along the river. Exactly 80 meters of fence covers the other three sides. If x is the width perpendicular to the river, which single-variable area function and physical domain should be optimized?



- **A. A(x)=x(80−2x), with 0<x<40.**

- B. A(x)=x(80−x), with 0<x<80.

- C. A(x)=x(80−4x), with 0<x<20.

- D. A(x)=2x(80−2x), with 0<x<40.



Check: Two widths use 2x of the 80 units of fence, leaving river-parallel length 80−2x. Area is width times that length, and both must be positive.

Rationales: B: Only one perpendicular side is subtracted; the enclosure requires two fenced widths. C: This subtracts four widths as if all sides used equal fence, contrary to the three-sided constraint. D: The factor 2 counts two copies of the area rather than the single rectangle's area.



**N-5.10-A-v3.** A rectangular pen borders a straight river, so no fence is needed along the river. Exactly 100 feet of fence covers the other three sides. If x is the width perpendicular to the river, which single-variable area function and physical domain should be optimized?



- **A. A(x)=x(100−2x), with 0<x<50.**

- B. A(x)=x(100−x), with 0<x<100.

- C. A(x)=x(100−4x), with 0<x<25.

- D. A(x)=2x(100−2x), with 0<x<50.



Check: Two widths use 2x of the 100 units of fence, leaving river-parallel length 100−2x. Area is width times that length, and both must be positive.

Rationales: B: Only one perpendicular side is subtracted; the enclosure requires two fenced widths. C: This subtracts four widths as if all sides used equal fence, contrary to the three-sided constraint. D: The factor 2 counts two copies of the area rather than the single rectangle's area.

---

## Seed N-5.10-B (new) — Topic 5.10 Introduction to Optimization Problems

**Skill:** construct a box-volume objective and physical interval from corner cuts



An open-top box is made by cutting an x-by-x square from every corner of a square sheet with side 12 inches, then folding up the flaps. Which volume function and allowable positive x interval give the optimization problem?



- **A. V(x)=x(12−2x)² for 0<x<6.**

- B. V(x)=x(12−x)² for 0<x<12.

- C. V(x)=x(12−2x) for 0<x<6.

- D. V(x)=(12−2x)² for 0<x<6.



Check: Each base side loses x at each end, becoming 12−2x; the folded height is x. A positive base requires x<6.

Rationales: B: A base side loses two cut lengths, not one; this overstates the base and domain. C: This omits one base dimension and has area units rather than volume units. D: This gives base area but omits the height x needed for volume.



**N-5.10-B-v1.** An open-top box is made by cutting an x-by-x square from every corner of a square sheet with side 18 centimeters, then folding up the flaps. Which volume function and allowable positive x interval give the optimization problem?



- **A. V(x)=x(18−2x)² for 0<x<9.**

- B. V(x)=x(18−x)² for 0<x<18.

- C. V(x)=x(18−2x) for 0<x<9.

- D. V(x)=(18−2x)² for 0<x<9.



Check: Each base side loses x at each end, becoming 18−2x; the folded height is x. A positive base requires x<9.

Rationales: B: A base side loses two cut lengths, not one; this overstates the base and domain. C: This omits one base dimension and has area units rather than volume units. D: This gives base area but omits the height x needed for volume.



**N-5.10-B-v2.** An open-top box is made by cutting x-by-x squares from the four corners of a 24-inch square sheet and folding up the flaps. Among boxes with positive height and base dimensions, which cut size produces the greatest volume, and what is that volume?



- **A. Cut x=4 inches; the maximum volume is 1,024 cubic inches.**

- B. Cut x=12 inches; the maximum volume is 0 cubic inches.

- C. Cut x=6 inches; the maximum volume is 864 cubic inches.

- D. Cut x=8 inches; the maximum volume is 512 cubic inches.



Check: The domain is 0<x<12, and V=x(24−2x)². Its derivative is (24−2x)(24−6x), so the interior critical point is x=4; V(4)=4(16)²=1,024, while volume tends to zero at both domain boundaries.

Rationales: B: A cut of 12 leaves zero base dimensions and is outside the positive-volume domain. C: The stated volume at x=6 is correct, but V'(6)<0 and it is smaller than V(4). D: The stated volume at x=8 is correct, but it is smaller than V(4).



**N-5.10-B-v3.** An open-top box is made by cutting an x-by-x square from every corner of a square sheet with side 30 centimeters, then folding up the flaps. Which volume function and allowable positive x interval give the optimization problem?



- **A. V(x)=x(30−2x)² for 0<x<15.**

- B. V(x)=x(30−x)² for 0<x<30.

- C. V(x)=x(30−2x) for 0<x<15.

- D. V(x)=(30−2x)² for 0<x<15.



Check: Each base side loses x at each end, becoming 30−2x; the folded height is x. A positive base requires x<15.

Rationales: B: A base side loses two cut lengths, not one; this overstates the base and domain. C: This omits one base dimension and has area units rather than volume units. D: This gives base area but omits the height x needed for volume.

---

## Seed N-5.10-C (new) — Topic 5.10 Introduction to Optimization Problems

**Skill:** eliminate cylinder height under a volume constraint and weight material costs



A cylindrical container must hold 100π cubic units. It has two circular caps. Material for each circular face costs 1 currency units per square unit, and material for the curved side costs 1 per square unit. If r>0 is the radius and h is height, which cost function of r alone should be minimized?



- **A. C(r)=2πr²+200π/r, for r>0.**

- B. C(r)=2πr²+100π/r, for r>0.

- C. C(r)=2πr²+200πr, for r>0.

- D. C(r)=2πr²+200π/r, for r>100.



Check: The volume constraint πr²h=100π gives h=100/r². Face cost is 2πr²; curved-side cost is 1(2πrh)=200π/r. Any r>0 gives a positive h.

Rationales: B: The curved area is 2πrh; dropping its factor 2 undercounts side material. C: Substituting h=V/(πr²) makes the curved cost proportional to 1/r, not r. D: Radius has no lower bound of the numerical volume; every positive radius yields a positive height.



**N-5.10-C-v1.** A cylindrical container must hold 64π cubic units. It has one circular base and no top. Material for each circular face costs 1 currency units per square unit, and material for the curved side costs 1 per square unit. If r>0 is the radius and h is height, which cost function of r alone should be minimized?



- **A. C(r)=1πr²+128π/r, for r>0.**

- B. C(r)=1πr²+64π/r, for r>0.

- C. C(r)=1πr²+128πr, for r>0.

- D. C(r)=1πr²+128π/r, for r>64.



Check: The volume constraint πr²h=64π gives h=64/r². Face cost is 1πr²; curved-side cost is 1(2πrh)=128π/r. Any r>0 gives a positive h.

Rationales: B: The curved area is 2πrh; dropping its factor 2 undercounts side material. C: Substituting h=V/(πr²) makes the curved cost proportional to 1/r, not r. D: Radius has no lower bound of the numerical volume; every positive radius yields a positive height.



**N-5.10-C-v2.** A cylindrical container must hold 54π cubic units. It has two circular caps. Material for each circular face costs 2 currency units per square unit, and material for the curved side costs 1 per square unit. If r>0 is the radius and h is height, which cost function of r alone should be minimized?



- **A. C(r)=4πr²+108π/r, for r>0.**

- B. C(r)=4πr²+54π/r, for r>0.

- C. C(r)=4πr²+108πr, for r>0.

- D. C(r)=4πr²+108π/r, for r>54.



Check: The volume constraint πr²h=54π gives h=54/r². Face cost is 4πr²; curved-side cost is 1(2πrh)=108π/r. Any r>0 gives a positive h.

Rationales: B: The curved area is 2πrh; dropping its factor 2 undercounts side material. C: Substituting h=V/(πr²) makes the curved cost proportional to 1/r, not r. D: Radius has no lower bound of the numerical volume; every positive radius yields a positive height.



**N-5.10-C-v3.** A cylindrical container must hold 200π cubic units. It has one circular base and no top. Material for each circular face costs 1 currency units per square unit, and material for the curved side costs 2 per square unit. If r>0 is the radius and h is height, which cost function of r alone should be minimized?



- **A. C(r)=1πr²+800π/r, for r>0.**

- B. C(r)=1πr²+400π/r, for r>0.

- C. C(r)=1πr²+800πr, for r>0.

- D. C(r)=1πr²+800π/r, for r>200.



Check: The volume constraint πr²h=200π gives h=200/r². Face cost is 1πr²; curved-side cost is 2(2πrh)=800π/r. Any r>0 gives a positive h.

Rationales: B: The curved area is 2πrh; dropping its factor 2 undercounts side material. C: Substituting h=V/(πr²) makes the curved cost proportional to 1/r, not r. D: Radius has no lower bound of the numerical volume; every positive radius yields a positive height.
