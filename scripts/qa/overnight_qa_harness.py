#!/usr/bin/env python3
"""
Overnight QA harness for Codex work orders A, B, C and D (2026-09-22).

Independently recomputes every invariant each work order tells the builder to report against.
Runs fully OFFLINE: it reads a Production truth snapshot produced by overnight_qa_truth.sql, so
it needs no credentials and cannot touch Production while verifying.

The harness never trusts the builder's packet.jsonl. It diffs that packet against the truth
snapshot first; if they disagree, the run is invalid regardless of how good the proposal looks.

Usage
-----
  python3 scripts/qa/overnight_qa_harness.py --order A --truth <dir> --run <dir> [--out <dir>]

  --truth   directory holding items.json, prior_versions.json, closed_list.json
  --run     the work order's output directory under docs/research/
  --out     where to write qa_findings.csv (default: the --run directory)

Exit status: 0 if every invariant passed, 1 if any failed, 2 on a harness/input error.
A FAIL is a finding about the builder's run, not a bug in this script -- read qa_findings.csv.
"""
from __future__ import annotations
import argparse, csv, json, os, re, sys
from collections import Counter, defaultdict

# ----------------------------------------------------------------------------- infrastructure

class Results:
    def __init__(self):
        self.rows = []      # invariant table
        self.findings = []  # per-item findings
        self._n = 0

    def check(self, name, expected, measured, ok, detail=""):
        self.rows.append({"invariant": name, "expected": expected,
                          "measured": measured, "verdict": "PASS" if ok else "FAIL",
                          "detail": detail})
        return ok

    def note(self, name, work_order_says, measured, detail=""):
        """Soft comparison against a number the WORK ORDER asserts. Production is the authority,
        not the work order, so drift here is reported and never fails the run -- that is the
        tiered-drift rule the prompts carry. Hard checks always compare builder vs Production."""
        same = str(work_order_says) == str(measured)
        self.rows.append({"invariant": name, "expected": work_order_says, "measured": measured,
                          "verdict": "PASS" if same else "NOTE", "detail": detail})
        if not same:
            self.finding("work_order_count_drift", "low", name,
                         f"work order says {work_order_says}, Production shows {measured}",
                         "Confirm the builder reported this drift rather than working around it")
        return same

    def finding(self, issue, severity, item, explanation, suggested=""):
        self._n += 1
        self.findings.append({"finding_id": f"QA-{self._n:04d}", "issue_type": issue,
                              "severity": severity, "content_key": item,
                              "explanation": explanation, "suggested_investigation": suggested})

    @property
    def failed(self):
        return any(r["verdict"] == "FAIL" for r in self.rows)  # NOTE rows never fail the run

    def report(self, order, run_dir, out_dir):
        w = max(len(r["invariant"]) for r in self.rows) if self.rows else 10
        print(f"\n{'='*(w+44)}\nWORK ORDER {order} — invariant table\n{'='*(w+44)}")
        print(f"{'invariant'.ljust(w)}  {'expected':>10}  {'measured':>10}  verdict")
        for r in self.rows:
            print(f"{r['invariant'].ljust(w)}  {str(r['expected']):>10}  {str(r['measured']):>10}  "
                  f"{r['verdict']}{('  — ' + r['detail']) if r['detail'] and r['verdict']=='FAIL' else ''}")
        out = os.path.join(out_dir, "qa_findings.csv")
        with open(out, "w", newline="") as f:
            wr = csv.DictWriter(f, fieldnames=["finding_id","issue_type","severity",
                                               "content_key","explanation","suggested_investigation"])
            wr.writeheader(); wr.writerows(self.findings)
        by = Counter(x["issue_type"] for x in self.findings)
        print(f"\nfindings: {len(self.findings)} -> {out}")
        for k, v in by.most_common():
            print(f"   {v:>4}  {k}")
        print(f"\nRESULT: {'FAIL — see findings above' if self.failed else 'PASS — all invariants held'}")


