"""Resolve the existing 20-item display-choice defect; no database or model calls.

Retain the stem, observations, choice order and both original histograms. Replace
the two under-specified non-histogram distractors with explicit counting errors.
This authors a review draft; it does not infer missing historical source details.
"""
from collections import Counter
from hashlib import sha256
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / 'image_readiness/precalc-statistics-u1-u3-2026-10-16/published-source-inventory.json'
SOURCE_COMMIT = '578ab8223e2e75b5dfb49a5420283c7af8ab28a1'


def histogram(text):
    return [dict(lower=int(a), upper=int(b), count=int(c))
            for a, b, c in re.findall(r'(\d+)-(\d+) [^:;]+: (\d+)', text)]


def description(bins, counts, unit):
    return 'Histogram with counts ' + '; '.join(
        f'{b["lower"]}-{b["upper"]} {unit}: {n}' for b, n in zip(bins, counts))


def rationale(counts, expected, bins):
    if counts == expected:
        return ('Each bar matches the number of supplied observations in its interval. '
                'The frequencies total 12, and every observation is counted once.')
    donor = next(i for i, (n, e) in enumerate(zip(counts, expected)) if n < e)
    recipient = next(i for i, (n, e) in enumerate(zip(counts, expected)) if n > e)
    a, b = bins[donor], bins[recipient]
    return (f'Bin-count error: the {a["lower"]}-{a["upper"]} bar has {counts[donor]} '
            f'instead of {expected[donor]}, while the {b["lower"]}-{b["upper"]} bar '
            f'has {counts[recipient]} instead of {expected[recipient]}. '
            'A correct total alone does not make the individual bars accurate. '
            'Fix: Tally each observation into its interval before comparing bar heights.')


