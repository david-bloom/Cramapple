# Authoring data for variants_c3.json. Each choice: text, claim (value the text denotes), calc (value recomputed from the stated error).
import sympy as sp, json
x,y,t,yp=sp.symbols('x y t yp')
E,pi=sp.E,sp.pi
S=sp.Rational
def solve_yp(eq): return sp.simplify(sp.solve(eq,yp)[0])
def C(text,claim,calc,rat,ep=None): return dict(text=text,claim=claim,calc=calc,rationale=rat,error_pattern=ep)
V=[]
def add(id,seed,diff,title,stem,correct,wrong,note,check='numeric',extra=None):
    V.append(dict(id=id,seed=seed,difficulty=diff,title=title,stem=stem,correct=correct,wrong=wrong,change_note=note,check=check,extra=extra))

# ---------------- u3n-006 implicit slope (medium)
s='apcalcab-mcq-u3n-006'
add(s+'-v1',s,'medium','Implicit slope with an exponential in y',
 "A curve is defined implicitly by e^y + xy = e + 2, and the point (2, 1) lies on it. Find the slope of the tangent line to the curve at that point.",
 C("−1/(e + 2)",-1/(E+2),solve_yp(E*yp+1+2*yp),"Differentiate both sides: e^y · dy/dx + y + x · dy/dx = 0. At (2, 1): e · dy/dx + 1 + 2 · dy/dx = 0, so (e + 2) · dy/dx = −1 and dy/dx = −1/(e + 2)."),
 [C("−(e + 1)/2",-(E+1)/2,solve_yp(E+1+2*yp),"This differentiates e^y as e^y without the chain-rule factor dy/dx. Then e + 1 + 2 · dy/dx = 0 gives dy/dx = −(e + 1)/2. The correct derivative of e^y is e^y · dy/dx, which gives −1/(e + 2).","Omits the chain-rule factor dy/dx when differentiating e^y"),
  C("0",0,solve_yp(E*yp+2*yp),"This differentiates xy as x · dy/dx, dropping the product-rule term y. Then e · dy/dx + 2 · dy/dx = 0 gives dy/dx = 0. The term y = 1 contributes, giving −1/(e + 2).","Drops the y term of the product rule for xy"),
  C("(e + 1)/(e + 2)",(E+1)/(E+2),solve_yp(E*yp+1+2*yp-(E+2)),"This differentiates the constant e + 2 as e + 2 instead of 0. Then e · dy/dx + 1 + 2 · dy/dx = e + 2 gives (e + 2) · dy/dx = e + 1. Since d/dx(e + 2) = 0, the equation is (e + 2) · dy/dx + 1 = 0.","Differentiates the constant on the right side as itself instead of 0")],
 "Different curve family (exponential in y instead of ln y), different point and constant; surface reworded as a tangent-slope request.",
 extra=dict(F=E**y+x*y-E-2,pt=(2,1),slope=-1/(E+2)))
add(s+'-v2',s,'medium','Implicit slope of a trigonometric curve',
 "The graph of sin(xy) + y = π/2 contains the point (2, π/2). Find dy/dx at this point.",
 C("−π/2",-pi/2,solve_yp(sp.cos(pi)*(pi/2+2*yp)+yp),"Differentiate both sides: cos(xy) · (y + x · dy/dx) + dy/dx = 0. At (2, π/2), xy = π and cos π = −1, so −(π/2 + 2 · dy/dx) + dy/dx = 0, which gives −π/2 − dy/dx = 0 and dy/dx = −π/2."),
 [C("π/2",pi/2,solve_yp(sp.cos(pi)*(pi/2)+yp),"This differentiates xy as y alone, dropping x · dy/dx from the product rule. Then cos π · (π/2) + dy/dx = 0 gives −π/2 + dy/dx = 0, so dy/dx = π/2. The inner derivative of xy is y + x · dy/dx, which gives −π/2.","Differentiates xy as y, dropping x · dy/dx"),
  C("1",1,solve_yp(sp.cos(pi)+yp),"This differentiates sin(xy) as cos(xy) with no inner-derivative factor. Then cos π + dy/dx = 0 gives −1 + dy/dx = 0, so dy/dx = 1. The chain rule requires multiplying by (y + x · dy/dx), which gives −π/2.","Omits the chain-rule factor for the inner function xy"),
  C("−π/6",-pi/6,solve_yp(1*(pi/2+2*yp)+yp),"This evaluates cos π as 1 instead of −1. Then (π/2 + 2 · dy/dx) + dy/dx = 0 gives 3 · dy/dx = −π/2, so dy/dx = −π/6. Since cos π = −1, the correct value is −π/2.","Evaluates cos π as 1")],
 "Trigonometric implicit curve with a product inside the sine; chain rule on xy and a special-angle evaluation replace the ln y structure.",
 extra=dict(F=sp.sin(x*y)+y-pi/2,pt=(2,pi/2),slope=-pi/2))
add(s+'-v3',s,'medium','Implicit slope with ln x and y squared',
 "Consider the curve y ln x + y² = 2, which passes through the point (e, 1). What is the value of dy/dx at (e, 1)?",
 C("−1/(3e)",-1/(3*E),solve_yp(yp+1/E+2*yp),"Differentiate both sides: (dy/dx) ln x + y/x + 2y · dy/dx = 0. At (e, 1), ln e = 1: dy/dx + 1/e + 2 · dy/dx = 0, so 3 · dy/dx = −1/e and dy/dx = −1/(3e)."),
 [C("0",0,solve_yp(yp+2*yp),"This differentiates y ln x as (dy/dx) ln x, dropping the product-rule term y/x. Then dy/dx + 2 · dy/dx = 0 gives dy/dx = 0. The term y/x = 1/e contributes, giving −1/(3e).","Drops the y/x term of the product rule"),
  C("−(2e + 1)/e",-(2*E+1)/E,solve_yp(yp+1/E+2),"This differentiates y² as 2y without the factor dy/dx. At (e, 1) that gives dy/dx + 1/e + 2 = 0, so dy/dx = −2 − 1/e = −(2e + 1)/e. The chain rule gives 2y · dy/dx, which leads to −1/(3e).","Omits dy/dx when differentiating y²"),
  C("(2e − 1)/(3e)",(2*E-1)/(3*E),solve_yp(yp+1/E+2*yp-2),"This differentiates the constant 2 on the right side as 2 instead of 0. Then 3 · dy/dx + 1/e = 2 gives dy/dx = (2 − 1/e)/3 = (2e − 1)/(3e). Since d/dx(2) = 0, the equation is 3 · dy/dx + 1/e = 0.","Differentiates the constant on the right side as itself instead of 0")],
 "Logarithm of x with y squared (rather than ln y with xy), point at x = e so ln x = 1.",
 extra=dict(F=y*sp.log(x)+y**2-2,pt=(E,1),slope=-1/(3*E)))

