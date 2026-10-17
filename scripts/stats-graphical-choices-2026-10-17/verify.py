"""Source, arithmetic and artifact checks; independent implementation of bin counts.

This is deterministic verification, not independent-family content QA or a live
stored-key comparison. Runs without model, database or network access.
"""
from bisect import bisect_right
from collections import Counter
from copy import deepcopy
from hashlib import sha256
import json
from pathlib import Path
import re
import struct
import xml.etree.ElementTree as ET

HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / 'image_readiness/precalc-statistics-u1-u3-2026-10-16/published-source-inventory.json'
NS = {'s': 'http://www.w3.org/2000/svg'}


def validate_item(item, source):
    assert item['stem'] == source['stem']
    assert item['source_content_item_version_id'] == source['content_item_version_id']
    assert item['source_audit_content_digest'] == source['audit_content_digest']
    assert item['source_stem_sha256'] == sha256(source['stem'].encode()).hexdigest()
    assert item['source_choices_sha256'] == sha256(json.dumps(source['choices'], sort_keys=True, ensure_ascii=False, separators=(',', ':')).encode()).hexdigest()
    raw = list(map(int, re.search(r' are (.*?)\.', source['stem']).group(1).split(', ')))
    assert item['observations'] == raw and len(raw) == 12
    edges = [b['left_edge'] for b in item['bins']] + [item['bins'][-1]['right_edge_exclusive']]
    assert len(set(edges[j+1]-edges[j] for j in range(len(edges)-1))) == 1
    for i, b in enumerate(item['bins']):
        assert b['lower'] == edges[i] and b['upper'] == edges[i+1]-1
    indices = [bisect_right(edges, value)-1 for value in raw]
    assert all(0 <= i < len(edges)-1 for i in indices)
    tally = Counter(indices)
    expected = [tally[i] for i in range(len(edges)-1)]
    assert item['expected_counts'] == expected
    choices = item['choices']
    assert [c['key'] for c in choices] == item['choice_order'] == [c['key'] for c in source['choices']]
    assert len(choices) == len({tuple(c['counts']) for c in choices}) == 4
    matches = [c['key'] for c in choices if c['counts'] == expected]
    assert matches == [item['derived_answer_key']]
    for c, old in zip(choices, source['choices']):
        assert len(c['counts']) == len(expected) and sum(c['counts']) == len(raw)
        assert all(isinstance(n, int) and n >= 0 for n in c['counts'])
        parsed = [(int(a), int(b), int(n)) for a,b,n in re.findall(r'(\d+)-(\d+) [^:;]+: (\d+)', c['choice_text'])]
        assert parsed == [(b['lower'], b['upper'], n) for b,n in zip(item['bins'],c['counts'])]
        assert c['alt_text'] == 'Choice ' + c['key'] + '. ' + c['choice_text']
        assert c['is_correct'] == (c['counts'] == expected)
        assert ('Fix:' in c['rationale']) != c['is_correct']
        if old['text'].startswith('Histogram with counts '):
            assert c['change'] == 'retained_histogram' and c['choice_text'] == old['text']
        else:
            assert c['change'].startswith('replaced_')
            mutation = c['proposed_error']
            donor, recipient = mutation['donor_bin_index'], mutation['recipient_bin_index']
            assert abs(donor-recipient) == 1
            assert mutation['misplaced_observation'] in raw
            assert bisect_right(edges, mutation['misplaced_observation'])-1 == donor
        if not c['is_correct']:
            assert sum(abs(n-e) for n,e in zip(c['counts'],expected)) == 2
    assert sum(c['change'] == 'retained_histogram' for c in choices) == 2
    assert len(item['replacements']) == 2
    assert item['y_axis_max'] >= max(max(c['counts']) for c in choices)
    return expected


def main():
    spec = json.loads((HERE/'specs.json').read_text())
    manifest = json.loads((HERE/'manifest.json').read_text())
    sources = {r['content_key']: r for r in json.loads(SOURCE.read_text())}
    assert len(spec['items']) == len(manifest['items']) == 20
    assert len({i['source_content_item_version_id'] for i in spec['items']}) == 20
    assert sha256(SOURCE.read_bytes()).hexdigest() == spec['source_inventory_sha256']
    assert sha256((HERE/'render.mjs').read_bytes()).hexdigest() == manifest['renderer_sha256']
    assert sha256((HERE/'specs.json').read_bytes()).hexdigest() == manifest['specs_sha256']
    graphics = 0
    for item, asset_item in zip(spec['items'], manifest['items']):
        validate_item(item, sources[item['content_key']])
        assert asset_item['content_key'] == item['content_key']
        records = asset_item['choices'] + [asset_item['all_choices_sheet']]
        for j, asset in enumerate(records):
            svg = (HERE/asset['svg']).read_bytes()
            png = (HERE/asset['png']).read_bytes()
            assert sha256(svg).hexdigest() == asset['svg_sha256']
            assert sha256(png).hexdigest() == asset['png_sha256']
            assert png[:8] == b'\x89PNG\r\n\x1a\n'
            w,h = struct.unpack('>II',png[16:24])
            assert (w,h) == (680,660 if j<4 else 2640)
            doc=ET.fromstring(svg)
            bars=doc.findall('.//s:rect[@data-role="histogram-bar"]',NS)
            wanted=[item['choices'][j]] if j<4 else item['choices']
            assert [int(b.attrib['data-count']) for b in bars] == [n for c in wanted for n in c['counts']]
            for bar in bars:
                n=int(bar.attrib['data-count'])
                assert abs(float(bar.attrib['height'])-n/item['y_axis_max']*178)<1e-5
                assert float(bar.attrib['x'])>=65 and float(bar.attrib['x'])+float(bar.attrib['width'])<=312.00001
            texts=doc.findall('.//s:text',NS)
            assert all('correct' not in (t.text or '').lower() for t in texts)
            assert {t.text for t in texts if t.attrib.get('data-meaningful')=='choice-label'} == {c['key'] for c in wanted}
            assert asset['long_description'] == (item['choices'][j]['long_description'] if j<4 else item['sheet_long_description'])
            graphics+=1
    # Prove key and stale-source guards reject real failure modes.
    tested=0
    original=spec['items'][0]
    for defect in ['duplicate_answer','changed_stem','changed_digest','misstated_alt']:
        bad=deepcopy(original)
        if defect=='duplicate_answer': bad['choices'][0]['counts']=bad['expected_counts'].copy()
        if defect=='changed_stem': bad['stem']+=' changed'
        if defect=='changed_digest': bad['source_audit_content_digest']='wrong'
        if defect=='misstated_alt': bad['choices'][0]['alt_text']='missing bins'
        try: validate_item(bad,sources[bad['content_key']])
        except AssertionError: tested+=1
        else: raise AssertionError('Negative control passed: '+defect)
    result={'status':'PASS','questions':20,'choices':80,'source_stems_and_observations_preserved':20,
            'historical_histogram_choices_preserved':40,'new_distractors':40,
            'unique_data_matching_answer_per_question':20,'svg_png_pairs_verified':graphics,
            'negative_controls_rejected':tested,
            'limits':'Local deterministic source/math/artifact checks only. Stored live keys, independent-family subject QA and actual app delivery are not certified.'}
    (HERE/'verification.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':
    main()
