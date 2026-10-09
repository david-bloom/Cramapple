"""Phase B step 2: two checker families (never the extractor's family) verify every candidate entry and hook
against the CED unit pages. Reject-only own-family veto runs last. A checker that flags is re-sampled once;
only a repeated flag counts (protocol v0.6 §0.2). Planted controls must all be rejected or the batch is void.
Output: out/verdicts_<subject>_u<unit>.json"""
import json, sys, pathlib, argparse, copy
import sys as _sys, pathlib as _pl; _sys.path.insert(0, str(_pl.Path(__file__).resolve().parent))
from gateway import chat_json, ced_pages

HERE = pathlib.Path(__file__).resolve().parent
CHECKERS = ["google/gemini-3.5-flash", "openai/gpt-6-sol"]   # protocol §3.2 menu slots B and A, picked 2026-10-09
VETO = "anthropic/claude-haiku-5.5"                            # extractor family, reject-only (DECISION-0107: Opus 5.5 was 56% of the pilot spend; Haiku 5.5 recosts the same calls at $0.28 vs $11.37)

SYSTEM = """You are a strict checker of AP reference content against the College Board CED. You never approve on
style; you reject on substance. Return only JSON."""

CHECKS = """Judge the ENTRY (and each of its HOOKS, if any) against the CED pages. Return:
{"entry": {"a_factual": bool, "b_topic_codes": bool, "c_ced_required": bool, "d_caution": bool, "accept": bool, "reasons": "..."},
 "hooks": [{"hook_text": "...", "e_expansion": bool, "f_admissible": bool, "accept": bool, "reasons": "..."}]}
Where:
 a_factual: the body/items/formula are correct as the CED states them (formula symbols, list members and order, definitions).
 b_topic_codes: owner_topic_code is where this unit first requires it, and every topic_codes entry is a topic of this unit that uses it.
 c_ced_required: a CED learning objective or essential-knowledge statement in these pages requires a student to reproduce or apply this; textbook completeness, trivia, or content from other units fails.
 d_caution: if the entry's wording is not the wording that earns the point (the CED phrases it differently), a caution is present and correct; if no caution is needed, true.
 e_expansion (hook): every cue in expands_to maps to the right member, in the right order, and matches the entry.
 f_admissible (hook): the hook recalls an ordered sequence, list, formula structure, sign/direction convention, or labelled diagram parts that the CED requires; it is not a song lyric; its caution is present when its wording is not the point-earning wording.
accept = all of that element's booleans. Be concrete in reasons: quote the CED line that supports or contradicts."""


def judge(model, ced, entry, log_dir, tag):
    e = {k: v for k, v in entry.items() if k not in ("extractor", "candidate_id", "control")}
    user = f"=== CED UNIT PAGES ===\n{ced}\n\n=== ENTRY ===\n{json.dumps(e, indent=1)}\n\n=== CHECKS ===\n{CHECKS}"
    parsed, _ = chat_json(model, SYSTEM, user, log_dir, tag, max_tokens=3000, temperature=0.1)
    return parsed


def _entry_flag(v):
    return not v.get("entry", {}).get("accept", False)


def _hook_flags(v):
    return {h.get("hook_text"): not h.get("accept", False) for h in v.get("hooks", [])}


