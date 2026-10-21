"""Run only against a disposable local/CI task0078_fixture database."""
import argparse
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--psql', default='psql')
parser.add_argument('--host', default='127.0.0.1')
parser.add_argument('--port', default='5432')
parser.add_argument('--user', default='postgres')
args = parser.parse_args()
if args.host not in ('127.0.0.1', 'localhost', '/private/tmp/task0078-pg-socket'):
    parser.error('only the disposable local/CI host is allowed')
base = [args.psql, '-X', '-v', 'ON_ERROR_STOP=1', '-h', args.host,
        '-p', args.port, '-U', args.user, '-d', 'task0078_fixture']
fixture = Path(__file__).with_name('replay_sql_test.sql')
subprocess.run(base + ['-f', str(fixture)], check=True, capture_output=True, text=True)
query = "set role service_role; select app.claim_operation_replay('racer','race-key','race-hash','session_start')->>'kind';"
def claim(_):
    result = subprocess.run(base + ['-At', '-c', query], check=True, capture_output=True, text=True)
    return result.stdout.strip().splitlines()[-1]
with ThreadPoolExecutor(max_workers=8) as pool:
    outcomes = list(pool.map(claim, range(8)))
if outcomes.count('claimed') != 1 or outcomes.count('pending') != 7:
    raise AssertionError(outcomes)
print('PASS: SQL replay/privilege/failure scenarios; 8 concurrent claimants: 1 claimed, 7 pending')
