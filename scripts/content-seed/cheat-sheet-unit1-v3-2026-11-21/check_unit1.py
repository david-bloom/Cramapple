#!/usr/bin/env python3
"""Two-family checker for proposed.json (AP Chemistry Unit 1, v3 guidelines). Key read from the gitignored
scripts/vercel-gateway-check/.env.local, never printed. Source snapshot: SRC (Production read 2026-11-21) copied to source_snapshot.json. Output in check_out/."""
import json, pathlib, urllib.request, time, sys
from concurrent.futures import ThreadPoolExecutor
HERE = pathlib.Path(__file__).parent; ROOT = HERE.parent.parent.parent
def key():
    env = ROOT / "scripts/vercel-gateway-check/.env.local"
    return [l.split("=", 1)[1].strip().strip("\"'") for l in env.read_text().splitlines() if l.startswith("AI_GATEWAY_API_KEY=")][0]
P = json.load(open(HERE / "proposed.json")); SRC = json.load(open(HERE / "source_snapshot.json"))
ced = "".join((ROOT / "docs/product/AP_CHEMISTRY_CED_FACT_PACK.md").read_text().splitlines(True)[354:400])
LABEL = {"core_idea": "KNOW core_idea", "what_students_need_to_understand": "KNOW mechanism (what_students_need_to_understand)", "how_this_becomes_points": "SCORE steps", "common_point_loss": "SCORE weak", "answer_move": "SCORE full credit", "practice_bridge": "LINK", "hook": "HOOK"}
def src_block(t):
    e = next(x for x in SRC["ex"] if x["t"] == t); w = next(x for x in SRC["w"] if x["t"] == t)
    ref = [f"{r['kind']}: {r['title']}: {r['body']}" for r in SRC["ref"] if t in r["codes"]]
    return f"=== SOURCE {t} {e['title']}\ncore_idea: {e['core']}\nwhat_to_understand: {e['wsu']}\nsteps: {e['hp']}\nanswer_move: {e['am']}\ncommon_point_loss: {e['cpl']}\npractice_bridge: {e['pb']}\nWORKED EXAMPLE question: {w['q']}\nWORKED weak answer: {w['weak']}\nWORKED point-attaining answer: {w['strong']}\nREFERENCE entries: {json.dumps(ref, ensure_ascii=False)}"
def draft_block(t, f):
    return f"=== DRAFT {t} {f['title']}\n" + "\n\n".join(f"[{LABEL[k]}]\n{v}" for k, v in f.items() if k != "title")
SYS = "You are an independent content checker for AP Chemistry exam-prep text. Count as defects only: factual errors (including arithmetic), changed meaning against the sources, unsupported additions that are wrong or unverifiable, or something that would mislead a student. Style preferences are suggestions. Reply with one JSON object only."
FMT = 'Return {"items":[{"id":"<topic code>","findings":[{"severity":"defect|suggestion|overlap","card":"","issue":"","evidence":""}],"verdict":"pass|fail"}]} with one item per topic code.'
def prompt(topics, d):
    return f"""Check these draft cheat sheets for AP Chemistry Unit 1 topics {', '.join(topics)}. Each draft has Know cards, Score cards (steps, Weak, Full credit render together as one worked unit), a Link and sometimes a Hook. Sources for each topic (published fields, worked example, reference entries) and a CED excerpt follow the drafts.

""" + "\n\n".join(draft_block(t, d[t]) for t in topics) + "\n\n" + "\n\n".join(src_block(t) for t in topics) + f"""

CED EXCERPT:
{ced}

For each topic check: (1) every chemistry fact and every number in the draft is correct, including any arithmetic in the Full-credit answer and every table cell; (2) nothing contradicts, inverts or loses meaning against that topic's sources, and the 'not tested' lines match the CED exclusions; (3) the Weak answer really breaks the step it names, and the Full-credit (1), (2), (3) really correspond to steps 1 to 3; (4) any claim that would mislead a student. Facts in tables that are not stated in the sources (1.7 trend directions and Radius column, 1.8 group table) are derived or standard chemistry: judge them as chemistry only, and say if a wording needs 'generally'. Also list, with severity "overlap", any two cards in one topic that make the same claim, in the same situation, for the same purpose (pure rewording). A concept stated, then used in a table, then demonstrated in a worked answer is NOT overlap. {FMT}"""
def plant(d):
    d = json.loads(json.dumps(d))
    def sub(t, k, a, b):
        assert a in d[t][k], f"plant target missing {t}.{k}: {a!r}"
        d[t][k] = d[t][k].replace(a, b)
    sub("1.1", "answer_move", "≈ 1.14×10²² molecules", "≈ 1.14×10²³ molecules")
    sub("1.3", "answer_move", "empirical mass ≈ 30.03 g/mol", "empirical mass ≈ 60.06 g/mol")
    sub("1.6", "what_students_need_to_understand", "| Core: closer to the nucleus, less shielded | Higher |", "| Core: closer to the nucleus, less shielded | Lower |")
    sub("1.8", "what_students_need_to_understand", "| 2 | Lose 2 | 2+ |", "| 2 | Gain 2 | 2+ |")
    return d
BATCHES = [["1.1", "1.2", "1.3", "1.4"], ["1.5", "1.6", "1.7", "1.8"]]
if len(sys.argv) > 2: BATCHES = [b.split(",") for b in sys.argv[2].split(";")]  # e.g. "1.6;1.7;1.8" runs each topic as its own call
suffix = sys.argv[1] if len(sys.argv) > 1 else "run"
jobs = []
for bi, b in enumerate(BATCHES):
    jobs.append((f"{suffix}_clean_{bi}", prompt(b, P)))
    if suffix == "run": jobs.append((f"{suffix}_plant_{bi}", prompt(b, plant(P))))
def run(model, name, p, k):
    req = {"model": model, "messages": [{"role": "system", "content": SYS}, {"role": "user", "content": p}], "temperature": 0.2, "max_tokens": 16000, "response_format": {"type": "json_object"}}
    r = urllib.request.Request("https://ai-gateway.vercel.sh/v1/chat/completions", data=json.dumps(req).encode(), method="POST", headers={"Authorization": "Bearer " + k, "Content-Type": "application/json"})
    t0 = time.time()
    try: resp = json.load(urllib.request.urlopen(r, timeout=900)); txt = resp["choices"][0]["message"]["content"] or ""; u = resp.get("usage", {})
    except Exception as e: txt, u = f"ERROR {e}", {}
    od = HERE / "check_out"; od.mkdir(exist_ok=True); (od / f"{model.replace('/', '_')}_{name}.json").write_text(txt)
    try: res = json.loads(txt)
    except Exception: return f"{model} {name} NO JSON len={len(txt)}"
    fl = [(x["id"], [(f.get("severity"), f.get("card", "")[:18]) for f in x.get("findings", [])], x.get("verdict")) for x in res.get("items", []) if x.get("verdict") != "pass" or x.get("findings")]
    return f"{model} {name} items={len(res.get('items', []))} flagged {fl} cost {u.get('market_cost')} {round(time.time() - t0)}s"
k = key()
with ThreadPoolExecutor(8) as ex:
    futs = [ex.submit(run, m, n, p, k) for m in ["openai/gpt-6.1-sol", "moonshotai/kimi-k3.1-pro"] for n, p in jobs]
    for f in futs: print(f.result(), flush=True)
