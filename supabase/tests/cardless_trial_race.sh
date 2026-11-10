#!/usr/bin/env bash
# Two-connection race against app.trial_grading_gate (spec §15.1 item 3). Development ONLY.
# Requires: a Supabase access token in ~/.supabase/access-token, a committed fixture user with a live
# trial_v2 row and app.config.trial_daily_grading_cap = 1 (see the spec for the fixture SQL), and the
# fixture user's uuid as $1. Prints both connections' timings; B must show waited_ms of several
# thousand and the verdict grading_access:trial_daily_cap. Delete the fixture and reset the cap afterwards.
set -euo pipefail
REF="${REF:-wmgjsdkphcyhngaffbqf}"   # Development; never point this at Production
U="${1:?fixture user uuid}"
TOK=$(cat ~/.supabase/access-token)
URL="https://api.supabase.com/v1/projects/$REF/database/query"
q(){ curl -s -X POST "$URL" -H "Authorization: Bearer $TOK" -H "Content-Type: application/json" -d "$1"; echo; }
QA="with a as (select clock_timestamp() t0, app.trial_grading_gate('$U', (select id from app.subjects where subject_key='biology'), 'grade_initial_attempt', 'race-A') verdict), s as (select pg_sleep(8) from a) select 'A' conn, a.t0 gate_start, a.verdict, clock_timestamp() commit_at, pg_backend_pid() pid from a, s;"
QB="do \$\$ declare t0 timestamptz; t1 timestamptz; v text; v_bio uuid := (select id from app.subjects where subject_key='biology'); begin perform pg_sleep(3); t0 := clock_timestamp(); begin v := app.trial_grading_gate('$U', v_bio, 'grade_initial_attempt', 'race-B'); exception when others then v := 'ERROR ' || sqlerrm; end; t1 := clock_timestamp(); raise exception 'B: verdict=% gate_started=% gate_returned=% waited_ms=% pid=%', v, t0, t1, round(extract(epoch from (t1 - t0)) * 1000), pg_backend_pid(); end \$\$;"
PA=$(python3 -c 'import json,sys; print(json.dumps({"query":sys.argv[1]}))' "$QA")
PB=$(python3 -c 'import json,sys; print(json.dumps({"query":sys.argv[1]}))' "$QB")
q "$PA" > /tmp/race_A.out & sleep 0.5; q "$PB" > /tmp/race_B.out & wait
echo "A:"; cat /tmp/race_A.out; echo "B:"; cat /tmp/race_B.out
