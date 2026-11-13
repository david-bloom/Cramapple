"""Build the exact TASK-0050 Statistics 14-item Production release SQL."""

import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
PHASE = HERE.parent / 'task0050-stats-phase-b-2026-11-11'

preflight = (HERE / 'preflight.sql').read_text()
expected = {
    key: (version_id, content_hash)
    for key, version_id, content_hash in re.findall(
        r"\('([^']+)','([0-9a-f-]+)'::uuid,'([0-9a-f]+)'\)", preflight
    )
}
drafts = {
    d['content_key']: d
    for d in json.loads((PHASE / 'review14_draft_successors.json').read_text())
}
working = {
    d['content_key']: d
    for d in json.loads((HERE / 'working_labels.json').read_text())
}
vote_file = json.loads((HERE / 'skill_decisions.json').read_text())
votes = {
    d['content_key']: d
    for d in vote_file['results'] + vote_file['deterministic']
}
assert len(expected) == len(working) == len(votes) == 14
assert len(drafts) == 12
assert set(expected) == set(working) == set(votes)
assert all(d['outcome'] == 'validated' for d in votes.values())

payload = []
for key in sorted(expected):
    version_id, content_hash = expected[key]
    draft = drafts.get(key)
    vote = votes[key]
    work = working[key]
    assert work['source_version_id'] == version_id
    assert work['proposed_topic'] == vote['topic_code']
    assert vote['skill_code'] in work['registered_skills']
    if draft:
        assert draft['source_version_id'] == version_id
        assert draft['source_content_hash'] == content_hash
    unit = int(vote['topic_code'].split('.')[0])
    difficulty = (
        'Hard' if key in {'APSTATS-HDG-2026-GRAPH-024', 'APSTATS-HDG-2026-GRAPH-026'}
        else 'Medium' if key.startswith('APSTATS-HDG-')
        else 'Hard' if key in {'APSTATS-MCQ-002-CAL', 'APSTATS-MCQ-010', 'APSTATS-MCQ-012'}
        else 'Medium'
    )
    payload.append({
        'content_key': key,
        'source_version_id': version_id,
        'source_content_hash': content_hash,
        'topic_code': vote['topic_code'],
        'skill_code': vote['skill_code'],
        'agreement': vote.get('agreement') or 'deterministic_single_candidate',
        'required_units': [1, 3] if key == 'APSTATS-MCQ-012' else [unit],
        'primary_unit': unit,
        'difficulty': difficulty,
        'proposed_content': draft['proposed_content'] if draft else None,
    })

serialized = json.dumps(payload, ensure_ascii=False, separators=(',', ':'))
delimiter = '$task0050_payload$'
assert delimiter not in serialized
template = (HERE / 'release_template.sql').read_text()
assert template.count('__PAYLOAD__') == 1
assert template.rstrip().endswith('commit;')
sql = template.replace('__PAYLOAD__', delimiter + serialized + delimiter)
(HERE / 'release_commit.sql').write_text(sql)
Path('/private/tmp/task0050-publish14-release-rehearsal.sql').write_text(
    sql.rsplit('commit;', 1)[0] + 'rollback;\n'
)
print(f'{len(payload)} guarded release targets; {len(drafts)} revised, 2 copied; '
      f'vote={vote_file["run_id"]}; SQL bytes={len(sql.encode())}')
