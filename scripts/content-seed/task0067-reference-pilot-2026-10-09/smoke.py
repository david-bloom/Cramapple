"""Protocol §3.2 rule 4: a checker never used on this pipeline must pass a structured-output smoke test
(3 items, one with a table/piecewise definition) before its verdicts count. Also smoke-tests the extractor."""
import json, pathlib
import sys as _sys, pathlib as _pl; _sys.path.insert(0, str(_pl.Path(__file__).resolve().parent))
from gateway import chat_json
HERE = pathlib.Path(__file__).resolve().parent
ITEMS = [
    ("plain", 'Return {"ok": true, "sum": 2+3}'),
    ("table", 'Given this table:\n| x | f(x) |\n|---|---|\n| 1 | 4 |\n| 2 | 7 |\nReturn {"ok": true, "slope": (f(2)-f(1))/(2-1), "piecewise": "f(x)=x^2 if x<0 else 3x"}'),
    ("latex", 'Return {"ok": true, "latex": "s=\\\\sqrt{\\\\frac{1}{n-1}\\\\sum (x_i-\\\\bar{x})^2}"}'),
]
for model in ["anthropic/claude-sonnet-5.5", "google/gemini-3.5-flash", "openai/gpt-6-sol", "anthropic/claude-opus-5.5"]:
    good = 0
    for tag, prompt in ITEMS:
        try:
            p, _ = chat_json(model, "Return only the JSON object requested.", prompt, HERE / "out" / "logs_smoke", f"smoke:{tag}", max_tokens=400)
            good += int(bool(p.get("ok")))
        except Exception as e:
            print(f"  {model} {tag}: {str(e)[:120]}")
    print(f"{model}: {good}/3 structured-output ok")
