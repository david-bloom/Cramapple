"""Small multimodal reviewer bake-off: two inexpensive models, nine fixed cases, no production writes."""

from __future__ import annotations

import base64
import hashlib
import json
import pathlib
import time
import urllib.error
import urllib.request


HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parents[2]
ENV = ROOT / "scripts" / "vercel-gateway-check" / ".env.local"
URL = "https://ai-gateway.vercel.sh/v1/chat/completions"
MODELS = ["google/gemini-3.5-flash", "anthropic/claude-haiku-5.5"]

EXPECTED = {
    "T1": "approve",
    "T2": "reject",
    "T3": "approve",
    "T4": "reject",
    "T5": "approve",
    "T6": "reject",
    "I1": "approve",
    "I2": "reject",
    "I3": "reject",
}

CED_EXCERPT = """AP Chemistry CED Unit 4 excerpts:
- 4.1.A.1: A physical change changes properties but not composition. Phase changes and mixture formation/separation are common physical changes.
- 4.1.A.2: A chemical change transforms substances into new substances, typically with different compositions. Heat/light, gas formation, precipitate formation, and/or color change provide possible evidence.
- 4.2.A.1-.3: Physical and chemical processes can be represented by balanced equations. Representations of chemical change contain equal numbers of every atom before and after; mass and charge are conserved. Molecular, complete ionic, and net ionic equations are different symbolic forms selected by context.
- 4.3.A.1: Balanced equations in their various forms can be translated into consistent symbolic particulate representations.
- 4.5.A.1-.2: Atoms are conserved; balanced-equation coefficients provide proportional amount information for stoichiometric calculations.
- 4.6.A.1: Equivalence occurs when analyte is totally consumed by the reacting titrant species. An observable property change that indicates equivalence is the endpoint.
- 4.7.A.3 exclusion: The meanings of “reducing agent” and “oxidizing agent” will not be assessed on the AP Exam.
"""

TEXT_CASES = [
    {
        "id": "T1",
        "claim": "A physical change changes a substance's properties without changing its composition; phase changes and mixture formation or separation are common examples.",
    },
    {
        "id": "T2",
        "claim": "A net ionic equation should retain spectator ions because charge, but not necessarily every atom type, must be conserved.",
    },
    {
        "id": "T3",
        "claim": "The equivalence point is the stoichiometric condition in which the analyte is totally consumed; the endpoint is the observable change used to signal it.",
    },
    {
        "id": "T4",
        "claim": "Students must memorize the meanings of oxidizing agent and reducing agent because those definitions are explicitly assessed on the AP Exam.",
    },
    {
        "id": "T5",
        "claim": "Physical as well as chemical processes can be represented symbolically with balanced equations.",
    },
    {
        "id": "T6",
        "claim": "The appearance of heat, light, a gas, a precipitate, or a color change proves that a chemical change occurred.",
    },
]

IMAGE_CASES = [
    ("I1", "Correct candidate. Decide whether the particle counts and caption are internally consistent with 2 A + B -> A2B.", "I1-correct-limiting-reactant.png"),
    ("I2", "Controlled-error candidate. Decide whether the particle counts and caption are internally consistent with 2 A + B -> A2B.", "I2-wrong-limiting-reactant-caption.png"),
    ("I3", "Controlled-error candidate. Decide whether all atoms are conserved and whether the particle counts match the caption for 2 A + B -> A2B.", "I3-missing-product-side-particle.png"),
]

SYSTEM = """You are the independent approval reviewer for AP Chemistry reference content. Return only JSON. Do not rewrite for style and do not debate alternate phrasings. Approve a case when it is scientifically correct, consistent with the supplied CED excerpt, correctly scoped, and (for images) internally consistent. Reject only for a concrete substantive defect. For rejection, state the smallest required correction. For approval, keep reason short."""


def api_key() -> str:
    for line in ENV.read_text().splitlines():
        if line.strip().startswith("AI_GATEWAY_API_KEY="):
            return line.split("=", 1)[1].strip().strip('"').strip("'")
    raise RuntimeError("AI_GATEWAY_API_KEY not found")


def data_url(path: pathlib.Path) -> str:
    return "data:image/png;base64," + base64.b64encode(path.read_bytes()).decode("ascii")


def request_content() -> list[dict]:
    schema = {
        "required_output": {
            "cases": [
                {
                    "id": "T1 through T6, then I1 through I3 exactly once",
                    "verdict": "approve or reject",
                    "reason": "one concrete sentence",
                    "required_correction": "null when approved; smallest correction when rejected",
                }
            ]
        }
    }
    content: list[dict] = [
        {
            "type": "text",
            "text": CED_EXCERPT
            + "\nReview every case independently. Do not infer that a case is wrong merely because it is a test.\n"
            + json.dumps(TEXT_CASES, indent=2)
            + "\n\n"
            + json.dumps(schema, indent=2),
        }
    ]
    for case_id, description, filename in IMAGE_CASES:
        content.append({"type": "text", "text": f"IMAGE CASE {case_id}: {description}"})
        content.append({"type": "image_url", "image_url": {"url": data_url(HERE / "fixtures" / filename), "detail": "high"}})
    return content


def parse_json(text: str) -> dict:
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        start, end = text.find("{"), text.rfind("}")
        if start >= 0 and end > start:
            return json.loads(text[start : end + 1])
        raise


def call(model: str) -> dict:
    body = {
        "model": model,
        "messages": [
            {"role": "system", "content": SYSTEM},
            {"role": "user", "content": request_content()},
        ],
        "temperature": 0,
        "max_tokens": 2200,
        "response_format": {"type": "json_object"},
    }
    request = urllib.request.Request(
        URL,
        data=json.dumps(body).encode(),
        method="POST",
        headers={"Authorization": f"Bearer {api_key()}", "Content-Type": "application/json"},
    )
    started = time.time()
    with urllib.request.urlopen(request, timeout=600) as response:
        payload = json.load(response)
    seconds = round(time.time() - started, 2)
    raw = payload["choices"][0]["message"]["content"] or ""
    parsed = parse_json(raw)
    cases = parsed.get("cases") or parsed.get("required_output", {}).get("cases", [])
    verdicts = {case["id"]: str(case["verdict"]).lower() for case in cases}
    correct = {case_id: verdicts.get(case_id) == expected for case_id, expected in EXPECTED.items()}
    return {
        "model": model,
        "seconds": seconds,
        "usage": payload.get("usage", {}),
        "score": sum(correct.values()),
        "possible": len(EXPECTED),
        "correct": correct,
        "expected": EXPECTED,
        "response": parsed,
        "prompt_sha": hashlib.sha256((SYSTEM + CED_EXCERPT + json.dumps(TEXT_CASES)).encode()).hexdigest()[:12],
    }


def main() -> None:
    results = []
    for model in MODELS:
        print(f"Reviewing with {model}...", flush=True)
        try:
            result = call(model)
        except (urllib.error.HTTPError, urllib.error.URLError) as exc:
            detail = exc.read().decode(errors="replace")[:500] if isinstance(exc, urllib.error.HTTPError) else str(exc)
            result = {"model": model, "error": detail}
        results.append(result)
        if "error" in result:
            print(f"  ERROR: {result['error']}", flush=True)
        else:
            print(f"  {result['score']}/{result['possible']} in {result['seconds']}s; cost={result['usage'].get('cost')}", flush=True)
    (HERE / "results.json").write_text(json.dumps(results, indent=2) + "\n")


if __name__ == "__main__":
    main()