# ---------------- u3n-007 vertical tangent (hard)
s='apcalcab-mcq-u3n-007'
def slope_of(F,pt):
    Fx=sp.diff(F,x).subs({x:pt[0],y:pt[1]}); Fy=sp.diff(F,y).subs({x:pt[0],y:pt[1]})
    return Fx,Fy   # dy/dx = -Fx/Fy
def onc(F,k,pt): return sp.simplify(F.subs({x:pt[0],y:pt[1]})-k)==0
F1=x**2-3*x*y+4*y**2
add(s+'-v1',s,'hard','Vertical tangent on a quadratic curve',
 "The point (a, b), with a > 0 and b > 0, lies on the curve x² − 3xy + 4y² = 28, and the line tangent to the curve at (a, b) is vertical. Which of the following is (a, b)?",
 C("(8, 3)",True,onc(F1,28,(8,3)) and slope_of(F1,(8,3))[1]==0 and slope_of(F1,(8,3))[0]!=0,"Implicit differentiation gives 2x − 3y − 3x · dy/dx + 8y · dy/dx = 0, so dy/dx = (3y − 2x)/(8y − 3x). The tangent is vertical where the denominator is 0 and the numerator is not, i.e. 3x = 8y. Substituting x = 8y/3 into the curve gives 64y²/9 − 8y² + 4y² = 28y²/9 = 28, so y = 3 and x = 8. The point is (8, 3)."),
 [C("(6, 4)",True,onc(F1,28,(6,4)) and slope_of(F1,(6,4))[0]==0 and slope_of(F1,(6,4))[1]!=0,"This point is on the curve (36 − 72 + 64 = 28), but there dy/dx = (12 − 12)/(32 − 18) = 0, so the tangent is horizontal, not vertical. The vertical condition is a zero denominator, 8y − 3x = 0.","Sets the numerator 3y − 2x to 0 (horizontal tangent) instead of the denominator"),
  C("(16, 6)",True,(not onc(F1,28,(16,6))) and 3*16-8*6==0,"This satisfies 3x = 8y, the vertical-tangent condition, but is not on the curve: 256 − 288 + 144 = 112, not 28. The condition must be combined with the curve's equation, which gives y = 3.","Uses the vertical-tangent condition but never checks the curve equation"),
  C("(1, 3)",True,onc(F1,28,(1,3)) and slope_of(F1,(1,3))[0]!=0 and slope_of(F1,(1,3))[1]!=0,"This point is on the curve (1 − 9 + 36 = 28), but there dy/dx = (9 − 2)/(24 − 3) = 1/3, so the tangent is neither vertical nor horizontal. Lying on the curve is not enough; the denominator 8y − 3x must be 0.","Picks a point on the curve without testing the tangent condition")],
 "Different quadratic coefficients and constant (x² − 3xy + 4y² = 28); new point set with the same three error types (horizontal, off-curve, on-curve but not vertical).",extra=None)
F2=x**2-2*x+4*y**2-8*y
add(s+'-v2',s,'hard','Vertical tangent on a shifted ellipse',
 "An ellipse is given by x² − 2x + 4y² − 8y = 11. At exactly one point (a, b) with a > 0 and b > 0, the tangent line to the ellipse is vertical. Which of the following is that point?",
 C("(5, 1)",True,onc(F2,11,(5,1)) and slope_of(F2,(5,1))[1]==0 and slope_of(F2,(5,1))[0]!=0,"Implicit differentiation gives 2x − 2 + 8y · dy/dx − 8 · dy/dx = 0, so dy/dx = (1 − x)/(4(y − 1)). The tangent is vertical where the denominator is 0 and the numerator is not, i.e. y = 1. Substituting into the curve gives x² − 2x + 4 − 8 = 11, so x² − 2x − 15 = 0 and x = 5 or x = −3. With a > 0, the point is (5, 1)."),
 [C("(1, 3)",True,onc(F2,11,(1,3)) and slope_of(F2,(1,3))[0]==0 and slope_of(F2,(1,3))[1]!=0,"This point is on the ellipse (1 − 2 + 36 − 24 = 11), but there dy/dx = (1 − 1)/(4 · 2) = 0, so the tangent is horizontal, not vertical. The vertical condition is a zero denominator, y − 1 = 0.","Sets the numerator 1 − x to 0 (horizontal tangent) instead of the denominator"),
  C("(1, 1)",True,(not onc(F2,11,(1,1))) and 1==1,"This point has y = 1, the vertical-tangent condition, but is not on the ellipse: 1 − 2 + 4 − 8 = −5, not 11. The condition must be combined with the curve's equation, which gives x = 5.","Uses the vertical-tangent condition y = 1 but never checks the curve equation"),
  C("(3, 1 + √3)",True,onc(F2,11,(3,1+sp.sqrt(3))) and slope_of(F2,(3,1+sp.sqrt(3)))[0]!=0 and slope_of(F2,(3,1+sp.sqrt(3)))[1]!=0,"This point is on the ellipse (9 − 6 + 4(4 + 2√3) − 8 − 8√3 = 11), but there dy/dx = (1 − 3)/(4√3) = −1/(2√3), so the tangent is neither vertical nor horizontal. Lying on the curve is not enough; y − 1 must be 0.","Picks a point on the curve without testing the tangent condition")],
 "Different surface: shifted ellipse with no xy term, so the vertical condition is y = 1 rather than a ratio of x and y; distractors are the horizontal-tangent point, an off-curve point, and an on-curve non-tangent point.")
F3=4*x**2-3*x*y+y**2
add(s+'-v3',s,'hard','Horizontal tangent on a quadratic curve',
 "The point (a, b), with a > 0 and b > 0, lies on the curve 4x² − 3xy + y² = 28, and the line tangent to the curve at (a, b) is horizontal. Which of the following is (a, b)?",
 C("(3, 8)",True,onc(F3,28,(3,8)) and slope_of(F3,(3,8))[0]==0 and slope_of(F3,(3,8))[1]!=0,"Implicit differentiation gives 8x − 3y − 3x · dy/dx + 2y · dy/dx = 0, so dy/dx = (8x − 3y)/(3x − 2y). The tangent is horizontal where the numerator is 0 and the denominator is not, i.e. 3y = 8x. Substituting y = 8x/3 into the curve gives 4x² − 8x² + 64x²/9 = 28x²/9 = 28, so x = 3 and y = 8. The point is (3, 8)."),
 [C("(4, 6)",True,onc(F3,28,(4,6)) and slope_of(F3,(4,6))[1]==0 and slope_of(F3,(4,6))[0]!=0,"This point is on the curve (64 − 72 + 36 = 28), but there the denominator 3x − 2y = 12 − 12 = 0 and the numerator 8x − 3y = 14 is not 0, so the tangent is vertical, not horizontal. The horizontal condition is a zero numerator, 8x − 3y = 0.","Sets the denominator 3x − 2y to 0 (vertical tangent) instead of the numerator"),
  C("(6, 16)",True,(not onc(F3,28,(6,16))) and 8*6-3*16==0,"This satisfies 3y = 8x, the horizontal-tangent condition, but is not on the curve: 144 − 288 + 256 = 112, not 28. The condition must be combined with the curve's equation, which gives x = 3.","Uses the horizontal-tangent condition but never checks the curve equation"),
  C("(3, 1)",True,onc(F3,28,(3,1)) and slope_of(F3,(3,1))[0]!=0 and slope_of(F3,(3,1))[1]!=0,"This point is on the curve (36 − 9 + 1 = 28), but there dy/dx = (24 − 3)/(9 − 2) = 3, so the tangent is neither horizontal nor vertical. Lying on the curve is not enough; the numerator 8x − 3y must be 0.","Picks a point on the curve without testing the tangent condition")],
 "Asks for the horizontal tangent (zero numerator) on a different quadratic curve, so the roles of numerator and denominator are reversed relative to the seed.")

