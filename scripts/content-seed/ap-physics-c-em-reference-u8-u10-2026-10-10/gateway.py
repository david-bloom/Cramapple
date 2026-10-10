"""Minimal Vercel AI Gateway chat client for the TASK-0067 pilot. Reads the key from the gitignored
scripts/vercel-gateway-check/.env.local in Python (never sourced in a shell). Every call is logged as
one JSONL line under out/<stage>/ with usage, so cost.py-style accounting is possible."""
import json, os, sys, time, urllib.request, urllib.error, pathlib, hashlib

ROOT = pathlib.Path(__file__).resolve().parents[3]
ENV = ROOT / "scripts" / "vercel-gateway-check" / ".env.local"
URL = "https://ai-gateway.vercel.sh/v1/chat/completions"


def _key():
    for line in ENV.read_text().splitlines():
        line = line.strip()
        if line.startswith("AI_GATEWAY_API_KEY="):
            return line.split("=", 1)[1].strip().strip('"').strip("'")
    raise SystemExit("AI_GATEWAY_API_KEY not found in scripts/vercel-gateway-check/.env.local")


def chat_json(model, system, user, log_dir, tag, max_tokens=8000, temperature=0.2, retries=3):
    """Returns (parsed_json, raw_text). Asks for a JSON object; falls back to brace-slicing."""
    key = _key()
    body = {
        "model": model,
        "messages": [{"role": "system", "content": system}, {"role": "user", "content": user}],
        "temperature": temperature,
        "max_tokens": max_tokens,
        "response_format": {"type": "json_object"},
    }
    log_dir = pathlib.Path(log_dir); log_dir.mkdir(parents=True, exist_ok=True)
    last_err = None
    for attempt in range(1, retries + 1):
        t0 = time.time()
        try:
            req = urllib.request.Request(URL, data=json.dumps(body).encode(), method="POST",
                                         headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=600) as r:
                resp = json.load(r)
            text = resp["choices"][0]["message"]["content"] or ""
            usage = resp.get("usage", {})
            parsed = None
            try:
                parsed = json.loads(text)
            except Exception:
                i, j = text.find("{"), text.rfind("}")
                if i >= 0 and j > i:
                    try:
                        parsed = json.loads(text[i:j + 1])
                    except Exception:
                        parsed = None
            rec = {"tag": tag, "model": model, "attempt": attempt, "ok": parsed is not None,
                   "seconds": round(time.time() - t0, 1), "usage": usage,
                   "prompt_sha": hashlib.sha256((system + user).encode()).hexdigest()[:12]}
            with open(log_dir / f"{model.replace('/', '_')}.jsonl", "a") as f:
                f.write(json.dumps(rec) + "\n")
            if parsed is None:
                last_err = f"non-JSON output ({len(text)} chars)"
                continue
            return parsed, text
        except urllib.error.HTTPError as e:
            last_err = f"HTTP {e.code}: {e.read()[:300]!r}"
        except Exception as e:  # network, timeout
            last_err = repr(e)
        time.sleep(3 * attempt)
    raise RuntimeError(f"{model} {tag}: {last_err}")


def ced_pages(subject, first, last):
    """Pages [first, last] (1-indexed, form-feed separated) of the pdftotext dump in the scratchpad."""
    scratch = os.environ.get("CED_TXT_DIR")
    if not scratch:
        raise SystemExit("set CED_TXT_DIR to the directory holding <subject>.txt (pdftotext -layout output)")
    pages = pathlib.Path(scratch, f"{subject}.txt").read_text().split("\f")
    return "\n".join(pages[first - 1:last])
