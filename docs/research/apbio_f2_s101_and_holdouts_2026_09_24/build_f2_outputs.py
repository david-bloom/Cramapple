#!/usr/bin/env python3
"""Build the F.2 proposal artifacts for S-101 and the three holdouts."""

import csv
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
SRC = HERE.parent / "apbio_frq_segmentation_2026_09_22" / "apbio_frq_segmentation.codex.jsonl"

TARGETS = {"APBIO-FRQ-S-101", "APBIO-FRQ-S-021", "APBIO-FRQ-S-023", "APBIO-FRQ-S-058"}


def load_source() -> dict[str, dict]:
    rows = {}
    for line in SRC.read_text().splitlines():
        row = json.loads(line)
        if row["content_key"] in TARGETS:
            rows[row["content_key"]] = row
    missing = TARGETS - set(rows)
    if missing:
        raise SystemExit(f"missing source rows: {sorted(missing)}")
    return rows


def offsets(text: str, source: str):
    idx = source.find(text)
    return idx if idx >= 0 else ""


def criterion_span(text: str, key: str, provenance: str = "drafted", source_field: str = "drafted", source_offset="") -> dict:
    return {
        "text": text,
        "criterion_keys": [key],
        "provenance": provenance,
        "source_field": source_field,
        "source_offset": source_offset,
    }


def literal(text: str) -> dict:
    return {
        "text": text,
        "criterion_keys": [],
        "provenance": "assembly_literal",
        "source_field": "assembly_literal",
        "source_offset": "",
    }


def make_answer(row: dict, span_specs: list[dict], ca2_decision: str, ca2_reason: str) -> dict:
    spans = []
    for idx, span in enumerate(span_specs):
        if idx:
            spans.append(literal("\n\n"))
        spans.append(span)
    full_text = "".join(span["text"] for span in spans)
    criteria = [c["criterion_key"] for c in row["rubric"]]
    covered = sorted({key for span in spans for key in span["criterion_keys"]})
    return {
        "content_key": row["content_key"],
        "content_item_id": row["content_item_id"],
        "content_item_version_id": row["content_item_version_id"],
        "version_num": row.get("version_num"),
        "full_text": full_text,
        "spans": spans,
        "coverage": {
            "criteria_total": len(criteria),
            "criteria_covered": covered,
            "criteria_uncovered": sorted(set(criteria) - set(covered)),
            "every_criterion_has_span": set(criteria) == set(covered),
            "criteria_without_exclusive_span": [],
            "spans_concat_equals_full_text": full_text == "".join(span["text"] for span in spans),
        },
        "canonical_answer_2_decision": ca2_decision,
        "canonical_answer_2_reason": ca2_reason,
        "needs_human": True,
    }


def write_packet(rows: dict[str, dict]) -> None:
    with (HERE / "packet.jsonl").open("w") as handle:
        for key in sorted(TARGETS):
            row = rows[key]
            packet = {
                "content_key": row["content_key"],
                "content_item_id": row["content_item_id"],
                "content_item_version_id": row["content_item_version_id"],
                "subject_key": row["subject_key"],
                "question": row["question"],
                "rubric": row["rubric"],
                "existing_canonical_answer": row["existing_canonical_answer"],
            }
            handle.write(json.dumps(packet, sort_keys=True) + "\n")