# ---------------- u3n-008 inverse from table (easy)
s='apcalcab-mcq-u3n-008'
add(s+'-v1',s,'easy','Inverse slope from a table of values',
 "The function f is differentiable and one-to-one. Selected values of f and f′ are shown.\n\nx | f(x) | f′(x)\n1 | 3 | 2\n2 | 6 | 5\n4 | 8 | 3\n6 | 13 | 9\n\nWhat is the value of (f⁻¹)′(6)?",
 C("1/5",S(1,5),S(1,5),"f(2) = 6, so f⁻¹(6) = 2, and (f⁻¹)′(6) = 1/f′(f⁻¹(6)) = 1/f′(2) = 1/5."),
 [C("5",5,5,"This is f′(2), the derivative of f rather than of f⁻¹. The derivative of the inverse is the reciprocal, 1/5.","Reports f′ at the matching point without taking the reciprocal"),
  C("1/9",S(1,9),1/S(9),"This uses 1/f′(6) = 1/9, plugging the input 6 into f′. The formula requires f′ at f⁻¹(6) = 2, where f′(2) = 5, so the value is 1/5.","Evaluates f′ at the input value instead of at f⁻¹ of the input"),
  C("2",2,2,"This is f⁻¹(6) = 2, the value of the inverse function itself, not its derivative. The derivative is 1/f′(2) = 1/5.","Reports the inverse function value instead of its derivative")],
 "New table values and a different input (6); distractors changed to non-reciprocal, wrong-row, and function-value errors.")
add(s+'-v2',s,'easy','Inverse rate for a filling tank',
 "The depth of water in a tank is g(t) centimeters at time t minutes, where g is differentiable and strictly increasing. Selected values are given.\n\nt | g(t) | g′(t)\n0 | 4 | 1/2\n3 | 10 | 2/3\n5 | 12 | 3/4\n8 | 15 | 5/4\n\nWhat is (g⁻¹)′(10)?",
 C("3/2",S(3,2),1/S(2,3),"g(3) = 10, so g⁻¹(10) = 3, and (g⁻¹)′(10) = 1/g′(g⁻¹(10)) = 1/g′(3) = 1/(2/3) = 3/2."),
 [C("2/3",S(2,3),S(2,3),"This is g′(3), the derivative of g rather than of g⁻¹. The derivative of the inverse is the reciprocal, 3/2.","Reports g′ at the matching point without taking the reciprocal"),
  C("3",3,3,"This is g⁻¹(10) = 3, the time at which the depth is 10, not the derivative of g⁻¹. The derivative is 1/g′(3) = 3/2.","Reports the inverse function value instead of its derivative"),
  C("1/10",S(1,10),1/S(10),"This takes the reciprocal of the input value 10. The reciprocal must be of the slope g′(3) = 2/3, so the value is 3/2.","Takes the reciprocal of the input value instead of the slope")],
 "Contextual (tank depth) with fractional derivative values, so the inverse derivative is not an integer-reciprocal.")
add(s+'-v3',s,'easy','Inverse slope for a decreasing function',
 "The function h is differentiable and one-to-one, with h(1) = 8, h(2) = 5, h(3) = 2, h′(1) = −4, h′(2) = −6, and h′(3) = −8. What is (h⁻¹)′(2)?",
 C("−1/8",-S(1,8),-1/S(8),"h(3) = 2, so h⁻¹(2) = 3, and (h⁻¹)′(2) = 1/h′(h⁻¹(2)) = 1/h′(3) = −1/8."),
 [C("1/8",S(1,8),1/S(8),"This takes the reciprocal of 8 but drops the negative sign, assuming the inverse must be increasing. Since h is decreasing, h⁻¹ is decreasing too: 1/h′(3) = 1/(−8) = −1/8.","Drops the negative sign of h′(3) when taking the reciprocal"),
  C("−8",-8,-8,"This is h′(3), the derivative of h rather than of h⁻¹. The derivative of the inverse is the reciprocal, −1/8.","Reports h′ at the matching point without taking the reciprocal"),
  C("−1/6",-S(1,6),-1/S(6),"This uses 1/h′(2) = 1/(−6), plugging the input 2 into h′. The formula requires h′ at h⁻¹(2) = 3, where h′(3) = −8, so the value is −1/8.","Evaluates h′ at the input value instead of at h⁻¹ of the input")],
 "Decreasing function given as a list of values rather than a table, so the sign of the answer matters; one distractor targets the sign misconception.")

# ---------------- u3n-009 inverse of formula (medium)
s='apcalcab-mcq-u3n-009'
fx=x**3+4*x-2
add(s+'-v1',s,'medium','Inverse derivative for a cubic polynomial',
 "The function f(x) = x³ + 4x − 2 is one-to-one. Find (f⁻¹)′(3).",
 C("1/7",S(1,7),1/sp.diff(fx,x).subs(x,1) if fx.subs(x,1)==3 else None,"f(1) = 1 + 4 − 2 = 3, so f⁻¹(3) = 1. Since f′(x) = 3x² + 4, f′(1) = 7, and (f⁻¹)′(3) = 1/f′(1) = 1/7."),
 [C("1/31",S(1,31),1/sp.diff(fx,x).subs(x,3),"This uses 1/f′(3) = 1/(3 · 9 + 4) = 1/31, evaluating f′ at 3. The formula needs f′ at f⁻¹(3) = 1, where f′(1) = 7.","Evaluates f′ at the input value instead of at f⁻¹ of the input"),
  C("7",7,sp.diff(fx,x).subs(x,1),"This is f′(1), the slope of f at the matching point. The slope of f⁻¹ is its reciprocal, 1/7.","Reports f′ at the matching point without taking the reciprocal"),
  C("1/3",S(1,3),1/S(3),"This takes the reciprocal of the value f(1) = 3. The reciprocal must be of the derivative f′(1) = 7, not of the function value.","Takes the reciprocal of the function value instead of the derivative")],
 "New cubic with different coefficients and target value.")
