# Reference Pack Production Parity and Hook Help Policy — 2026-10-12

STATUS: CURRENT
DATE: 2026-10-12 (America/New_York)
OWNER: Codex / Product Owner David Bloom
BRANCH: `codex/hook-help-policy`
PR: https://github.com/david-bloom/Cramapple/pull/426
GOVERNING DECISION: `DECISION-0118` / `APPROVAL-0164`
SCOPE: Read-only content verification and documentation of the owner-approved placement rule.

## Direction and outcome

David directed: "All reference packs should be in production. Update the rule about using hooks and hints."

All currently published reference packs already match between Development (`wmgjsdkphcyhngaffbqf`)
and Production (`pcntajvbdfqhbeewmdry`). No load, migration, RPC change, function deployment, or
frontend publication was needed or performed. The earlier chat answer relied on an outdated build
handoff; `APPROVAL-0154` records the later Production promotion.

## Live evidence

Two read-only inventory queries returned the same 33 subject-unit groups, published entry/hook counts,
and content hashes. A separate Production query independently confirmed **1083 published reference
entries and 13 published hooks**. No student records or authentication data were read.

| Stored subject | Published units | Entries | Hooks |
| --- | --- | ---: | ---: |
| ap_biology | 1, 2, 3 | 95 | 0 |
| ap_calculus_ab | 1, 2, 3 | 51 | 2 |
| ap_chemistry | 1, 2, 3, 4, 5, 6, 7, 8, 9 | 227 | 4 |
| ap_physics_1 | 1, 2, 3 | 99 | 3 |
| ap_physics_2 | 9, 10, 11 | 102 | 0 |
| ap_physics_c_em | 8, 9, 10 | 69 | 0 |
| ap_physics_c_mechanics | 1, 2, 3 | 113 | 0 |
| ap_precalculus | 1, 2, 3 | 145 | 2 |
| ap_statistics | 1, 2, 3 | 182 | 2 |
| **Total** | **33 subject-unit groups** | **1083** | **13** |

Production also has `ap_calculus_bc → ap_calculus_ab` in `app.subject_reference_aliases`, units 1–8.
BC does not need duplicate rows. Both demo formula entries are published in Production:
Calculus AB 2.1 "Average rate of change as a difference quotient" and Chemistry 3.7 "Molarity"
(Chemistry also has a 4.5 molarity entry).

Equality covers the published reference content and published hooks, not unpublished drafts, all-course
coverage, figure-renderer parity, or signed-in delivery of a new help template. Chemistry covers units 1–9;
other stored subjects cover their first three registry units.

### Reproducible query

```sql
select r.subject_key,r.unit_number,count(*) as reference_entries,count(*) filter(where r.kind='formula') as formulas,count(h.memory_hook_id) as hooks,md5(string_agg(md5(jsonb_build_array(r.owner_topic_code,r.topic_codes,r.kind,r.title,r.body,r.items,r.visual_asset_ref,r.caution)::text),'' order by r.owner_topic_code,r.kind,r.title,r.body)) as reference_hash,md5(coalesce(string_agg(md5(jsonb_build_array(r.owner_topic_code,r.title,h.kind,h.hook_text,h.expands_to,h.when_to_use,h.caution)::text),'' order by r.owner_topic_code,r.title,h.hook_text) filter(where h.memory_hook_id is not null),'')) as hook_hash from app.unit_reference_entries r left join app.topic_memory_hooks h on h.reference_entry_id=r.reference_entry_id and h.status='published' where r.status='published' group by r.subject_key,r.unit_number order by r.subject_key,r.unit_number;
```

The reference digest includes owner topic, reuse topics, kind, title, body, items, visual reference, and
caution. The hook digest includes its reference's owner/title, kind, text, expansion, when-to-use, and
caution. UUIDs, timestamps, and provenance are excluded from the content comparison. Per-unit returned
digests are retained in `REFERENCE_PACK_PARITY_2026_10_12.json`.

## Approved placement rule

- Relevant, checked, published hooks may appear in hints, post-miss feedback, and student-requested
  "I don't get it" / "I'm stuck" help, as well as the existing study/reference surfaces.
- They remain linked to a published reference entry; expansion, conditions, and cautions accompany the
  recall aid. No suitable hook means omit it; this does not authorize unchecked generated hooks.
- Pre-submission use is still assistance under `APPROVAL-0130` and `DECISION-0074`; post-submission
  help does not retroactively change the submitted attempt's independence.
- Existing Practice answer-disclosure, unscored Worked Example, and ungraded BYOQ boundaries apply.

The rule supersedes `DECISION-0104` D5 only. It is not approval to build or deploy the new template/agent.

## Closeout

Protocol, proposal, TASK-0066, decision/approval/activity logs, the index, and the outdated handoff now
point to the amendment and verified Production state. Documentation checks: `git diff --check`,
cross-reference existence, and targeted searches for the former exclusion. Unrelated local changes in
the primary checkout were not included.

**Next owner / action:** the implementation owner, when the help-template slice is approved, should
select relevant reference entries/hooks and wire existing assistance recording into that surface.
The content-placement rule needs no further owner confirmation. Production releases retain their
normal gates.
