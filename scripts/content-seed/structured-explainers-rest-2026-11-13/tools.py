#!/usr/bin/env python3
"""Recommendation #3 rollout helper: validate, build the migration, and run the two-family check
for explainer rows reshaped into bullets ('- '), numbered steps ('1. ') and tables ('| a | b |').

  tools.py validate  CURRENT.json PROPOSED.json
  tools.py migration CURRENT.json PROPOSED.json OUT.sql "<source_note sentence>"
  tools.py check     CURRENT.json PROPOSED.json OUTDIR MODEL [MODEL ...] [--plant CODE]

CURRENT.json: list of rows with subject_key, unit_number, topic_code, core_idea,
what_students_need_to_understand, how_this_becomes_points, point_attaining_answer, h (md5 guard).
PROPOSED.json: {topic_code: {core_idea, what_students_need_to_understand, how_this_becomes_points, point_attaining_answer}}
(only the topics being changed). The gateway key is read in Python from the gitignored
scripts/vercel-gateway-check/.env.local and is never printed."""
import json, re, sys, pathlib, time, urllib.request

FIELDS = ["core_idea", "what_students_need_to_understand", "how_this_becomes_points", "point_attaining_answer"]
CAPS = {"core_idea": 360, "what_students_need_to_understand": 360, "how_this_becomes_points": 320, "point_attaining_answer": 520}
BULLET = re.compile(r"^\s*[-•*]\s+\S"); STEP = re.compile(r"^\s*\d+[.)]\s+\S"); ROW = re.compile(r"^\s*\|.*\|\s*$")
NUM = re.compile(r"\d+(?:\.\d+)?")


def load(cur_p, prop_p):
    cur = {r["topic_code"]: r for r in json.load(open(cur_p))}
    prop = json.load(open(prop_p))
    return cur, prop


def paragraph_issues(text):
    out = []
    for p in re.split(r"\n[\t ]*\n", text.replace("\r\n", "\n")):
        lines = [l for l in p.split("\n") if l.strip()]
        kinds = {("b" if BULLET.match(l) else "s" if STEP.match(l) else "t" if ROW.match(l) else "p") for l in lines}
        if len(kinds - {"p"}) and kinds != {"b"} and kinds != {"s"} and kinds != {"t"}:
            out.append("mixed or partly marked paragraph: " + lines[0][:50])
        if kinds in ({"b"}, {"s"}, {"t"}) and len(lines) < 2:
            out.append("single marked line is read as prose: " + lines[0][:50])
        if kinds == {"t"}:
            n = {len(l.strip().strip("|").split("|")) for l in lines}
            if len(n) != 1:
                out.append("table rows differ in column count")
    return out


def validate(cur_p, prop_p):
    cur, prop = load(cur_p, prop_p)
    bad = 0
    for code, new in prop.items():
        if code not in cur:
            print(code, "NOT IN CURRENT"); bad += 1; continue
        c = cur[code]
        probs = []
        for f in FIELDS:
            if f not in new: probs.append(f"missing {f}"); continue
            if len(new[f]) > CAPS[f]: probs.append(f"{f} over cap {len(new[f])}>{CAPS[f]}")
            probs += [f"{f}: {i}" for i in paragraph_issues(new[f])]
        strip = lambda t: re.sub(r"(?m)^\s*\d+[.)]\s+", "", t)
        old_nums = set(NUM.findall(strip(" ".join(c[f] for f in FIELDS)))); new_nums = set(NUM.findall(strip(" ".join(new.get(f, "") for f in FIELDS))))
        lost = sorted(old_nums - new_nums)
        added = sorted(new_nums - old_nums)
        if lost: probs.append("numbers only in CURRENT: " + ",".join(lost))
        if added: probs.append("numbers only in PROPOSED: " + ",".join(added))
        w_old = sum(len(c[f].split()) for f in FIELDS); w_new = sum(len(new.get(f, "").replace("|", " ").split()) for f in FIELDS)
        print(f"{code}: words {w_old}->{w_new}" + ("  " + "; ".join(probs) if probs else "  ok"))
        bad += bool(probs)
    print("topics", len(prop), "with notes", bad)


def migration(cur_p, prop_p, out_p, note):
    cur, prop = load(cur_p, prop_p)
    subj = next(iter(cur.values()))["subject_key"]
    parts = ["-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.", "begin;"]
    for code, new in prop.items():
        c = cur[code]
        sets = ",\n  ".join(f"{f} = $q${new[f]}$q$" for f in FIELDS)
        parts.append(f"update app.topic_explainers set\n  {sets},\n  source_note = coalesce(source_note,'') || $q$ {note}$q$\n"
                     f"where subject_key='{subj}' and unit_number={c['unit_number']} and topic_code='{code}' and status='published'\n"
                     f"  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='{c['h']}';")
    codes = ",".join(f"'{k}'" for k in prop)
    parts.append(f"do $$ begin if (select count(*) from app.topic_explainers where subject_key='{subj}' and topic_code in ({codes}) and source_note like '%{note[:40]}%')<>{len(prop)} then raise exception 'expected {len(prop)} rows updated'; end if; end $$;")
    parts.append("commit;")
    pathlib.Path(out_p).write_text("\n".join(parts) + "\n")
    print("wrote", out_p, len(prop), "rows")