fe=sp.exp(x)+3*x
add(s+'-v2',s,'medium','Inverse derivative with an exponential function',
 "Let f(x) = e^x + 3x, which is one-to-one. What is (f⁻¹)′(1)?",
 C("1/4",S(1,4),1/sp.diff(fe,x).subs(x,0) if fe.subs(x,0)==1 else None,"f(0) = e⁰ + 0 = 1, so f⁻¹(1) = 0. Since f′(x) = e^x + 3, f′(0) = 4, and (f⁻¹)′(1) = 1/f′(0) = 1/4."),
 [C("1/(e + 3)",1/(E+3),1/sp.diff(fe,x).subs(x,1),"This uses 1/f′(1) = 1/(e + 3), evaluating f′ at 1. The formula needs f′ at f⁻¹(1) = 0, where f′(0) = 4.","Evaluates f′ at the input value instead of at f⁻¹ of the input"),
  C("4",4,sp.diff(fe,x).subs(x,0),"This is f′(0), the slope of f at the matching point. The slope of f⁻¹ is its reciprocal, 1/4.","Reports f′ at the matching point without taking the reciprocal"),
  C("1/3",S(1,3),1/(0+3),"This evaluates e⁰ as 0, so f′(0) = 0 + 3 = 3 and the result is 1/3. Since e⁰ = 1, f′(0) = 1 + 3 = 4 and the value is 1/4.","Evaluates e^0 as 0")],
 "Exponential-plus-linear function (not a polynomial); the matching point is found by inspection at x = 0.")
fq=x**2+3*x
add(s+'-v3',s,'medium','Inverse derivative with a restricted domain',
 "The function f(x) = x² + 3x is defined for x ≥ 0, so it is one-to-one on that domain. What is (f⁻¹)′(10)?",
 C("1/7",S(1,7),1/sp.diff(fq,x).subs(x,2) if fq.subs(x,2)==10 else None,"Solve x² + 3x = 10: (x + 5)(x − 2) = 0, and x ≥ 0 gives x = 2, so f⁻¹(10) = 2. Since f′(x) = 2x + 3, f′(2) = 7, and (f⁻¹)′(10) = 1/f′(2) = 1/7."),
 [C("1/23",S(1,23),1/sp.diff(fq,x).subs(x,10),"This uses 1/f′(10) = 1/(2 · 10 + 3) = 1/23, evaluating f′ at 10. The formula needs f′ at f⁻¹(10) = 2, where f′(2) = 7.","Evaluates f′ at the input value instead of at f⁻¹ of the input"),
  C("7",7,sp.diff(fq,x).subs(x,2),"This is f′(2), the slope of f at the matching point. The slope of f⁻¹ is its reciprocal, 1/7.","Reports f′ at the matching point without taking the reciprocal"),
  C("−1/7",-S(1,7),1/sp.diff(fq,x).subs(x,-5),"This uses the root x = −5 of x² + 3x = 10, which is outside the domain x ≥ 0. Then f′(−5) = −7 and 1/f′(−5) = −1/7. The domain requires x = 2, giving 1/7.","Chooses the root of f(x) = 10 that lies outside the domain")],
 "Quadratic with a domain restriction, so locating f⁻¹(10) requires choosing the correct root; a distractor uses the extraneous root.")

# ---------------- u3n-010 inverse trig with chain (medium)
s='apcalcab-mcq-u3n-010'
u=sp.symbols('u')
add(s+'-v1',s,'medium','Slope of an inverse cosine curve',
 "Find the slope of the tangent line to the graph of g(x) = cos⁻¹(3x) at x = 1/6.",
 C("−2√3",-2*sp.sqrt(3),(-3/sp.sqrt(1-(3*x)**2)).subs(x,S(1,6)),"g′(x) = −3/√(1 − (3x)²). At x = 1/6: 1 − 1/4 = 3/4, so g′(1/6) = −3/√(3/4) = −3/(√3/2) = −6/√3 = −2√3."),
 [C("−2/√3",-2/sp.sqrt(3),(-1/sp.sqrt(1-(3*x)**2)).subs(x,S(1,6)),"This is −1/√(1 − (3x)²) = −1/(√3/2) = −2/√3 at x = 1/6, with no chain-rule factor 3 from d/dx(3x). The correct value is −2√3.","Omits the chain-rule factor from the inner function 3x"),
  C("2√3",2*sp.sqrt(3),(3/sp.sqrt(1-(3*x)**2)).subs(x,S(1,6)),"This uses +3/√(1 − (3x)²), the derivative of sin⁻¹(3x), and misses the negative sign of the derivative of cos⁻¹: 3/(√3/2) = 2√3. The correct value is −2√3.","Uses the sin⁻¹ derivative, dropping the minus sign of cos⁻¹"),
  C("−6/√5",-6/sp.sqrt(5),(-3/sp.sqrt(1+(3*x)**2)).subs(x,S(1,6)),"This uses −3/√(1 + (3x)²) = −3/√(5/4) = −6/√5, with a plus sign under the radical. The derivative of cos⁻¹ u has 1 − u² under the radical, giving −2√3.","Uses 1 + u² instead of 1 − u² under the radical")],
 "Inverse cosine instead of inverse sine (adds the negative sign), different coefficient and evaluation point; reworded as a tangent-slope request.")
add(s+'-v2',s,'medium','Derivative of inverse sine with a fractional argument',
 "Let f(x) = sin⁻¹(x/3). Evaluate f′(3/2).",
 C("2/(3√3)",2/(3*sp.sqrt(3)),((1/S(3))/sp.sqrt(1-(x/3)**2)).subs(x,S(3,2)),"f′(x) = (1/3)/√(1 − (x/3)²). At x = 3/2: (x/3)² = 1/4, so f′(3/2) = (1/3)/√(3/4) = (1/3)/(√3/2) = 2/(3√3)."),
 [C("2/√3",2/sp.sqrt(3),(1/sp.sqrt(1-(x/3)**2)).subs(x,S(3,2)),"This is 1/√(1 − (x/3)²) = 1/(√3/2) = 2/√3 at x = 3/2, with no chain-rule factor 1/3 from d/dx(x/3). The correct value is 2/(3√3).","Omits the chain-rule factor from the inner function x/3"),
  C("2/(3√5)",2/(3*sp.sqrt(5)),((1/S(3))/sp.sqrt(1+(x/3)**2)).subs(x,S(3,2)),"This uses (1/3)/√(1 + (x/3)²) = (1/3)/√(5/4) = 2/(3√5), with a plus sign under the radical. The derivative of sin⁻¹ u has 1 − u² under the radical, giving 2/(3√3).","Uses 1 + u² instead of 1 − u² under the radical"),
  C("4/9",S(4,9),((1/S(3))/(1-(x/3)**2)).subs(x,S(3,2)),"This drops the square root: (1/3)/(1 − 1/4) = (1/3)/(3/4) = 4/9. The derivative of sin⁻¹ u has √(1 − u²) in the denominator, giving 2/(3√3).","Drops the square root in the denominator")],
 "Fractional inner function x/3 (chain factor 1/3 instead of 2) with a different evaluation point.")
