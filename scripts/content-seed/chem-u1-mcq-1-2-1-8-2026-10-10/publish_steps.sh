#!/bin/bash
# Production publish steps for the 9 AP Chemistry 1.2/1.8 practice MCQs (apchem-mcq-080..084 + 4 variants).
# NOT run by the generating session. Run step by step; record the Hard-Gate APPROVAL entry before step 3.
#   usage: publish_steps.sh <preflight|rehearse|publish APPROVAL-NNNN|verify>
set -e
cd "$(dirname "$0")/.."
PLAN=chem-u1-mcq-1-2-1-8-2026-10-10/plan_publish.json
case "$1" in
  preflight) python3 publish_mcq_batch.py preflight --plan $PLAN --env prod ;;   # expect: chunk 1 (9 items): absent
  rehearse)  python3 publish_mcq_batch.py rehearse  --plan $PLAN --env prod ;;   # expect: REHEARSAL OK: published=9 skill_cells=9 (rolled back)
  publish)   python3 publish_mcq_batch.py publish   --plan $PLAN --env prod --approval "$2" --confirm-production ;;  # rehearses, commits, verifies
  verify)    python3 publish_mcq_batch.py verify    --plan $PLAN --env prod
             python3 chem-u1-mcq-1-2-1-8-2026-10-10/q.py prod chem-u1-mcq-1-2-1-8-2026-10-10/sql/verify_serving_prod.sql ;;
             # expect: served_new 9, teaching_served 0, practice_by_topic {"1.2": 5, "1.8": 4}
  *) echo "usage: $0 preflight|rehearse|publish APPROVAL-NNNN|verify"; exit 2 ;;
esac
