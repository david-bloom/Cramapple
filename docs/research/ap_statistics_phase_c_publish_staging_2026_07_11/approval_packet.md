# AP Statistics Phase C Publish Approval Packet

**Decision sentence:** Approving this packet authorizes running the staged `admin-content` draft `bulk_import` payload for 100 MCQ + 100 FRQ AP Statistics calibration items; it does **not** publish anything automatically, and the later `publish` operation remains a separate explicit action.

## 1. Decisions Needed

| risk | item / issue | ambiguity or finding | recommended resolution |
| --- | --- | --- | --- |
| high | Manifest R3 schema drift | manifest.json still stores deterministic_check_targets as integer 3 | Approve staging but fix manifest metadata before treating package metadata as schema-clean. |
| high | admin-content rights_record inline insert | rights_records.source_version_id is required, but bulk create_draft does not connect newly inserted source_records to rights_records | Run draft import without inline rights_record; keep Product Owner approval in this packet and do not publish until rights/source gate is explicitly accepted. |
| medium | APSTAT-MOD3-H001-INV r2 ci_calculation | flag vs earned | Response recomputes 120/sqrt(30) and gives (807, 893), which is arithmetically correct within rounding; deterministic flag is too strict because the SE value is not separately stated. |
| medium | APSTAT-MOD4-H001-INV r1 hypothesis_test_execution | flag vs earned | Exact SE is about 1.56 and t is about -2.56; the response's 't approx -2.5' is arithmetically acceptable, so the deterministic flag is a missing-exact-SE artifact. |
| medium | APSTAT-MOD6-M001 r1 margin_of_error | pass vs partially_earned | n approx 384 is the standard conservative 95%/5% sample-size result; partial provisional credit appears to reflect missing explanation rather than arithmetic error. |
| medium | APSTAT-MOD6-M001 r3 margin_of_error | pass vs not_earned | n approx 385 is arithmetically correct for the margin calculation; the not-earned label likely conflates this criterion with the separate bad sampling-design response. |
| medium | APSTAT-MOD6-H001 r1 test_calculation | flag vs earned | Exact SE is about 1.94 and \|t\| is about 2.06; the response's '2.0 to 2.1' is a reasonable rounded statistic, so the deterministic flag is too exacting for prose. |
| medium | APSTAT-MOD7-M005 r1 expected_value | pass vs not_earned | The keyed value 5 appears only inside a guess list ('4, 5, or 6'), not as a computed expected value; provisional not-earned is more likely correct. |
| medium | APSTAT-MOD7-H001 r2 calculation | pass vs partially_earned | P(D)=0.023 and P(B\|D) approx 0.65 are the keyed arithmetic values; provisional partial may be under-crediting a terse but numerically correct calculation. |
| medium | APSTAT-MOD8-M002 r1 r_squared_interpretation | pass vs not_earned | 0.64 is present, but the interpretation says x explains x's variance instead of response-variable variance; provisional not-earned is more likely correct. |
| medium | APSTAT-MOD8-M004 r1 slope_interpretation | pass vs not_earned | The slope value 3 is present, but the interpretation is not contextual rate-of-change language; provisional not-earned is more likely correct. |
| medium | STATS-MOD1-E004 r1 mean_calculation | pass vs not_earned | 18 appears as one raw data value, but the response divides by 4 and gives 22.5; provisional not-earned is more likely correct. |

### Existing 30-Row Adjudication Queue

| priority | response | type | ambiguity | recommended action |
| --- | --- | --- | --- | --- |
| medium | APSTAT-MOD3-H001-INV r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD3-H001-INV r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD3-H001-INV r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |
| medium | APSTAT-MOD4-H001-INV r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD4-H001-INV r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD4-H001-INV r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |
| medium | APSTAT-MOD5-H001-INV r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD5-H001-INV r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD5-H001-INV r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |
| medium | APSTAT-MOD6-M001 r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD6-M001 r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD6-M001 r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |
| medium | APSTAT-MOD6-H001 r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD6-H001 r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD6-H001 r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |
| medium | APSTAT-MOD6-H002-INV r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD6-H002-INV r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD6-H002-INV r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |
| medium | APSTAT-MOD7-H001 r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD7-H001 r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD7-H001 r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |
| medium | APSTAT-MOD7-H002-INV r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD7-H002-INV r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD7-H002-INV r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |
| medium | APSTAT-MOD8-H001 r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD8-H001 r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD8-H001 r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |
| medium | APSTAT-MOD8-VH001 r1 | borderline | Near-boundary response with mixed criterion labels | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| medium | APSTAT-MOD8-VH001 r2 | partially_correct | Concise-but-partial response that may be under-credited | Confirm the minimum-fix threshold / evidence quote for the ambiguous criteria |
| high | APSTAT-MOD8-VH001 r3 | subtly_wrong | Subtle error or deterministic miss | Confirm whether any criterion should be upgraded from not_earned to partial before gold promotion |

## 2. Coverage Summary

### Staged Item Counts

| unit | count |
| --- | --- |
| MCQ items staged | 100 |
| FRQ items staged | 100 |
| Total staged draft items | 200 |
| Known published source-key collisions renamed in payload | 18 |

### MCQ Module Distribution

| module | count |
| --- | --- |
| 1 | 11 |
| 2 | 11 |
| 3 | 11 |
| 4 | 11 |
| 5 | 11 |
| 6 | 11 |
| 7 | 11 |
| 8 | 11 |
| 9 | 12 |

### MCQ Difficulty Distribution

| difficulty | count |
| --- | --- |
| Easy | 12 |
| Hard | 42 |
| Medium | 43 |
| Very Hard | 3 |

### FRQ Module Distribution

| module | count |
| --- | --- |
| 1 | 11 |
| 2 | 1 |
| 3 | 15 |
| 4 | 16 |
| 5 | 6 |
| 6 | 15 |
| 7 | 16 |
| 8 | 10 |
| 9 | 10 |

### FRQ Difficulty Distribution

| difficulty | count |
| --- | --- |
| easy | 15 |
| hard | 44 |
| medium | 35 |
| very_hard | 6 |

### FRQ Form Distribution

| form | count |
| --- | --- |
| long | 10 |
| short | 90 |

### Deterministic Coverage

| bucket | FRQ items |
| --- | --- |
| non-conceptual deterministic key | 28 |
| conceptual-only | 68 |
| excluded/method-only | 4 |
| unresolved suspected key gap | 0 |

### D1 Sample Check

| sample | result |
| --- | --- |
| deterministic key validation | 44/44 integrity; 7/7 ECF |
| adjudication queue carried forward | 30 rows |
| additional unqueued/unkeyed spot sample | 18/18 pass |
| new label changes made by Codex | 0 |

## 3. Approval Checklist

- [ ] Approve staging the MCQ bank as draft content (100 items; 18 source-key collisions renamed with `-CAL` in the payload).
- [ ] Approve staging FRQ items for modules 1-3 as draft content.
- [ ] Approve staging FRQ items for modules 4-6 as draft content.
- [ ] Approve staging FRQ items for modules 7-9 as draft content.
- [ ] Accept the listed 30-row adjudication queue as Product Owner review notes for this one-reviewer packet.
- [ ] Accept the R3 manifest metadata drift as non-blocking for draft staging, or request metadata cleanup before running `bulk_import`.
- [ ] Confirm that running `publish` after draft import remains a separate explicit Product Owner action.
