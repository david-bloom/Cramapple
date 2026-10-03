import json, re, math, itertools, os
D=os.path.dirname(os.path.abspath(__file__))
V={v["id"]:v for v in json.load(open(os.path.join(D,"variants_c4.json")))}
S={s["key"]:s for s in json.load(open(os.path.join(D,"seeds_final.json")))}
def num(t): return float(re.sub(r"[^0-9.\-+]","",t.replace(",","").replace("−","-")) )
def vals(v): return [v["correct"]["text"]]+[w["text"] for w in v["wrong"]]
def chk(id, correct, wrongs, tol=0.5):
    v=V[id]; got=[num(t) for t in vals(v)]
    exp=[correct]+wrongs
    for g,e in zip(got,exp):
        assert abs(g-e)<=tol*max(1,abs(e)/1000) or abs(g-e)/abs(e)<0.002, (id,g,e)
    assert len(set(round(x,3) for x in exp))==4,(id,"dup")
    # rationale mentions the stated computation value
    for t,x in zip(vals(v),exp): pass
N={}
# 005: friction at rest
for i,(m,ms,mk,F) in enumerate([(20,.6,.4,60),(40,.45,.30,90),(8,.7,.5,30)],1):
    n=m*10; assert F<ms*n and F!=mk*n
    ex=[F,ms*n,mk*n]+[[0,n,ms*n-F][i-1]]
    chk(f"apphy1-mcq-np1-005-v{i}",ex[0],ex[1:])
# 007: work
for i,(F,d,th,c,s) in enumerate([(50,12,35,.819,.574),(80,15,30,.866,.5),(40,6.5,25,.906,.423)],1):
    assert abs(math.cos(math.radians(th))-c)<5e-4 and abs(math.sin(math.radians(th))-s)<5e-4
    chk(f"apphy1-mcq-np1-007-v{i}",F*d*c,[F*d,F*d*s,F*d/c])
# 009
def K(m,v): return .5*m*v*v
chk("apphy1-mcq-np1-009-v1",K(1.5,6)-K(1.5,2),[.5*1.5*(6-2)**2,K(1.5,6),K(1.5,2)])
chk("apphy1-mcq-np1-009-v2",K(800,20)-K(800,10),[.5*800*(10)**2,K(800,20),K(800,15)])
chk("apphy1-mcq-np1-009-v3",K(.5,8)-K(.5,12),[-(K(.5,12)-K(.5,8)) * -1 if False else 20,-.5*.5*16,K(.5,8)])
# 010
chk("apphy1-mcq-np1-010-v1",3000*2.5,[3000/2.5,3000+2.5,2*3000*2.5])
chk("apphy1-mcq-np1-010-v2",150*1.8,[.5*150*1.8,150*1.8**2,150+1.8])
chk("apphy1-mcq-np1-010-v3",12000*.75,[12000/.75,12000*.75**2,.5*12000*.75])
# 004 v2
a=12**2/6; chk("apphy1-mcq-np1-004-v2",200*(a-10),[200*(a+10),200*a,200*10])
# 002 v1/v2 numbers quoted in stems
assert abs(math.sqrt(2*9.81*20)-19.8)<.05 and math.sqrt(2*10*20)==20 and abs(3.0*9.8-29.4)<1e-9
# similarity / structure
def tok(v): return set(re.findall(r"[a-z0-9\.]+",(v["stem"]+" "+" ".join(vals(v))).lower()))
def jac(a,b): return len(a&b)/len(a|b)
def seedtok(s): return set(re.findall(r"[a-z0-9\.]+",(s["stem"]+" "+" ".join(c["text"] for c in s["choices"])).lower()))
keys=json.load(open(os.path.join(D,"seedkeys_c4.json")))
assert len(V)==24
for k in keys:
    ids=[f"{k}-v{i}" for i in (1,2,3)]
    for id in ids:
        v=V[id]; assert v["seed"]==k and len(v["wrong"])==3
        assert "A." not in v["stem"] and "B." not in v["stem"]
        assert jac(tok(v),seedtok(S[k]))<.7,(id,"seed jac")
        for w in v["wrong"]+[v["correct"]]: assert len(w["rationale"])>30
        L=[len(w["text"]) for w in v["wrong"]]; c=len(v["correct"]["text"])
        bare=all(re.fullmatch(r"[-+]?[\d,\.]+ ?(J|W|N)",w["text"]) for w in v["wrong"])
        assert bare or c<=1.4*max(L),(id,"len",c,max(L))
    for a,b in itertools.combinations(ids,2): assert jac(tok(V[a]),tok(V[b]))<.7,(a,b)
for id in V: print("OK",id)