add(s+'-v3',s,'medium','Inverse sine of an exponential',
 "If f(x) = sin⁻¹(e^x), what is f′(−ln 2)?",
 C("1/√3",1/sp.sqrt(3),(sp.exp(x)/sp.sqrt(1-sp.exp(2*x))).subs(x,-sp.log(2)),"f′(x) = e^x/√(1 − (e^x)²). At x = −ln 2, e^x = 1/2, so f′ = (1/2)/√(1 − 1/4) = (1/2)/(√3/2) = 1/√3."),
 [C("2/√3",2/sp.sqrt(3),(1/sp.sqrt(1-sp.exp(2*x))).subs(x,-sp.log(2)),"This is 1/√(1 − (e^x)²) = 1/(√3/2) = 2/√3, with no chain-rule factor e^x = 1/2 from the inner function. The correct value is 1/√3.","Omits the chain-rule factor e^x from the inner function"),
  C("√2/2",sp.sqrt(2)/2,(sp.exp(x)/sp.sqrt(1-sp.exp(x))).subs(x,-sp.log(2)),"This writes 1 − e^x under the radical instead of 1 − (e^x)²: (1/2)/√(1 − 1/2) = (1/2)/(√2/2) = √2/2. The inside function must be squared, giving 1/√3.","Does not square the inner function under the radical"),
  C("1/√5",1/sp.sqrt(5),(sp.exp(x)/sp.sqrt(1+sp.exp(2*x))).subs(x,-sp.log(2)),"This uses (1/2)/√(1 + 1/4) = (1/2)/(√5/2) = 1/√5, with a plus sign under the radical. The derivative of sin⁻¹ u has 1 − u² under the radical, giving 1/√3.","Uses 1 + u² instead of 1 − u² under the radical")],
 "Inner function is an exponential and the evaluation point uses a logarithm value; a new distractor targets forgetting to square the inner function.")

# ---------------- u3n-011 derivative of tan^-1 (easy)
s='apcalcab-mcq-u3n-011'
ex=sp.exp(x)
add(s+'-v1',s,'easy','Derivative of inverse tangent of an exponential',
 "Find f′(x) when f(x) = tan⁻¹(e^x).",
 C("e^x/(1 + e^(2x))",ex/(1+ex**2),sp.diff(sp.atan(ex),x),"d/dx tan⁻¹ u = u′/(1 + u²) with u = e^x, u′ = e^x, so f′(x) = e^x/(1 + (e^x)²) = e^x/(1 + e^(2x))."),
 [C("1/(1 + e^(2x))",1/(1+ex**2),1/(1+ex**2),"This keeps the denominator 1 + (e^x)² but omits the chain-rule factor u′ = e^x in the numerator.","Omits the chain-rule factor u′"),
  C("e^x/(1 + e^x)",ex/(1+ex),ex/(1+ex),"This uses 1 + u instead of 1 + u². The denominator is 1 + (e^x)² = 1 + e^(2x).","Does not square u in the denominator"),
  C("e^x/√(1 − e^(2x))",ex/sp.sqrt(1-ex**2),ex/sp.sqrt(1-ex**2),"This uses the derivative of sin⁻¹(e^x), not tan⁻¹(e^x). The derivative of tan⁻¹ u is u′/(1 + u²), with no radical.","Uses the sin⁻¹ derivative formula")],
 "Inner function e^x instead of 5x (exponential rather than linear); distractors include a new error of not squaring u.")
add(s+'-v2',s,'easy','Derivative of inverse sine with a linear inside',
 "If f(x) = sin⁻¹(4x), what is f′(x)?",
 C("4/√(1 − 16x²)",4/sp.sqrt(1-16*x**2),sp.diff(sp.asin(4*x),x),"d/dx sin⁻¹ u = u′/√(1 − u²) with u = 4x, u′ = 4, so f′(x) = 4/√(1 − (4x)²) = 4/√(1 − 16x²)."),
 [C("4/(1 + 16x²)",4/(1+16*x**2),sp.diff(sp.atan(4*x),x),"This uses the derivative of tan⁻¹(4x), not sin⁻¹(4x). The derivative of sin⁻¹ u has a radical, √(1 − u²), in the denominator.","Uses the tan⁻¹ derivative formula"),
  C("1/√(1 − 16x²)",1/sp.sqrt(1-16*x**2),1/sp.sqrt(1-16*x**2),"This keeps the denominator √(1 − (4x)²) but omits the chain-rule factor u′ = 4 in the numerator.","Omits the chain-rule factor u′"),
  C("4/√(1 − 4x²)",4/sp.sqrt(1-4*x**2),4/sp.sqrt(1-4*x**2),"This squares only x, not 4x: (4x)² = 16x², so the radicand is 1 − 16x².","Squares x instead of 4x inside the radical")],
 "Inverse sine instead of inverse tangent; swaps the confusion between the two derivative formulas.")
add(s+'-v3',s,'easy','Derivative of inverse cosine',
 "Which of the following is the derivative of y = cos⁻¹(2x)?",
 C("−2/√(1 − 4x²)",-2/sp.sqrt(1-4*x**2),sp.diff(sp.acos(2*x),x),"d/dx cos⁻¹ u = −u′/√(1 − u²) with u = 2x, u′ = 2, so dy/dx = −2/√(1 − (2x)²) = −2/√(1 − 4x²)."),
 [C("2/√(1 − 4x²)",2/sp.sqrt(1-4*x**2),2/sp.sqrt(1-4*x**2),"This is the derivative of sin⁻¹(2x); it is missing the negative sign. The derivative of cos⁻¹ u is −u′/√(1 − u²).","Drops the negative sign of the cos⁻¹ derivative"),
  C("−1/√(1 − 4x²)",-1/sp.sqrt(1-4*x**2),-1/sp.sqrt(1-4*x**2),"This keeps the negative sign and the radical but omits the chain-rule factor u′ = 2 in the numerator.","Omits the chain-rule factor u′"),
  C("−2/(1 + 4x²)",-2/(1+4*x**2),-sp.diff(sp.atan(2*x),x),"This uses the tan⁻¹ pattern, 1 + (2x)², with a negative sign. The derivative of cos⁻¹ u has a radical, √(1 − u²), in the denominator.","Uses a 1 + u² denominator instead of the radical")],
 "Inverse cosine (negative sign), different inner coefficient, and a mixed-formula distractor.")