def gateway_key():
    env = pathlib.Path(__file__).resolve().parents[3] / "scripts/vercel-gateway-check/.env.local"
    if not env.exists(): env = pathlib.Path("/Users/davidbloom/Documents/Cramapple.nosync/scripts/vercel-gateway-check/.env.local")
    return [l.split("=", 1)[1].strip().strip("\"'") for l in env.read_text().splitlines() if l.startswith("AI_GATEWAY_API_KEY=")][0]


SYS = "You are an independent content checker for AP exam prep text. Count only factual errors, changed meaning, lost required content, arithmetic errors or broken markup as defects. Style preferences are suggestions. Reply with one JSON object only."


def prompt(subject, items):
    body = [f"Subject: {subject}. Each topic below has CURRENT published text (previously reviewed, treat as the source of truth) and PROPOSED text reshaped into bullets ('- '), numbered steps ('1. ') and tables ('| a | b |', first row is the header). The reshaping must not change facts."]
    for code, (c, n) in items.items():
        body.append(f"=== Topic {code}\nMini example question: {c.get('mini_example_question','')}\nCURRENT:\n" + json.dumps({f: c[f] for f in FIELDS}, ensure_ascii=False) + "\nPROPOSED:\n" + json.dumps({f: n[f] for f in FIELDS}, ensure_ascii=False))
    body.append('For every topic check: (1) any fact, number, named term or required element in CURRENT that is missing or altered in PROPOSED; (2) anything added to PROPOSED that CURRENT does not support and that is wrong or unsupported; (3) arithmetic in any table or worked line; (4) markup that would render badly; (5) whether the answer still answers the mini example question. Return {"topics":[{"code":"","findings":[{"field":"","severity":"defect|suggestion","issue":"","evidence":""}],"verdict":"pass|fail"}]} and include every topic code.')
    return "\n\n".join(body)


def check(cur_p, prop_p, outdir, models, plant=None):
    cur, prop = load(cur_p, prop_p)
    subj = next(iter(cur.values()))["subject_key"]
    key = gateway_key(); out = pathlib.Path(outdir); out.mkdir(parents=True, exist_ok=True)
    prop = json.loads(json.dumps(prop))
    if plant:
        a = prop[plant]["point_attaining_answer"]; m = NUM.search(a)
        prop[plant]["point_attaining_answer"] = a[:m.start()] + str(int(float(m.group())) + 7) + a[m.end():]
        print("planted a changed number in", plant)
    codes = list(prop); batches = [codes[i:i + 5] for i in range(0, len(codes), 5)]
    for model in models:
        for bi, b in enumerate(batches):
            items = {k: (cur[k], prop[k]) for k in b}
            req = {"model": model, "messages": [{"role": "system", "content": SYS}, {"role": "user", "content": prompt(subj, items)}], "temperature": 0.2, "max_tokens": 16000, "response_format": {"type": "json_object"}}
            r = urllib.request.Request("https://ai-gateway.vercel.sh/v1/chat/completions", data=json.dumps(req).encode(), method="POST", headers={"Authorization": "Bearer " + key, "Content-Type": "application/json"})
            t = time.time()
            try:
                resp = json.load(urllib.request.urlopen(r, timeout=900)); txt = resp["choices"][0]["message"]["content"] or ""; u = resp.get("usage", {})
            except Exception as e:
                txt, u = f"ERROR {e}", {}
            name = f"{model.replace('/', '_')}_b{bi}{'_plant' if plant else ''}.json"
            (out / name).write_text(txt)
            try: res = json.loads(txt)
            except Exception: res = None
            if res is None: print(model, "batch", bi, "NO JSON", len(txt)); continue
            fails = [(x["code"], len(x.get("findings", []))) for x in res.get("topics", []) if x.get("verdict") != "pass" or x.get("findings")]
            seen = {x["code"] for x in res.get("topics", [])}
            print(model, "batch", bi, "topics", b, "returned", len(seen), "flagged", fails, "cost", u.get("market_cost"), round(time.time() - t))


if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "validate": validate(sys.argv[2], sys.argv[3])
    elif cmd == "migration": migration(*sys.argv[2:6])
    elif cmd == "check":
        a = sys.argv[2:]; plant = None
        if "--plant" in a: i = a.index("--plant"); plant = a[i + 1]; del a[i:i + 2]
        check(a[0], a[1], a[2], a[3:], plant)
