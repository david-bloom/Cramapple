import json, os, re
import sympy as sp
x,t,h=sp.symbols('x t h',real=True)
D=os.path.dirname(os.path.abspath(__file__))
S={q["key"]:q for q in json.load(open(os.path.join(D,"seeds_u2n.json")))}
R=sp.Rational; pi=sp.pi; e=sp.E
def tidy(v): return sp.nsimplify(sp.simplify(v))
def num(v):
    v=sp.sympify(v)
    if v.free_symbols: v=v.subs(x,R(7,3))  # compare expressions at a generic point
    return float(sp.N(v))

# spec: key -> (true value, {choice text: value of that choice computed from the intended (wrong) reasoning})
spec={}
f=x**2-3*x
true=(f.subs(x,4)-f.subs(x,1))/3
spec[1]=(true,{"2":2,"6":f.subs(x,4)-f.subs(x,1),"5":sp.diff(f,x).subs(x,4),"−1":sp.diff(f,x).subs(x,1)})
s=t**3-6*t
spec[2]=(sp.diff(s,t).subs(t,2),{"6 m/s":6,"−2 m/s":(s.subs(t,2)-s.subs(t,0))/2,"−4 m/s":s.subs(t,2),"0 m/s":(3*t-6).subs(t,2)})
lim=sp.limit((sp.sqrt(9+h)-3)/h,h,0)
spec[3]=(lim,{"1/6":R(1,6),"1/3":1/sp.sqrt(9),"6":2*sp.sqrt(9),"0":0})
spec[4]=(R(16-7,5-2),{"3":3,"9":9,"2":R(18-16,1),"9/7":R(9,7)})
# 5: piecewise
a=x**2; b=3*x-2
cont=(a.subs(x,2)==b.subs(x,2)); dl=sp.diff(a,x).subs(x,2); dr=sp.diff(b,x).subs(x,2)
assert cont and dl==4 and dr==3 and dl!=dr
g=3/x**2
spec[6]=(sp.diff(g,x),{"−6/x³":-6/x**3,"6/x³":6/x**3,"−6/x":-6/x,"−3/x³":-3/x**3})
f7=x**R(3,2)-12*x**R(1,2)
sol=lambda d:sp.solve(sp.simplify(d),x)
true7=[v for v in sol(sp.diff(f7,x)) if v>0]
w8=[v for v in sol(R(3,2)*sp.sqrt(x)-12/sp.sqrt(x)) if v>0]
w6=[v for v in sol(sp.sqrt(x)-6/sp.sqrt(x)) if v>0]
w12=[v for v in sol(f7) if v>0]
assert true7==[4] and w8==[8] and w6==[6] and w12==[12]
fg=sp.Function('f')
g8=lambda fp:2*fp-3
spec[8]=(g8(4),{"5":5,"2":2*4-3*2,"1":4-3,"11":2*4+3})
f9=4*sp.exp(x)-2*sp.cos(x)
spec[9]=(tidy(sp.diff(f9,x).subs(x,pi/2)),{"4e^(π/2) + 2":4*e**(pi/2)+2,"4e^(π/2) − 2":4*e**(pi/2)-2,"4e^(π/2)":4*e**(pi/2)+2*sp.cos(pi/2),"2πe^(π/2 − 1)":4*(pi/2)*e**(pi/2-1)})
g10=5*sp.log(x)-2/x
spec[10]=(sp.diff(g10,x).subs(x,2),{"3":3,"2":R(5,2)-R(2,4),"7/2":R(5,2)+R(2,2),"5/2":R(5,2)})
f11=(x**2+1)*(3*x-2)
u=x**2+1;v=3*x-2
spec[11]=(sp.diff(f11,x).subs(x,2),{"31":31,"12":sp.diff(u,x).subs(x,2)*sp.diff(v,x),"16":sp.diff(u,x).subs(x,2)*v.subs(x,2),"1":sp.diff(u,x).subs(x,2)*v.subs(x,2)-u.subs(x,2)*sp.diff(v,x)})
F=sp.Function('F'); 
# 12: h'(3) = 2*3*f(3) + 9*f'(3), f(3)=2, f'(3)=-1
true12=2*3*2+9*(-1); assert true12==3
spec[12]=(3,{None:3})
f13=(2*x+1)/(x-3)
spec[13]=(sp.diff(f13,x).subs(x,4),{"−7":-7,"7":((2*x+1)-2*(x-3)).subs(x,4),"11":(2*(x-3)+(2*x+1)).subs(x,4),"2":R(2,1)})
y=x/(x**2+4)
tr=set(sp.solve(sp.diff(y,x),x)); assert tr=={-2,2}
assert set(sp.solve(y,x))=={0} and sp.diff(y,x).subs(x,0)==R(1,4)
assert sp.solve(3*x**2+4,x)==[]  # no real roots (x declared real)
f15=sp.sec(x)+sp.cot(x)
spec[15]=(sp.simplify(sp.diff(f15,x).subs(x,pi/4)),{"√2 − 2":sp.sqrt(2)-2,"√2 + 2":sp.sqrt(2)+2,"0":sp.sec(pi/4)**2-2,"−√2 − 2":-sp.sqrt(2)-2})
# independent numeric derivative check of 15, 9, 11, 13
import math
nd=lambda fn,a,hh=1e-6:(fn(a+hh)-fn(a-hh))/(2*hh)
assert abs(nd(lambda z:1/math.cos(z)+1/math.tan(z),math.pi/4)-(math.sqrt(2)-2))<1e-5
assert abs(nd(lambda z:4*math.exp(z)-2*math.cos(z),math.pi/2)-(4*math.exp(math.pi/2)+2))<1e-4
assert abs(nd(lambda z:(z*z+1)*(3*z-2),2)-31)<1e-4
assert abs(nd(lambda z:(2*z+1)/(z-3),4)+7)<1e-4
assert abs(nd(lambda z:5*math.log(z)-2/z,2)-3)<1e-5
assert abs(((math.sqrt(9+1e-7)-3)/1e-7)-1/6)<1e-5

