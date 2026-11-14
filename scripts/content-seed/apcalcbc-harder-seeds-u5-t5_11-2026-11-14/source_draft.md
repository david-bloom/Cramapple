# AP Calculus AB and BC Unit 5 topic 5.11 — Solving Optimization Problems

DRAFT. Author-in-session 2026-11-14. Identical content for separate AB and BC packs. CED FUN-4.C.1.

---

## Seed N-5.11-A (new) — Topic 5.11 Solving Optimization Problems

**Skill:** solve and interpret a constrained global surface-area minimum



An open-top cylindrical tank must contain 8π cubic meters. Its circular base and curved side use the same material. What radius and height minimize the material area, and what does that result mean for the tank?



- **A. Radius 2 m and height 2 m; this is the least material area among positive dimensions holding 8π m³.**

- B. Radius 1 m and height 8 m; this is the least material area.

- C. Radius 4 m and height 0.5 m; this is the least material area.

- D. Radius 6 m and height 2/9 m; this is the least material area.



Check: From πr²h=8π, h=8/r² and S(r)=πr²+16π/r. S'(r)=2πr−16π/r² vanishes only at r³=8, so r=2 and h=2. The area tends to infinity at both positive-domain ends, so this is the global minimum.

Rationales: B: These dimensions meet the volume requirement, but the area derivative is negative at radius 1, so a larger radius uses less material. C: Doubling the optimal radius keeps the volume but increases area; the area derivative is positive there. D: Tripling the optimal radius makes a much wider, shallower tank and increases material area.



**N-5.11-A-v1.** An open-top cylindrical tank must contain 27π cubic meters. Its circular base and curved side use the same material. What radius and height minimize the material area, and what does that result mean for the tank?



- **A. Radius 3 m and height 3 m; this is the least material area among positive dimensions holding 27π m³.**

- B. Radius 1 m and height 27 m; this is the least material area.

- C. Radius 6 m and height 0.75 m; this is the least material area.

- D. Radius 9 m and height 3/9 m; this is the least material area.



Check: From πr²h=27π, h=27/r² and S(r)=πr²+54π/r. S'(r)=2πr−54π/r² vanishes only at r³=27, so r=3 and h=3. The area tends to infinity at both positive-domain ends, so this is the global minimum.

Rationales: B: These dimensions meet the volume requirement, but the area derivative is negative at radius 1, so a larger radius uses less material. C: Doubling the optimal radius keeps the volume but increases area; the area derivative is positive there. D: Tripling the optimal radius makes a much wider, shallower tank and increases material area.



**N-5.11-A-v2.** An open-top cylindrical tank must contain 64π cubic meters. Its circular base and curved side use the same material. What radius and height minimize the material area, and what does that result mean for the tank?



- **A. Radius 4 m and height 4 m; this is the least material area among positive dimensions holding 64π m³.**

- B. Radius 1 m and height 64 m; this is the least material area.

- C. Radius 8 m and height 1 m; this is the least material area.

- D. Radius 12 m and height 4/9 m; this is the least material area.



Check: From πr²h=64π, h=64/r² and S(r)=πr²+128π/r. S'(r)=2πr−128π/r² vanishes only at r³=64, so r=4 and h=4. The area tends to infinity at both positive-domain ends, so this is the global minimum.

Rationales: B: These dimensions meet the volume requirement, but the area derivative is negative at radius 1, so a larger radius uses less material. C: Doubling the optimal radius keeps the volume but increases area; the area derivative is positive there. D: Tripling the optimal radius makes a much wider, shallower tank and increases material area.



**N-5.11-A-v3.** An open-top cylindrical tank must contain 125π cubic meters. Its circular base and curved side use the same material. What radius and height minimize the material area, and what does that result mean for the tank?



- **A. Radius 5 m and height 5 m; this is the least material area among positive dimensions holding 125π m³.**

- B. Radius 1 m and height 125 m; this is the least material area.

- C. Radius 10 m and height 1.25 m; this is the least material area.

- D. Radius 15 m and height 5/9 m; this is the least material area.



