"""Second bounded Haiku calibration: subtle text, equations, graph labels, and electrochemical direction."""

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
MODEL = "anthropic/claude-haiku-5.5"

EXPECTED = {
    "T7": "approve",
    "T8": "reject",
    "T9": "approve",
    "T10": "reject",
    "T11": "approve",
    "T12": "reject",
    "T13": "approve",
    "T14": "reject",
    "I4": "approve",
    "I5": "reject",
    "I6": "approve",
    "I7": "reject",
}

CED_EXCERPT = """AP Chemistry CED excerpts:
- 2.2.A.1-.2: A potential-energy/internuclear-distance graph shows equilibrium bond length at minimum potential energy and bond energy as the energy required to separate atoms. Higher-order covalent bonds are shorter and have larger bond energies.
- 2.7.A.2-.3: Lewis diagrams and VSEPR predict geometry, bond angles, bond lengths/energies, dipole presence, and hybridization. Ideal angles are sp 180 degrees, sp2 120 degrees, and sp3 109.5 degrees.
- 5.3.A.2-.5: First order gives a linear ln[A] versus time plot and ln[A]t-ln[A]0=-kt. Second order gives a linear 1/[A] versus time plot and 1/[A]t-1/[A]0=kt. First-order half-life is constant and t1/2=0.693/k.
- 7.3.A.1-.2: Q tends toward K and Q=K at equilibrium. Q/K expressions omit solids and pure liquids because their concentrations are independent of amount.
- 7.10.A.1-.2: A disturbance makes Q differ from K. Concentration changes change Q only; temperature changes K. Species redistribute until Q=K again.
- 8.1.A.3-.4: In pure water pH=pOH. Both equal 7.0 at 25 degrees C, but Kw is temperature dependent, so neutral-water pH deviates from 7.0 at other temperatures.
- 8.7.A.1: If pH<pKa, the acid form has the greater concentration; if pH>pKa, the base form has the greater concentration.
- 9.8.A.1-.3: Cell diagrams are used to determine electron flow and half-cell reactions. Oxidation occurs at the anode and reduction at the cathode in every electrochemical cell.
"""

TEXT_CASES = [
    {"id": "T7", "claim": "For comparable covalent bonds, increasing bond order generally shortens the bond and increases its bond energy."},
    {"id": "T8", "claim": "An sp2-hybridized central atom has an ideal bond angle of 109.5 degrees."},
    {"id": "T9", "claim": "For a first-order reaction, half-life is constant and equals 0.693/k rather than depending on the initial reactant concentration."},
    {"id": "T10", "claim": "A second-order reaction is identified by a linear ln[A]-versus-time plot with slope -k."},
    {"id": "T11", "claim": "Pure solids and pure liquids are omitted from Q and K expressions because their concentrations do not depend on the amount present."},
    {"id": "T12", "claim": "Adding more reactant to an equilibrium mixture changes K immediately while leaving Q unchanged."},
    {"id": "T13", "claim": "When solution pH is below an acid's pKa, the protonated acid form is present at the greater concentration."},
    {"id": "T14", "claim": "Pure neutral water always has pH 7.0, regardless of temperature."},
]

IMAGE_CASES = [
    ("I4", "Review all graph axes, linearized variables, and slope signs.", "I4-correct-integrated-rate-plots.png"),
    ("I6", "Review the cell labels, half-reactions, electron-flow direction, and salt-bridge ion directions.", "I6-correct-galvanic-cell.png"),
    ("I5", "Review all graph axes, linearized variables, and slope signs.", "I5-wrong-second-order-slope.png"),
    ("I7", "Review the cell labels, half-reactions, electron-flow direction, and salt-bridge ion directions.", "I7-wrong-electron-flow.png"),
]

SYSTEM = """You are an independent AP Chemistry approval reviewer. Return only JSON. Approve only when a case is scientifically correct, agrees with the supplied CED excerpt, and, for images, all visual labels/arrows/relationships are internally consistent. Reject only for a substantive error, not style. Give the smallest required correction. Judge each case independently and do not assume the test contains paired correct/incorrect versions."""


def api_key() -> str:
    for line in ENV.read_text().splitlines():
        if line.strip().startswith("AI_GATEWAY_API_KEY="):
            return line.split("=", 1)[1].strip().strip('"').strip("'")
    raise RuntimeError("AI_GATEWAY_API_KEY not found")


def data_url(path: pathlib.Path) -> str:
    return "data:image/png;base64," + base64.b64encode(path.read_bytes()).decode("ascii")


def request_content() -> list[dict]:
    content: list[dict] = [
        {
            "type": "text",
            "text": CED_EXCERPT
            + "\nReview all twelve cases. Return exactly: "
            + '{"cases":[{"id":"...","verdict":"approve|reject","reason":"...","required_correction":null|"..."}]}'
            + "\n\nTEXT CASES:\n"
            + json.dumps(TEXT_CASES, indent=2),
        }
    ]
    for case_id, description, filename in IMAGE_CASES:
        content.append({"type": "text", "text": f"IMAGE CASE {case_id}: {description}"})
        content.append({"type": "image_url", "image_url": {"url": data_url(HERE / "fixtures-round2" / filename), "detail": "high"}})
    return content


def parse_json(text: str) -> dict:
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        start, end = text.find("{"), text.rfind("}")
        if start >= 0 and end > start:
            return json.loads(text[start : end + 1])
        raise


def main() -> None:
    body = {
        "model": MODEL,
        "messages": [
            {"role": "system", "content": SYSTEM},
            {"role": "user", "content": request_content()},
        ],
        "temperature": 0,
        "max_tokens": 2600,
        "response_format": {"type": "json_object"},
    }
    request = urllib.request.Request(
        URL,
        data=json.dumps(body).encode(),
        method="POST",
        headers={"Authorization": f"Bearer {api_key()}", "Content-Type": "application/json"},
    )
    started = time.time()
    try:
        with urllib.request.urlopen(request, timeout=600) as response:
            payload = json.load(response)
    except (urllib.error.HTTPError, urllib.error.URLError) as exc:
        detail = exc.read().decode(errors="replace")[:500] if isinstance(exc, urllib.error.HTTPError) else str(exc)
        raise RuntimeError(detail) from exc
    seconds = round(time.time() - started, 2)
    raw = payload["choices"][0]["message"]["content"] or ""
    parsed = parse_json(raw)
    cases = parsed.get("cases") or parsed.get("required_output", {}).get("cases", [])
    verdicts = {case["id"]: str(case["verdict"]).lower() for case in cases}
    correct = {case_id: verdicts.get(case_id) == expected for case_id, expected in EXPECTED.items()}
    result = {
        "model": MODEL,
        "seconds": seconds,
        "usage": payload.get("usage", {}),
        "score": sum(correct.values()),
        "possible": len(EXPECTED),
        "correct": correct,
        "expected": EXPECTED,
        "response": parsed,
        "prompt_sha": hashlib.sha256((SYSTEM + CED_EXCERPT + json.dumps(TEXT_CASES)).encode()).hexdigest()[:12],
    }
    (HERE / "results_round2.json").write_text(json.dumps(result, indent=2) + "\n")
    print(f"{MODEL}: {result['score']}/{result['possible']} in {seconds}s; cost={result['usage'].get('cost')}", flush=True)


if __name__ == "__main__":
    main()