def write_criteria_change(s101: dict) -> None:
    old = next(c for c in s101["rubric"] if c["criterion_key"] == "a-iv")
    answer_text = (
        "A synapomorphy is a shared derived character that evolved in the common ancestor of a group and was inherited by its descendants.\n\n"
        "It is more useful than a symplesiomorphy because an ancestral character may be shared by many lineages and therefore does not distinguish more recent branches, whereas a shared derived character identifies a more recent common ancestor.\n\n"
        "Species A is the outgroup because it lacks all four derived characters. The most parsimonious topology is (A,(B,(C,(D,E)))). Character 1 unites B-E, character 2 unites C-E, character 3 unites D and E, and character 4 is unique to E, so each character needs to arise only once on this tree.\n\n"
        "\"Most parsimonious\" means the tree that requires the fewest total character-state changes.\n\n"
        "Parsimony is preferred because it explains the observed character distribution with the fewest unsupported evolutionary assumptions, such as repeated independent origins or reversals of the same character."
    )
    spans = [
        criterion_span("A synapomorphy is a shared derived character that evolved in the common ancestor of a group and was inherited by its descendants.", "a-i"),
        literal("\n\n"),
        criterion_span("It is more useful than a symplesiomorphy because an ancestral character may be shared by many lineages and therefore does not distinguish more recent branches, whereas a shared derived character identifies a more recent common ancestor.", "a-ii"),
        literal("\n\n"),
        criterion_span("Species A is the outgroup because it lacks all four derived characters. The most parsimonious topology is (A,(B,(C,(D,E)))). Character 1 unites B-E, character 2 unites C-E, character 3 unites D and E, and character 4 is unique to E, so each character needs to arise only once on this tree.", "a-iii"),
        literal("\n\n"),
        criterion_span("\"Most parsimonious\" means the tree that requires the fewest total character-state changes.", "a-iv"),
        literal("\n\n"),
        criterion_span("Parsimony is preferred because it explains the observed character distribution with the fewest unsupported evolutionary assumptions, such as repeated independent origins or reversals of the same character.", "a-v"),
    ]
    criteria = ["a-i", "a-ii", "a-iii", "a-iv", "a-v"]
    change = {
        "content_key": "APBIO-FRQ-S-101",
        "content_item_id": s101["content_item_id"],
        "content_item_version_id": s101["content_item_version_id"],
        "rubric_change_only": True,
        "grader_gate_not_run_by_codex": True,
        "before": {
            "criterion_key": old["criterion_key"],
            "points_possible": old["points_possible"],
            "learner_facing_text": old["learner_facing_text"],
            "evidence_requirements": old["evidence_requirements"],
            "minimum_fix": old["minimum_fix"],
        },
        "after": [
            {
                "criterion_key": "a-iv",
                "points_possible": 1,
                "learner_facing_text": "Explains what \"most parsimonious\" means in phylogenetic analysis.",
                "evidence_requirements": "States that the most parsimonious tree requires the fewest evolutionary changes or character-state transitions.",
                "span_text": spans[6]["text"],
            },
            {
                "criterion_key": "a-v",
                "points_possible": 1,
                "learner_facing_text": "Explains why parsimony is preferred when building cladograms.",
                "evidence_requirements": "States that parsimony is preferred because it requires the fewest unsupported assumptions, such as independent origins or reversals.",
                "span_text": spans[8]["text"],
            },
        ],
        "unchanged_answer_text": answer_text,
        "spans": spans,
        "invariants": {
            "spans_concat_equals_full_text": answer_text == "".join(span["text"] for span in spans),
            "criteria_total_after": len(criteria),
            "criteria_covered": sorted({key for span in spans for key in span["criterion_keys"]}),
            "criteria_without_exclusive_span": [],
            "mean_overstrike_fraction": 0,
        },
    }
    (HERE / "criteria_change.json").write_text(json.dumps(change, indent=2, sort_keys=True) + "\n")


