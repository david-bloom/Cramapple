#!/usr/bin/env python3
"""Build OFFLINE serving-label packets for the original items, in the exact shape
scripts/taxonomy/fetch_serving_label_packets.sql returns. Ids are random placeholders (nothing is in a database);
choice order is shuffled with OS entropy and canonical_answer_1 is the resulting letter.
Usage: python3 build_serving_packets.py <out.json> [--variants]"""
import importlib, json, secrets, sys, uuid
from items import MCQS, FRQS
rng = secrets.SystemRandom()
L = "ABCD"
out = sys.argv[1]
with_var = "--variants" in sys.argv
def base(key, title, itype):
    return dict(exam_code="ap_calculus_ab", exam_pack_version_id=str(uuid.uuid4()), content_item_id=str(uuid.uuid4()),
                content_key=key, title=title, content_status="reviewed_approved", item_type=itype,
                frq_form="short" if itype == "frq" else None, practice_format="targeted_drill" if itype == "frq" else None,
                content_item_version_id=str(uuid.uuid4()), version_num=1, version_status="reviewed_approved", published_at=None,
                stimulus_image_path=None, prompt_json_without_legacy_taxonomy={}, canonical_answer_2=None,
                taxonomy_relevant_hash="offline", taxonomy_source_version="33b4408b-0ecc-4c7a-b0b1-612db81164a1",
                legacy_label_status=None, legacy_required_units=None, legacy_max_required_unit=None,
                legacy_primary_unit=None, legacy_source=None)
def mcq_packet(key, title, stem, correct, wrong):
    ch = [("c", correct)] + [("w", w) for w in wrong]; rng.shuffle(ch)
    p = base(key, title, "mcq"); p.update(stem=stem, stimulus=None, frq_criteria=[],
        mcq_choices=[dict(choice_key=L[i], choice_text=c[1][0], is_correct=(c[0] == "c"), rationale=c[1][1]) for i, c in enumerate(ch)],
        canonical_answer_1=next(L[i] for i, c in enumerate(ch) if c[0] == "c"))
    return p
def frq_packet(key, title, stem, stim, crit):
    p = base(key, title, "frq"); p.update(stem=stem, stimulus=stim, mcq_choices=[], canonical_answer_1=None,
        frq_criteria=[dict(criterion_key=c[0], learner_facing_text=c[1], points_possible=c[2], evidence_requirements=c[3], minimum_fix=c[4]) for c in crit])
    return p
rows = []
for m in MCQS: rows.append(mcq_packet(f"apcalcab-mcq-u1n-{m['id']}", m["title"], m["stem"], m["correct"], m["wrong"]))
vals = ["0.16713", "0.16671", "0.16667", "0.16666", "0.16662", "0.16621"]
for f in FRQS:
    stim = f["stimulus"]
    for n, v in enumerate(vals, 1): stim = stim.replace(f"TABLE_H{n}", v)
    rows.append(frq_packet(f"apcalcab-frq-u1n-{f['id']}", f["title"], f["stem"], stim, f["criteria"]))
if with_var:
    for n in ["variants_mcq_a", "variants_mcq_b", "variants_mcq_c", "variants_frq"]:
        for v in importlib.import_module(n).VARIANTS:
            if v["kind"] == "mcq": rows.append(mcq_packet(f"apcalcab-mcq-u1v-{v['id']}", v["title"], v["stem"], v["correct"], v["wrong"]))
            else: rows.append(frq_packet(f"apcalcab-frq-u1v-{v['id']}", v["title"], v["stem"], v["stimulus"], v["criteria"]))
json.dump(rows, open(out, "w"), indent=1)
print(len(rows), "packets;", sum(r["item_type"] == "mcq" for r in rows), "MCQ,", sum(r["item_type"] == "frq" for r in rows), "FRQ")
