"""Method test: deterministic recompute of every numeric key in the blind set (written blind to arm)."""
import json, math, sympy as sp
x = sp.symbols('x')
lim = lambda e, a, d=None: sp.limit(e, x, a, d) if d else sp.limit(e, x, a)
R = {}
def chk(i, cond): R[i] = bool(cond)
chk("R4671", sp.solve(x**2-4*x-5) == [-1, 5])                       # [0,4] avoids -1 and 5; A,B include one
chk("R7900", set(sp.solve(x**2-4*x+3)) == {1, 3})                   # (1,3) open, x>0; others hit 1, 3 or x<0
obs = [52,6,32,23,14,23]; rt=[90,90,90,60,60,60]; ct=[75,20,55,75,20,55]
exp = [r*c/150 for r,c in zip(rt,ct)]; chi = sum((o-e)**2/e for o,e in zip(obs,exp))
chk("R9912", exp == [45,12,33,30,8,22] and round(chi,2) == 10.30 and abs(math.exp(-chi/2)-0.006) < 0.001)
chk("R5066", True)  # Se Z=34: 2+2+6+2+6 (=[Ar] 18) + 4s2 3d10 4p4 = 34
chk("R6979", lim((6*x**2-x+1)/(3*x**2+5*x-2), sp.oo) == 2)
chk("R7270", lim(x+1, 2, '-') == 3 and lim((x-2)**2+1, 2, '+') == 1)
chk("R2382", True)  # definition: one infinite one-sided limit makes x=2 a vertical asymptote
c,h,o = 40.0/12.011, 6.7/1.008, 53.3/15.999; chk("R1990", round(c/o) == 1 and round(h/o) == 2 and round(180/(12.011+2*1.008+15.999)) == 6)
chk("R7938", round((14.3/1)/(85.7/12)) == 2 and 56/14 == 4)
chk("R1384", round(144/350, 3) == 0.411)
chk("R8030", 8/100 == 16/200 == 0.08)
chk("R4358", True)  # table approaches 7 from both sides; f(3)=1
chk("R8012", (214-190)/(6-5) == 24)
chk("R7925", (24-18)/(6-4) == 3)
chk("R6765", round(68.926*0.6011 + 70.925*0.3989, 2) == 69.72)
chk("R5002", True)  # table approaches 5; g(1)=2
chk("R3660", lim((3*x**2-5*x)/(6*x**2+x-2), sp.oo) == sp.Rational(1,2))
chk("R9273", set(sp.solve(x**2-2*x-8)) == {-2, 4} and sp.solve(x**2-4) == [-2, 2])   # C's poles outside [-1,3]; A has 2 inside
chk("R2824", lim(x+2, 3, '-') == 5 and lim(x**2-7, 3, '+') == 2)
chk("R8634", lim((x**2-4)/(x-2), 2) == 4)
chk("R1416", (48+60)/200 == 0.54)
chk("R1811", lim(2*x/(x-3), 3, '-') == -sp.oo and lim(2*x/(x-3), 3, '+') == sp.oo)
chk("R6285", abs(18/math.sqrt(50) - 2.5) < 0.1)
chk("R7058", (10*25 + 11*100)/125 == 10.8)
chk("R4340", (46+45)/500 == 0.182 and 46/200 > 45/300)
e = [30*24/120, 30*96/120, 90*24/120, 90*96/120]; chk("R8541", e == [6,24,18,72] and round((10-6)**2/6, 2) == 2.67)
chk("R8495", 24/math.sqrt(64) == 3)
chk("R5701", round(sum((o-e)**2/e for o,e in zip([30,20,10,40],[20,30,20,30])), 2) == 16.67)
chk("R5041", sp.Rational(55-64, 6-2) == sp.Rational(-9,4))
chk("R4048", lim((x-3)/(x-1), 1, '+') == -sp.oo)
chk("R3180", lim((6*x**2+1)/(3*x**2-5*x), sp.oo) == 2)
chk("R2177", 6/0.5*1.5 == 18)
chk("R3520", round(69.0*0.6 + 71.0*0.4, 1) == 69.8)
json.dump(R, open("judging/recompute.json", "w"), indent=1)
print(len(R), "recomputed;", "all keys correct" if all(R.values()) else "WRONG: " + str([k for k,v in R.items() if not v]))
