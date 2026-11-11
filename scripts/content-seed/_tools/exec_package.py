#!/usr/bin/env python3
"""Execute one prepared package in PRODUCTION (from ~/supabase, which links Production): preflight, load, hash check, rehearse, publish, rehearse retire, retire, verify, selector check.
Stops at the first failure. Usage: python3 exec_package.py <folder>"""
import json,os,re,subprocess,sys,tempfile,collections
F=os.path.abspath(sys.argv[1]); cfg=json.load(open(F+"/cfg.json")); items=json.load(open(F+"/items.json")); old=json.load(open(F+"/superseded_keys.json"))
CWD=os.path.expanduser("~/supabase")
def q(path_or_sql,is_sql=False,table=False):
    p=path_or_sql
    if is_sql:
        t=tempfile.NamedTemporaryFile("w",suffix=".sql",delete=False); t.write(path_or_sql); t.close(); p=t.name
    r=subprocess.run(["supabase","db","query","--linked","-f",p,"-o","json"],capture_output=True,text=True,cwd=CWD)
    if is_sql: os.unlink(p)
    out=r.stdout+r.stderr
    m=re.search(r"REHEARSAL OK[^\"\\]*",out)
    if m: return {"rehearsal":m.group(0)}
    if "{\n" not in r.stdout: raise SystemExit("QUERY FAILED: "+out[-500:])
    d=json.JSONDecoder().raw_decode(r.stdout[r.stdout.index("{\n"):])[0]; return d.get("rows")
def stop(m): print("STOP:",m); sys.exit(1)
print("==",os.path.basename(F),cfg["subject"],len(items),"new /",len(old),"retire")
U=cfg.get("unit",3)
K=",".join("'"+k.replace("'","''")+"'" for k in old); PK=cfg["pack"]; PFX=cfg["prefix"]
K=K or "''"
pre=q(f"select (select count(*) from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id and v.status='published' where ci.exam_pack_version_id='{PK}' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ({K})) o, (select count(*) from app.content_items where exam_pack_version_id='{PK}' and content_key like '{PFX}-%h-{U}.%') n",True)[0]
print("preflight old_published",pre["o"],"new_exist",pre["n"])
if pre["o"]!=len(old) or pre["n"]!=0: stop(f"preflight mismatch: expected {len(old)} published and 0 existing")
for f in sorted(os.listdir(F+"/load")):
    r=q(F+"/load/"+f)
    if not isinstance(r,list): stop("load "+f)
print("loaded",len(os.listdir(F+"/load")),"chunks")
def verify(expect):
    rows=q(F+"/verify_hashes.sql"); bad=[x for x in rows if not x["ok"] or (x["item_status"],x["version_status"])!=expect]
    return len(rows),bad
n,bad=verify(("draft","draft")); print("hash check",n-len(bad),"of",n,"draft")
if n!=len(items) or bad: stop("hash check "+str(bad[:3]))
r=q(F+"/publish_rehearsal.sql"); print(r if isinstance(r,dict) else "no rehearsal marker"); 
if not (isinstance(r,dict) and "published="+str(len(items)) in r["rehearsal"]): stop("publish rehearsal")
r=q(F+"/publish.sql")[0]; print("published",r)
if r["published"]!=len(items) or r["validated_labels"]!=len(items) or r["topic_cells"]!=len(items): stop("publish counts")
if old:
    r=q(F+"/retire_old_rehearsal.sql")
    if not (isinstance(r,dict) and f"retired={len(old)}" in r["rehearsal"]): stop("retire rehearsal "+str(r))
    r=q(F+"/retire_old.sql")[0]; print("retired",r)
    if r["retired"]!=len(old): stop("retire count")
else: print("no retirements in this batch")
n,bad=verify(("published","published")); print("post hash check",n-len(bad),"of",n,"published")
if bad: stop("post verify")
topics=sorted({i["topic"] for i in items},key=lambda t:int(t.split(".")[1])); unit=3
sel=q("select t, count(*) n, count(*) filter (where s.content_key like '"+PFX+"-%h-"+str(U)+".%') new_n from (values "+",".join(f"('{t}')" for t in topics)+") v(t), lateral public.select_student_practice_items('"+PK+"'::uuid, "+str(U)+", gen_random_uuid(), null, 'mcq', v.t, 51, 0) s group by t order by t",True)
exp=collections.Counter(i["topic"] for i in items); got={x["t"]:x["new_n"] for x in sel}
miss=[(t,got.get(t,0),exp[t]) for t in topics if got.get(t,0)<min(exp[t],51)]   # a topic with no rows at all counts as missing
print("selector new items per topic",{x["t"]:x["new_n"] for x in sel}, "MISSING" if miss else "ok")
cnt=q("select c.topic_code t, count(*) n from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id and v.status='published' join app.content_item_cells c on c.content_item_version_id=v.id and c.is_primary and c.superseded_by is null where ci.exam_pack_version_id='"+PK+"' and ci.item_type='mcq' and ci.status='published' and c.topic_code in ("+",".join(f"'{t}'" for t in topics)+") group by 1",True)
print("published MCQs per topic",{x["t"]:x["n"] for x in sorted(cnt,key=lambda x:int(x["t"].split(".")[1]))})
if miss: stop("selector missing "+str(miss))
print("DONE",os.path.basename(F))
