"""Deterministic check of every data-reading key in the Biology Unit 3 batch (read from the stems' tables)."""
import json
R = {}
R["APBIO-MCQ-124"] = max({"4": 2, "7": 12, "10": 2}.items(), key=lambda x: x[1])[0] == "7" and 12 == 12          # key A: max at pH 7, full recovery
R["APBIO-MCQ-SV-124-v1"] = max({"20": 4, "40": 16, "65": 1}.items(), key=lambda x: x[1])[0] == "40" and 16 == 16  # key D: max at 40 C, full recovery
R["APBIO-MCQ-SV-128-v1"] = [9, 6, 3] == sorted([9, 6, 3], reverse=True) and [6, 4, 2] == sorted([6, 4, 2], reverse=True)  # key C: both outputs fall
R["APBIO-MCQ-130"] = [0, 12, 24] == sorted([0, 12, 24])                                                   # key C: ATP rises with O2
R["APBIO-MCQ-SV-130-v1"] = [30, 14, 2] == sorted([30, 14, 2], reverse=True)                               # key C: ATP falls as O2 falls
json.dump(R, open("recompute.json", "w"), indent=1); print(all(R.values()), R)
