import json,re,itertools
V={v["id"]:v for v in json.load(open("variants_batch2.json"))}
S={s["key"]:s for s in json.load(open("seeds_batch2.json"))}
assert len(V)==15
def texts(v): return [v["correct"]["text"]]+[w["text"] for w in v["wrong"]]
def has(v,i,s):  # rationale i (0=correct) contains s
    r=v["correct"]["rationale"] if i==0 else v["wrong"][i-1]["rationale"]
    assert s in r,(v["id"],i,s,r)
for v in V.values():
    assert len(v["wrong"])==3 and len(set(texts(v)))==4
    for w in v["wrong"]: assert w["text"]!=v["correct"]["text"]
    L=[len(t) for t in texts(v)]
    assert L[0]<=max(L[1:])*1.6, (v["id"],L)
# ---- seed 025: EN
EN=dict(Na=0.93,H=2.20,S=2.58,N=3.04,Cl=3.16,O=3.44,K=0.82,Si=1.90,P=2.19,Br=2.96,Li=0.98,Be=1.57,C=2.55,I=2.66,F=3.98)
d=lambda a,b:round(abs(EN[a]-EN[b]),2); sm=lambda a,b:round(EN[a]+EN[b],2)
def pr(b): return b.split("–")
def f(x): return f"{x:.2f}"
# v1
v=V["apchem-mcq-025-v1"]; bonds=[pr(t) for t in texts(v)]
dd=[d(*b) for b in bonds]; assert dd[0]==max(dd) and dd.count(max(dd))==1
nonmetal=[i for i,b in enumerate(bonds) if "Na" not in b]
assert max(nonmetal,key=lambda i:dd[i])==3          # excluded-metal pattern -> H-Cl
assert max(range(4),key=lambda i:sm(*bonds[i]))==2   # sum pattern -> N-Cl
assert max(range(4),key=lambda i:max(EN[a] for a in bonds[i]))==1  # highest-EN atom -> O-S
for i,b in enumerate(bonds): has(v,i,f(dd[i])) if i!=1 or True else 0
assert f(sm('N','Cl'))=="6.20"; has(v,2,"6.20")
# v3
v=V["apchem-mcq-025-v3"]; bonds=[pr(t) for t in texts(v)]
dd=[d(*b) for b in bonds]; assert dd[0]==max(dd) and dd.count(max(dd))==1
assert min(range(4),key=lambda i:min(EN[a] for a in bonds[i]))==1  # most metallic atom -> Li-I
assert max(range(4),key=lambda i:max(EN[a] for a in bonds[i]))==2  # F -> C-F
assert max(range(4),key=lambda i:sm(*bonds[i]))==3                 # sum -> O-Cl
for i in range(4): has(v,i,f(dd[i]))
has(v,3,f(sm('O','Cl')))
# v2 ranking
v=V["apchem-mcq-025-v2"]; rk=[[pr(x.strip()) for x in t.split("<")] for t in texts(v)]
def order(key): return sorted(["P–H","S–Cl","Si–Cl","K–Br"],key=lambda b:key(pr(b)))
bs=["P–H","S–Cl","Si–Cl","K–Br"]
fmt=lambda o:" < ".join(o)
assert fmt(order(lambda b:d(*b)))==v["correct"]["text"]
assert fmt(order(lambda b:-d(*b)))==v["wrong"][0]["text"]
assert fmt(order(lambda b:sm(*b)))==v["wrong"][1]["text"]
# H-as-metal: H bonds treated as most ionic, rest by dEN
assert fmt(sorted(bs,key=lambda b:(("H" in pr(b)),d(*pr(b)))))==v["wrong"][2]["text"]
for b in bs: has(v,0,f(d(*pr(b))))
for b in bs: has(v,2,f(sm(*pr(b))))
# ---- formal charge
def fc(val,nb,be): return val-nb-be/2
cases={"apchem-mcq-027-v1":[(6,2,6,"+1"),(6,2,12,"−2"),(6,0,6,"+3"),(6,6,2,"−1")],
 }