def load_json(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def load_jsonl(path):
    rows = []
    with open(path, encoding="utf-8") as f:
        for n, line in enumerate(f, 1):
            line = line.strip()
            if not line:
                continue
            try:
                rows.append(json.loads(line))
            except json.JSONDecodeError as e:
                raise SystemExit(f"{path}:{n} is not valid JSON — {e}")
    return rows


def need(run_dir, name):
    p = os.path.join(run_dir, name)
    if not os.path.exists(p):
        raise SystemExit(f"missing required artifact: {p}")
    return p


def norm(s):
    """Whitespace-normalise for verbatim comparison. Deliberately conservative: collapses runs of
    whitespace only. Anything else is a real difference and should surface as a failure."""
    return re.sub(r"\s+", " ", (s or "")).strip()


def _tokens(s):
    """Case- and punctuation-insensitive word tokens, for similarity only -- never for verbatim
    checks, which must stay byte-exact."""
    return re.sub(r"[^a-z0-9 ]", " ", (s or "").lower()).split()


def check_rubric_restatement(R, proposals, truth_by_key, *, label="",
                             hard=0.85, soft=0.70, fail_run=False):
    """Does an AUTHORED span answer the question, or just say the criterion back?

    Added 2026-09-23 after QA of work order A. A's requirement-1 guard only caught second-person
    rubric phrasing ("make sure your response identifies skew"). The failure that actually occurred
    was DECLARATIVE restatement: three of A's drafted spans were character-identical to their own
    learner_facing_text and contained no second-person phrasing at all, so that guard passed every
    one of them. Many criteria are written as declarative content statements, which makes copying
    them the path of least resistance.

    Why it matters: an answer copied from its rubric cannot be used to validate that rubric, and it
    is thin as the post-submission exemplar a student sees.

    Only spans whose provenance is authored (drafted) are scored. Recovered and unchanged spans are
    vetted prior content and are out of scope for this check.

    fail_run=False reports the distribution without failing, for orders already dispositioned.
    """
    import difflib
    scored, over_hard, over_soft = [], [], []
    for p in proposals:
        key = p.get("content_key")
        crit = {c["criterion_key"]: c.get("learner_facing_text", "")
                for c in ((truth_by_key.get(key) or {}).get("criteria") or [])}
        for s in (p.get("spans") or []):
            if (s.get("provenance") or "") != "drafted":
                continue
            for ck in (s.get("criterion_keys") or []):
                if ck not in crit:
                    continue
                r = difflib.SequenceMatcher(None, _tokens(s.get("text")), _tokens(crit[ck])).ratio()
                scored.append(r)
                if r >= hard:
                    over_hard.append((key, ck, r))
                elif r >= soft:
                    over_soft.append((key, ck, r))
    if not scored:
        return True
    mean = sum(scored) / len(scored)
    print(f"\n  authored-span similarity to rubric text: n={len(scored)} mean={mean:.3f} "
          f">={soft}: {len(over_soft) + len(over_hard)}  >={hard}: {len(over_hard)}")
    for key, ck, r in over_hard:
        R.finding("rubric_restatement", "medium", key,
                  f"authored span for criterion {ck} is {r:.2f} similar to its own "
                  f"learner_facing_text -- it restates the rubric rather than answering",
                  "Re-author from the stem, stimulus and CED fact pack")
    for key, ck, r in over_soft:
        if not any(f.get("type") == "restatement_justified"
                   for f in (next((p for p in proposals if p.get("content_key") == key), {})
                             .get("flags") or []) if isinstance(f, dict)):
            R.finding("rubric_restatement_unjustified", "low", key,
                      f"authored span for criterion {ck} is {r:.2f} similar to its "
                      f"learner_facing_text and carries no restatement_justified flag",
                      "Name what the span adds beyond the criterion, or re-author it")
    ok = not over_hard
    R.check(f"authored spans are not rubric restatements{label}",
            f"0 at or above {hard}", f"{len(over_hard)} of {len(scored)} (mean {mean:.3f})",
            ok or not fail_run,
            "reported only; this order was dispositioned before the check existed"
            if over_hard and not fail_run else "")
    return ok


# ----------------------------------------------------------------------------- shared checks

def check_packet(R, packet, truth_items, expect_n, label="packet"):
    """The builder's packet must match independently-read Production. This runs first for every
    order, because nothing downstream is meaningful if the inputs were misread."""
    by_key = {i["content_key"]: i for i in truth_items}
    pk = {p.get("content_key"): p for p in packet}
    R.check(f"{label}: row count", expect_n, len(packet), len(packet) == expect_n)
    missing = sorted(set(by_key) - set(pk))
    extra = sorted(set(pk) - set(by_key))
    R.check(f"{label}: items missing vs Production", 0, len(missing), not missing,
            ", ".join(missing[:5]))
    R.check(f"{label}: items not in Production", 0, len(extra), not extra, ", ".join(extra[:5]))
    for k in missing[:50]:
        R.finding("packet_missing_item", "high", k, "Published item absent from the builder's packet")
    for k in extra[:50]:
        R.finding("packet_phantom_item", "high", k, "Packet row does not correspond to a published item")

    drift = 0
    for k, p in pk.items():
        t = by_key.get(k)
        if not t:
            continue
        for field, tf in (("version_id", "version_id"), ("version_num", "version_num"),
                          ("canonical_answer_1", "canonical_answer_1"),
                          ("canonical_answer_2", "canonical_answer_2")):
            if field in p and norm(str(p.get(field))) != norm(str(t.get(tf))):
                drift += 1
                R.finding("packet_drift", "high", k,
                          f"packet.{field} disagrees with Production", "Re-read Production; the run may predate a change")
                break
        pc = p.get("criteria") or p.get("frq_criteria") or []
        tc = t.get("criteria") or []
        if pc and len(pc) != len(tc):
            drift += 1
            R.finding("packet_criteria_count", "high", k,
                      f"packet has {len(pc)} criteria, Production has {len(tc)}")
    R.check(f"{label}: field drift vs Production", 0, drift, drift == 0)


NON_SOURCE_PROV = {"drafted", "assembly_literal"}

def resolve_source(truth_item, span, prior_by_item=None, items_by_key=None):
    """Return the text a recovered span claims to come from.

    A recovery may cite the CURRENT version, a PRIOR version of the same item, or -- for a split
    child -- a PARENT item's version. Resolving only against the current item is wrong and reads
    every prior-version recovery as non-verbatim.
    """
    fld = span.get("source_field") or ""
    if fld in ("canonical_answer_1", "canonical_answer_2"):
        return (truth_item or {}).get(fld)
    sv = span.get("source_version_id")
    if fld.startswith("prior_") or fld.startswith("parent_"):
        base = fld.replace("prior_", "").replace("parent_", "")
        for v in (prior_by_item or {}).get(sv, []):
            return v.get(base)
        # parent: the cited version belongs to a different content_item_id
        for lst in (prior_by_item or {}).values():
            for v in lst:
                if v.get("version_id") == sv:
                    return v.get(base)
        for it in (items_by_key or {}).values():
            if it.get("version_id") == sv:
                return it.get(base)
    return None


def check_spans(R, proposals, truth_by_key, *, require_verbatim_fields=None,
                forbid_drafted=False, label="segmentation", prior_by_version=None,
                items_by_key=None, allow_declared_uncovered=False):
    """Concatenation, criterion coverage, no invented criteria, verbatim provenance, and the
    non-empty-on-removal property. Shared by A, B and C."""
    concat_ok = cover_ok = invent_ok = verbatim_ok = removal_ok = 0
    drafted_spans = 0
    n = len(proposals)
    for p in proposals:
        key = p.get("content_key")
        spans = p.get("spans") or []
        full = p.get("full_text", "")
        truth = truth_by_key.get(key, {})
        crit_keys = {c["criterion_key"] for c in (truth.get("criteria") or [])}

        if norm("".join(s.get("text", "") for s in spans)) == norm(full):
            concat_ok += 1
        else:
            R.finding("concatenation_mismatch", "high", key,
                      "Spans do not concatenate to full_text",
                      "Recompute the assembly; the proposal is internally inconsistent")

        covered = {k for s in spans for k in (s.get("criterion_keys") or [])}
        declared = set((p.get("coverage") or {}).get("criteria_uncovered") or [])
        miss = sorted(crit_keys - covered) if crit_keys else []
        if not miss:
            cover_ok += 1
        elif allow_declared_uncovered and set(miss) <= declared:
            # Work order C: an honest uncovered criterion IS the correct output, provided the
            # builder declared it rather than silently dropping it.
            cover_ok += 1
            R.finding("criterion_uncovered_declared", "medium", key,
                      f"criteria the builder declares uncovered: {', '.join(miss[:6])}",
                      "Permitted by the work order; confirm the published answer truly does not satisfy them")
        else:
            R.finding("criterion_uncovered", "high", key,
                      f"criteria with no span and not declared uncovered: {', '.join(miss[:6])}",
                      "Either recover/author coverage, or declare it in coverage.criteria_uncovered")

        invented = sorted(covered - crit_keys) if crit_keys else []
        if not invented:
            invent_ok += 1
        else:
            R.finding("invented_criterion", "high", key,
                      f"span tagged with criteria absent from the stored rubric: {', '.join(invented[:6])}")

        if require_verbatim_fields:
            bad = []
            for s in spans:
                prov = (s.get("provenance") or "")
                if forbid_drafted and prov == "drafted":
                    drafted_spans += 1
                if prov in NON_SOURCE_PROV:
                    continue   # joining whitespace / genuinely new text has no source to match
                if prov.startswith("recovered") or prov == "unchanged_from_prior_run" \
                   or s.get("source_field") in require_verbatim_fields:
                    src = resolve_source(truth, s, prior_by_version, items_by_key)
                    if src is None or norm(s.get("text", "")) not in norm(src):
                        bad.append(s.get("criterion_keys"))
            if not bad:
                verbatim_ok += 1
            else:
                R.finding("not_verbatim", "high", key,
                          f"{len(bad)} span(s) claim recovery but do not appear verbatim in the named source field",
                          "Check source_field/source_offset; recovered text must be character-exact")
        else:
            verbatim_ok += 1

        # Only meaningful when an item has 2+ criteria: removing the sole criterion of a
        # single-criterion item is *supposed* to leave nothing.
        empties = ([k for k in crit_keys
                    if not norm("".join(s.get("text", "") for s in spans
                                        if k not in (s.get("criterion_keys") or [])))]
                   if len(crit_keys) >= 2 else [])
        if not empties:
            removal_ok += 1
        else:
            R.finding("removal_empties_answer", "medium", key,
                      f"removing criterion {empties[0]} empties the whole answer",
                      "Open Hand would show a blank plate for that deselection")

    R.check(f"{label}: spans concatenate to full_text", n, concat_ok, concat_ok == n)
    R.check(f"{label}: every criterion covered", n, cover_ok, cover_ok == n)
    R.check(f"{label}: no invented criteria", n, invent_ok, invent_ok == n)
    R.check(f"{label}: recovered spans verbatim", n, verbatim_ok, verbatim_ok == n)
    R.check(f"{label}: removal never empties answer", n, removal_ok, removal_ok == n)
    if forbid_drafted:
        R.check(f"{label}: drafted spans (must be zero)", 0, drafted_spans, drafted_spans == 0)


# ----------------------------------------------------------------------------- per-order checks

def order_A(R, truth, run):
    items = [i for i in truth["items"] if i["subject_key"] == "biology" and i["item_type"] == "frq"]
    by_key = {i["content_key"]: i for i in items}
    packet = load_jsonl(need(run, "packet.jsonl"))
    prop = load_jsonl(need(run, "recovery_proposal.jsonl"))
    check_packet(R, packet, items, len(items), "packet")
    R.note("work order says 75 Biology FRQ", 75, len(items))

    graph = {k for k in by_key if "HDG-2026-GRAPH" in k}
    in_scope = [p for p in prop if p.get("content_key") not in graph]
    expect_in_scope = len(items) - len(graph)
    R.check("in-scope proposals", expect_in_scope, len(in_scope), len(in_scope) == expect_in_scope)
    R.note("work order says 71 in scope", 71, expect_in_scope)
    touched = sorted(graph & {p.get("content_key") for p in prop
                              if (p.get("spans") or p.get("full_text"))
                              and p.get("out_of_scope") is not True})
    R.check("graph items left out of scope", 0, len(touched), not touched, ", ".join(touched))
    for k in touched:
        R.finding("out_of_scope_item_processed", "high", k,
                  "Drawn-graph item was segmented; the work order puts it out of scope")

    prior_by_version = defaultdict(list)
    for v in truth["prior_versions"]:
        prior_by_version[v["version_id"]].append(v)
    check_spans(R, in_scope, by_key,
                require_verbatim_fields={"canonical_answer_1", "canonical_answer_2"},
                label="A", prior_by_version=prior_by_version,
                items_by_key={i["content_key"]: i for i in truth["items"]})

    # A was dispositioned (accepted, except S-073 a) before this check existed, so it reports
    # rather than fails. Work order F specifies the same thresholds as a hard gate.
    check_rubric_restatement(R, in_scope, by_key, label=" (A)", fail_run=False)

    # provenance ledger and the headline delta
    prov = Counter()
    for p in in_scope:
        for s in (p.get("spans") or []):
            prov[s.get("provenance", "unspecified")] += 1
    recovered = sum(v for k, v in prov.items() if str(k).startswith("recovered"))
    drafted = prov.get("drafted", 0)
    unchanged = prov.get("unchanged_from_prior_run", 0)
    print(f"\n  provenance: recovered={recovered}  drafted={drafted}  "
          f"unchanged_from_prior_run={unchanged}  other={sum(prov.values())-recovered-drafted-unchanged}")
    R.check("spans carry a provenance value", sum(prov.values()),
            sum(prov.values()) - prov.get("unspecified", 0), prov.get("unspecified", 0) == 0)

    # source_version_id must belong to the same item
    pv = defaultdict(set)
    for v in truth["prior_versions"]:
        pv[v["content_item_id"]].add(v["version_id"])
    bad = 0
    id_by_key = {i["content_key"]: i["content_item_id"] for i in items}
    all_version_ids = ({v["version_id"] for v in truth["prior_versions"]}
                       | {i["version_id"] for i in truth["items"]})
    for p in in_scope:
        cid = id_by_key.get(p.get("content_key"))
        for s in (p.get("spans") or []):
            sv = s.get("source_version_id")
            # A split child legitimately cites its PARENT item's version (S-101/102/103 -> L-025),
            # so "belongs to this item" is too strict; require only that the version exists.
            if (s.get("provenance") or "").startswith("recovered_parent"):
                if sv and sv not in all_version_ids:
                    bad += 1
                    R.finding("unknown_source_version", "high", p.get("content_key"),
                              f"parent recovery cites {sv}, which is not a known version")
                    break
                continue
            if sv and cid and sv not in pv[cid] and sv != by_key[p["content_key"]]["version_id"]:
                bad += 1
                R.finding("foreign_source_version", "high", p.get("content_key"),
                          f"span cites source_version_id {sv}, which is not a version of this item")
                break
    R.check("source_version_id belongs to the item", 0, bad, bad == 0)


def order_B(R, truth, run):
    items = [i for i in truth["items"] if i["subject_key"] == "ap-statistics" and i["item_type"] == "frq"]
    by_key = {i["content_key"]: i for i in items}
    packet = load_jsonl(need(run, "packet.jsonl"))
    prop = load_jsonl(need(run, "canonical_proposal.jsonl"))
    check_packet(R, packet, items, len(items), "packet")
    R.note("work order says 80 Statistics FRQ", 80, len(items))

    blank = {k for k, i in by_key.items()
             if not norm(i.get("canonical_answer_1")) and not norm(i.get("canonical_answer_2"))}
    R.note("work order says 46 blank-canonical", 46, len(blank))
    R.check("proposals produced", len(blank), len(prop), len(prop) == len(blank))

    out_touched = sorted({p.get("content_key") for p in prop} - blank)
    R.check("out-of-scope items untouched", 0, len(out_touched), not out_touched, ", ".join(out_touched[:5]))
    for k in out_touched:
        R.finding("out_of_scope_item_processed", "high", k,
                  "Item already had a canonical answer; work order B must not touch it")

    check_spans(R, prop, by_key, label="B")

    # every numeric value in full_text must be accounted for in derivations[]
    NUM = re.compile(r"(?<![\w.])\d+(?:\.\d+)?(?![\w.])")
    orphan_items = 0
    for p in prop:
        nums = set(NUM.findall(p.get("full_text", "")))
        derived = set()
        for d in (p.get("derivations") or []):
            derived |= set(NUM.findall(str(d.get("value", ""))))
        orphans = sorted(nums - derived)
        if orphans:
            orphan_items += 1
            R.finding("underived_number", "high", p.get("content_key"),
                      f"values in the answer with no entry in derivations[]: {', '.join(orphans[:8])}",
                      "A second model cannot re-derive these; treat the arithmetic as unverified")
    R.check("every number appears in derivations[]", len(prop), len(prop) - orphan_items, orphan_items == 0)

    # the rubric-restatement trap this work order was patched to close
    TRAP = re.compile(r"to earn this point|make sure your response|DRAFT PROPOSAL", re.I)
    trapped = [p.get("content_key") for p in prop if TRAP.search(p.get("full_text", ""))]
    R.check("no rubric-instruction phrasing in answers", 0, len(trapped), not trapped, ", ".join(trapped[:4]))
    for k in trapped:
        R.finding("rubric_restatement_reused", "high", k,
                  "Answer contains second-person rubric-instruction phrasing; this is a restatement, not a student answer",
                  "Compare against bio_stats_topic_tagging_2026_09_22/frq_canonical_review.csv")


def order_C(R, truth, run):
    items = [i for i in truth["items"] if i["subject_key"] == "ap-statistics" and i["item_type"] == "frq"]
    by_key = {i["content_key"]: i for i in items}
    packet = load_jsonl(need(run, "packet.jsonl"))
    prop = load_jsonl(need(run, "segmentation_proposal.jsonl"))
    check_packet(R, packet, items, len(items), "packet")
    R.note("work order says 80 Statistics FRQ", 80, len(items))

    have = {k for k, i in by_key.items()
            if norm(i.get("canonical_answer_1")) or norm(i.get("canonical_answer_2"))}
    R.note("work order says 34 existing-answer", 34, len(have))
    R.check("proposals produced", len(have), len(prop), len(prop) == len(have))

    out_touched = sorted({p.get("content_key") for p in prop} - have)
    R.check("work order B's items untouched", 0, len(out_touched), not out_touched, ", ".join(out_touched[:5]))
    for k in out_touched:
        R.finding("scope_collision", "high", k,
                  "Item belongs to work order B; C must not segment it")

    prior_by_version = defaultdict(list)
    for v in truth["prior_versions"]:
        prior_by_version[v["version_id"]].append(v)
    check_spans(R, prop, by_key,
                require_verbatim_fields={"canonical_answer_1", "canonical_answer_2"},
                forbid_drafted=True, label="C", prior_by_version=prior_by_version,
                items_by_key={i["content_key"]: i for i in truth["items"]},
                allow_declared_uncovered=True)

    # every non-blank canonical_answer_2 must survive verbatim in the assembly
    lost = []
    for p in prop:
        t = by_key.get(p.get("content_key"), {})
        ca2 = norm(t.get("canonical_answer_2"))
        if ca2 and ca2 not in norm(p.get("full_text", "")):
            lost.append(p.get("content_key"))
    R.check("canonical_answer_2 preserved verbatim", 0, len(lost), not lost, ", ".join(lost[:4]))
    for k in lost:
        R.finding("ca2_dropped", "high", k,
                  "Non-blank canonical_answer_2 does not appear in the assembled answer",
                  "This is the exact defect the accepted Biology run had to fix")


def order_D(R, truth, run):
    subs = ("ap-calculus-ab", "ap-chemistry")
    items = [i for i in truth["items"] if i["subject_key"] in subs]
    by_key = {i["content_key"]: i for i in items}
    packet = load_jsonl(need(run, "packet.jsonl"))
    check_packet(R, packet, items, len(items), "packet")
    R.note("work order says 241 items", 241, len(items))

    with open(need(run, "topic_labels_proposal.csv"), encoding="utf-8") as f:
        prop = list(csv.DictReader(f))
    R.check("one row per published item", len(items), len(prop), len(prop) == len(items))
    dups = [k for k, v in Counter(r.get("content_key") for r in prop).items() if v > 1]
    R.check("no duplicate rows", 0, len(dups), not dups, ", ".join(dups[:4]))

    CL = {(c["subject_key"], c["topic_code"]): c for c in truth["closed_list"]}
    invalid = unit_bad = foreign = undetermined = 0
    for r in prop:
        k = r.get("content_key"); s = r.get("subject_key", "").strip()
        code = (r.get("proposed_topic_code") or "").strip()
        if s not in subs:
            foreign += 1
            R.finding("out_of_scope_subject", "high", k, f"subject {s!r} is not in work order D's scope")
            continue
        if code == "undetermined":
            # A permitted sentinel, not a code: the builder is declaring it cannot determine a
            # topic from the available fields. That is a better output than a confident wrong
            # code, so it is counted separately rather than failing closed-list validity.
            undetermined += 1
            if (r.get("needs_human") or "").strip().lower() not in ("true", "1", "yes"):
                R.finding("undetermined_not_routed", "medium", k,
                          "proposed_topic_code is 'undetermined' but needs_human is not true")
            continue
        c = CL.get((s, code))
        if not c:
            invalid += 1
            R.finding("topic_code_not_in_closed_list", "high", k,
                      f"{s} code {code!r} is not in that subject's closed list",
                      "Selection-only was violated; an invalid code is a pipeline defect")
            continue
        if str(c["unit_number"]) != str(r.get("proposed_unit", "")).strip():
            unit_bad += 1
            R.finding("unit_topic_mismatch", "high", k,
                      f"proposed_unit {r.get('proposed_unit')} but {code} is unit {c['unit_number']}")
    R.check("every code in the closed list (excl. 'undetermined')", 0, invalid, invalid == 0)
    R.note("items declared 'undetermined'", "0 or more", undetermined,
           "a permitted sentinel; high counts mean the evidence fields were thin, not that the run failed")
    R.check("unit matches the code's registry unit", 0, unit_bad, unit_bad == 0)
    R.check("no out-of-scope subjects", 0, foreign, foreign == 0)

    # recovered rows must equal the author's own parsed code
    rec_bad = 0
    rec = [r for r in prop if (r.get("basis") or "").strip() == "recovered_author_code"]
    for r in rec:
        t = by_key.get(r.get("content_key"), {})
        m = re.match(r"\s*(\d+\.\d+)", t.get("prompt_topic") or "")
        if not m or m.group(1) != (r.get("proposed_topic_code") or "").strip():
            rec_bad += 1
            R.finding("recovery_mismatch", "high", r.get("content_key"),
                      "row claims recovered_author_code but the code differs from prompt_json.topic")
    R.check("recovered rows match prompt_json.topic", 0, rec_bad, rec_bad == 0)
    R.note("work order says 106 recoverable", 106, len(rec))

    conc = Counter((r.get("subject_key"), r.get("proposed_topic_code")) for r in prop)
    top = conc.most_common(3)
    print("\n  topic concentration (top 3): " + ", ".join(f"{s} {c}: {n}" for (s, c), n in top))
    for (s, c), n in top:
        share = n / max(1, sum(v for (ss, _), v in conc.items() if ss == s))
        if share > 0.25:
            R.finding("topic_concentration", "low", f"{s} {c}",
                      f"{n} items ({share:.0%} of the subject) share one topic code",
                      "DIAGNOSTIC ONLY, not proof of error: check whether a template family "
                      "defaulted here, but do not move correct labels to flatten the distribution")


def order_F(R, truth, run):
    """Work order F — AP Biology, the 88 criteria A left drafted.

    Added 2026-09-23. An earlier version of F's text claimed this harness already enforced its
    anti-restatement threshold; it did not -- there were modes for A-D only, and the similarity
    routine ran against A in report-only mode. Codex caught the discrepancy before executing.
    Here the threshold is a real gate: unlike A, F was written knowing the rule.
    """
    items = [i for i in truth["items"] if i["subject_key"] == "biology" and i["item_type"] == "frq"]
    by_key = {i["content_key"]: i for i in items}
    packet = load_jsonl(need(run, "packet.jsonl"))
    prop = load_jsonl(need(run, "canonical_proposal.jsonl"))
    check_packet(R, packet, items, len(items), "packet")

    graph = {k for k in by_key if "HDG-2026-GRAPH" in k}
    in_scope = [p for p in prop if p.get("content_key") not in graph]
    check_spans(R, in_scope, by_key, label="F",
                items_by_key={i["content_key"]: i for i in truth["items"]})

    # the gate F was written around
    check_rubric_restatement(R, in_scope, by_key, label=" (F)", fail_run=True)

    # DECISION-0056: every removal must be auditable, and each removed span must have really
    # existed in Production. A removal that cannot be traced is worse than one not made.
    rem_path = os.path.join(run, "removals.csv")
    if os.path.exists(rem_path):
        with open(rem_path, newline="") as f:
            rows = list(csv.DictReader(f))
        bad = 0
        for row in rows:
            key, text = row.get("content_key"), row.get("removed_text") or ""
            truth_item = by_key.get(key) or {}
            sources = [truth_item.get("canonical_answer_1") or "", truth_item.get("canonical_answer_2") or ""]
            if not text.strip() or not any(text in s for s in sources):
                bad += 1
                R.finding("unverifiable_removal", "high", key,
                          "removals.csv row whose removed_text is not present verbatim in either "
                          "Production canonical field",
                          "DECISION-0056 allows removing only prose a new span supersedes; an "
                          "untraceable removal breaks its audit trail")
            if not (row.get("source_version_id") or "").strip():
                bad += 1
                R.finding("removal_missing_provenance", "medium", key,
                          "removals.csv row with no source_version_id",
                          "DECISION-0056 requires provenance on every removal")
        R.check("every logged removal is traceable to Production", 0, bad, bad == 0,
                f"{len(rows)} removals logged")
    else:
        R.check("removals.csv present (DECISION-0056 audit trail)", "optional", "absent", True,
                "no removals claimed; acceptable — the exception is permissive, not mandatory")


ORDERS = {"A": order_A, "B": order_B, "C": order_C, "D": order_D, "F": order_F}


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--order", required=True, choices=sorted(ORDERS))
    ap.add_argument("--truth", required=True, help="directory with items.json, prior_versions.json, closed_list.json")
    ap.add_argument("--run", required=True, help="the work order's output directory")
    ap.add_argument("--out", default=None, help="where to write qa_findings.csv (default: --run)")
    a = ap.parse_args()

    try:
        truth = {"items": load_json(os.path.join(a.truth, "items.json")),
                 "prior_versions": load_json(os.path.join(a.truth, "prior_versions.json")),
                 "closed_list": load_json(os.path.join(a.truth, "closed_list.json"))}
    except FileNotFoundError as e:
        raise SystemExit(f"truth snapshot incomplete: {e}\nRun scripts/qa/overnight_qa_truth.sql first.")

    if not os.path.isdir(a.run):
        raise SystemExit(f"run directory does not exist: {a.run}\n"
                         f"If the work order never executed, that is itself the finding.")

    R = Results()
    ORDERS[a.order](R, truth, a.run)
    R.report(a.order, a.run, a.out or a.run)
    return 1 if R.failed else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except SystemExit:
        raise
    except Exception as e:  # a harness bug must not be mistaken for a clean run
        print(f"HARNESS ERROR: {type(e).__name__}: {e}", file=sys.stderr)
        sys.exit(2)