Check: From πr²h=125π, h=125/r² and S(r)=πr²+250π/r. S'(r)=2πr−250π/r² vanishes only at r³=125, so r=5 and h=5. The area tends to infinity at both positive-domain ends, so this is the global minimum.

Rationales: B: These dimensions meet the volume requirement, but the area derivative is negative at radius 1, so a larger radius uses less material. C: Doubling the optimal radius keeps the volume but increases area; the area derivative is positive there. D: Tripling the optimal radius makes a much wider, shallower tank and increases material area.

---

## Seed N-5.11-B (new) — Topic 5.11 Solving Optimization Problems

**Skill:** maximize area with an interior fence and interpret field dimensions



A farmer has 120 meters of fencing for a rectangular field and one interior fence parallel to the two shorter sides, making two pens. The interior fence spans the field's width. What field dimensions give the greatest total enclosed area, and what is that area?



- **A. Width 20 m, length 30 m; maximum total area 600 m².**

- B. Width 30 m, length 15 m; total area 450 m².

- C. Width 10 m, length 45 m; total area 450 m².

- D. Width 30 m, length 30 m; total area 900 m².



Check: With width w and length l, 3w+2l=120. Thus A(w)=w(120−3w)/2, 0<w<40. The quadratic is concave and A'=(120−6w)/2=0 at w=20; l=30, giving 600 m².

Rationales: B: This feasible width lies past the vertex of the concave area function, so its area is smaller. C: This feasible width lies before the vertex, so its area is smaller. D: A square of those dimensions requires more fencing once the interior divider is included.



**N-5.11-B-v1.** A farmer has 144 meters of fencing for a rectangular field and one interior fence parallel to the two shorter sides, making two pens. The interior fence spans the field's width. What field dimensions give the greatest total enclosed area, and what is that area?



- **A. Width 24 m, length 36 m; maximum total area 864 m².**

- B. Width 36 m, length 18 m; total area 648 m².

- C. Width 12 m, length 54 m; total area 648 m².

- D. Width 36 m, length 36 m; total area 1296 m².



Check: With width w and length l, 3w+2l=144. Thus A(w)=w(144−3w)/2, 0<w<48. The quadratic is concave and A'=(144−6w)/2=0 at w=24; l=36, giving 864 m².

Rationales: B: This feasible width lies past the vertex of the concave area function, so its area is smaller. C: This feasible width lies before the vertex, so its area is smaller. D: A square of those dimensions requires more fencing once the interior divider is included.



**N-5.11-B-v2.** A farmer has 168 meters of fencing for a rectangular field and one interior fence parallel to the two shorter sides, making two pens. The interior fence spans the field's width. What field dimensions give the greatest total enclosed area, and what is that area?



- **A. Width 28 m, length 42 m; maximum total area 1176 m².**

- B. Width 42 m, length 21 m; total area 882 m².

- C. Width 14 m, length 63 m; total area 882 m².

- D. Width 42 m, length 42 m; total area 1764 m².



Check: With width w and length l, 3w+2l=168. Thus A(w)=w(168−3w)/2, 0<w<56. The quadratic is concave and A'=(168−6w)/2=0 at w=28; l=42, giving 1176 m².

Rationales: B: This feasible width lies past the vertex of the concave area function, so its area is smaller. C: This feasible width lies before the vertex, so its area is smaller. D: A square of those dimensions requires more fencing once the interior divider is included.



**N-5.11-B-v3.** A farmer has 192 meters of fencing for a rectangular field and one interior fence parallel to the two shorter sides, making two pens. The interior fence spans the field's width. What field dimensions give the greatest total enclosed area, and what is that area?



- **A. Width 32 m, length 48 m; maximum total area 1536 m².**

- B. Width 48 m, length 24 m; total area 1152 m².

- C. Width 16 m, length 72 m; total area 1152 m².

- D. Width 48 m, length 48 m; total area 2304 m².



Check: With width w and length l, 3w+2l=192. Thus A(w)=w(192−3w)/2, 0<w<64. The quadratic is concave and A'=(192−6w)/2=0 at w=32; l=48, giving 1536 m².

