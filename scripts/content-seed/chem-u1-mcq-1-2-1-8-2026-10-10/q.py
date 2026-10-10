"""Read-only helper: run one SQL statement (inline or from a .sql file) on dev or prod via the Management API."""
import sys, json, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
import publish_mcq_batch as P
env = sys.argv[1]
sql = open(sys.argv[2]).read() if sys.argv[2].endswith('.sql') else sys.argv[2]
print(f'-- env {env} ref {P.ENVS[env]}')
print(json.dumps(P.query(P.ENVS[env], sql), indent=1, ensure_ascii=False))
