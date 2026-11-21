#!/usr/bin/env python3
"""Two-family checker for one unit folder (proposed.json + source_snapshot.json + optional plants.json).
Usage: python3 -I check_unit.py <folder> <suffix> [batches]    batches e.g. "3.1,3.2,3.3;3.4,3.5" (default: 3 topics per call)
suffix 'run' also runs a planted-defect copy using plants.json: [{"t":"3.2","k":"answer_move","a":"text present","b":"planted wrong text"}, ...] (2 to 4 plants; asserts every target exists).
Key read from the gitignored scripts/vercel-gateway-check/.env.local, never printed. Output in <folder>/check_out/."""
import json, pathlib, urllib.request, time, sys, re
from concurrent.futures import ThreadPoolExecutor
ROOT = pathlib.Path(__file__).resolve().parents[3]
D = pathlib.Path(sys.argv[1]).resolve(); suffix = sys.argv[2]
def key():
    env = ROOT / "scripts/vercel-gateway-check/.env.local"
    return [l.split("=", 1)[1].strip().strip("\"'") for l in env.read_text().splitlines() if l.startswith("AI_GATEWAY_API_KEY=")][0]
P = json.load(open(D / "proposed.json")); SRC = json.load(open(D / "source_snapshot.json"))
unit = next(iter(P)).split(".")[0]
pack = (ROOT / "docs/product/AP_CHEMISTRY_CED_FACT_PACK.md").read_text().splitlines()
ced = []; on = False
for l in pack:
    if re.match(r"- \*\*" + unit + r"\.\d", l): on = True
    elif re.match(r"- \*\*\d+\.\d", l) or (l.startswith("#") or l.startswith("**Documented")): on = False if not re.match(r"- \*\*" + unit + r"\.\d", l) else on
    if on: ced.append(l)
CED = "\n".join(ced)[:14000] or "(no CED excerpt found for this unit)"
LABEL = {"core_idea": "KNOW core_idea", "what_students_need_to_understand": "KNOW mechanism (what_students_need_to_understand)", "how_this_becomes_points": "SCORE steps", "common_point_loss": "SCORE weak", "answer_move": "SCORE full credit", "practice_bridge": "LINK", "hook": "HOOK"}
def src_block(t):
    e = next(x for x in SRC["ex"] if x["t"] == t); w = next(x for x in SRC["w"] if x["t"] == t)
    ref = [f"{r['kind']}: {r['title']}: {r['body']}" + (f" items={json.dumps(r['items'], ensure_ascii=False)}" if r.get("items") else "") for r in SRC["ref"] if t in r["codes"]]
    hooks = [h["hook"] for h in SRC["hooks"] if t in h["codes"]]
    return f"=== SOURCE {t} {e['title']}\ncore_idea: {e['core']}\nwhat_to_understand: {e['wsu']}\nsteps: {e['hp']}\nanswer_move: {e['am']}\ncommon_point_loss: {e['cpl']}\npractice_bridge: {e['pb']}\nHOOKS: {json.dumps(hooks, ensure_ascii=False)}\nWORKED EXAMPLE question: {w['q']}\nWORKED weak answer: {w['weak']}\nWORKED point-attaining answer: {w['strong']}\nREFERENCE entries: {json.dumps(ref, ensure_ascii=False)}"
def draft_block(t, f):
    return f"=== DRAFT {t} {f.get('title', '')}\n" + "\n\n".join(f"[{LABEL[k]}]\n{v}" for k, v in f.items() if k in LABEL)