def build():
    inventory = json.loads(SOURCE.read_text())
    sources = sorted((r for r in inventory if r['content_key'].startswith('apstat-u1-5-3a-graphs-')),
                     key=lambda r: r['content_key'])
    assert len(sources) == 20
    items = []
    for source in sources:
        match = re.fullmatch(r'The (.*?) \((.*?)\) are (.*?)\. Which representation correctly displays these quantitative data\?', source['stem'])
        assert match, source['content_key']
        variable, unit, numbers = match.groups()
        values = [int(n) for n in numbers.split(', ')]
        old_histograms = [c for c in source['choices'] if c['text'].startswith('Histogram with counts ')]
        assert len(values) == 12 and len(old_histograms) == 2
        bins = histogram(old_histograms[0]['text'])
        assert all([(b['lower'], b['upper']) for b in histogram(c['text'])] ==
                   [(b['lower'], b['upper']) for b in bins] for c in old_histograms)
        expected = [sum(b['lower'] <= n <= b['upper'] for n in values) for b in bins]
        used = {tuple(b['count'] for b in histogram(c['text'])) for c in old_histograms}
        assert tuple(expected) in used and len(used) == 2
        old_correct = next(c['key'] for c in old_histograms
                           if [b['count'] for b in histogram(c['text'])] == expected)
        # Choose adjacent-bin, one-observation errors. Prefer a real observation
        # near the crossed boundary; record the proposed error explicitly.
        candidates = []
        for donor, b in enumerate(bins):
            observations = [n for n in values if b['lower'] <= n <= b['upper']]
            if not observations:
                continue
            for recipient in [donor - 1, donor + 1]:
                if not 0 <= recipient < len(bins):
                    continue
                boundary = b['lower'] if recipient < donor else b['upper'] + 1
                observation = min(observations, key=lambda n: (abs(n - boundary), n))
                counts = expected.copy()
                counts[donor] -= 1
                counts[recipient] += 1
                candidates.append((abs(observation - boundary), donor, recipient, observation, counts))
        candidates.sort(key=lambda c: c[:4])
        choices = []
        replacements = []
        for old in source['choices']:
            if old['text'].startswith('Histogram with counts '):
                counts = [b['count'] for b in histogram(old['text'])]
                text = old['text']
                change = 'retained_histogram'
                mutation = None
            else:
                candidate = next(c for c in candidates if tuple(c[4]) not in used)
                _, donor, recipient, observation, counts = candidate
                used.add(tuple(counts))
                text = description(bins, counts, unit)
                change = ('replaced_categorical_bar' if old['text'].startswith('Bar chart')
                          else 'replaced_keyless_stemplot')
                assert change != 'replaced_keyless_stemplot' or old['text'].startswith('Stemplot ')
                mutation = {'donor_bin_index': donor, 'recipient_bin_index': recipient,
                            'misplaced_observation': observation, 'count_shift': 1,
                            'meaning': 'Proposed distractor error; the source observations do not change.'}
                replacements.append({'choice_key': old['key'], 'change': change,
                                     'old_text': old['text'], 'new_text': text})
            choices.append({'key': old['key'], 'kind': 'histogram', 'counts': counts,
                            'choice_text': text, 'alt_text': f'Choice {old["key"]}. ' + text,
                            'long_description': 'Numeric horizontal axis with contiguous equal-width bins. ' + text + '.',
                            'change': change, 'proposed_error': mutation,
                            'is_correct': counts == expected,
                            'rationale': rationale(counts, expected, bins)})
        assert len(replacements) == 2 and sum(c['is_correct'] for c in choices) == 1
        assert next(c['key'] for c in choices if c['is_correct']) == old_correct
        assert len({tuple(c['counts']) for c in choices}) == 4
        items.append({
            'content_key': source['content_key'],
            'source_content_item_version_id': source['content_item_version_id'],
            'source_audit_content_digest': source['audit_content_digest'],
            'source_stem_sha256': sha256(source['stem'].encode()).hexdigest(),
            'source_choices_sha256': sha256(json.dumps(source['choices'], sort_keys=True, ensure_ascii=False, separators=(',', ':')).encode()).hexdigest(),
            'stem': source['stem'], 'variable': variable, 'unit': unit, 'observations': values,
            'bins': [{'lower': b['lower'], 'upper': b['upper'],
                      'left_edge': b['lower'], 'right_edge_exclusive': b['upper'] + 1} for b in bins],
            'expected_counts': expected, 'derived_answer_key': old_correct,
            'stored_key_comparison': 'Not in frozen source inventory; compare the live stored key and scoring on release.',
            'proposed_version_policy': 'New content_item_versions revision; never mutate the published source version in place.',
            'choice_order': [c['key'] for c in source['choices']],
            'y_axis_max': ((max(max(c['counts']) for c in choices) + 1) // 2) * 2,
            'choices': choices, 'replacements': replacements,
            'sheet_alt_text': 'Four histogram answer choices A through D; all use the same axes. No option is marked correct.',
            'sheet_long_description': '\n'.join(c['alt_text'] for c in choices),
        })
    result = {
        'date': '2026-10-17',
        'status': 'All 20 choice specifications resolved and built locally; independent content QA and release remain open.',
        'authorization': 'David: Resolve the 20 graphical choice questions. Existing-content repair draft and review artifacts; no Production publication inferred.',
        'source_commit': SOURCE_COMMIT,
        'source_inventory_sha256': sha256(SOURCE.read_bytes()).hexdigest(),
        'method': 'Retain both historical histogram options and all source stems/data. Replace the two ambiguous non-histogram distractors with distinct, explicit adjacent-bin count errors. All four displays use identical axes and styling.',
        'new_mcq_generation': False, 'live_changes': False, 'independent_qa': False,
        'publish_gates': ['Current source/key/scoring comparison', 'Existing-content independent QA per CONTENT_AUTHORING_AND_QA_PROTOCOL sections 4, 5 and 9', 'New-version content/rationale review', 'Scoped live release authority and guarded recovery', 'Authenticated desktop/phone student delivery verification'],
        'items': items,
    }
    (HERE / 'specs.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'items': len(items), 'choices': sum(len(i['choices']) for i in items),
                      'retained_histogram_choices': 40, 'replaced_choices': 40,
                      'derived_answer_positions': dict(Counter(i['derived_answer_key'] for i in items))}, indent=2))


if __name__ == '__main__':
    build()
