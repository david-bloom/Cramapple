"""Phase B step 1: extraction, not authoring. The extractor reads the CED unit pages plus the fact-pack
section and returns reference entries (formula / vocabulary / list_sequence / convention / diagram) with
candidate memory hooks. Output: out/candidates_<subject>_u<unit>.json. Nothing is loaded here."""
import json, sys, pathlib, argparse
import sys as _sys, pathlib as _pl; _sys.path.insert(0, str(_pl.Path(__file__).resolve().parent))
from gateway import chat_json, ced_pages

HERE = pathlib.Path(__file__).resolve().parent
EXTRACTOR = "anthropic/claude-sonnet-5.5"

SYSTEM = """You extract reference content for AP students from the College Board Course and Exam Description (CED).
You are not authoring. Every entry must be something the CED's learning objectives or essential knowledge
statements require a student to reproduce or apply in this unit. Return only JSON."""

SCHEMA = """Return a JSON object: {"entries": [Entry, ...]} where Entry is:
{
  "owner_topic_code": "1.7",            // the topic where the student first needs it (format N.N)
  "topic_codes": ["1.7","1.8"],         // owner first, then later topics in this unit that reuse it
  "kind": "formula" | "vocabulary" | "list_sequence" | "convention" | "diagram",
  "title": "Sample standard deviation",  // <= 80 chars, student-facing
  "body": "...",                         // formula: LaTeX only; vocabulary: one-sentence definition in CED terms;
                                         // convention: one sentence; list_sequence/diagram: one-line description
  "items": [{"label":"...","meaning":"..."}],  // ordered members for list_sequence and diagram; [] otherwise
  "caution": null | "...",               // only when the common wording is NOT the wording that earns the point
  "ced_evidence": "verbatim CED phrase or EK/LO code this entry comes from",
  "hooks": [ { "kind": "acronym"|"acrostic"|"phrase"|"formula_sentence"|"visual"|"diagram_parts",
               "hook_text": "SOCS", "expands_to": [{"cue":"S","means":"shape"}, ...],
               "when_to_use": "one sentence", "caution": null | "...",
               "source_note": "public-domain-common" | "cramapple-authored" } ]   // [] for most entries
}
Rules:
- Extract, do not invent. If the CED gives a formula, copy it; if it gives a list, keep the CED's members and order.
- Vocabulary: only terms the CED defines or distinguishes in this unit; not a glossary dump. Define in CED terms.
- list_sequence: ordered or enumerated sets the CED names (e.g. the four bias types). diagram: only representations the CED requires students to read or construct, with the labelled parts as items.
- convention: sign/direction/decision rules (e.g. which measure is resistant, where mean sits under skew).
- A memory hook is admissible only for an ordered sequence, list, formula structure, sign/direction convention, or the labelled parts of a required diagram. Most entries get no hook. Prefer hooks in general circulation (source_note public-domain-common). Never a song lyric. When the hook's wording is not the wording that earns the point, set caution.
- Formulas must be valid LaTeX without surrounding $.
- Topic codes must belong to this unit."""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--subject", required=True)          # ap-statistics | ap-chemistry
    ap.add_argument("--subject-key", required=True)      # ap_statistics | ap_chemistry
    ap.add_argument("--unit", type=int, required=True)
    ap.add_argument("--pages", required=True)            # e.g. 28-59
    ap.add_argument("--factpack", required=True)         # path to a text file with the unit's fact-pack section
    ap.add_argument("--model", default=EXTRACTOR)
    a = ap.parse_args()
    first, last = [int(x) for x in a.pages.split("-")]
    ced = ced_pages(a.subject, first, last)
    fp = pathlib.Path(a.factpack).read_text()
    user = (f"SUBJECT: {a.subject_key}  UNIT: {a.unit}\n\n=== CED UNIT PAGES (governs) ===\n{ced}\n\n"
            f"=== CRAMAPPLE FACT-PACK SECTION (paraphrase; the CED governs where they differ) ===\n{fp}\n\n"
            f"=== OUTPUT SCHEMA ===\n{SCHEMA}")
    out_dir = HERE / "out"; out_dir.mkdir(exist_ok=True)
    parsed, raw = chat_json(a.model, SYSTEM, user, out_dir / "logs_extract", f"{a.subject_key}_u{a.unit}", max_tokens=16000)
    entries = parsed.get("entries", [])
    for i, e in enumerate(entries):
        e["candidate_id"] = f"{a.subject_key}-u{a.unit}-{i+1:03d}"
        e["subject_key"] = a.subject_key; e["unit_number"] = a.unit
        e["extractor"] = a.model
    path = out_dir / f"candidates_{a.subject_key}_u{a.unit}.json"
    path.write_text(json.dumps(entries, indent=2))
    kinds = {}
    for e in entries: kinds[e.get("kind")] = kinds.get(e.get("kind"), 0) + 1
    print(f"{path.name}: {len(entries)} entries {kinds}; hooks: {sum(len(e.get('hooks') or []) for e in entries)}")


if __name__ == "__main__":
    main()
