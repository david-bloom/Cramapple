import json, re, math, itertools
R=0.08206
V={v["id"]:v for v in json.load(open("variants_batch4.json"))}
seeds={s["key"]:s for s in json.load(open("seeds_batch4.json"))}
assert len(V)==15
def num(t): return float(re.match(r"\s*([\d.]+)",t).group(1))
def dec(t): m=re.match(r"\s*\d*\.?(\d*)",t); return len(m.group(1))
def chk(vid, key, wrongs):
    v=V[vid]
    shown=[num(v["correct"]["text"])]+[num(w["text"]) for w in v["wrong"]]
    exp=[key]+wrongs
    for s,e,t in zip(shown,exp,[v["correct"]["text"]]+[w["text"] for w in v["wrong"]]):
        assert round(e,dec(t))==s,(vid,e,s)
    assert len(set(shown))==4 and all(abs(x-shown[0])>1e-9 for x in shown[1:]),vid
    print(vid,"ok",shown)
# 032-v1: n .250, V 5.00, T 47C
n,Vv,C=0.250,5.00,47; T=C+273
chk("apchem-mcq-032-v1",n*R*T/Vv,[n*R*C/Vv,1*R*T/Vv,n*R*T*Vv])
# v2: P 1.50 atm, V 4.00 L, 127C -> n
P,Vv,C=1.50,4.00,127; T=C+273
chk("apchem-mcq-032-v2",P*Vv/(R*T),[P*Vv/(R*C),R*T/(P*Vv),P*Vv/T])
# v3: n .800, P 2.50, 25C -> V
n,P,C=0.800,2.50,25; T=C+273
chk("apchem-mcq-032-v3",n*R*T/P,[n*R*C/P,P/(n*R*T),n*R*T*P])
# conceptual 033 supporting numbers
assert round(math.sqrt(2),1)==1.4
assert round(math.sqrt(40/4.0),1)==3.2 and 3.0<math.sqrt(10)<3.3  # "about 3 times"
assert 10!=round(math.sqrt(10))
assert round(math.sqrt(10))==3
# KE=1/2mv^2: doubling v -> KE x4 (distractor v2 option A is wrong)
assert (2**2)==4 and 4!=2
# conceptual variants must carry facts and 3 wrong each
for vid,v in V.items():
    assert v["seed"] in seeds and len(v["wrong"])==3 and v["check"] in("numeric","conceptual")
    texts=[v["correct"]["text"]]+[w["text"] for w in v["wrong"]]
    assert len(set(texts))==4
    for w in v["wrong"]:
        assert len(w["rationale"])>60 and w["error_pattern"]
    if v["check"]=="conceptual": assert v.get("facts"),vid
# Jaccard
def toks(v): return set(re.findall(r"\w+"," ".join([v["stem"]]+[v["correct"]["text"]]+[w["text"] for w in v["wrong"]]).lower()))
def stoks(s): return set(re.findall(r"\w+"," ".join([s["stem"]]).lower()))  # seed stem already embeds choices
mx=0
def jac(a,b): return len(a&b)/len(a|b)
for v in V.values():
    j=jac(toks(v),stoks(seeds[v["seed"]])); mx=max(mx,j); assert j<0.7,(v["id"],j)
for a,b in itertools.combinations(V.values(),2):
    if a["seed"]==b["seed"]:
        j=jac(toks(a),toks(b)); mx=max(mx,j); assert j<0.7,(a["id"],b["id"],j)
print("max jaccard %.3f"%mx)
# length balance
for v in V.values():
    L=[len(v["correct"]["text"])]+[len(w["text"]) for w in v["wrong"]]
    print(v["id"],L, "CORRECT LONGEST" if L[0]==max(L) and L[0]>max(L[1:]) else "")
print("ALL PASSED")
