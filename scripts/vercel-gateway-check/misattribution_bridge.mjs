import { spawn } from 'node:child_process';
import path from 'node:path';
import readline from 'node:readline';

// Persistent worker bridge to scripts/misattribution-check/checker.py.
// Spawns the Python process once (paying spaCy's model-load cost a single
// time, not per check) and communicates over stdin/stdout using one JSON
// object per line in each direction. Requests are matched to responses by
// FIFO order: Node is single-threaded, so as long as we don't await between
// encoding a request and writing it to stdin, writes happen in the order
// callers invoked check(), and checker.py answers in the order it receives
// lines - a simple pending-queue shift on each stdout line is correct even
// under concurrent callers.

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const CHECKER_DIR = path.join(ROOT, 'scripts', 'misattribution-check');
const PYTHON_BIN = path.join(CHECKER_DIR, '.venv', 'bin', 'python3');
const CHECKER_SCRIPT = path.join(CHECKER_DIR, 'checker.py');

let proc = null;
let rl = null;
let pending = [];
let startupError = null;

function ensureStarted() {
  if (proc) return;
  proc = spawn(PYTHON_BIN, [CHECKER_SCRIPT], { cwd: CHECKER_DIR, stdio: ['pipe', 'pipe', 'pipe'] });
  rl = readline.createInterface({ input: proc.stdout });
  rl.on('line', (line) => {
    const resolve = pending.shift();
    if (!resolve) return;
    try {
      resolve({ ok: true, result: JSON.parse(line) });
    } catch (err) {
      resolve({ ok: false, error: `parse error: ${err.message}` });
    }
  });
  proc.stderr.on('data', (chunk) => {
    startupError = chunk.toString();
  });
  proc.on('exit', (code) => {
    if (code !== 0 && pending.length) {
      const err = startupError || `misattribution checker exited with code ${code}`;
      while (pending.length) pending.shift()({ ok: false, error: err });
    }
    proc = null;
  });
}

export async function checkMisattribution(responseId, answerText) {
  ensureStarted();
  return new Promise((resolve) => {
    pending.push(resolve);
    proc.stdin.write(`${JSON.stringify({ response_id: responseId, answer_text: answerText })}\n`);
  });
}

export function shutdownMisattributionChecker() {
  if (proc) {
    proc.stdin.end();
    proc = null;
  }
}
