#!/usr/bin/env python3
"""Two-family checker for TWO_LAYER_1_5.md and UNIT_1_ROLLUP_MOCK.md. Key is read from the gitignored
scripts/vercel-gateway-check/.env.local and never printed. Output in check_out/."""
import json, re, pathlib, urllib.request, time, sys
from concurrent.futures import ThreadPoolExecutor
HERE = pathlib.Path(__file__).parent
ROOT = HERE.parent.parent.parent
SCR = pathlib.Path("/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple-nosync/00741843-093c-4449-b77f-fb4f4c5505d7/scratchpad")
def key():
    env = ROOT / "scripts/vercel-gateway-check/.env.local"
    return [l.split("=", 1)[1].strip().strip("\"'") for l in env.read_text().splitlines() if l.startswith("AI_GATEWAY_API_KEY=")][0]
def block(md, title):
    m = re.search(r"### " + re.escape(title) + r".*?\n```\n(.*?)\n```", md, re.S); return m.group(1)
t1 = (HERE / "TWO_LAYER_1_5.md").read_text(); t2 = (HERE / "UNIT_1_ROLLUP_MOCK.md").read_text()
cards = {n: block(t1, n) for n in ["Know: core_idea", "Know: what_students_need_to_understand (the levers)", "Score: how_this_becomes_points", "Score: answer_move (explicit Example of the steps)", "Score: common_point_loss (Trap)", "Link: practice_bridge", "Remember it (unchanged)"]}
unit = {"Formulas": block(t2, "Formulas"), "Three levers": block(t2, "Three levers (used in 1.5, 1.6 and 1.7; shown once)")}
for m in re.finditer(r"### (1\.\d [^\n]+)\n```\n(.*?)\n```", t2, re.S): unit[m.group(1)] = m.group(2)
src = json.load(open(SCR / "u1.json"))
ced = "".join((ROOT / "docs/product/AP_CHEMISTRY_CED_FACT_PACK.md").read_text().splitlines(True)[354:400])
sources = "\n".join(f"=== {e['t']} {e['title']}\ncore_idea: {e['core']}\nwhat_to_understand: {e['wsu']}\nsteps: {e['hp']}\nanswer_move: {e['am']}\ncommon_point_loss: {e['cpl']}\npractice_bridge: {e['pb']}" for e in src["ex"])
sources += "\nHOOKS: " + json.dumps(src["hooks"], ensure_ascii=False) + "\nREFERENCE ENTRIES: " + json.dumps([{k: r[k] for k in ("codes", "title", "body")} for r in src["ref"]], ensure_ascii=False)
SYS = "You are an independent content checker for AP Chemistry exam-prep text. Count as defects only: factual errors, changed meaning against the sources, unsupported additions that are wrong or unverifiable, or something that would mislead a student. Style preferences are suggestions. Reply with one JSON object only."
FMT = 'Return {"items":[{"id":"","findings":[{"severity":"defect|suggestion","issue":"","evidence":""}],"verdict":"pass|fail"}]} and include every id.'
def p15(c):
    body = "\n\n".join(f"--- id: {k}\n{v}" for k, v in c.items())
    return f"""Check this draft cheat sheet for AP Chemistry topic 1.5 (Atomic Structure and Electron Configuration). Sources (published fields, reference entries, CED excerpt) follow the draft.

DRAFT CARDS:
{body}

SOURCES:
{sources}

CED EXCERPT:
{ced}

Checks, per card id: (1) every chemistry fact is correct (fill order and occupancy string, levers table direction holding other things equal, the S vs Al example with Z=16 and Z=13, 'not tested' scope against the CED exclusion statement); (2) nothing contradicts or loses meaning against the 1.5 sources; (3) the link card's claims about topics 1.6 and 1.7 match those topics' sources. Then add one extra item with id "overlap": list any two cards that make the same claim, in the same situation, for the same purpose (pure rewording); different jobs (a concept stated, then used in a table, then applied in an example) are NOT overlap. {FMT}"""
def punit(u):
    body = "\n\n".join(f"--- id: {k}\n{v}" for k, v in u.items())
    return f"""Check this draft Unit 1 roll-up cheat sheet for AP Chemistry. Each topic block is a condensation (Know / Do / Trap) of that topic's published fields below. Lines marked NEW are not in the published fields: judge them as chemistry only (true? AP-appropriate?). The Radius column of the levers table is also new.

DRAFT:
{body}

SOURCES:
{sources}

CED EXCERPT:
{ced}

For each id: (1) each Know/Do/Trap line is supported by that topic's sources, with no inverted, dropped-key or invented content; (2) chemistry is correct (including the formulas strip and the levers table, holding other things equal); (3) any claim that would mislead (e.g. a rule of thumb that contradicts the course). Ids are the topic titles plus "Formulas" and "Three levers". {FMT}"""
def plant(c, u):
    c = dict(c); u = dict(u)
    def sub(d, k, a, b):
        assert a in d[k], f"plant target missing in {k!r}: {a!r}"  # a silent no-op would hide a lost control
        d[k] = d[k].replace(a, b)
    sub(c, "Know: core_idea", "4s² 3d¹⁰ 4p⁶", "3d¹⁰ 4s² 4p⁶")
    sub(c, "Know: what_students_need_to_understand (the levers)", "More inner (core) electrons in between | Weaker | Lower", "More inner (core) electrons in between | Stronger | Higher")
    sub(u, "1.4 Composition of mixtures", "constant supports pure, changing means mixture", "constant means mixture, changing means pure")
    sub(u, "1.6 Photoelectron spectroscopy", "Core electrons always bind more tightly than valence electrons", "Core electrons always bind more loosely than valence electrons")
    return c, u
pc, pu = plant(cards, unit)
jobs = [("m15", p15(cards)), ("munit", punit(unit)), ("plant15", p15(pc)), ("plantunit", punit(pu))]
def run(model, name, prompt, k):
    req = {"model": model, "messages": [{"role": "system", "content": SYS}, {"role": "user", "content": prompt}], "temperature": 0.2, "max_tokens": 16000, "response_format": {"type": "json_object"}}
    r = urllib.request.Request("https://ai-gateway.vercel.sh/v1/chat/completions", data=json.dumps(req).encode(), method="POST", headers={"Authorization": "Bearer " + k, "Content-Type": "application/json"})
    t0 = time.time()
    try:
        resp = json.load(urllib.request.urlopen(r, timeout=900)); txt = resp["choices"][0]["message"]["content"] or ""; u = resp.get("usage", {})
    except Exception as e:
        txt, u = f"ERROR {e}", {}
    od = HERE / "check_out"; od.mkdir(exist_ok=True)
    (od / f"{model.replace('/', '_')}_{name}.json").write_text(txt)
    try: res = json.loads(txt)
    except Exception: return f"{model} {name} NO JSON len={len(txt)}"
    fl = [(x["id"][:28], [f.get("severity") for f in x.get("findings", [])], x.get("verdict")) for x in res.get("items", []) if x.get("verdict") != "pass" or x.get("findings")]
    return f"{model} {name} returned {len(res.get('items', []))} flagged {fl} cost {u.get('market_cost')} {round(time.time() - t0)}s"
if len(sys.argv) > 1: jobs = [(n + '_' + sys.argv[1], p) for n, p in jobs if n == 'munit']
k = key()
models = ["openai/gpt-6.1-sol", "moonshotai/kimi-k3.1-pro"]
with ThreadPoolExecutor(8) as ex:
    futs = [ex.submit(run, m, n, p, k) for m in models for n, p in jobs]
    for f in futs: print(f.result(), flush=True)
