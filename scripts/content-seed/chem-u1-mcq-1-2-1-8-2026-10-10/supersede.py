"""Move seed slots that duplicate a published bank item into superseded_seeds (the APPROVAL-0134 pattern), so the
next seed_pipeline run regenerates them with --bank. Nothing in any item is edited; the records are kept whole."""
import json, os, sys
os.chdir(os.path.dirname(os.path.abspath(__file__)))
REASON = {
    ('1.2', 'A'): 'seed duplicates Open Hand item apchem-oht-1.2 (two-peak weighted average, same three traps; bank 3-gram 0.133 > 0.12)',
    ('1.8', 'A'): 'seed duplicates Open Hand item apchem-oht-1.8 (group 2 metal + nitrogen -> M3N2, same three distractor formulas; bank 3-gram 0.125 > 0.12)',
}
for (topic, slot), why in REASON.items():
    p = f'batch/topics/ap-chemistry__{topic}.json'
    st = json.load(open(p))
    keep = [s for s in st['seeds'] if s['slot']['slot'] != slot]
    gone = [s for s in st['seeds'] if s['slot']['slot'] == slot]
    if not gone:
        print(topic, slot, 'already superseded'); continue
    st.setdefault('superseded_seeds', []).extend(dict(s, superseded_reason=why) for s in gone)
    st['seeds'] = keep
    json.dump(st, open(p + '.tmp', 'w'), indent=1); os.replace(p + '.tmp', p)
    print(topic, slot, 'superseded:', why)
