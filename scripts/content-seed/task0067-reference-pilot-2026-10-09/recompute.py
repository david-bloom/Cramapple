"""Re-derive every verdict from the stored checker samples under the corrected rules (entry and hook
verdicts independent; a flag counts only when repeated), and run the own-family veto for candidates
that both checkers now accept but that never reached the veto. Archives the previous verdict file."""
import sys as _sys, pathlib as _pl; _sys.path.insert(0, str(_pl.Path(__file__).resolve().parent))
import json, argparse, pathlib, shutil
from gateway import ced_pages
import check as C

HERE = pathlib.Path(__file__).resolve().parent


def rederive(samples, entry):
    e = [C._entry_flag(v) for v in samples]
    hs = [C._hook_flags(v) for v in samples]
    hooks = {}
    for h in entry.get("hooks") or []:
        k = h.get("hook_text")
        flags = [hf.get(k, True) for hf in hs]
        hooks[k] = not all(flags)              # ok unless flagged in every sample
    return {"accept": not all(e), "hooks": hooks, "samples": samples}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--subject", required=True); ap.add_argument("--subject-key", required=True)
    ap.add_argument("--unit", type=int, required=True); ap.add_argument("--pages", required=True)
    a = ap.parse_args()
    first, last = [int(x) for x in a.pages.split("-")]
    ced = ced_pages(a.subject, first, last)
    out = HERE / "out"
    vpath = out / f"verdicts_{a.subject_key}_u{a.unit}.json"
    shutil.copy(vpath, out / f"verdicts_{a.subject_key}_u{a.unit}_pre_recompute.json")
    cands = {c["candidate_id"]: c for c in json.loads((out / f"candidates_{a.subject_key}_u{a.unit}.json").read_text())}
    for cf in HERE.glob(f"controls_{a.subject_key}_u{a.unit}.json"):
        for c in json.loads(cf.read_text()): cands[c["candidate_id"]] = c
    rows = json.loads(vpath.read_text())
    log_dir = out / f"logs_check_{a.subject_key}_u{a.unit}"
    changed = vetoes = 0
    for r in rows:
        c = cands.get(r["candidate_id"])
        if not c: continue
        per = {m: rederive(v["samples"], c) for m, v in r["checkers"].items()}
        both = all(per[m]["accept"] for m in C.CHECKERS)
        veto = rederive(r["veto"]["samples"], c) if r.get("veto") else None
        if both and veto is None:
            veto = C.verdict_for(C.VETO, ced, c, log_dir, r["candidate_id"] + ":veto"); vetoes += 1
        accepted = both and (veto is None or veto["accept"])
        hook_ok = {h["hook_text"]: accepted and all(v["hooks"].get(h["hook_text"], False) for v in list(per.values()) + ([veto] if veto else []))
                   for h in (c.get("hooks") or [])}
        if accepted != r["accepted"] or hook_ok != r["hooks_accepted"]:
            changed += 1
            print(f"{r['candidate_id']:<30} {r['accepted']}->{accepted}  hooks {r['hooks_accepted']}->{hook_ok}")
        r.update({"accepted": accepted, "hooks_accepted": hook_ok, "checkers": per, "veto": veto})
    vpath.write_text(json.dumps(rows, indent=2))
    ctrl = [r for r in rows if r["control"]]
    leaked = [r["candidate_id"] for r in ctrl if r["accepted"]]
    real = [r for r in rows if not r["control"]]
    print(f"recomputed: {changed} changed, {vetoes} new veto calls; accepted {sum(r['accepted'] for r in real)}/{len(real)}; "
          f"controls {len(ctrl)-len(leaked)}/{len(ctrl)} rejected{'  BATCH VOID '+str(leaked) if leaked else ''}")


if __name__ == "__main__":
    main()
