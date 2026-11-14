#!/usr/bin/env python3
"""Retire apcalcbc-mcq-007 (Newton's method, outside the CED). One rehearsable transaction. Production only.
  python3 -I retire_apcalcbc_mcq_007.py rehearse | publish --approval APPROVAL-NNNN --confirm-production | verify"""
import importlib.util, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py')); pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']; assert REF == 'pcntajvbdfqhbeewmdry'
ITEM = 'b23f4776-2483-4a24-bf8b-a8dac6381775'; KEY = 'apcalcbc-mcq-007'
def sql(mode):
    body = f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-retire-{KEY}-2026-11-14'));
create temporary table old on commit drop as select ci.id item_id, v.id version_id from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id and v.status='published' where ci.id='{ITEM}' and ci.content_key='{KEY}' and ci.status='published';
do $g$ declare n int; begin
 select count(*) into n from old; if n<>1 then raise exception 'expected 1 published item/version, got %', n; end if;
 select count(*) into n from app.content_item_versions where content_item_id='{ITEM}'; if n<>1 then raise exception 'item has % versions', n; end if;
 select count(*) into n from app.content_taxonomy_labels where content_item_id='{ITEM}' and label_scope='serving' and superseded_by is null and label_status='validated'; if n<>0 then raise exception 'item has a validated serving label'; end if;
end $g$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $g$ declare n int; begin
 select count(*) into n from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id where ci.id='{ITEM}' and ci.status='retired' and v.status='retired'; if n<>1 then raise exception 'retire post-check %', n; end if;
end $g$;
"""
    return body + ("set constraints all immediate;\ndo $g$ begin raise exception 'REHEARSAL OK: retire %'; end $g$;\nrollback;\n".replace('%', KEY) if mode == 'rehearse' else "commit;\n")
def verify():
    r = pmb.query(REF, f"select ci.status ist, v.status vs from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id where ci.id='{ITEM}'")
    ok = len(r) == 1 and r[0]['ist'] == 'retired' and r[0]['vs'] == 'retired'; print('verify', KEY, r, 'MATCH' if ok else 'MISMATCH'); return ok
cmd = sys.argv[1]
if cmd == 'rehearse':
    msg = pmb.query(REF, sql('rehearse'), expect_error=True); print(msg[msg.index('REHEARSAL OK'):].splitlines()[0] if 'REHEARSAL OK' in msg else 'FAILED ' + msg[:800])
elif cmd == 'verify': sys.exit(0 if verify() else 1)
elif cmd == 'publish':
    a = sys.argv
    if '--confirm-production' not in a or not any(x.startswith('APPROVAL-') for x in a): sys.exit('needs --approval APPROVAL-NNNN and --confirm-production')
    msg = pmb.query(REF, sql('rehearse'), expect_error=True)
    if 'REHEARSAL OK' not in msg: sys.exit('pre-commit rehearsal FAILED: ' + msg[:800])
    pmb.query(REF, sql('commit')); print('COMMITTED'); sys.exit(0 if verify() else 1)
