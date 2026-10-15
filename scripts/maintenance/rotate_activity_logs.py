"""Rotate docs/activity_log/{ACTIVITY,APPROVALS,DECISIONS}_LOG.md: entries (and index lines) dated before CUT move to a new
archive/ file; the live log keeps CUT onward. Run from the repo root after editing CUT and ROT below. Every entry and
index line is asserted to appear exactly once across live plus archive. Used 2026-10-15 (see
docs/handoffs/HELP_COVERAGE_AUDIT_SESSION_CLOSE_2026_10_15.md section 4). Review the diff before committing.
"""
import re, pathlib, json
CUT = "2026-10-01"; ROT = "2026-10-15"
MARK = "<!-- INDEX_END -->"
D = pathlib.Path("docs/activity_log"); A = D / "archive"
KEEP_LIVE = ("## Approval Format",)


def entry_date(head, body):
    m = re.search(r'\*\*Date:\*\*\s*(20\d\d-\d\d-\d\d)', body[:900])
    if m:
        return m.group(1)
    m = re.search(r'20\d\d-\d\d-\d\d', head)
    if m:
        return m.group()
    m = re.search(r'20\d\d-\d\d-\d\d', body[:500])
    return m.group() if m else None


def bullet_date(b):
    m = re.search(r'\([^)]*?(20\d\d-\d\d-\d\d)', b[:400]) or re.search(r'(20\d\d-\d\d-\d\d)', b[:400])
    return m.group(1) if m else None


def eid(h):
    m = re.search(r'(?:APPROVAL|DECISION)-(\d+)', h)
    return m.group(1) if m else None


def split(name, kind):
    t = (D / f"{name}.md").read_text()
    i = t.index(MARK)
    head, body = t[:i], t[i + len(MARK):]
    j = head.index("## Index\n") + len("## Index\n")
    prefix, idx = head[:j], head[j:]
    k = idx.index("- Older entries:")
    bullets_txt, tail = idx[:k], idx[k:]
    parts = re.split(r'\n(?=- )', bullets_txt)
    intro = parts[0] if not parts[0].startswith("- ") else ""
    bullets = [p.rstrip("\n") for p in parts if p.startswith("- ")]
    old_line, rest = tail.split("\n", 1)
    pieces = re.split(r'(?m)^(?=## )', body)
    pre, ents = pieces[0], pieces[1:]
    live, arch, last = [], [], None
    for e in ents:
        h = e.split("\n", 1)[0]
        d = entry_date(h, e)
        if h.startswith(KEEP_LIVE):
            d = "9999"
        if d is None:
            d = last
        last = d
        (live if (d or "9999") >= CUT else arch).append((h, d, e))
    arch_ids = {eid(h) for h, _, _ in arch if eid(h)}
    lb, ab = [], []
    for b in bullets:
        if kind == "activity":
            d = bullet_date(b)
            (ab if d and d < CUT else lb).append(b)
        else:
            m = re.search(r'(?:APPROVAL|DECISION)-(\d+)', b)
            (ab if m and m.group(1) in arch_ids else lb).append(b)
    return dict(name=name, kind=kind, prefix=prefix, intro=intro, old_line=old_line, rest=rest, pre=pre,
                live=live, arch=arch, lb=lb, ab=ab, nbul=len(bullets), nent=len(ents), orig=t)


def arch_name(s):
    if s["kind"] == "activity":
        ds = [d for _, d, _ in s["arch"] if d] + [bullet_date(b) for b in s["ab"] if bullet_date(b)]
        return f'{s["name"]}-{min(ds)}_to_{max(ds)}.md', min(ds), max(ds)
    ids = sorted({eid(h) for h, _, _ in s["arch"] if eid(h)})
    return f'{s["name"]}-{ids[0]}_to_{ids[-1]}.md', ids[0], ids[-1]


def build(s):
    an, lo, hi = arch_name(s)
    mo = re.search(r'\[`([^`]+)`\]\(([^)]+)\)', s["old_line"])
    older = f'- Older entries (newest archive first): [`{an[:-3]}`](archive/{an}), [`{mo.group(1)}`]({mo.group(2)})'
    note = (f"\n*Rotated {ROT}: entries dated before {CUT} moved to the archive above, with their index lines; "
            f"nothing was discarded. This log now holds {CUT} onward.*\n")
    live_txt = (s["prefix"] + s["intro"].rstrip("\n") + "\n\n" + "\n".join(s["lb"]) + "\n" + older + "\n" + note
                + "\n" + s["rest"].lstrip("\n").rstrip("\n") + "\n\n" + MARK + s["pre"] + "".join(e for _, _, e in s["live"]))
    title = {"ACTIVITY_LOG": "Activity Log", "APPROVALS_LOG": "Approvals Log", "DECISIONS_LOG": "Decisions Log"}[s["name"]]
    rng = f"{lo} to {hi}" if s["kind"] == "activity" else f"{s['name'].split('_')[0][:-1].upper() if False else ''}{lo} through {hi}"
    if s["kind"] != "activity":
        word = "APPROVAL" if s["kind"] == "approvals" else "DECISION"
        rng = f"{word}-{lo} through {word}-{hi}"
    arch_txt = (f"# {title} Archive — {rng}\n\nOlder entries rotated from `{s['name']}.md` on {ROT} "
                f"(entries dated before {CUT}). Their index lines are kept below.\n\n"
                f"## Rotated index lines\n\n" + "\n".join(s["ab"]) + "\n\n" + "".join(e for _, _, e in s["arch"]))
    return an, live_txt, arch_txt


summary = {}
for name, kind in [("ACTIVITY_LOG", "activity"), ("APPROVALS_LOG", "approvals"), ("DECISIONS_LOG", "decisions")]:
    s = split(name, kind)
    an, live_txt, arch_txt = build(s)
    assert len(s["live"]) + len(s["arch"]) == s["nent"]
    assert len(s["lb"]) + len(s["ab"]) == s["nbul"]
    for _, _, e in s["live"]:
        assert live_txt.count(e) == 1 and e not in arch_txt
    for _, _, e in s["arch"]:
        assert arch_txt.count(e) == 1 and e not in live_txt
    for b in s["lb"]:
        assert live_txt.count(b) == 1
    for b in s["ab"]:
        assert arch_txt.count(b) == 1
    (D / f"{name}.md").write_text(live_txt)
    (A / an).write_text(arch_txt)
    summary[name] = dict(archive=an, orig_kb=round(len(s["orig"]) / 1024), live_kb=round(len(live_txt) / 1024),
                         arch_kb=round(len(arch_txt) / 1024), entries_live_arch=(len(s["live"]), len(s["arch"])),
                         bullets_live_arch=(len(s["lb"]), len(s["ab"])), live_lines=live_txt.count("\n"))
print(json.dumps(summary, indent=1))