SYS = "You are an independent content checker for AP Chemistry exam-prep text. Count as defects only: factual errors (including arithmetic and rounding), changed meaning against the sources, unsupported additions that are wrong or unverifiable, overgeneralized rules (missing 'generally', 'tend to', 'supports' where the source hedges), or something that would mislead a student. Style preferences are suggestions. Reply with one JSON object only."
FMT = 'Return {"items":[{"id":"<topic code>","findings":[{"severity":"defect|suggestion|overlap","card":"","issue":"","evidence":""}],"verdict":"pass|fail"}]} with one item per topic code.'
def prompt(topics, d):
    return f"""Check these draft cheat sheets for AP Chemistry topics {', '.join(topics)}. Each draft has Know cards, Score cards (steps, Weak and Full credit render together as one worked unit), a Link and sometimes a Hook. Sources for each topic (published fields, worked example, reference entries, hooks) and a CED excerpt follow the drafts.

""" + "\n\n".join(draft_block(t, d[t]) for t in topics) + "\n\n" + "\n\n".join(src_block(t) for t in topics) + f"""

CED EXCERPT:
{CED}

For each topic check: (1) every chemistry fact and every number in the draft is correct, including all arithmetic and rounding in the Full-credit answer and every table cell; (2) nothing contradicts, inverts or loses meaning against that topic's sources, and any 'not tested' line matches the CED exclusions; (3) the Weak answer really breaks the step it names, and the Full-credit (1), (2), (3) really correspond to steps 1 to 3; (4) any claim that would mislead a student, including rules stated more absolutely than the source states them. Facts in a draft that are not in the sources are derived or standard chemistry: judge them as chemistry only and say so. Also list, with severity "overlap", any two cards in one topic that make the same claim, in the same situation, for the same purpose (pure rewording); a concept stated, then used in a table, then demonstrated in a worked answer is NOT overlap. {FMT}"""
def plant(d):
    d = json.loads(json.dumps(d)); pl = json.load(open(D / "plants.json"))
    assert 2 <= len(pl) <= 4, "plants.json needs 2 to 4 plants"
    for p in pl:
        assert p["a"] in d[p["t"]][p["k"]], f"plant target missing {p['t']}.{p['k']}: {p['a']!r}"
        assert p["a"] != p["b"]; d[p["t"]][p["k"]] = d[p["t"]][p["k"]].replace(p["a"], p["b"])
    return d
topics = list(P)
if len(sys.argv) > 3: BATCHES = [b.split(",") for b in sys.argv[3].split(";")]
else: BATCHES = [topics[i:i + 3] for i in range(0, len(topics), 3)]
jobs = []
for bi, b in enumerate(BATCHES):
    jobs.append((f"{suffix}_clean_{bi}", prompt(b, P)))
    if suffix == "run":
        pd = plant(P); jobs.append((f"{suffix}_plant_{bi}", prompt(b, pd)))
def run(model, name, p, k):
    req = {"model": model, "messages": [{"role": "system", "content": SYS}, {"role": "user", "content": p}], "temperature": 0.2, "max_tokens": 16000, "response_format": {"type": "json_object"}}
    r = urllib.request.Request("https://ai-gateway.vercel.sh/v1/chat/completions", data=json.dumps(req).encode(), method="POST", headers={"Authorization": "Bearer " + k, "Content-Type": "application/json"})
    t0 = time.time()
    try: resp = json.load(urllib.request.urlopen(r, timeout=900)); txt = resp["choices"][0]["message"]["content"] or ""; u = resp.get("usage", {})
    except Exception as e: txt, u = f"ERROR {e}", {}
    od = D / "check_out"; od.mkdir(exist_ok=True); (od / f"{model.replace('/', '_')}_{name}.json").write_text(txt)
    try: res = json.loads(txt)
    except Exception: return f"{model} {name} NO JSON len={len(txt)} (rerun that batch with a smaller batch list)"
    fl = [(x["id"], [(f.get("severity"), f.get("card", "")[:20]) for f in x.get("findings", [])], x.get("verdict")) for x in res.get("items", []) if x.get("verdict") != "pass" or x.get("findings")]
    return f"{model} {name} items={len(res.get('items', []))} flagged {fl} cost {u.get('market_cost')} {round(time.time() - t0)}s"
import os
MODELS = os.environ.get("CHECK_MODELS", "openai/gpt-6.1-sol,moonshotai/kimi-k3.1-pro").split(",")
k = key()
with ThreadPoolExecutor(8) as ex:
    futs = [ex.submit(run, m, n, p, k) for m in MODELS for n, p in jobs]
    for f in futs: print(f.result(), flush=True)
