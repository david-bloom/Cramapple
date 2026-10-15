"""Run-level gates: complete verdicts, six controls, separate correct-entry/bad-hook detection."""
import json,pathlib,hashlib

def digest(path): return hashlib.sha256(pathlib.Path(path).read_bytes()).hexdigest()

def validate(candidates, controls, results, checkers, veto):
    if len(checkers)!=2 or len({x.split('/')[0] for x in checkers})!=2:
        raise ValueError('Two distinct checker families required')
    if len(controls)!=6 or len({c['candidate_id'] for c in controls})!=6:
        raise ValueError('Exactly six distinct controls required')
    targets=candidates+controls
    ids=[c['candidate_id'] for c in targets]
    if len(ids)!=len(set(ids)):raise ValueError('Duplicate candidate/control IDs')
    ri=[r['candidate_id'] for r in results]
    if len(ri)!=len(set(ri)) or set(ri)!=set(ids):raise ValueError('Incomplete, extra or duplicate verdicts')
    byid={r['candidate_id']:r for r in results}
    for c in targets:
        r=byid[c['candidate_id']]
        if set(r.get('checkers',{}))!=set(checkers):raise ValueError('Missing checker verdict')
        for v in r['checkers'].values():
            if not v.get('samples') or type(v.get('accept')) is not bool:raise ValueError('Malformed checker verdict')
        both=all(r['checkers'][m]['accept'] for m in checkers)
        if both and (not r.get('veto') or not r['veto'].get('samples')):raise ValueError('Missing veto verdict')
        expected=both and r['veto']['accept'] if both else False
        if r.get('accepted') is not expected:raise ValueError('Inconsistent acceptance')
        if c.get('control'):
            if c.get('control_target')=='hook':
                expected_hooks={h['hook_text'] for h in c.get('hooks',[])}
                if not expected_hooks or not r['accepted'] or expected_hooks!=set(r.get('hooks_accepted',{})) or any(r['hooks_accepted'].values()):
                    raise ValueError('Hook control must retain correct entry and reject every planted hook')
            elif r['accepted']:raise ValueError('Control leaked')
    return True

def write_receipt(path,candidates,controls,verdicts,checkers,veto):
    validate(json.loads(pathlib.Path(candidates).read_text()),json.loads(pathlib.Path(controls).read_text()),json.loads(pathlib.Path(verdicts).read_text()),checkers,veto)
    receipt={'version':1,'files':{str(pathlib.Path(p).resolve()):digest(p) for p in [candidates,controls,verdicts]},'checkers':checkers,'veto':veto,'complete':True,'controls_passed':6}
    pathlib.Path(path).write_text(json.dumps(receipt,indent=2)+'\n')

def verify_receipt(path):
    r=json.loads(pathlib.Path(path).read_text())
    if r.get('complete') is not True or r.get('controls_passed')!=6:raise ValueError('No complete six-control gate')
    for p,sha in r['files'].items():
        if digest(p)!=sha:raise ValueError('Gate receipt stale: '+p)
    return r