def sg(x): return ("+" if x>0 else "−" if x<0 else "")+str(abs(int(x)))
v=V["apchem-mcq-027-v1"]
vals=[fc(6,2,6),fc(6,2,12),fc(6,0,6),fc(6,6,2)]  # correct; full-bond; no lone pair(=6-3 -> 6-0-6 =3? check)
assert vals==[1,-2,3,-1],vals
assert [sg(x) for x in vals]==texts(v)
v=V["apchem-mcq-027-v2"]
vals=[fc(5,0,8),fc(5,0,16),5-0,-1]
assert fc(5,0,8)==1 and 5-0-8==-3 and 5==5
assert [sg(x) for x in [1,-3,5,-1]]==texts(v)
v=V["apchem-mcq-027-v3"]
assert fc(4,2,6)==-1 and fc(6,2,6)==1 and 4-2-6==-4
assert [sg(x) if x else "0" for x in [-1,1,0,-4]]==texts(v)
assert fc(4,2,6)+fc(6,2,6)==0
# ---- seed 026 v2 electrons around I in IF5
val=7; bonds_=5; lp=(val-bonds_)//2; assert (val-bonds_)%2==0
e=bonds_*2+lp*2; dom=bonds_+lp
v=V["apchem-mcq-026-v2"]
assert [f"{x} electrons" for x in (e,bonds_*2,8,dom)]==texts(v) and e==12 and dom==6
# 026 v3 ICl2- electron count
tot=7+14+1; I_lp=(tot-4-12)//2   # 2 bonds (4 e), Cl take 3 LP each=12 e
assert I_lp==3 and 2*2+I_lp*2==10
# ---- VSEPR lookups for conceptual
shape={(2,0):"linear",(3,0):"trigonal planar",(3,1):"bent",(4,0):"tetrahedral",(4,1):"trigonal pyramidal",(4,2):"bent",
 (5,0):"trigonal bipyramidal",(5,1):"seesaw",(5,2):"T-shaped",(5,3):"linear",(6,0):"octahedral",(6,1):"square pyramidal",(6,2):"square planar"}
edg={2:"linear",3:"trigonal planar",4:"tetrahedral",5:"trigonal bipyramidal",6:"octahedral"}
def sp(bonded,lp): return shape[(bonded+lp,lp)] if False else shape[(bonded,lp)]
# keyed by (domains, lp)
def S_(dom,lp): return shape[(dom,lp)], edg[dom]
def lp_single(val,n,charge=0): x=val+charge-n; assert x%2==0; return x//2
# XeF4, BrF3, IF5, SF4, XeF2
assert S_(4+lp_single(8,4),lp_single(8,4))==("square planar","octahedral")
assert S_(3+lp_single(7,3),lp_single(7,3))==("T-shaped","trigonal bipyramidal")
assert S_(5+lp_single(7,5),lp_single(7,5))==("square pyramidal","octahedral")
assert S_(2+lp_single(8,2),lp_single(8,2))==("linear","trigonal bipyramidal")  # XeF2: 5 domains, 3 lp
assert lp_single(8,2)==3 and 2*2+3*2==10
for vid,(sh,e_) in {"apchem-mcq-028-v1":("square planar","octahedral"),"apchem-mcq-028-v2":("T-shaped","trigonal bipyramidal")}.items():
    assert texts(V[vid])[0].lower()==f"{e_}, then {sh}".lower()
# NO3-, CO3 2-, SO3 2-, ClF3, NO2-, PH3, SiH4, SO2
assert S_(3,0)[0]=="trigonal planar"   # NO3-, CO3 2-, CH2O (3 regions)
assert S_(3+1,1)[0]=="trigonal pyramidal"   # PH3 (3 bonds+1 lp), SO3 2-
assert lp_single(5,3)==1  # PH3
# SO3^2-: total valence 6+18+2=26, 3 S-O bonds (6) + 9 lone pairs on O (18) leaves 2 e = 1 lp on S
assert (26-6-18)//2==1
assert S_(5,2)[0]=="T-shaped" and lp_single(7,3)==2  # ClF3
assert S_(3,1)[0]=="bent"  # SO2, NO2-
assert S_(4,0)[0]=="tetrahedral"  # SiH4
# ---- Jaccard
tok=lambda v:set(re.findall(r"\w+"," ".join([v["stem"]]+texts(v)).lower()))
stok=lambda s:set(re.findall(r"\w+"," ".join([s["stem"]]+[c["text"] for c in s["choices"]]).lower()))
J=lambda a,b:len(a&b)/len(a|b)
mx=0;worst=None
for k,s in S.items():
    ids=[f"{k}-v{i}" for i in (1,2,3)]
    for i in ids:
        j=J(tok(V[i]),stok(s)); 
        if j>mx: mx,worst=j,(i,"seed")
        assert j<0.7,(i,j)
    for a,b in itertools.combinations(ids,2):
        j=J(tok(V[a]),tok(V[b]))
        if j>mx: mx,worst=j,(a,b)
        assert j<0.7,(a,b,j)
print("ALL CHECKS PASSED; max Jaccard %.3f"%mx,worst)
