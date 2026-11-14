#!/bin/bash
cd "$(dirname "$0")"
M="openai/gpt-6.1-sol moonshotai/kimi-k3.1-pro"
for s in ap_biology ap_chemistry ap_calculus_ab ap_calculus_bc_a ap_calculus_bc_b ap_physics_1 ap_precalculus; do
  python3 -u tools.py check current_$s.json proposed_$s.json check_out/$s $M > check_log_$s.txt 2>&1 &
done
python3 -u tools.py check current_ap_calculus_bc_a.json control_bc_a.json check_out/control $M --plant 1.1 > check_log_control.txt 2>&1 &
wait
echo done > check_done.txt