Rationales: B: This feasible width lies past the vertex of the concave area function, so its area is smaller. C: This feasible width lies before the vertex, so its area is smaller. D: A square of those dimensions requires more fencing once the interior divider is included.

---

## Seed N-5.11-C (new) — Topic 5.11 Solving Optimization Problems

**Skill:** maximize and interpret profit under a linear demand and cost model



A shop can sell q=100−2p items per week when each sells for p dollars, where demand is positive. The variable cost is $10 per item and there is no fixed cost. Which price maximizes weekly profit, and what maximum profit does the model predict?



- **A. Price $30; maximum profit $800 per week.**

- B. Price $25; maximum profit equals revenue, so $1250 per week.

- C. Price $10; maximum profit $0 per week.

- D. Price $50; maximum profit $0 per week.



Check: Profit is P(p)=(p−10)(100−2p). Its derivative is 120−4p, which is zero at p=30; the second derivative is −4<0. Then q=40 and P=800. This price lies in the feasible positive-demand interval.

Rationales: B: This maximizes revenue p·q but ignores the per-item cost, so it does not maximize profit. C: Pricing at marginal cost gives zero profit, while the interior critical price gives positive profit. D: At this price demand is zero, so profit is zero rather than maximal.



**N-5.11-C-v1.** A shop can sell q=120−3p items per week when each sells for p dollars, where demand is positive. The variable cost is $8 per item and there is no fixed cost. Which price maximizes weekly profit, and what maximum profit does the model predict?



- **A. Price $24; maximum profit $768 per week.**

- B. Price $20; maximum profit equals revenue, so $1200 per week.

- C. Price $8; maximum profit $0 per week.

- D. Price $40; maximum profit $0 per week.



Check: Profit is P(p)=(p−8)(120−3p). Its derivative is 144−6p, which is zero at p=24; the second derivative is −6<0. Then q=48 and P=768. This price lies in the feasible positive-demand interval.

Rationales: B: This maximizes revenue p·q but ignores the per-item cost, so it does not maximize profit. C: Pricing at marginal cost gives zero profit, while the interior critical price gives positive profit. D: At this price demand is zero, so profit is zero rather than maximal.



**N-5.11-C-v2.** A shop can sell q=80−2p items per week when each sells for p dollars, where demand is positive. The variable cost is $12 per item and there is no fixed cost. Which price maximizes weekly profit, and what maximum profit does the model predict?



- **A. Price $26; maximum profit $392 per week.**

- B. Price $20; maximum profit equals revenue, so $800 per week.

- C. Price $12; maximum profit $0 per week.

- D. Price $40; maximum profit $0 per week.



Check: Profit is P(p)=(p−12)(80−2p). Its derivative is 104−4p, which is zero at p=26; the second derivative is −4<0. Then q=28 and P=392. This price lies in the feasible positive-demand interval.

Rationales: B: This maximizes revenue p·q but ignores the per-item cost, so it does not maximize profit. C: Pricing at marginal cost gives zero profit, while the interior critical price gives positive profit. D: At this price demand is zero, so profit is zero rather than maximal.



**N-5.11-C-v3.** A shop can sell q=90−3p items per week when each sells for p dollars, where demand is positive. The variable cost is $10 per item and there is no fixed cost. Which price maximizes weekly profit, and what maximum profit does the model predict?



- **A. Price $20; maximum profit $300 per week.**

- B. Price $15; maximum profit equals revenue, so $675 per week.

- C. Price $10; maximum profit $0 per week.

- D. Price $30; maximum profit $0 per week.



Check: Profit is P(p)=(p−10)(90−3p). Its derivative is 120−6p, which is zero at p=20; the second derivative is −6<0. Then q=30 and P=300. This price lies in the feasible positive-demand interval.

Rationales: B: This maximizes revenue p·q but ignores the per-item cost, so it does not maximize profit. C: Pricing at marginal cost gives zero profit, while the interior critical price gives positive profit. D: At this price demand is zero, so profit is zero rather than maximal.