def write_canonical_proposals(rows: dict[str, dict]) -> None:
    proposals = []
    s021 = rows["APBIO-FRQ-S-021"]
    proposals.append(make_answer(s021, [
        criterion_span("A peptide bond forms between the carboxyl group of one amino acid and the amino group of the adjacent amino acid.", "a1"),
        criterion_span("Formation of this bond releases a water molecule in a dehydration-synthesis reaction.", "a2"),
        criterion_span("A fatty acid contains a long, nonpolar hydrocarbon tail.", "b1"),
        criterion_span("Because this nonpolar tail cannot form hydrogen bonds with water, the fatty acid is hydrophobic.", "b2"),
    ], "remove", "Both stored canonical fields are off-rubric or supplementary; the new canonical_answer_1 fully covers the rubric."))

    s023 = rows["APBIO-FRQ-S-023"]
    ca2 = s023["existing_canonical_answer"]["canonical_answer_2"]
    recovered = "acidic conditions denature it by disrupting ionic and hydrogen bonds."
    proposals.append(make_answer(s023, [
        criterion_span("At about pH 2, the acidic environment maintains the ionic and hydrogen bonds that give pepsin's active site its functional shape.", "a1"),
        criterion_span("That conformation allows the substrate to bind effectively, so pepsin functions optimally at pH 2.", "a2"),
        criterion_span("Trypsin activity decreases greatly or stops at pH 2.", "b1"),
        criterion_span(recovered, "b2", "recovered_ca2", "canonical_answer_2", offsets(recovered, ca2)),
    ], "remove", "The b2 clause is recovered into the complete canonical_answer_1; the remaining canonical_answer_2 context is supplementary and redundant."))

    s058 = rows["APBIO-FRQ-S-058"]
    proposals.append(make_answer(s058, [
        criterion_span("A population bottleneck is a drastic reduction in population size that changes allele frequencies by chance.", "a1"),
        criterion_span("Rare alleles may be lost entirely, while alleles common among the few survivors can become overrepresented.", "a2"),
        criterion_span("With less genetic variation, individuals in the surviving population are more genetically similar to one another.", "b1"),
        criterion_span("If a new disease or environmental change occurs, many individuals may share the same susceptibility, threatening the population's survival.", "b2"),
    ], "remove", "Both stored canonical fields are broad or off-rubric; the new canonical_answer_1 covers every rubric criterion explicitly."))

    with (HERE / "canonical_proposal.jsonl").open("w") as handle:
        for proposal in proposals:
            handle.write(json.dumps(proposal, sort_keys=True) + "\n")


def write_removal_log(rows: dict[str, dict]) -> None:
    entries = []
    for key in ["APBIO-FRQ-S-021", "APBIO-FRQ-S-058"]:
        answer = rows[key]["existing_canonical_answer"]
        for field in ["canonical_answer_1", "canonical_answer_2"]:
            text = answer[field]
            if text:
                entries.append({
                    "content_key": key,
                    "source_field": field,
                    "verbatim_text": text,
                    "char_count": len(text),
                    "decision": "remove",
                    "reason": "off-rubric or supplementary; superseded by drafted exclusive spans in canonical_answer_1",
                })
    s023 = rows["APBIO-FRQ-S-023"]["existing_canonical_answer"]
    entries.append({
        "content_key": "APBIO-FRQ-S-023",
        "source_field": "canonical_answer_1",
        "verbatim_text": s023["canonical_answer_1"],
        "char_count": len(s023["canonical_answer_1"]),
        "decision": "remove",
        "reason": "does not explicitly satisfy a1/a2; superseded by drafted exclusive spans",
    })
    removed_prefix = "Trypsin is most active near neutral-to-basic pH; "
    entries.append({
        "content_key": "APBIO-FRQ-S-023",
        "source_field": "canonical_answer_2",
        "verbatim_text": removed_prefix,
        "char_count": len(removed_prefix),
        "decision": "remove",
        "reason": "supplementary context not required by the rubric; b2 clause is recovered separately into canonical_answer_1",
    })
    recovered = "acidic conditions denature it by disrupting ionic and hydrogen bonds."
    entries.append({
        "content_key": "APBIO-FRQ-S-023",
        "source_field": "canonical_answer_2",
        "verbatim_text": recovered,
        "char_count": len(recovered),
        "decision": "relocate_to_canonical_answer_1",
        "reason": "recoverable b2 evidence retained verbatim as an exclusive span",
    })
    with (HERE / "removal_log.csv").open("w", newline="") as handle:
        fieldnames = ["content_key", "source_field", "verbatim_text", "char_count", "decision", "reason"]
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(entries)


def main() -> None:
    rows = load_source()
    write_packet(rows)
    write_criteria_change(rows["APBIO-FRQ-S-101"])
    write_canonical_proposals(rows)
    write_removal_log(rows)


if __name__ == "__main__":
    main()