def verdict_for(model, ced, entry, log_dir, cid):
    """Entry and hook verdicts are independent. A flag on either is re-sampled once; only a repeated
    flag counts. Returns {"accept": entry_ok, "hooks": {hook_text: ok}, "samples": [...]}."""
    v1 = judge(model, ced, entry, log_dir, f"{cid}:1")
    e1, h1 = _entry_flag(v1), _hook_flags(v1)
    if not e1 and not any(h1.values()):
        return {"accept": True, "hooks": {k: True for k in h1}, "samples": [v1]}
    v2 = judge(model, ced, entry, log_dir, f"{cid}:2")
    e2, h2 = _entry_flag(v2), _hook_flags(v2)
    hooks = {}
    for h in entry.get("hooks") or []:
        k = h.get("hook_text")
        hooks[k] = not (h1.get(k, True) and h2.get(k, True))   # rejected only if flagged twice (missing = flagged)
    return {"accept": not (e1 and e2), "hooks": hooks, "samples": [v1, v2]}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--subject", required=True); ap.add_argument("--subject-key", required=True)
    ap.add_argument("--unit", type=int, required=True); ap.add_argument("--pages", required=True)
    ap.add_argument("--controls", default=None)
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--workers", type=int, default=6)
    ap.add_argument("--round", type=int, default=1)
    a = ap.parse_args()
    first, last = [int(x) for x in a.pages.split("-")]
    ced = ced_pages(a.subject, first, last)
    out = HERE / "out"
    sfx = "" if a.round == 1 else f"_r{a.round}"
    cands = json.loads((out / f"candidates_{a.subject_key}_u{a.unit}{sfx}.json").read_text())
    if a.limit: cands = cands[:a.limit]
    if a.controls:
        cands = cands + json.loads(pathlib.Path(a.controls).read_text())
    log_dir = out / f"logs_check_{a.subject_key}_u{a.unit}"
    vpath = out / f"verdicts_{a.subject_key}_u{a.unit}{sfx}.json"
    results = json.loads(vpath.read_text()) if vpath.exists() else []
    done = {r["candidate_id"] for r in results}
    todo = [c for c in cands if c["candidate_id"] not in done]
    print(f"{len(done)} already judged, {len(todo)} to go", flush=True)
    import threading
    from concurrent.futures import ThreadPoolExecutor, as_completed
    lock = threading.Lock()

    def one(c):
        cid = c["candidate_id"]
        per = {m: verdict_for(m, ced, c, log_dir, cid) for m in CHECKERS}
        both = all(per[m]["accept"] for m in CHECKERS)
        veto = verdict_for(VETO, ced, c, log_dir, cid + ":veto") if both else None
        accepted = both and (veto is None or veto["accept"])
        hook_ok = {}
        for h in c.get("hooks") or []:
            k = h["hook_text"]
            hook_ok[k] = accepted and all(v["hooks"].get(k, False) for v in list(per.values()) + ([veto] if veto else []))
        return {"candidate_id": cid, "control": c.get("control"), "accepted": accepted,
                "hooks_accepted": hook_ok, "checkers": per, "veto": veto}

    with ThreadPoolExecutor(max_workers=a.workers) as ex:
        futs = {ex.submit(one, c): c for c in todo}
        for f in as_completed(futs):
            c = futs[f]
            try:
                r = f.result()
            except Exception as e:
                print(f"{c['candidate_id']:<28} ERROR {str(e)[:160]}", flush=True)
                continue
            with lock:
                results.append(r)
                vpath.write_text(json.dumps(results, indent=2))
            per = r["checkers"]; veto = r["veto"]; hook_ok = r["hooks_accepted"]
            print(f"{r['candidate_id']:<28} {'ACCEPT' if r['accepted'] else 'reject'}  hooks={sum(hook_ok.values())}/{len(hook_ok)}  "
                  f"{' '.join(m.split('/')[1][:12]+('Y' if per[m]['accept'] else 'N') for m in CHECKERS)}"
                  f"{'  veto'+('Y' if veto and veto['accept'] else 'N') if veto else ''}", flush=True)
    ctrl = [r for r in results if r["control"]]
    if ctrl:
        leaked = [r["candidate_id"] for r in ctrl if r["accepted"]]
        print(f"controls: {len(ctrl) - len(leaked)}/{len(ctrl)} rejected" + (f"  BATCH VOID, accepted controls: {leaked}" if leaked else ""), flush=True)
    print("DONE", flush=True)


if __name__ == "__main__":
    main()
