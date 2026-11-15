#!/bin/bash
cd "$(dirname "$0")"
M="openai/gpt-6.1-sol moonshotai/kimi-k3.1-pro"
for s in ap_biology ap_chemistry ap_calculus_ab ap_calculus_bc ap_physics_1 ap_precalculus; do
  ONLY=$s python3 -u qt2.py check $M > qlog_$s.txt 2>&1 &
done
ONLY=ap_calculus_bc python3 -u qt2.py check $M --plant > qlog_control.txt 2>&1 &
python3 -u tools_wrap.py > /dev/null 2>&1 &
wait; echo done > qcheck_done.txt
