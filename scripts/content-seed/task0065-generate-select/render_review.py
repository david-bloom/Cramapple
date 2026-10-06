"""Render a batch's accepted items as one static review page (TASK-0065). usage: python3 render_review.py <batch-dir> <out.html>"""
import json, sys, html, glob, os
batch, out = sys.argv[1], sys.argv[2]
items = sorted(json.load(open(os.path.join(batch, "accepted.json"))), key=lambda x: [int(p) for p in x["topic_code"].split(".")])
states = {json.load(open(f))["topic"]["topic_code"]: json.load(open(f)) for f in glob.glob(os.path.join(batch, "topics", "*.json"))}
e = html.escape
short = {"anthropic/claude-opus-5.5": "Claude Opus 5.5", "openai/gpt-6.1-sol": "GPT-6.1", "google/gemini-3.8-flash": "Gemini 3.8", "deepseek/deepseek-v4-pro": "DeepSeek v4", "moonshotai/kimi-k3": "Kimi K3"}
cards = []
for it in items:
    st = states[it["topic_code"]]; n = len(st["candidates"])
    prov = it["provenance"]; veto = [short[m] for m in (next(c for c in st["candidates"] if c["id"] == prov["candidate_id"])["eval"].get("veto") or {})]
    ch = []
    for c in it["choices"]:
        r = e(c["rationale"]).replace("Fix:", "<b class=fix>Fix:</b>")
        ch.append(f'<li class="{"key" if c["is_correct"] else "trap"}"><div class=opt><span class=letter>{c["choice_key"]}</span><span class=otext>{e(c["choice_text"])}</span><span class=tag>{"Correct ✓" if c["is_correct"] else "Trap"}</span></div><p class=rat>{r}</p></li>')
    cards.append(f'''<article id="t{it["topic_code"].replace(".","-")}"><header><span class=code>{e(it["topic_code"])}</span><h2>{e(it["topic_title"])}</h2></header>
<p class=meta>Written by {short.get(prov["author"], prov["author"])} · passed {", ".join(short[m] for m in prov["checkers"])}{" · veto " + ", ".join(veto) + " passed" if veto else ""} · candidate {[c['id'] for c in st['candidates']].index(prov['candidate_id']) + 1} of {n}</p>
<p class=stem>{e(it["stem"])}</p><ol class=choices>{"".join(ch)}</ol></article>''')
pending = [s for s in states.values() if s["status"] != "accepted"]
notes = json.load(open(os.path.join(batch, "review_notes.json"))) if os.path.exists(os.path.join(batch, "review_notes.json")) else {}
pend_html = "".join(f'<li><b>{e(s["topic"]["topic_code"])} {e(s["topic"]["topic_title"])}</b>: {e(notes.get(s["topic"]["topic_code"], s["status"]))}</li>' for s in sorted(pending, key=lambda s: [int(p) for p in s["topic"]["topic_code"].split(".")]))
toc = "".join(f'<a href="#t{it["topic_code"].replace(".","-")}">{e(it["topic_code"])}</a>' for it in items)
page = open(os.path.join(os.path.dirname(__file__), "review_template.html")).read()
page = page.replace("%%COUNT%%", str(len(items))).replace("%%TOTAL%%", str(len(states))).replace("%%TOC%%", toc).replace("%%CARDS%%", "\n".join(cards)).replace("%%PENDING%%", pend_html or "<li>None</li>")
open(out, "w").write(page)
print("wrote", out, len(items), "items")
