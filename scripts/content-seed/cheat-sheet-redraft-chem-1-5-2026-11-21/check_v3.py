#!/usr/bin/env python3
"""Two-family checker for TWO_LAYER_1_5_v3.md. Key read from the gitignored scripts/vercel-gateway-check/.env.local, never printed. Output in check_out/ (files named *_v3_*)."""
import json, re, pathlib, urllib.request, time
from concurrent.futures import ThreadPoolExecutor
HERE = pathlib.Path(__file__).parent; ROOT = HERE.parent.parent.parent
SCR = pathlib.Path("/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple-nosync/00741843-093c-4449-b77f-fb4f4c5505d7/scratchpad")
def key():
    env = ROOT / "scripts/vercel-gateway-check/.env.local"
    return [l.split("=", 1)[1].strip().strip("\"'") for l in env.read_text().splitlines() if l.startswith("AI_GATEWAY_API_KEY=")][0]
md = (HERE / "TWO_LAYER_1_5_v3.md").read_text()
def block(title): return re.search(r"### " + re.escape(title) + r".*?\n```\n(.*?)\n```", md, re.S).group(1)
T = ["Know: core_idea", "Know: what_students_need_to_understand (the levers)", "Score: how_this_becomes_points (steps)", 'Score: common_point_loss (shown as "Weak")', 'Score: answer_move (shown as "Full credit")', "Link: practice_bridge", "Remember it (unchanged)"]
cards = {t: block(t) for t in T}
src = json.load(open(SCR / "u1.json"))
ced = "".join((ROOT / "docs/product/AP_CHEMISTRY_CED_FACT_PACK.md").read_text().splitlines(True)[354:400])
sources = "\n".join(f"=== {e['t']} {e['title']}\ncore_idea: {e['core']}\nwhat_to_understand: {e['wsu']}\nsteps: {e['hp']}\nanswer_move: {e['am']}\ncommon_point_loss: {e['cpl']}\npractice_bridge: {e['pb']}" for e in src["ex"])
sources += "\nHOOKS: " + json.dumps(src["hooks"], ensure_ascii=False)
SYS = "You are an independent content checker for AP Chemistry exam-prep text. Count as defects only: factual errors, changed meaning against the sources, unsupported additions that are wrong or unverifiable, or something that would mislead a student. Style preferences are suggestions. Reply with one JSON object only."
FMT = 'Return {"items":[{"id":"","findings":[{"severity":"defect|suggestion","issue":"","evidence":""}],"verdict":"pass|fail"}]} and include every id.'
def prompt(c):
    body = "\n\n".join(f"--- id: {k}\n{v}" for k, v in c.items())
    return f"""Check this draft cheat sheet for AP Chemistry topic 1.5 (Atomic Structure and Electron Configuration). The three Score cards render together as one unit: Steps, then Weak, then Full credit. Sources follow the draft.

DRAFT CARDS:
{body}

SOURCES:
{sources}

CED EXCERPT:
{ced}

Checks, per card id: (1) every chemistry fact is correct (fill string and occupancy, levers table direction holding other things equal, S (Z=16) and Al (Z=13) configurations, valence shell and core-electron counts, the ionization-energy conclusion, the 'not tested' scope against the CED exclusion statement); (2) nothing contradicts or loses meaning against the 1.5 sources; (3) the Weak answer really skips step 2 and the Full-credit answer's (1), (2), (3) really match steps 1 to 3; (4) the link card's claims about 1.6 and 1.7 match those topics' sources. Add one extra item with id "overlap": list any two cards that make the same claim, in the same situation, for the same purpose (pure rewording). A concept stated, then used in a table, then demonstrated in a worked answer is NOT overlap. {FMT}"""
def plant(c):
    c = dict(c)
    def sub(k, a, b):
        assert a in c[k], f"plant target missing in {k!r}: {a!r}"
        c[k] = c[k].replace(a, b)
    sub(T[0], "4s² 3d¹⁰ 4p⁶", "3d¹⁰ 4s² 4p⁶")
    sub(T[1], "More inner (core) electrons in between | Weaker | Lower", "More inner (core) electrons in between | Stronger | Higher")
    sub(T[4], "the same 10 core electrons", "the same 12 core electrons")
    sub(T[4], "3s² 3p⁴", "3s² 3p³")
    return c
jobs = [("v3_clean", prompt(cards)), ("v3_plant", prompt(plant(cards)))]
def run(model, name, p, k):
    req = {"model": model, "messages": [{"role": "system", "content": SYS}, {"role": "user", "content": p}], "temperature": 0.2, "max_tokens": 16000, "response_format": {"type": "json_object"}}
    r = urllib.request.Request("https://ai-gateway.vercel.sh/v1/chat/completions", data=json.dumps(req).encode(), method="POST", headers={"Authorization": "Bearer " + k, "Content-Type": "application/json"})
    t0 = time.time()
    try: resp = json.load(urllib.request.urlopen(r, timeout=900)); txt = resp["choices"][0]["message"]["content"] or ""; u = resp.get("usage", {})
    except Exception as e: txt, u = f"ERROR {e}", {}
    (HERE / "check_out" / f"{model.replace('/', '_')}_{name}.json").write_text(txt)
    try: res = json.loads(txt)
    except Exception: return f"{model} {name} NO JSON len={len(txt)}"
    fl = [(x["id"][:30], [f.get("severity") for f in x.get("findings", [])], x.get("verdict")) for x in res.get("items", []) if x.get("verdict") != "pass" or x.get("findings")]
    return f"{model} {name} returned {len(res.get('items', []))} flagged {fl} cost {u.get('market_cost')} {round(time.time() - t0)}s"
k = key()
with ThreadPoolExecutor(4) as ex:
    futs = [ex.submit(run, m, n, p, k) for m in ["openai/gpt-6.1-sol", "moonshotai/kimi-k3.1-pro"] for n, p in jobs]
    for f in futs: print(f.result(), flush=True)
