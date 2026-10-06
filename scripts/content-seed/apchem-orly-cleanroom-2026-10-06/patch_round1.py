"""Round-1 patches after the 2026-10-06 audit. Text-only fixes; keys and letters unchanged.
Run from scripts/content-seed/. Writes items_assembled.json in place after saving items_assembled_prepatch.json."""
import json, shutil, os
P = {
 'apchem-orly-cleanroom-2026-10-06': {
  'apchem-mcq-orly-f6-v3': [('rationales', 'A', 'mol (NH₄)₂SO₄ = 2.64 g ÷ 132.15 g/mol = 0.01998 mol, giving 2 × 0.01998 = 0.03995 mol NH₄⁺', 'mol (NH₄)₂SO₄ = 2.64 g ÷ 132.15 g/mol = 0.019977 mol, giving 2 × 0.019977 = 0.039955 mol NH₄⁺'),
                            ('rationales', 'D', '(NH₄)₂SO₄ gives 0.114 M and NH₄NO₃ gives 0.0286 M; (0.114 + 0.0286) ÷ 2 = 0.0714 M', '(NH₄)₂SO₄ gives 0.1142 M and NH₄NO₃ gives 0.02855 M; (0.1142 + 0.02855) ÷ 2 = 0.0714 M')],
  'apchem-mcq-orly-f7-v1': [('stem', None, 'reads the pressure of the gas from a gauge attached to the flask', 'measures the absolute pressure of the gas with a pressure sensor attached to the flask'),
                            ('stem', None, 'No liquid is present in the flask at any time.', 'The gas is dry, and no liquid is present in the flask at any time.'),
                            ('rationales', 'B', 'No liquid is present, so no vapor contributes a partial pressure.', 'The gas is dry and no water was used, so no water vapor contributes a partial pressure.'),
                            ('rationales', 'C', 'and P is read from the gauge', 'and P is the measured absolute pressure')],
  'apchem-mcq-orly-f7-v2': [('stem', None, 'No liquid is present.', 'The gas is dry, and no liquid is present.'),
                            ('rationales', 'B', 'No liquid is present, so there is no vapor to contribute a partial pressure.', 'The gas is dry and no water was used, so no water vapor contributes a partial pressure.')],
  'apchem-mcq-orly-f8-v3': [('stem', None, "How does the student's result compare with", "How does the student's result most likely compare with"),
                            ('rationales', 'A', 'the direction of the error can already be judged.', 'the most likely direction of the error can already be judged.')],
 },
 'apcalcab-orly-cleanroom-2026-10-06': {
  'apcalcab-mcq-orly-c1-v1': [('rationales', 'D', 'The later value must be subtracted first.', 'The earlier value must be subtracted from the later value.')],
 },
}
for batch, items in P.items():
    f = os.path.join(batch, 'items_assembled.json'); pre = os.path.join(batch, 'items_assembled_prepatch.json')
    if not os.path.exists(pre): shutil.copy(f, pre)
    data = json.load(open(pre))
    for it in data:
        for field, lab, old, new in items.get(it['key'], []):
            if field == 'stem':
                assert it['stem'].count(old) == 1, (it['key'], old); it['stem'] = it['stem'].replace(old, new)
            else:
                assert it[field][lab].count(old) == 1, (it['key'], lab, old); it[field][lab] = it[field][lab].replace(old, new)
    json.dump(data, open(f, 'w'), ensure_ascii=False, indent=1)
    print(batch, 'patched', list(items))
# Round 2 (after the CED check): apchem-mcq-orly-f3-v1 stem "A chemist weighs out 2.00 mol of barium nitrate, Ba(NO₃)₂."
# -> "A chemist measures out a sample of barium nitrate, Ba(NO₃)₂, that contains 2.00 mol of the compound." Applied in place; re-audited (out_audit_r2).
