#!/usr/bin/env python3
"""quick_take rollout helper.
  qt.py build              -> proposed.json {subject:{code:text}} from chem/bio/stats .txt, validated
  qt.py check MODEL... [--plant]  -> two-family checker over all topics, output in check_out/
  qt.py migration          -> prod_apply.sql (md5-guarded on answer_move|common_point_loss, quick_take must be null)
Gateway key is read from the gitignored scripts/vercel-gateway-check/.env.local and never printed."""
import json, sys, pathlib, time, urllib.request, re
HERE = pathlib.Path(__file__).resolve().parent
SUBJ = {"chem": "ap_chemistry", "bio": "ap_biology", "stats": "ap_statistics"}
LABELS = ["The answer move", "How points are lost"]
snap = {(r["subject_key"], r["topic_code"]): r for r in json.load(open(HERE / "prod_snapshot.json"))}

def build():
    out = {}
    for f, subj in SUBJ.items():
        out[subj] = {}
        for l in (HERE / f"{f}.txt").read_text().splitlines():
            p = l.split("|"); code = p[0]
            if code.endswith("R"):
                out[subj][code[:-1]] = out[subj].get(code[:-1], "") + "\nRemember it: " + p[1]; continue
            assert len(p) == 3, l
            out[subj][code] = f"The answer move: {p[1]}\nHow points are lost: {p[2]}"
    bad = 0
    for subj, d in out.items():
        want = {c for (s, c) in snap if s == subj}
        if set(d) != want: print(subj, "coverage mismatch", sorted(want ^ set(d))); bad += 1
        for c, t in d.items():
            for ln in t.split("\n"):
                lab, body = ln.split(": ", 1)
                if len(body.split()) > 25: print(subj, c, "over 25 words"); bad += 1
            if len(t) > 400: print(subj, c, "over 400 chars", len(t)); bad += 1
    json.dump(out, open(HERE / "proposed.json", "w"), indent=1, ensure_ascii=False)
    print({s: len(d) for s, d in out.items()}, "problems", bad)

def key():
    env = pathlib.Path("/Users/davidbloom/Documents/Cramapple.nosync/scripts/vercel-gateway-check/.env.local")
    return [l.split("=", 1)[1].strip().strip("\"'") for l in env.read_text().splitlines() if l.startswith("AI_GATEWAY_API_KEY=")][0]

SYS = "You are an independent content checker for AP exam prep text. Count only factual errors, changed meaning, added unsupported content or lost key meaning as defects. Style preferences are suggestions. Reply with one JSON object only."

def prompt(subj, items):
    b = [f"Subject: {subj}. For each topic, PROPOSED quick_take is a 2-3 line 'In 30 seconds' summary. It must be a faithful condensation of that topic's own SOURCE fields (answer_move, common_point_loss, hooks): no new facts, no changed meaning, each sentence at most 25 words, line 1 summarising the answer move, line 2 the common point loss (a 'Remember it' line, if present, must equal a hook)."]
    for code, (r, t) in items.items():
        b.append(f"=== Topic {code}\nSOURCE answer_move: {r['answer_move']}\nSOURCE common_point_loss: {r['common_point_loss']}\nSOURCE hooks: {json.dumps(r['hooks'], ensure_ascii=False)}\nPROPOSED:\n{t}")
    b.append('For each topic check: (1) each PROPOSED line is supported by the matching SOURCE field; (2) nothing important to scoring is inverted or dropped such that the line misleads; (3) no unsupported additions. Return {"topics":[{"code":"","findings":[{"severity":"defect|suggestion","issue":"","evidence":""}],"verdict":"pass|fail"}]} and include every topic code.')
    return "\n\n".join(b)

def check(models, plant, revised=False):
    prop = json.load(open(HERE / "proposed.json")); k = key(); od = HERE / ("recheck_out" if revised else "check_out"); od.mkdir(exist_ok=True)
    if revised:
        rv = json.load(open(HERE / "revised_topics.json")); m = {"chem": "ap_chemistry", "bio": "ap_biology", "stats": "ap_statistics"}
        prop = {m[f]: {c: prop[m[f]][c] for c in codes} for f, codes in rv.items()}
    if plant:
        # swap line 2 between two Biology topics, and invert a claim in one Chemistry topic
        b = prop["ap_biology"]; l2 = lambda t: t.split("\n")[1]
        b["2.5"] = b["2.5"].split("\n")[0] + "\n" + l2(b["2.7"])
        c = prop["ap_chemistry"]; c["3.4"] = c["3.4"].replace("Using Celsius in PV = nRT", "Using Kelvin in PV = nRT")
        print("planted: biology 2.5 (line 2 from 2.7), chemistry 3.4 (Kelvin inverted)")
    for model in models:
        for subj, d in prop.items():
            codes = list(d)
            for bi in range(0, len(codes), 12):
                items = {c: (snap[(subj, c)], d[c]) for c in codes[bi:bi + 12]}
                req = {"model": model, "messages": [{"role": "system", "content": SYS}, {"role": "user", "content": prompt(subj, items)}], "temperature": 0.2, "max_tokens": 16000, "response_format": {"type": "json_object"}}
                r = urllib.request.Request("https://ai-gateway.vercel.sh/v1/chat/completions", data=json.dumps(req).encode(), method="POST", headers={"Authorization": "Bearer " + k, "Content-Type": "application/json"})
                t0 = time.time()
                try:
                    resp = json.load(urllib.request.urlopen(r, timeout=900)); txt = resp["choices"][0]["message"]["content"] or ""; u = resp.get("usage", {})
                except Exception as e:
                    txt, u = f"ERROR {e}", {}
                name = f"{model.replace('/', '_')}_{subj}_{bi // 12}{'_plant' if plant else ''}.json"
                (od / name).write_text(txt)
                try: res = json.loads(txt)
                except Exception: print(model, subj, bi // 12, "NO JSON", len(txt)); continue
                fl = [(x["code"], [f.get("severity") for f in x.get("findings", [])]) for x in res.get("topics", []) if x.get("verdict") != "pass" or x.get("findings")]
                print(model, subj, bi // 12, "returned", len(res.get("topics", [])), "of", len(items), "flagged", fl, "cost", u.get("market_cost"), round(time.time() - t0))

def migration():
    prop = json.load(open(HERE / "proposed.json")); parts = ["begin;"]; n = 0
    for subj, d in prop.items():
        for c, t in d.items():
            r = snap[(subj, c)]
            parts.append(f"update app.topic_explainers set quick_take = $qt${t}$qt$ where subject_key='{subj}' and topic_code='{c}' and status='published' and quick_take is null and md5(answer_move||'|'||common_point_loss)='{r['h']}';"); n += 1
    parts.append(f"do $$ begin if (select count(*) from app.topic_explainers where subject_key in ('ap_chemistry','ap_biology','ap_statistics') and unit_number between 1 and 5 and status='published' and quick_take is not null)<>{n} then raise exception 'expected {n} rows with quick_take'; end if; end $$;")
    parts.append("commit;")
    (HERE / "prod_apply.sql").write_text("\n".join(parts) + "\n"); print("wrote prod_apply.sql", n)

if __name__ == "__main__":
    c = sys.argv[1]
    if c == "build": build()
    elif c == "migration": migration()
    elif c == "check":
        a = sys.argv[2:]; plant = "--plant" in a; rev = "--revised" in a; a = [x for x in a if x not in ("--plant", "--revised")]; check(a, plant, rev)
