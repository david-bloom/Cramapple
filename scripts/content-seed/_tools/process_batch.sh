#!/bin/bash
# env: LABEL_CFG (default _tools/label_cfg.json: pack, taxonomy and per-topic required_units per subject), AUDIT_OUT (default <folder>/_audit)
# usage: process_batch.sh <folder> "<subject>" <prefix> <tag> [date]  -- validate, package, blind-solve, tier-check (read-only; nothing executed in Production)
F=$(cd "$1" && pwd); SUBJ="$2"; PFX="$3"; TAG="$4"; DATE="${5:-2026-11-12}"; UNIT="${UNIT:-3}"; T=$(cd "$(dirname "$0")" && pwd)
python3 - "$F" "$SUBJ" "$PFX" "$TAG" "$DATE" "${LABEL_CFG:-$T/label_cfg.json}" "$UNIT" <<'PY'
import json,sys
f,subj,pfx,tag,date=sys.argv[1:6]
c=json.load(open(sys.argv[6]))[subj]
unit=int(sys.argv[7]); lr=dict(c["label_req_u%d"%unit] if unit in (2,4) else c["label_req"])
if unit==3:
    for t in ("3.8","3.11"): lr.setdefault(t,[3])
json.dump({"subject":subj,"pack":c["pack"],"tsv":c["tsv"],"prefix":pfx,"tag":tag,"date":date,"label_req":lr,"unit":unit,"seed":20261201},open(f+"/cfg.json","w"),indent=1)
PY
python3 $T/validate_draft.py $F/source_draft.md > $F/validate.log 2>&1 || { tail -20 $F/validate.log; echo 'draft validation FAILED'; exit 1; }; tail -2 $F/validate.log
python3 $T/make_package.py $F $F/cfg.json || exit 1
python3 $T/blind_solve.py $F/items.json "$SUBJ" 20
S=${AUDIT_OUT:-$F/_audit}
python3 $T/../../difficulty-audit/audit.py --items-file $F/items.json --subject-label "$SUBJ" --workers 16 --out $S > /dev/null 2>&1
cat $S/summary.csv; python3 - "$S" <<'PY'
import csv,sys
for r in csv.DictReader(open(sys.argv[1]+"/items.csv")):
    if r["tier"]=="R1" or "key_disputed" in r["flags"] or "missing" in r["flags"]: print("  R1/flag:",r["content_key"],r["tiers"],r["flags"],r["reason"][:100])
PY