# ---------------- u3n-012 which rules (easy)
s='apcalcab-mcq-u3n-012'
add(s+'-v1',s,'easy','Which differentiation rules apply to a quotient',
 "Which of the following correctly identifies the rules needed to differentiate f(x) = e^(x²)/(x + 3)?",
 C("Quotient Rule, with the Chain Rule for e^(x²)",True,True,"f is a quotient of e^(x²) and x + 3. The numerator e^(x²) is a composite function, so its derivative uses the chain rule: 2x e^(x²). Thus f′(x) = (2x e^(x²)(x + 3) − e^(x²))/(x + 3)²."),
 [C("Quotient Rule only, since e^(x²) is its own derivative",True,True,"The derivative of e^(x²) is 2x e^(x²), not e^(x²), because the exponent x² is a composite inner function. The quotient rule alone leaves out the factor 2x.","Treats e^(x²) as having derivative e^(x²)"),
  C("Chain Rule only, with x + 3 as the inner function",True,True,"f is a ratio of two functions, not a function evaluated at x + 3, so the chain rule alone cannot differentiate it. The quotient rule is needed for the division.","Applies only the chain rule to a quotient"),
  C("Product Rule only, writing e^(x²)(x + 3)⁻¹ as a product",True,True,"Even after rewriting as a product, the factor e^(x²) is a composite function whose derivative is 2x e^(x²), which needs the chain rule. The product rule alone is not enough.","Uses the product rule without the chain rule for e^(x²)")],
 "Quotient of an exponential composite and a linear function; distractors target missing the chain rule, misapplying chain alone, and product-only.",check='conceptual')
add(s+'-v2',s,'easy','Which differentiation rules apply to a product',
 "A student must differentiate g(x) = (3x − 1)⁴ sin x. Which of the following correctly identifies the rules needed?",
 C("Product Rule, with the Chain Rule for (3x − 1)⁴",True,True,"g is a product of (3x − 1)⁴ and sin x. The factor (3x − 1)⁴ is a composite function, so its derivative uses the chain rule: 4(3x − 1)³ · 3 = 12(3x − 1)³. Thus g′(x) = 12(3x − 1)³ sin x + (3x − 1)⁴ cos x."),
 [C("Product Rule only, using 4(3x − 1)³ as the derivative of the first factor",True,True,"The derivative of (3x − 1)⁴ is 4(3x − 1)³ · 3 = 12(3x − 1)³; the inner derivative 3 is required. Without the chain rule the factor 3 is lost.","Applies the power rule to (3x − 1)⁴ without the inner derivative"),
  C("Chain Rule only, with sin x as the inner function",True,True,"g is a product of two factors, not a function evaluated at sin x, so the chain rule alone cannot differentiate it. The product rule is needed.","Applies only the chain rule to a product"),
  C("Quotient Rule, with the Chain Rule for (3x − 1)⁴",True,True,"g is a product, not a quotient: no function is divided by another. The quotient rule does not apply, although the chain rule is needed for (3x − 1)⁴.","Confuses a product with a quotient")],
 "Product of a power of a linear function and a trigonometric function; a distractor targets the specific lost factor of 3.",check='conceptual')
add(s+'-v3',s,'easy','How many chain rules for a nested function',
 "Which of the following correctly describes how to differentiate y = sin(e^(3x))?",
 C("Chain Rule twice: sin outside, e^(3x) in the middle, 3x inside",True,True,"y is nested three levels deep. The derivative is cos(e^(3x)) · e^(3x) · 3, which applies the chain rule to sin(u) with u = e^(3x), and again to e^(3x) with inner function 3x."),
 [C("Chain Rule once, with e^(3x) as the inner function and e^(3x) as its derivative",True,True,"The derivative of e^(3x) is 3e^(3x), which needs a second chain-rule step for the inner function 3x. Using e^(3x) as its derivative loses the factor 3.","Treats the derivative of e^(3x) as e^(3x)"),
  C("Product Rule, treating sin and e^(3x) as two factors",True,True,"y is sin evaluated at e^(3x), a composition, not a product of sin and e^(3x). The chain rule applies, not the product rule.","Treats a composition as a product"),
  C("Chain Rule once, with sin as the outer function and 3x as the inner function",True,True,"The inner function of sin is e^(3x), not 3x. Skipping the e^(3x) layer gives 3cos(3x) instead of 3e^(3x) cos(e^(3x)).","Skips the middle layer e^(3x) of the composition")],
 "Counts the layers of a three-level composition instead of identifying a product/quotient; no product or quotient structure appears in the correct answer.",check='conceptual')

# ---------------- u3n-013 quotient with composite (medium)
s='apcalcab-mcq-u3n-013'
f=sp.sin(3*x)/x
at=pi/3
u_,v_=sp.sin(3*x),x
add(s+'-v1',s,'medium','Quotient rule with a sine composite',
 "If f(x) = sin(3x)/x, what is f′(π/3)?",
 C("−9/π",-9/pi,sp.simplify(sp.diff(f,x).subs(x,at)),"f′(x) = (3cos(3x) · x − sin(3x) · 1)/x². At x = π/3: 3cos π · (π/3) − sin π = −π − 0 = −π, and x² = π²/9, so f′(π/3) = −π/(π²/9) = −9/π."),
 [C("9/π",9/pi,sp.simplify(((u_*1-sp.diff(u_,x)*v_)/v_**2).subs(x,at)),"This reverses the quotient rule numerator to f · g′ − f′ · g, giving (0 − (−π))/(π²/9) = π/(π²/9) = 9/π. The numerator must be f′ · g − f · g′, giving −9/π.","Reverses the order of subtraction in the quotient rule"),
  C("−3/π",-3/pi,sp.simplify(((sp.cos(3*x)*v_-u_*1)/v_**2).subs(x,at)),"This differentiates sin(3x) as cos(3x), omitting the factor 3: (cos π · (π/3) − 0)/(π²/9) = (−π/3)/(π²/9) = −3/π. The chain rule gives 3cos(3x), so the numerator is −π.","Omits the chain-rule factor 3 for sin(3x)"),
  C("−3",-3,sp.simplify(((sp.diff(u_,x)*v_-u_*1)/v_).subs(x,at)),"The numerator −π is correct, but the denominator was x = π/3 instead of x² = π²/9: −π/(π/3) = −3.","Divides by g instead of g² in the quotient rule")],
 "Trigonometric composite over x, evaluated at a special angle; different distractor set (reversed subtraction, missing chain factor, unsquared denominator).")
