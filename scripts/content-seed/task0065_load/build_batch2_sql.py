"""Batch 2 of TASK-0065: the 15 items fixed in fix15/ (blocked from batch 1).
Same generator and SQL as build_load_sql.py, pointed at fix15/items_after.json with
no exclusions, writing to load_batch2/."""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
import build_load_sql as b

b.SRC = os.path.join(b.ROOT, 'docs/research/open_hand_teaching_batch_2026_10_06/fix15/items_after.json')
b.OUT = os.path.join(b.ROOT, 'docs/research/open_hand_teaching_batch_2026_10_06/load_batch2')
b.EXCLUDE = {}
b.main()
