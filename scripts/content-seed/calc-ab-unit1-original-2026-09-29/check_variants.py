#!/usr/bin/env python3
"""Verify one or more variant modules.  Usage: python3 check_variants.py variants_mcq_a [variants_mcq_b ...]

Passes only if every variant's calc() reproduces its keyed answer, distractor wrong_calcs (when given) reproduce
their texts, structure is sound, and each module's variants cover its originals exactly 3 times each."""
import importlib
import sys
from vlib import check_variants
from items import MCQS, FRQS

mods = sys.argv[1:] or []
variants = []
for name in mods:
    m = importlib.import_module(name)
    variants += m.VARIANTS
fails, per = check_variants(variants, MCQS, FRQS)
for (kind, of), ids in sorted(per.items()):
    if len(ids) != 3:
        fails.append(f"{kind} original {of}: has {len(ids)} variants, need exactly 3 ({ids})")
if fails:
    print("FAILED:")
    for f in fails:
        print("  -", f)
    sys.exit(1)
print(f"OK: {len(variants)} variants verified across {len(per)} originals")