f=sp.exp(-x)/(x**2+1)
u_,v_=sp.exp(-x),x**2+1
add(s+'-v2',s,'medium','Quotient rule with a decaying exponential',
 "Let f(x) = e^(−x)/(x² + 1). Find f′(1).",
 C("−1/e",-1/E,sp.simplify(sp.diff(f,x).subs(x,1)),"f′(x) = (−e^(−x)(x² + 1) − e^(−x) · 2x)/(x² + 1)². At x = 1: (−2/e − 2/e)/4 = (−4/e)/4 = −1/e."),
 [C("0",0,sp.simplify(((sp.exp(-x)*v_-u_*sp.diff(v_,x))/v_**2).subs(x,1)),"This differentiates e^(−x) as e^(−x), missing the chain-rule factor −1: (e^(−1) · 2 − e^(−1) · 2)/4 = 0. The correct derivative is −e^(−x), giving −1/e.","Omits the chain-rule factor −1 for e^(−x)"),
  C("1/e",1/E,sp.simplify(((u_*sp.diff(v_,x)-sp.diff(u_,x)*v_)/v_**2).subs(x,1)),"This reverses the quotient rule numerator to f · g′ − f′ · g, giving (2/e + 2/e)/4 = 1/e. The numerator must be f′ · g − f · g′, giving −1/e.","Reverses the order of subtraction in the quotient rule"),
  C("−2/e",-2/E,sp.simplify(((sp.diff(u_,x)*v_-u_*sp.diff(v_,x))/v_).subs(x,1)),"The numerator −4/e is correct, but the denominator was x² + 1 = 2 instead of (x² + 1)² = 4: (−4/e)/2 = −2/e.","Divides by g instead of g² in the quotient rule")],
 "Decaying exponential over a quadratic; the chain-rule error here produces a different value than in the seed.")
f=sp.sqrt(4*t+1)/t
u_,v_=sp.sqrt(4*t+1),t
add(s+'-v3',s,'medium','Concentration rate using the quotient rule',
 "The concentration of a medication in a patient's blood is C(t) = √(4t + 1)/t, where t is the time in hours since the dose, t > 0. What is C′(2)?",
 C("−5/12",-S(5,12),sp.simplify(sp.diff(f,t).subs(t,2)),"C′(t) = ((2/√(4t + 1)) · t − √(4t + 1) · 1)/t². At t = 2: (2/3 · 2 − 3)/4 = (4/3 − 3)/4 = (−5/3)/4 = −5/12."),
 [C("−2/3",-S(2,3),sp.simplify((((1/(2*sp.sqrt(4*t+1)))*v_-u_*1)/v_**2).subs(t,2)),"This differentiates √(4t + 1) as 1/(2√(4t + 1)), omitting the chain-rule factor 4: ((1/6) · 2 − 3)/4 = (1/3 − 3)/4 = −2/3. The chain rule gives 2/√(4t + 1) = 2/3 at t = 2.","Omits the chain-rule factor 4 for √(4t + 1)"),
  C("5/12",S(5,12),sp.simplify(((u_*1-sp.diff(u_,t)*v_)/v_**2).subs(t,2)),"This reverses the quotient rule numerator to f · g′ − f′ · g, giving (3 − 4/3)/4 = 5/12. The numerator must be f′ · g − f · g′, giving −5/12.","Reverses the order of subtraction in the quotient rule"),
  C("−5/6",-S(5,6),sp.simplify(((sp.diff(u_,t)*v_-u_*1)/v_).subs(t,2)),"The numerator −5/3 is correct, but the denominator was t = 2 instead of t² = 4: (−5/3)/2 = −5/6.","Divides by g instead of g² in the quotient rule")],
 "Square-root composite in a medication-concentration context; chain factor 4 inside the root.")

# ---------------- u3n-014 identify the error (medium)
s='apcalcab-mcq-u3n-014'
x_=x
add(s+'-v1',s,'medium','Identify the error in a product with a trig composite',
 "A student writes: d/dx[x sin 2x] = sin 2x + x cos 2x. Which statement correctly describes the student's error?",
 C("The product rule is set up correctly, but sin 2x has derivative 2cos 2x, so the second term is 2x cos 2x.",True,sp.simplify(sp.diff(x*sp.sin(2*x),x)-(sp.sin(2*x)+2*x*sp.cos(2*x)))==0 and sp.simplify(sp.diff(x*sp.sin(2*x),x)-(sp.sin(2*x)+x*sp.cos(2*x)))!=0,"By the product rule, d/dx[x sin 2x] = (1) sin 2x + x · (2cos 2x) = sin 2x + 2x cos 2x. The student's first term, sin 2x, was correct; the chain-rule factor 2 was missing from the second term."),
 [C("The derivative of x should be 0, because x is multiplied by a trigonometric function.",True,True,"The derivative of x is 1 whatever it is multiplied by, so the student's first term sin 2x was correct. The error is the missing factor 2 in the derivative of sin 2x.","Claims the derivative of x is 0"),
  C("The Quotient Rule is required, because sin 2x is not a polynomial.",True,True,"The expression is a product, not a quotient, and the quotient rule is for division. The product rule is the correct tool, whether or not a factor is a polynomial.","Confuses the product rule with the quotient rule"),
  C("The derivative of sin 2x is −cos 2x, so the second term should be −x cos 2x.",True,True,"The derivative of sin is cos, not −cos (the minus sign belongs to the derivative of cos). The actual error is the missing chain-rule factor 2, giving 2x cos 2x.","Uses −cos as the derivative of sin")],
 "Error type is a missing chain-rule factor inside a correctly set-up product rule, rather than multiplying the derivatives.",check='conceptual')
add(s+'-v2',s,'medium','Identify the error in a quotient derivative',
 "A student writes: d/dx[(x² + 1)/x] = 2x/1 = 2x. Which statement correctly describes the student's error?",
 C("It takes the quotient of the derivatives; the quotient rule gives (2x · x − (x² + 1))/x² = (x² − 1)/x².",True,sp.simplify(sp.diff((x**2+1)/x,x)-(x**2-1)/x**2)==0,"The derivative of a quotient is not the quotient of the derivatives. The quotient rule gives ((x²+1)′ · x − (x² + 1) · x′)/x² = (2x · x − (x² + 1))/x² = (x² − 1)/x²."),
 [C("The derivative of x² + 1 is 2x + 1, so the result should be (2x + 1)/1.",True,True,"The derivative of x² + 1 is 2x, since the derivative of the constant 1 is 0. The student's numerator derivative 2x was correct; the error was dividing derivatives instead of using the quotient rule.","Claims the derivative of x² + 1 is 2x + 1"),
  C("The derivative of the denominator x is 0, so the result should be 2x/x² = 2/x.",True,True,"The derivative of x is 1, not 0. Also the quotient rule requires the term (x² + 1) · 1 in the numerator, which gives (x² − 1)/x².","Claims the derivative of x is 0"),
  C("The answer should be negative because x is in the denominator, giving −2x.",True,True,"Placing a function in the denominator does not simply change the sign of a derivative. The quotient rule gives (x² − 1)/x², which is not −2x.","Believes a denominator just flips the sign")],
 "Error type is dividing derivatives instead of applying the quotient rule; correct statement includes the correct quotient-rule result.",check='conceptual')
