# Replaces APBIO-MCQ-021 variant v2 with a CED-level version (2026-10-01, Product Owner decision after the CED check).
# Why: the original v2 (and v1, and the seed) rest on signal peptide / SRP targeting, which the AP Biology CED (V.1, pp. 49-50) never names.
# This version tests only EK 2.1.A.1 (ribosomes make protein from mRNA), 2.1.A.2 (endomembrane system modifies/packages/transports),
# 2.1.A.3 (rough ER: ribosomes, protein synthesis; smooth ER: detox, lipid synthesis), 2.1.A.4 (Golgi folds/modifies/packages), 2.1.A.6 (lysosomes digest).
# Only 021-v2 changes; the other 15 variants keep their text and letters. build_variants.py is NOT re-run (it would redraw letters).
import json, random, os
D = os.path.dirname(__file__)
KEY, SEED = "apbio-mcq-sv-021-v2", "APBIO-MCQ-021"
L = "ABCD"
stim = ("A pancreatic cell secretes a digestive enzyme. Researchers expose the cells briefly to radioactive amino acids and then follow the radioactive enzyme over time. "
        "At first, most of the radioactivity is found in the rough ER. Later it is found in the Golgi complex, then in transport vesicles near the plasma membrane, and finally outside the cell.")
q = "Which interpretation of these results is best supported?"
corr = ("Ribosomes on the rough ER make the enzyme, and it then moves through the Golgi complex and vesicles, where it is modified and packaged for secretion.",
        "Correct. Ribosomes synthesize proteins from mRNA, and rough ER has membrane-bound ribosomes. The Golgi complex then folds, modifies, and packages the protein, and vesicles carry it out of the cell.")
dis = [("The smooth ER makes the enzyme, because the rough ER only provides support for the cell and does not take part in making proteins.",
        "Incorrect. Rough ER is the part with membrane-bound ribosomes that helps carry out protein synthesis; smooth ER is involved in detoxification and lipid synthesis."),
       ("The Golgi complex makes the enzyme from mRNA, and the rough ER later folds it before the enzyme is moved to the plasma membrane.",
        "Incorrect. Ribosomes, not the Golgi complex, synthesize proteins from mRNA, and the radioactivity reached the Golgi complex after the rough ER, not before it."),
       ("Lysosomes receive the enzyme from the rough ER and release it from the cell, because lysosomes are the organelles that secrete enzymes.",
        "Incorrect. Lysosomes contain hydrolytic enzymes that digest material; they are not the route for secretion. The radioactivity moved through the Golgi complex and transport vesicles to the outside.")]
rng = random.Random(KEY + "-ced")
opts = [(corr[0], corr[1], True)] + [(t, r, False) for t, r in dis]
rng.shuffle(opts)
keyed = next(L[i] for i, o in enumerate(opts) if o[2])
item = dict(key=KEY, kind="mcq", unit=2, topic="2.1", seed=SEED, stem=f"Stimulus: {stim}\n\nQuestion: {q}",
            choices=[dict(label=L[i], text=o[0]) for i, o in enumerate(opts)], keyed_label=keyed, rationales={L[i]: o[1] for i, o in enumerate(opts)})
change = "signal peptide ADDED (SRP targeting, not in the CED) -> pulse-chase of a secreted enzyme through rough ER, Golgi, vesicles (CED 2.1.A.1-A.4, A.6 only)"
def patch(fn, mf=None):
    p = os.path.join(D, fn); data = json.load(open(p)); n = 0
    for i, x in enumerate(data):
        if x["key"] == KEY: data[i] = item if "keyed_label" in x and "choices" in x else {**x, "keyed_label": keyed, "change": change}; n += 1
    assert n == 1, (fn, n); json.dump(data, open(p, "w"), indent=1, ensure_ascii=False)
for fn in ("variants_all_items.json", "variants_items.json"): patch(fn)
patch("variants_manifest.json")
json.dump([item], open(os.path.join(D, "variants_021v2_ced_items.json"), "w"), indent=1, ensure_ascii=False)
print("keyed", keyed)
