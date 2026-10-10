"""Phase B step 1: extraction, not authoring. The extractor reads the CED unit pages plus the fact-pack
section and returns reference entries (formula / vocabulary / list_sequence / convention / diagram) with
candidate memory hooks. Output: out/candidates_<subject>_u<unit>.json. Nothing is loaded here."""
import json, sys, pathlib, argparse
import sys as _sys, pathlib as _pl; _sys.path.insert(0, str(_pl.Path(__file__).resolve().parent))
from gateway import chat_json, ced_pages

HERE = pathlib.Path(__file__).resolve().parent
EXTRACTOR = "anthropic/claude-sonnet-5.5"

SYSTEM = """You extract reference content for AP students from the College Board Course and Exam Description (CED).
You are not authoring. An entry is admissible only when a LEARNING OBJECTIVE or ESSENTIAL KNOWLEDGE statement
in this unit's Required Course Content requires a student to reproduce or apply it. The unit pages also carry
teacher-facing and scope-limiting material that must never become an entry; the rules below name it. Return
only JSON."""

SCHEMA = """Return a JSON object: {"entries": [Entry, ...]} where Entry is:
{
  "owner_topic_code": "1.7",            // the topic whose own LO/EK requires this entry AS STATED (format N.N) —
                                        // NOT the earliest topic that merely mentions the idea
  "topic_codes": ["1.7","1.8"],         // owner first, then ONLY LATER topics of this unit whose own LO/EK use the
                                        // entry; never a topic that precedes the owner
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
- A memory hook is admissible only for an ordered sequence, list, formula structure, sign/direction convention, or the labelled parts of a required diagram. Most entries get no hook. Prefer hooks in general circulation (source_note public-domain-common). Never a song lyric. A hook's caution is REQUIRED whenever its wording is not the CED's point-earning wording, which is nearly always the case for an acronym or acrostic: the caution must tell the student to state the CED's actual terms or conditions in the answer. A hook with mnemonic wording and caution null will be rejected.
- Formulas must be valid LaTeX without surrounding $.
- Topic codes must belong to this unit. The owner is the topic whose own LO/EK requires the entry as stated, not the earliest topic to mention the idea: ask which topic's LO/EK would be incomplete without this entry worded this way. Do not tag a later topic merely because the idea is related; tag it only when that topic's own LO/EK statements use the entry. Never list a topic that comes before the owner — if an earlier topic needs its own lookup, that is a separate entry owned by that earlier topic.
- ADMISSIBLE SOURCE. Only the LEARNING OBJECTIVE and ESSENTIAL KNOWLEDGE statements under "Required Course Content" may be the basis for an entry. These unit pages also contain material that must NEVER become an entry, however useful it looks: Exclusion Statements and Boundary Statements (they are scope limits, not content); the SUGGESTED SKILL / science-practice / mathematical-practice lists printed beside each topic; "Preparing for the AP Exam"; "Developing Understanding"; "Essential Questions"; "Unit at a Glance"; "Sample Instructional Activities"; "Available Resources"; and "Building ... Practices". If the only support you can cite for an entry comes from one of those sections, drop the entry.
- ILLUSTRATIVE EXAMPLES cannot be the whole content of an entry. An EK statement must require the entry; a named illustrative example may then appear inside it. A list whose only basis is "ILLUSTRATIVE EXAMPLES" is not an entry.
- An Exclusion or Boundary Statement still has two legitimate uses: it tells you what to leave out, and it may be quoted in the `caution` of an entry that has its own LO/EK basis. It is never the entry itself. Respect every Exclusion Statement on these pages: excluded content is not an entry.
- ced_evidence: cite at least one LO or EK code (e.g. 1.5.A.2) plus a short verbatim phrase. If you cannot cite an LO or EK code that requires the entry, the entry is not admissible — drop it rather than citing a boundary statement, a skill, or a page heading."""


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
    only_txt = ("" if not only else "\n\n=== EXTRACT ONLY THESE ENTRIES (one each; same schema; tag topic_codes only with topics of this unit whose learning objectives actually use the entry) ===\n" + json.dumps(only, indent=1))
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