add(s+'-v3',s,'medium','Identify the error in a chain rule derivative',
 "A student writes: d/dx[sin(x²)] = cos(2x). Which statement correctly describes the student's error?",
 C("It replaces x² by its derivative inside the cosine; the chain rule gives 2x cos(x²).",True,sp.simplify(sp.diff(sp.sin(x**2),x)-2*x*sp.cos(x**2))==0 and sp.simplify(sp.diff(sp.sin(x**2),x)-sp.cos(2*x))!=0,"The inside function x² must stay inside the cosine, and its derivative 2x is multiplied outside: d/dx[sin(x²)] = cos(x²) · 2x = 2x cos(x²). The student wrote cos(2x) instead."),
 [C("The derivative of sin should be −cos, so the answer should be −cos(2x).",True,True,"The derivative of sin u is cos u, not −cos u. The student's outside factor was correct; the error is placing the derivative 2x inside the cosine instead of multiplying by it.","Uses −cos as the derivative of sin"),
  C("The product rule is needed on sin and x², giving x² cos x + 2x sin x.",True,True,"sin(x²) is a composition (sin evaluated at x²), not a product of sin and x², so the product rule does not apply. The chain rule gives 2x cos(x²).","Treats a composition as a product"),
  C("The inside function should be left alone, so the derivative is cos(x²).",True,True,"The chain rule requires multiplying by the derivative of the inside function, 2x. Without it the derivative is cos(x²), which is missing a factor of 2x.","Believes no inner-derivative factor is needed")],
 "Error type is substituting the inner derivative inside the outer function instead of multiplying by it.",check='conceptual')

# ---------------- u3n-015 second derivative (hard)
s='apcalcab-mcq-u3n-015'
f=sp.sin(x**2); x0=sp.sqrt(pi/6)
f2=sp.simplify(sp.diff(f,x,2).subs(x,x0))
add(s+'-v1',s,'hard','Second derivative of a sine composite',
 "If f(x) = sin(x²), what is f″(√(π/6))?",
 C("√3 − π/3",sp.sqrt(3)-pi/3,f2,"f′(x) = 2x cos(x²). By the product rule, f″(x) = 2cos(x²) + 2x(−sin(x²))(2x) = 2cos(x²) − 4x² sin(x²). At x² = π/6: 2(√3/2) − 4(π/6)(1/2) = √3 − π/3."),
 [C("√3",sp.sqrt(3),(2*sp.cos(x**2)).subs(x,x0),"This keeps only the term 2cos(x²) = √3 and omits −4x² sin(x²), the term from differentiating cos(x²). Both terms together give √3 − π/3.","Drops the term from differentiating the second factor"),
  C("−π/3",-pi/3,sp.simplify((-4*x**2*sp.sin(x**2)).subs(x,x0)),"This differentiates only the factor cos(x²) and treats 2x as constant: −4x² sin(x²) = −4(π/6)(1/2) = −π/3. The product rule also needs the term 2cos(x²) = √3.","Drops the term from differentiating the first factor"),
  C("√3 + π/3",sp.sqrt(3)+pi/3,sp.simplify((2*sp.cos(x**2)+4*x**2*sp.sin(x**2)).subs(x,x0)),"This differentiates cos(x²) as +sin(x²) · 2x, with the wrong sign: 2cos(x²) + 4x² sin(x²) = √3 + π/3. The derivative of cos u is −sin u · u′, giving √3 − π/3.","Uses +sin as the derivative of cos")],
 "Sine composite in place of the Gaussian; special-angle evaluation with errors dropping each product-rule term and a sign error.")
f=sp.log(x**2+1)
add(s+'-v2',s,'hard','Second derivative of a logarithm',
 "If f(x) = ln(x² + 1), what is f″(3)?",
 C("−4/25",-S(4,25),sp.simplify(sp.diff(f,x,2).subs(x,3)),"f′(x) = 2x/(x² + 1). By the quotient rule, f″(x) = (2(x² + 1) − 2x · 2x)/(x² + 1)² = (2 − 2x²)/(x² + 1)². At x = 3: (2 − 18)/100 = −16/100 = −4/25."),
 [C("4/25",S(4,25),sp.simplify(((2*x*2*x-2*(x**2+1))/(x**2+1)**2).subs(x,3)),"This reverses the quotient rule numerator to f · g′ − f′ · g: (2x · 2x − 2(x² + 1)) = 36 − 20 = 16, so 16/100 = 4/25. The numerator must be f′ · g − f · g′, giving −16/100 = −4/25.","Reverses the order of subtraction in the quotient rule"),
  C("1/5",S(1,5),sp.simplify((2/(x**2+1)).subs(x,3)),"This differentiates only the numerator 2x and treats x² + 1 as constant: 2/(x² + 1) = 2/10 = 1/5. The quotient rule also needs the term from differentiating the denominator.","Treats the denominator of f′ as constant"),
  C("−8/5",-S(8,5),sp.simplify(((2*(x**2+1)-2*x*2*x)/(x**2+1)).subs(x,3)),"The numerator −16 is correct, but the denominator was x² + 1 = 10 instead of (x² + 1)² = 100: −16/10 = −8/5.","Divides by g instead of g² in the quotient rule")],
 "Logarithm of a quadratic: f′ is a quotient, so f″ needs the quotient rule instead of the product rule and chain.")
f=t**2*sp.exp(-t)
add(s+'-v3',s,'hard','Acceleration from an exponential position function',
 "A particle moves along a line with position s(t) = t² e^(−t) meters at time t seconds, t ≥ 0. What is the acceleration s″(3) in meters per second squared?",
 C("−1/e³",-1/E**3,sp.simplify(sp.diff(f,t,2).subs(t,3)),"s′(t) = 2t e^(−t) − t² e^(−t) = (2t − t²)e^(−t). By the product rule, s″(t) = (2 − 2t)e^(−t) − (2t − t²)e^(−t) = (t² − 4t + 2)e^(−t). At t = 3: (9 − 12 + 2)e⁻³ = −1/e³."),
 [C("−4/e³",-4/E**3,sp.simplify(((2-2*t)*sp.exp(-t)).subs(t,3)),"This differentiates only the polynomial factor 2t − t² and treats e^(−t) as constant: s″ = (2 − 2t)e^(−t) = −4e⁻³ at t = 3. The product rule also needs −(2t − t²)e^(−t).","Treats the exponential factor as constant in the second differentiation"),
  C("23/e³",23/E**3,sp.simplify(((2+2*t)*sp.exp(-t)+(2*t+t**2)*sp.exp(-t)).subs(t,3)),"This differentiates e^(−t) as +e^(−t), missing the chain-rule factor −1, at both steps: s′ = (2t + t²)e^(−t), s″ = (t² + 4t + 2)e^(−t), which is 23e⁻³ at t = 3. The correct derivative of e^(−t) is −e^(−t).","Omits the chain-rule factor −1 for e^(−t)"),
  C("−3/e³",-3/E**3,sp.simplify(((2*t-t**2)*sp.exp(-t)).subs(t,3)),"This is s′(3) = (6 − 9)e⁻³ = −3/e³, the velocity: the derivative was taken only once. Acceleration is the second derivative, which gives −1/e³.","Stops after the first derivative")],
 "Contextual (acceleration of a particle) with t² e^(−t); product rule at both steps and a distinct set of errors, including stopping after one derivative.")
