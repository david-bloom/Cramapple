#!/bin/zsh
# Re-extract every AP Chemistry formula entry with symbol definitions, then check (round label 9 = format pass).
export CED_TXT_DIR=/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple-nosync/211f199a-0378-46e1-a488-cab0ad894344/scratchpad/ced
typeset -A PAGES; PAGES=(1 29-45 2 46-59 3 60-79 4 80-95 5 96-113 6 114-129 7 130-147 8 148-167 9 168-185)
for u in 1 2 3 4 5 6 7 8 9; do
  echo "== unit $u"
  python3 extract.py --subject ap-chemistry --subject-key ap_chemistry --unit $u --pages ${PAGES[$u]} --factpack out/factpack_ap_chemistry_u$u.md --only out/only_fmt_u$u.json --round 9 || { echo "EXTRACT_FAILED u$u"; continue; }
  if [ $u = 3 ]; then CT="--controls controls_fmt_u3.json"; else CT=""; fi
  python3 check.py --subject ap-chemistry --subject-key ap_chemistry --unit $u --pages ${PAGES[$u]} --round 9 --workers 6 ${=CT} > out/check_fmt_u$u.log 2>&1 || echo "CHECK_FAILED u$u"
  tail -2 out/check_fmt_u$u.log
done
echo ALL_DONE
