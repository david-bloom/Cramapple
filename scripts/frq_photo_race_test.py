#!/usr/bin/env python3
"""Deterministic two-connection race test for photographed FRQ submission
(TASK-0069, remediation of Codex QA P1-b).

Two real database sessions, forced into both orderings with pg_sleep:

  Ordering 1 -- the retake holds the attempt lock first:
    session A: BEGIN; lock attempt; sleep; bind photo B (retake of A); COMMIT
    session B: submit_response (started while A holds the lock)
    expected:  B blocks until A commits, then the submission guard sees photo B,
               whose digest does not match the confirmation -> refused with
               transcript_confirmation_required.

  Ordering 2 -- the submit holds the lock first:
    session B: BEGIN; submit_response; sleep; COMMIT
    session A: bind photo B (started while B holds the lock)
    expected:  A blocks until B commits, then the bind's writable guard refuses
               (the response is submitted); the graded photo is A, as confirmed.

Each ordering builds and commits its own fixture (attempt, response version,
photo A, confirmation of A) for the newest Development smoke student. Rows are
left in Development, owned by that smoke student. Development only.

Usage (repo root linked to Development):
  python3 -I scripts/frq_photo_race_test.py /path/to/linked/repo/root
"""
import json
import subprocess
import sys
import threading
import time
import uuid

WORKDIR = sys.argv[1] if len(sys.argv) > 1 else "."
SLEEP_S = 6
LAUNCH_GAP_S = 2


def run_sql(sql: str):
    """Runs one SQL batch through the Supabase CLI (Management API). Returns (ok, text, seconds)."""
    t0 = time.time()
    proc = subprocess.run(
        ["supabase", "db", "query", "--linked", "--workdir", WORKDIR, "-o", "json", sql],
        capture_output=True, text=True, timeout=120,
    )
    out = (proc.stdout or "") + (proc.stderr or "")
    ok = proc.returncode == 0 and "Failed to run sql query" not in out
    return ok, out, time.time() - t0


def rows(text: str):
    """Parses the CLI's JSON object out of combined stdout/stderr text."""
    start = text.find("{")
    if start < 0:
        return []
    try:
        obj, _ = json.JSONDecoder().raw_decode(text[start:])
        return obj.get("rows", []) if isinstance(obj, dict) else []
    except Exception:
        return []


def fixture() -> dict:
    tag = uuid.uuid4().hex[:8]
    sql = f"""
    with s as (
      select ls.user_id, ls.id as session_id, ls.exam_pack_version_id as pack
        from app.learning_sessions ls join auth.users u on u.id = ls.user_id
       where u.email like 'smoke+frqphoto-student-%'
         and exists (select 1 from app.content_items ci join app.content_item_versions civ
                       on civ.content_item_id = ci.id and civ.status = 'published'
                      where ci.exam_pack_version_id = ls.exam_pack_version_id and ci.item_type = 'frq'
                        and ci.status = 'published' and ci.response_policy = 'photo_allowed')
       order by ls.created_at desc limit 1
    ), item as (
      select civ.id as civ from app.content_items ci join app.content_item_versions civ
        on civ.content_item_id = ci.id and civ.status = 'published', s
       where ci.exam_pack_version_id = s.pack and ci.item_type = 'frq' and ci.status = 'published'
         and ci.response_policy = 'photo_allowed'
       order by ci.content_key limit 1
    )
    select s.user_id, s.session_id, s.pack, item.civ from s, item;
    """
    ok, out, _ = run_sql(sql)
    r = rows(out)
    if not ok or not r:
        raise SystemExit(f"SKIP: no smoke student fixture ({out[-300:]})")
    user, session, pack, civ = r[0]["user_id"], r[0]["session_id"], r[0]["pack"], r[0]["civ"]
    setup = f"""
    begin;
    set local role service_role;
    with a as (
      insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode, status, assistance_state)
      values ('{user}', '{session}', '{pack}', '{civ}', 'frq', 'draft', 'independent') returning id
    )
    insert into app.response_versions (attempt_id, response_parts, version_number, is_submitted, created_by)
    select a.id, '{{"capture":"pending"}}'::jsonb, 1, false, '{user}' from a;
    commit;
    select rv.id as rv, rv.attempt_id as attempt from app.response_versions rv
      join app.attempts a on a.id = rv.attempt_id
     where a.user_id = '{user}' and a.content_item_version_id = '{civ}' and rv.response_parts ? 'capture'
     order by rv.created_at desc limit 1;
    """
    ok, out, _ = run_sql(setup)
    r = rows(out)
    if not ok or not r:
        raise SystemExit(f"setup failed: {out[-400:]}")
    rv, attempt = r[0]["rv"], r[0]["attempt"]
    bind_a = f"""
    begin;
    set local role service_role;
    select (app.bind_response_attachment('{rv}', '{attempt}', '{civ}', 'original', null,
      '{user}/race/{tag}-a.png', 'image/png', 2048, 800, 600, repeat('a', 64), '{user}')).id as id;
    select (app.confirm_response_transcript('{attempt}', '{rv}', '{user}', '{{"response":"answer A"}}'::jsonb,
      'answer A', '{{}}'::jsonb, repeat('a', 64), now())).id;
    commit;
    select id from app.response_attachments where response_version_id = '{rv}' and is_current and kind = 'original';
    """
    ok, out, _ = run_sql(bind_a)
    r = rows(out)
    if not ok or not r:
        raise SystemExit(f"bind/confirm A failed: {out[-400:]}")
    return {"user": user, "civ": civ, "rv": rv, "attempt": attempt, "att_a": r[0]["id"], "tag": tag}


