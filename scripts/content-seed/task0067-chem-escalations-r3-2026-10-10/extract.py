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
  "topic_codes": ["1.7","1.8"],         // owner first, then ONLY later topics of this unit whose own learning objectives or essential knowledge use the entry
  "kind": "formula" | "vocabulary" | "list_sequence" | "convention" | "diagram",
  "title": "Sample standard deviation",  // <= 80 chars, student-facing
  "body": "...",                         // formula: the LaTeX expression only (symbol meanings go in items, never in body); vocabulary: one-sentence definition in CED terms;
                                         // convention: one sentence; list_sequence/diagram: one-line description
  "items": [{"label":"...","meaning":"..."}],  // list_sequence/diagram: ordered members/labelled parts; formula: REQUIRED, one item per symbol in order of appearance, e.g. {"label":"P","meaning":"pressure (atm)"}, meaning gives what it is plus units or unit constraint where the CED gives or implies them; vocabulary/convention: []
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
- A memory hook is admissible only for an ordered sequence, list, formula structure, sign/direction convention, or the labelled parts of a required diagram. Most entries get no hook. Prefer hooks in general circulation (source_note public-domain-common). Never a song lyric. A hook's caution is REQUIRED whenever its wording is not the CED's point-earning wording, which is nearly always the case for an acronym or acrostic: the caution must tell the student to state the CED's actual terms or conditions in the answer. A hook with mnemonic wording and caution null will be rejected.
- Formulas must be valid LaTeX without surrounding $.
- Preserve every CED qualifier and scope limit exactly (e.g. generally, often, in most, typically, can, for a monoprotic acid, for a weak acid): never turn a hedged or scoped CED statement into a universal one, and never add a claim (e.g. about what wording earns credit) that the CED does not make.
- Every formula entry MUST define every symbol in items (one per symbol, units where applicable). Put use conditions the CED states (temperature scale, standard state, sign convention, when the relationship applies or is excluded) in caution; a proportionality must stay a proportionality.
- Topic codes must belong to this unit. Do not tag a later topic merely because the idea is related; tag it only when that topic's own LO/EK statements use the entry.
- Respect every CED Exclusion Statement on these pages: excluded content is not an entry.
- ced_evidence: cite the EK/LO code(s) (e.g. 1.5.A.2) and a short verbatim phrase."""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--subject", required=True)          # ap-statistics | ap-chemistry
    ap.add_argument("--subject-key", required=True)      # ap_statistics | ap_chemistry
    ap.add_argument("--unit", type=int, required=True)
    ap.add_argument("--pages", required=True)            # e.g. 28-59
    ap.add_argument("--factpack", required=True)         # path to a text file with the unit's fact-pack section
    ap.add_argument("--model", default=EXTRACTOR)
    ap.add_argument("--only", default=None)   # JSON file: [{"owner_topic_code","title"}] -> extract these only (round 2)
    ap.add_argument("--round", type=int, default=1)
    a = ap.parse_args()
    first, last = [int(x) for x in a.pages.split("-")]
    ced = ced_pages(a.subject, first, last)
    fp = pathlib.Path(a.factpack).read_text()
    only = json.loads(pathlib.Path(a.only).read_text()) if a.only else None
    only_txt = ("" if not only else "\n\n=== EXTRACT ONLY THESE ENTRIES (one each; same schema; keep each title, owner_topic_code and topic_codes EXACTLY as given — they are Product Owner decisions; define every formula symbol in items; ced_evidence notes are authoritative readings of the printed CED, including symbols the text extraction loses) ===\n" + json.dumps(only, indent=1))
    user = (f"SUBJECT: {a.subject_key}  UNIT: {a.unit}\n\n=== CED UNIT PAGES (governs) ===\n{ced}\n\n"
            f"=== CRAMAPPLE FACT-PACK SECTION (paraphrase; the CED governs where they differ) ===\n{fp}\n\n"
            f"=== OUTPUT SCHEMA ===\n{SCHEMA}" + only_txt)
    out_dir = HERE / "out"; out_dir.mkdir(exist_ok=True)
    parsed, raw = chat_json(a.model, SYSTEM, user, out_dir / "logs_extract", f"{a.subject_key}_u{a.unit}", max_tokens=16000)
    entries = parsed.get("entries", [])
    for i, e in enumerate(entries):
        e["candidate_id"] = f"{a.subject_key}-u{a.unit}-r{a.round}-{i+1:03d}"
        e["subject_key"] = a.subject_key; e["unit_number"] = a.unit
        e["extractor"] = a.model
    path = out_dir / (f"candidates_{a.subject_key}_u{a.unit}.json" if a.round == 1 else f"candidates_{a.subject_key}_u{a.unit}_r{a.round}.json")
    path.write_text(json.dumps(entries, indent=2))
    kinds = {}
    for e in entries: kinds[e.get("kind")] = kinds.get(e.get("kind"), 0) + 1
    print(f"{path.name}: {len(entries)} entries {kinds}; hooks: {sum(len(e.get('hooks') or []) for e in entries)}")


if __name__ == "__main__":
    main()
