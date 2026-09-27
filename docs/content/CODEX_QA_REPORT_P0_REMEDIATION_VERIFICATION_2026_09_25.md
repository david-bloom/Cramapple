# Codex QA Report — P0 Remediation Verification (2026-09-25)

**Task:** `docs/content/CODEX_QA_TASK_P0_REMEDIATION_VERIFICATION_2026_09_25.md`  
**Production:** `pcntajvbdfqhbeewmdry`  
**Branch:** `codex/qa-p0-remediation-verification-2026-09-25`  
**Base:** `main` at `2e68589f49cda5039819ba737dbd693515c4a863`  
**Mode:** read-only Production QA. No Production writes were made.

## Verdict

**FAIL — 32 of 34 original P0 findings are genuinely closed; 2 remain open at P0 severity.**

The two unresolved items are:

1. **`apphy1-frq-026`** — the corrected canonical and `learner_facing_text` now correctly state that arrival order is not determined by the qualitative track description, but the same rubric row's `evidence_requirements` still requires the response to “conclude Track A finishes first.” The original false grading requirement therefore still survives in Production.
2. **`apstats-frq-u12-020`** — changing South's reported SD from 3.1 to 5.8 removes the original mathematical impossibility, but the rewritten part (c) and `part-c-criterion-03` are wrong. From the corrected pre-error summary itself, replacing 40 by 8 forces the corrected South sample SD to about **3.735**, which is still **larger** than North's 3.1. The canonical says it could be “close to, or even below” 3.1, while the rubric says it “would be smaller than North's SD”; both are false.

No other corrected item failed independent stem-first re-derivation.

## Highest-consequence verification

### Group 1 — rubric-level fixes

#### `apcalcab-frq-005` — VERIFIED CLOSED

The stimulus is (x^2+xy+2y^2=16). Independent implicit differentiation gives

[
2x+y+xy'+4yy'=0,qquad
y'=-\frac{2x+y}{x+4y}.
]