def bind_b_sql(f, locked_first: bool) -> str:
    lock = f"select 1 from app.attempts where id = '{f['attempt']}' for update; select pg_sleep({SLEEP_S});" if locked_first else ""
    return f"""
    begin;
    set local role service_role;
    {lock}
    select (app.bind_response_attachment('{f['rv']}', '{f['attempt']}', '{f['civ']}', 'original', '{f['att_a']}',
      '{f['user']}/race/{f['tag']}-b.png', 'image/png', 2048, 800, 600, repeat('b', 64), '{f['user']}')).id;
    commit;
    """


def submit_sql(f, hold: bool) -> str:
    key = "race-" + uuid.uuid4().hex
    tail = f"select pg_sleep({SLEEP_S});" if hold else ""
    return f"""
    begin;
    select app.submit_response('{f['attempt']}', '{f['rv']}', '{f['user']}', 'student', '{key}', 'race');
    {tail}
    commit;
    """


def race(first_sql: str, second_sql: str):
    results = {}

    def go(name, sql):
        results[name] = run_sql(sql)

    t1 = threading.Thread(target=go, args=("first", first_sql))
    t1.start()
    time.sleep(LAUNCH_GAP_S)
    t2 = threading.Thread(target=go, args=("second", second_sql))
    t2.start()
    t1.join()
    t2.join()
    return results["first"], results["second"]


def main():
    failures = 0

    def check(label, ok, detail=""):
        nonlocal failures
        print(("PASS  " if ok else "FAIL  ") + label + ("" if ok else f"\n      {detail[-500:]}"))
        if not ok:
            failures += 1

    # Ordering 1: retake holds the lock; submit waits and must be refused.
    f1 = fixture()
    (a_ok, a_out, a_s), (b_ok, b_out, b_s) = race(bind_b_sql(f1, locked_first=True), submit_sql(f1, hold=False))
    check("ordering 1: the retake commits", a_ok, a_out)
    check("ordering 1: the submit waited for the retake's lock", b_s >= SLEEP_S - LAUNCH_GAP_S - 1, f"submit took {b_s:.1f}s")
    check("ordering 1: the submit is refused (stale confirmation)", (not b_ok) and "transcript_confirmation_required" in b_out, b_out)

    # Ordering 2: submit holds the lock; the retake waits and must be refused.
    f2 = fixture()
    (s_ok, s_out, s_s), (r_ok, r_out, r_s) = race(submit_sql(f2, hold=True), bind_b_sql(f2, locked_first=False))
    check("ordering 2: the submit commits (photo A was confirmed)", s_ok, s_out)
    check("ordering 2: the retake waited for the submit's lock", r_s >= SLEEP_S - LAUNCH_GAP_S - 1, f"retake took {r_s:.1f}s")
    check("ordering 2: the retake is refused after submission", (not r_ok) and ("submitted" in r_out or "not_writable" in r_out or "attach_capture" in r_out), r_out)

    ok, out, _ = run_sql(f"select count(*) as n from app.response_attachments where response_version_id = '{f2['rv']}' and is_current and kind = 'original' and sha256_digest = repeat('a', 64)")
    check("ordering 2: the graded photo is still A", ok and rows(out) and int(rows(out)[0]["n"]) == 1, out)

    print("\nALL RACE CHECKS PASSED" if failures == 0 else f"\n{failures} RACE CHECK(S) FAILED")
    sys.exit(0 if failures == 0 else 1)


if __name__ == "__main__":
    main()
