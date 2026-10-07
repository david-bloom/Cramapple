#!/usr/bin/env python3
"""Stem/choice cleanup 2026-10-06: extract Production snapshot, classify, compute cleaned stems.

Usage:
  build.py extract <raw_mcp_output.txt>   -> writes prod_snapshot.json
  build.py classify                         -> writes classification.json (from prod_snapshot.json)
"""
import hashlib, json, re, sys, unicodedata
from pathlib import Path

HERE = Path(__file__).resolve().parent

def extract(raw_path):
    raw = json.loads(Path(raw_path).read_text())["result"]
    m = re.search(r"<untrusted-data-[0-9a-f-]+>\n(.*)\n</untrusted-data-", raw, re.S)
    rows = json.loads(m.group(1))[0]["j"]
    for r in rows:
        assert hashlib.md5(r["stem"].encode()).hexdigest() == r["stem_md5"], r["content_key"]
    snap = {
        "project": "pcntajvbdfqhbeewmdry",
        "captured": "2026-10-06",
        "selector": "civ.status='published' and ci.item_type='mcq' and civ.stem ~ '\\mA\\. .+\\mB\\. .+\\mC\\. '",
        "count": len(rows),
        "rows": rows,
    }
    (HERE / "prod_snapshot.json").write_text(json.dumps(snap, ensure_ascii=False, indent=1) + "\n")
    print("rows", len(rows))

# ---- normalisation used for the choice comparison ------------------------------------------
TRANS = {"−": "-", "–": "-", "—": "-", "×": "x", "⋅": "*", "·": "*",
         "‘": "'", "’": "'", "“": '"', "”": '"', " ": " "}

def norm(s):
    s = unicodedata.normalize("NFKC", s)
    s = "".join(TRANS.get(c, c) for c in s)
    s = re.sub(r"\s+", " ", s).strip().lower()
    s = re.sub(r"[.\s]+$", "", s)
    return s

# a choice-list line: "A. x", "A) x", "(A) x"
LINE = re.compile(r"^[ \t]*(?:\(([A-E])\)|([A-E])[.)])[ \t]+(.+?)[ \t]*$")
PREFIX = re.compile(r"(?im)^[ \t]*(answer choices|choices|options)\s*:?[ \t]*$")

def classify(r):
    stem = r["stem"]
    choices = {c["choice_key"]: c["choice_text"] for c in r["choices"]}
    keys = sorted(choices)
    lines = stem.split("\n")
    # locate letter lines
    idx = [(i, LINE.match(l)) for i, l in enumerate(lines)]
    hits = [(i, m.group(1) or m.group(2), m.group(3)) for i, m in idx if m]
    out = {"version_id": r["version_id"], "content_key": r["content_key"], "exam_code": r["exam_code"]}
    if not hits:
        # inline (same-line) list, e.g. "... ? A. x B. y C. z D. w"
        m = re.search(r"\s*\(?A[.)]\s+(.+?)\s+\(?B[.)]\s+(.+?)\s+\(?C[.)]\s+(.+?)\s+\(?D[.)]\s+(.+?)(?:\s+\(?E[.)]\s+(.+?))?\s*$", stem, re.S)
        if not m:
            out.update(cls="regex_false_positive", reason="no choice list found")
            return out
        parsed = dict(zip("ABCDE", [g for g in m.groups() if g is not None]))
        start, tail = m.start(), ""
    else:
        # contiguous run of letter lines A,B,C,D(,E) in order
        letters = "".join(h[1] for h in hits)
        if not letters.startswith("ABCD") or len(hits) not in (4, 5) or any(hits[k][0] != hits[0][0] + k for k in range(len(hits))):
            out.update(cls="ambiguous", reason=f"letter lines not a single contiguous A-D run: {letters}")
            return out
        parsed = {h[1]: h[2] for h in hits}
        first, last = hits[0][0], hits[-1][0]
        start = sum(len(l) + 1 for l in lines[:first])
        tail = "\n".join(lines[last + 1:])
    # compare with stored choices
    if sorted(parsed) != keys:
        out.update(cls="partial_mismatch", reason=f"inline letters {sorted(parsed)} vs stored {keys}")
        return out
    diffs = [k for k in keys if norm(parsed[k]) != norm(choices[k])]
    if diffs:
        out.update(cls="partial_mismatch", reason="text differs for " + ",".join(diffs),
                   detail={k: [parsed[k], choices[k]] for k in diffs})
        return out
    exact = all(parsed[k].strip() == choices[k].strip() for k in keys)
    head = stem[:start]
    # drop an "Answer choices:" header line directly above the list
    head2 = re.sub(r"(?is)\n[ \t]*(answer choices|choices|options)\s*:?[ \t]*\s*$", "", head)
    cleaned = head2.rstrip()
    if tail.strip():
        out.update(cls="ambiguous", reason="choice list is not at the end of the stem (trailing text follows)",
                   trailing_text=tail.strip(), proposed_stem=cleaned + "\n\n" + tail.strip(), exact_text_match=exact)
        return out
    out.update(cls="clean_match", exact_text_match=exact, cleaned_stem=cleaned,
               old_md5=hashlib.md5(stem.encode()).hexdigest(),
               new_md5=hashlib.md5(cleaned.encode()).hexdigest(),
               letter_dot_in_prose=bool(re.search(r"\b[A-E]\. ", cleaned)),
               no_terminal_punct=not re.search(r"[?.:)\]]$", cleaned))
    return out

def do_classify():
    snap = json.loads((HERE / "prod_snapshot.json").read_text())
    res = [classify(r) for r in snap["rows"]]
    (HERE / "classification.json").write_text(json.dumps(res, ensure_ascii=False, indent=1) + "\n")
    from collections import Counter
    print(Counter((x["exam_code"], x["cls"]) for x in res))
    print(Counter(x["cls"] for x in res))
    print("exact", sum(1 for x in res if x.get("exact_text_match")), "letterdot", sum(1 for x in res if x.get("letter_dot_in_prose")),
          "noterm", sum(1 for x in res if x.get("no_terminal_punct")))

if __name__ == "__main__":
    {"extract": lambda: extract(sys.argv[2]), "classify": do_classify}[sys.argv[1]]()