At ((2,2)), (y'=-6/10=-3/5); the normal slope is (5/3). The current rubric no longer states the wrong constant 14. Canonical, rubric, and stimulus now agree.

#### `apphy1-frq-026` — PARTIALLY FIXED, P0 REMAINS

Energy conservation correctly gives both sleds the same final speed,

[
v_f=\sqrt{2g\Delta h}.
]

Travel time requires (t=\int ds/v), so endpoint energy alone is insufficient.

For a concrete counterexample, model Track A as a straight descent over the first half of horizontal span (L), followed by a flat segment, and Track B as a straight uniform descent over the full span. Let (r=h/L). Then

[
\frac{t_A\sqrt{gh}}{L}
=
\sqrt2\sqrt{r^2+\tfrac14}
+
\frac{1}{2\sqrt2},
]

while

[
\frac{t_B\sqrt{gh}}{L}
=
\sqrt2\sqrt{r^2+1}.
]

The times cross at (r\approx1.281). For (h/L=2), the normalized values are approximately (3.269) for A and (3.162) for B, so **Track A is slower**. Thus the corrected canonical's “not determined in general” conclusion is correct.

However, Production's `b-time` rubric row is internally contradictory:
- `learner_facing_text` correctly says the winner depends on track geometry;
- `evidence_requirements` still says the response must “conclude Track A finishes first.”

Because grading evidence can still enforce the original false answer, this P0 is not closed.

## Group 4 — numerical/source-data fixes

### `APSTAT-MOD4-H001-INV` — VERIFIED CLOSED

Independent recomputation:

[
t=\frac{68-72}{\sqrt{6^2/25+5^2/25}}
=-2.56074.
]

Welch-Satterthwaite (df\approx46.488). For the stated one-sided lower-tail alternative,

[
p\approx0.006877,
]

so (p\approx0.007) is correct. The stem, canonical, and rubric now agree; the reject-at-0.05 conclusion is unchanged.

### `apstats-frq-u12-020` — PARTIALLY FIXED, NEW P0

With (n=40), mean (12.4), and corrected sample SD (5.8),

[
SS=(n-1)s^2=39(5.8^2)=1311.96.
]

The single 40-pound observation contributes

[
(40-12.4)^2=761.76,
]

leaving (550.20) squared-deviation units for the other observations. Unlike the old SD=3.1 summary, the corrected SD=5.8 is no longer mathematically impossible.

But part (c) can be computed exactly from the corrected summary statistics. Before correction:

[
\sum x=40(12.4)=496,
]

[
\sum x^2=(39)(5.8^2)+40(12.4^2)=7462.36.
]

Replacing 40 with 8 gives

[
\sum x'=464,quad \bar x'=11.6,
]

[
\sum {x'}^2=7462.36-40^2+8^2=5926.36.
]

Therefore

[
{s'}^2
=
\frac{5926.36-40(11.6^2)}{39}
\approx13.9477,
]

so

[
s'\approx3.735.
]

That is **still above North's 3.1**, not “even below” it. The spread gap shrinks from (5.8-3.1=2.7) to about (3.735-3.1=0.635); the facilities become **more similar in spread**, not less.

Current defects:
- canonical says corrected South SD could be “close to, or even below” North's 3.1;
- canonical later says spread is “shown to differ more than originally reported,” contradicting the preceding paragraph and the exact calculation;
- `part-c-criterion-03` still says corrected South SD “would be smaller than North's SD” and refers to the old “identical originally reported SDs (3.1 each).”

The original impossible-summary defect is fixed, but the remediation introduced a new P0 in the answer/rubric comparison.

## Item-by-item verification

| content_key | Group | Fix resolves original finding? | Severity now | Independent note |
| --- | ---: | --- | --- | --- |
| `apcalcab-frq-005` | 1 | Yes | — | Constant/rubric corrected; independent derivative, slope, and normal line all agree. |
| `apphy1-frq-026` | 1 | **Partially** | **P0** | Canonical and learner-facing rubric text are correct; `evidence_requirements` still wrongly requires “Track A finishes first.” |
| `apchem-frq-l-005` | 2 | Yes | — | Deleted mechanism criteria were not asked by stem parts (b)/(d); remaining 8 criteria fully cover requested rate-law design/net-rate work. |
| `apphycem-frq-np1-002` | 3 | Yes | — | Concentric spherical shells require spherical symmetry; stem now says spherical and canonical/rubric already use it correctly. |
| `APSTAT-MOD4-H001-INV` | 4 | Yes | — | Independent Welch one-sided p-value = 0.006877 ≈ 0.007. |
| `apstats-frq-u12-020` | 4 | **Partially** | **P0** | SD=5.8 removes impossibility, but exact corrected SD is ≈3.735; canonical/rubric spread comparison is wrong/stale. |
| `apphy1-frq-054` | 5 | Yes | — | (v_{0x}=25\cos40^\circ\approx19.15\) m/s now present; remaining projectile calculations are correct. |
| `apphycem-frq-038` | 5 | Yes | — | (\vec v\times\vec B) drives conventional current along +transverse direction in the rod; viewed from above, loop current is counterclockwise and gives upward induced field. |
| `apchem-frq-l-002` | 6 | Yes | — | Formal charges +1 central, 0 double-bond terminal, −1 single-bond terminal now explicit; resonance/geometry/bond-order discussion correct. |
| `apchem-frq-l-003` | 6 | Yes | — | (n\approx0.0699) mol; ideal assumptions, independently determined (n), and Z test now complete and correct. |
| `apchem-frq-l-004` | 6 | Yes | — | 0.00300 mol AgCl, 1:1 stoichiometry/completion assumption, gravimetry, and error directions correct. |
| `apchem-frq-l-006` | 6 | Yes | — | (c=4.19\) J g⁻¹ K⁻¹; conservation assumption, verification procedure, and heat-loss direction now covered. |
| `apchem-sfrq-008` | 6 | Yes | — | (s=2.0\times10^{-6}) M in pure water; no-common-ion assumption and common-ion calculation are correct. |
| `apchem-sfrq-009` | 6 | Yes | — | Small-x derivation/check and exact dilute quadratic root (~(2.7\times10^{-5}) M) are correct. |
| `apphy1-frq-014` | 6 | Yes | — | Doubling height gives (\sqrt2) speed factor; rolling-energy derivation and no-dissipation assumptions now explicit. |
| `apphy1-frq-019` | 6 | Yes | — | Vector construction, 5.0 m/s at 37° E of N, 30 s crossing, and 90 m drift all correct. |
| `apphy1-frq-022` | 6 | Yes | — | Critical-angle procedure, controls, uncertainty reduction, and (\mu_s=\tan\theta_c) derivation now complete. |
| `apphy1-frq-029` | 6 | Yes | — | Correctly separates momentum conservation during impact from mechanical energy during rise; (v_f\approx2.97) m/s, pellet ~149 m/s. |
| `apphy2-frq-002` | 6 | Yes | — | Midpoint fields cancel; scalar potentials add to ~(1.80\times10^5) V; superposition explanation now complete. |
| `apphy2-frq-003` | 6 | Yes | — | (RC=2.00) s and charging exponential correct; KVL differential-equation/initial-condition explanation now present. |
| `apphy2-frq-017` | 6 | Yes | — | (v_{rms}) ratio 2 and per-molecule KE ratio 4; gas amount irrelevance now explicitly justified. |
| `apphy2-frq-019` | 6 | Yes | — | Clockwise P–V cycle description, hottest vertex, (W_{net}=Q_{net}=2P_0V_0) all correct. |
| `apphy2-frq-023` | 6 | Yes | — | 6 Ω equivalent, 2 A total, 1 A branches, powers, junction and loop checks all correct. |
| `apphy2-frq-028` | 6 | Yes | — | Two valid principal rays now described; real, inverted, enlarged image beyond C is correct. |
| `apphy2-frq-032` | 6 | Yes | — | n=4→2 diagram and (2.55) eV, (6.16\times10^{14}) Hz, ~487 nm values are correct. |
| `apphycm-frq-003` | 6 | Yes | — | Stable equilibria (\pm\sqrt{b/(2a)}); (U''=4b) gives (\omega=2\sqrt{b/m}). |
| `apphycm-frq-008` | 6 | Yes | — | (a=2\alpha t), (x=\alpha t^3/3), graph slope/area meaning, and (\bar v=\alpha T^2/3) comparison are correct. |
| `apphycm-frq-019` | 6 | Yes | — | FBD now explicitly contains only tension and weight; conical-pendulum equations and period are correct. |
| `apphycm-frq-026` | 6 | Yes | — | Momentum vectors/components, elastic-energy equation, perpendicularity proof, and 30°/60° speeds are complete. |
| `apphycem-frq-008` | 6 | Yes | — | Exponential V graph behavior and (E_x=-dV/dx=(V_0/L)e^{-x/L}) interpretation are correct. |
| `apphycem-frq-009` | 6 | Yes | — | Experimental design now varies d, measures C, and holds A/ε fixed; closes the original missing-procedure finding. |
| `apphycem-frq-011` | 6 | Yes | — | Background subtraction/current reversal and return-path/end-effect controls are now explicit; B vs 1/r model is correct. |
| `apphycem-frq-017` | 6 | Yes | — | (dq=(Q/2\pi)d\phi), transverse cancellation, axial integral/result, and limits are correct. |
| `APSTATS-HDG-2026-GRAPH-005` | 6 | Yes | — | Independent least-squares fit gives slope ≈5.883, intercept ≈60.05, (r\approx0.773); stated line through about (0,60) and (5,90) is reasonable. |

## Span integrity on remediated items

Five of the 34 current versions have `canonical_answer_spans`:
- `APSTAT-MOD4-H001-INV`
- `apstats-frq-u12-020`
- `apphy1-frq-054`
- `apphycem-frq-038`
- `apphycem-frq-np1-002`

For all five:
- span concatenation equals current `canonical_answer_1` exactly;
- covered criterion-key set equals the current `frq_criteria` key set exactly.

The remaining remediated legacy items had no spans before this pass; that known segmentation debt is not treated as a new defect.

## Part B — no-collateral-damage check

### Timestamp-window correction

The task proposed a full-platform window beginning at 07:00 UTC. That window is not specific to remediation: Production contains **104** `content_item_versions.updated_at` rows from 07:00 onward.

They partition cleanly:
- **71 rows / 71 keys from 07:00 to 11:23 UTC** — the earlier canonical-authoring work that preceded this remediation;
- **33 rows / 33 keys from 11:23 UTC onward** — the remediation's content-version/stem/canonical writes.

The first remediation write occurred at 11:23:02 UTC, so 11:23 UTC is the evidence-based remediation boundary rather than an invented cutoff.

### Remediation-period result

From 11:23 UTC onward:
- 33 content-version rows changed;
- all 33 map to the 34-item remediation set;
- there are **zero unexpected content keys**;
- the only remediation item without a content-version update is `apcalcab-frq-005`, which was rubric-only as expected;
- no new span rows were created after 11:23 UTC.

No collateral `content_item_versions` write was found.

### Rubric/span audit limitation

`canonical_answer_spans` exposes `created_at` but no `updated_at`; `frq_criteria` exposes `created_at` but no `updated_at` or deletion timestamp. Therefore timestamp queries cannot independently prove absence of collateral UPDATE/DELETE operations on those tables.

Current-state checks provide the available independent evidence:
- all five span-bearing remediated items retain exact canonical concatenation and exact criterion-key coverage;
- `apchem-frq-l-005` now has 8 criteria, and the two removed mechanism criteria were correctly out of stem scope;
- `apcalcab-frq-005` current rubric is corrected;
- `apphy1-frq-026` current rubric exposes the remaining stale-evidence P0 described above.

No observable collateral damage was found, but criteria/span UPDATE/DELETE absence cannot be proven from timestamps alone with the current schema.

## Part C — untouched-item spot check

Fifteen non-remediation items, spanning all seven subjects, were checked. Every sampled current version's `updated_at` precedes the first remediation write at 11:23 UTC, so none of their `canonical_answer_1` rows were modified by the remediation.

| content_key | current version | last updated UTC | canonical MD5 |
| --- | ---: | --- | --- |
| `apcalcab-frq-024` | 2 | 01:23:19 | `3fca1fc7f1b029cfff39645383d48bdb` |
| `apcalcab-frq-027` | 1 | 2026-08-07 | `813cf8fc316044760306a4d9fb1a2967` |
| `apchem-frq-l-010` | 5 | 2026-08-12 | `5f92d78c5dd274417b02b315b78bdf13` |
| `apchem-sfrq-002` | 3 | 2026-08-05 | `7710064cce5bcc2beaab1112925d8854` |
| `apphy1-frq-033` | 3 | 10:28:00 | `cb8e2213dfeb49d55a4622b6067681a5` |
| `apphy1-frq-035` | 2 | 10:28:00 | `96e58439c4a0981e5e8cda6c31e9458c` |
| `apphy1-frq-048` | 2 | 10:16:07 | `d21fe36747fc8edeb08aa3a69433015f` |
| `apphy2-frq-020` | 2 | 02:01:33 | `0cf5ac208c8f846a851f57936f455365` |
| `apphy2-frq-035` | 2 | 02:03:50 | `01c8e543271daf3a9bf5fafe68ab1d16` |
| `apphycm-frq-017` | 2 | 02:07:49 | `33d9f20ee56fd9f6104c78318b42e9ee` |
| `apphycm-frq-035` | 2 | 02:12:17 | `204f0b612b8e64828ee2e9490904d722` |
| `apphycem-frq-020` | 2 | 02:18:35 | `b844f77c063173d89bb9c6a0184c731b` |
| `apphycem-frq-035` | 2 | 02:20:56 | `4b0c721b44f9ff49401c174f6ffa0c10` |
| `APSTAT-MOD3-E002` | 1 | 10:06:19 | `c54ee1716a86dffe255ca2e19a46e9cb` |
| `apstats-frq-u12-010` | 1 | 10:13:18 | `1f53d8d48cfe8f6e2a4ba806dfe0e020` |

**Part C result:** no sampled untouched canonical was modified during the remediation window.

## Summary

| Result | Count |
| --- | ---: |
| Original P0 findings verified genuinely closed | **32** |
| Original findings only partially closed | **2** |
| Remaining/new P0 defects | **2** |
| Remaining/new P1 defects | 0 |
| Remaining/new P2 defects | 0 |
| Remediated span-bearing items with exact structural integrity | 5/5 |
| Unexpected content-version writes in remediation window | 0 |
| Untouched items spot-checked | 15 |

## Required follow-up

The 34-item remediation should **not** be declared fully closed yet.

Two targeted corrections are still required under a separately authorized remediation action:

1. `apphy1-frq-026`: update the `b-time` `evidence_requirements` so it matches the corrected learner-facing criterion and no longer requires “Track A finishes first.”
2. `apstats-frq-u12-020`: rewrite part (c) using the exact corrected South SD (~3.735), and update `part-c-criterion-03` to state that South remains somewhat more variable than North but the difference in spread is substantially smaller after correcting the data-entry error.

After those two corrections, rerun a narrow verification on those two current version/rubric rows plus span integrity for `apstats-frq-u12-020`.



## Final Verification Addendum — 2026-09-26

The two P0s left open by this report were subsequently remediated in
`supabase/migrations/20260925140000_fix_last_2_p0s_apphy1_026_apstats_u12_020.sql` and were independently re-checked read-only against Production.

- `apphy1-frq-026`: **CLOSED.** The `b-time` `evidence_requirements` now match the corrected learner-facing criterion and no longer require the false “Track A finishes first” conclusion. The canonical remains correct that arrival order depends on specific track geometry.
- `apstats-frq-u12-020`: **CLOSED.** The canonical now recomputes the corrected South sample SD exactly as approximately **3.735**, correctly states that it remains somewhat larger than North's 3.1, and correctly states that the spread gap shrinks substantially. `part-c-criterion-03` matches that result. Existing canonical spans still concatenate exactly to the current canonical and retain exact criterion-key coverage.

**Final status:** all **34/34** original P0 findings from PR #188 are now independently verified closed.

No Production writes were made during this verification addendum.
