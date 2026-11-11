import re,json,sys
SRC="/Users/davidbloom/Documents/Cramapple.nosync/output/stats_unit2_replacement_seeds_draft.md"
lines=open(SRC).read().split("\n")
items=[];cur=None;topic=None;mode=None
TOP={"2.4":"2.4","2.5":"2.5","2.6":"2.6","2.7":"2.7","2.9":"2.9","2.10":"2.10"}
def flush():
    global cur
    if cur: items.append(cur)
    cur=None
def tbl_to_text(rows):
    hdr=[c.strip() for c in rows[0].strip("|").split("|")]
    out=[]
    for r in rows[2:]:
        cells=[c.strip() for c in r.strip("|").split("|")]
        if cells[0].lower().startswith("total"): continue
        for h,c in list(zip(hdr,cells))[1:]:
            if h.lower().startswith("total") or h.lower() in ("did not","did not pass","did not improve","do not"): 
                pass
            if h.lower().startswith("total"): continue
            if hdr[0]: out.append(f"{hdr[0]} = {h}: {c} {cells[0].lower()}")
            else: out.append(f"{cells[0]}, {h}: {c}")
    return out
i=0
while i<len(lines):
    L=lines[i]
    m=re.match(r"^#{2,3} Seed (N-2\.\d+-[AB])\b",L)
    mv=re.match(r"^\*\*(N-2\.\d+-[AB]-v\d)\.\*\*\s*(.*)",L)
    mt=re.match(r"^#+ TOPIC (2\.\d+)",L)
    if m or mv:
        flush()
        key=(m or mv).group(1)
        cur=dict(id=key,seed=bool(m),stem_lines=[],choices=[],notes=[],raw_head=L)
        if mv and mv.group(2): cur["stem_lines"].append(mv.group(2))
        i+=1;continue
    if cur is None: i+=1;continue
    if L.startswith("---") or L.startswith("# "):
        flush();i+=1;continue
    mo=re.match(r"^- (\*\*)?([A-D])\. (.*?)(\*\*)?$",L)
    if mo:
        txt=mo.group(3); 
        correct=bool(mo.group(1))
        cur["choices"].append(dict(k=mo.group(2),t=txt.rstrip("*").strip(),ok=correct));i+=1;continue
    if L.startswith("|"):
        rows=[];
        while i<len(lines) and lines[i].startswith("|"): rows.append(lines[i]);i+=1
        cur["stem_lines"]+=tbl_to_text(rows);continue
    if re.match(r"^(Check|Rationales?):",L):
        cur["notes"].append(L);i+=1;continue
    if L.strip()=="" or L.startswith("**Skill") or L.startswith("(replaced"):
        i+=1;continue
    if not cur["choices"] and not L.startswith(("Part","Replaces","Target","DRAFT")):
        cur["stem_lines"].append(L.strip())
    i+=1
flush()
json.dump(items,open("parsed.json","w"),indent=1,ensure_ascii=False)
bad=[x["id"] for x in items if len(x["choices"])!=4 or sum(c["ok"] for c in x["choices"])!=1]
print(len(items),"bad:",bad)
print(sum(1 for x in items if x["seed"]),"seeds")
print([x["id"] for x in items if not x["notes"]])