ok_all=True
assert len(S)==15
for i in range(1,16):
    k=f"apcalcab-mcq-u2n-{i:03d}"; q=S[k]; msgs=[]
    ch=[q["correct"]]+q["wrong"]
    if len(q["wrong"])!=3: msgs.append("wrong count")
    if re.search(r"(^|\n)\s*[A-D][.)]\s",q["stem"]): msgs.append("option list in stem")
    for c in ch:
        if not c["rationale"].strip(): msgs.append("empty rationale")
    lens=[len(c["text"]) for c in q["wrong"]]
    if len(q["correct"]["text"])>1.4*max(lens): msgs.append("correct too long")
    if len({c["text"] for c in ch})!=4: msgs.append("dup choices")
    if i in spec and i!=12:
        tv,m=spec[i]; tv=num(tv)
        texts={c["text"] for c in ch}
        if set(m)!=texts: msgs.append(f"text mismatch {texts^set(m)}")
        else:
            if abs(num(m[q["correct"]["text"]])-tv)>1e-9: msgs.append("correct value wrong")
            for c in q["wrong"]:
                if abs(num(m[c["text"]])-tv)<1e-9: msgs.append("wrong equals true: "+c["text"])
            vals=[round(num(m[c["text"]]),9) for c in ch]
            if len(set(vals))!=4: msgs.append("duplicate values")
    if i==12:
        # error candidates: 6, 12, -9 and student's -6
        assert 2*3*(-1)==-6 and 2*3*2==12 and 9*(-1)==-9 and true12 not in (6,12,-9)
    if i==5:
        assert "continuous at x = 2 but not differentiable" in q["correct"]["text"]
    if i==14:
        assert q["correct"]["text"]=="x = −2 and x = 2"
    if i==7: assert q["correct"]["text"]=="x = 4"
    ok = not msgs; ok_all&=ok
    print(k,"OK" if ok else "FAIL "+"; ".join(msgs))
print("ALL OK" if ok_all else "FAILURES")
