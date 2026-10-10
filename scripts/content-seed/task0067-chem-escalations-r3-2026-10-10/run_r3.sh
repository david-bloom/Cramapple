#!/bin/zsh
export CED_TXT_DIR=/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple-nosync/211f199a-0378-46e1-a488-cab0ad894344/scratchpad/ced
typeset -A PAGES; PAGES=(5 96-113 7 130-147 8 148-167 9 168-185)
for u in 5 7 8 9; do
  echo "== unit $u"
  python3 extract.py --subject ap-chemistry --subject-key ap_chemistry --unit $u --pages ${PAGES[$u]} --factpack out/factpack_ap_chemistry_u$u.md --only out/only_r3_u$u.json --round 3 || { echo "EXTRACT_FAILED u$u"; continue; }
  if [ $u = 5 ]; then CT="--controls controls_r3_u5.json"; else CT=""; fi
  python3 check.py --subject ap-chemistry --subject-key ap_chemistry --unit $u --pages ${PAGES[$u]} --round 3 --workers 6 ${=CT} > out/check_r3_u$u.log 2>&1 || echo "CHECK_FAILED u$u"
  tail -3 out/check_r3_u$u.log
done
echo ALL_DONE
