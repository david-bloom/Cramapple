# Lane A: classification of the chart-shaped entries outside `kind='diagram'`

**STATUS:** CURRENT, 2026-10-11. This is `FIGURE_PRODUCTION_PROTOCOL.md` §2 executed over the gap
the handoff `LANE_A_GAPS_AND_LANE_B_EXECUTION_2026_10_11.md` §2 identified. **Classification only
for the entries not built in this session** — nothing below is authored, specced or loaded.

**Why this document exists.** The handoff's §2 gives a *lead list* from a keyword scan and says
plainly that it is not a classification. Protocol v1.5 §2 now records that `kind` is not the lane
filter, and requires the verdict to be written down "or the next session re-derives it". This is
that record.

## 1. Method, and what it is worth

Every published entry with `kind <> 'diagram'` whose title or body matches
`plot|graph|chart|curve|histogram|distribution|spectrum|scatter|plotted against|horizontal axis|
vertical axis` was read from **Production** (`pcntajvbdfqhbeewmdry`) on 2026-10-11, with its `kind`,
its authored `items[]` and its body. **81 entries** have no figure.

The keyword net is deliberately wider than the handoff's (~24): it also searches `items[]`. Most of
what the extra width catches is **not** a chart — "Mean of a binomial distribution" is a formula
about a distribution, not a picture of one — which is the point of classifying rather than counting.

A verdict here is a **judgement from the entry's body**, not a build. Several will change when
someone tries to draw them. Treat it as the starting point for a batch, not as a contract.

## 2. The headline: AP Precalculus is one family, not fourteen entries

**Fifteen entries across AP Precalculus and AP Calculus AB are the same picture**: a function
plotted over a domain with one feature marked. They need **one new family, `function_plot`**, and
it is the highest-leverage thing left in Lane A by a wide margin.

| Subject · topic | Entry | kind | What the plot must mark |
|---|---|---|---:|
| Precalc 1.1 | Concave up and concave down | convention | two arcs, curvature named |
| Precalc 1.1 | Zero of a function | vocabulary | x-axis crossing |
| Precalc 1.3 | Concavity from changing average rates of change | convention | secant slopes over equal intervals |
| Precalc 1.4 | Point of inflection | vocabulary | concavity switch |
| Precalc 1.5 | Even-multiplicity zeros | convention | graph tangent to the axis, sign unchanged |
| Precalc 1.10 | Location of a hole | formula | removable discontinuity, open circle |
| Precalc 1.12 | Additive and multiplicative transformations | list_sequence (4) | f, f+k, kf, f(x+k), f(kx) |
| Precalc 1.13 | Points determine polynomial degree | convention | n+1 points, degree ≤ n |
| Precalc 2.1 | Sequence | vocabulary | discrete points, not a curve |
| Precalc 2.3 | Shape and extrema of exponential functions | convention | monotone, one concavity, no extremum |
| Precalc 2.10 | Graph and ordered pairs of log vs. exponential | convention | reflection in y = x |
| Precalc 3.5 | Concavity of sinusoidal graphs | convention | concavity alternating each half period |
| Precalc 3.8 | Reflections in tangent transformations | convention | a<0 and b<0 compared |
| Precalc 3.11 | Graph features of secant, cosecant, cotangent | list_sequence (3) | asymptotes, range gaps |
| Calc AB 1.3 | Graphs can miss important behavior | convention | **one function at two scales** |

`function_plot` needs: a function evaluated over a domain, asymptotes, open/closed circles,
tangency, marked points, secant lines, a second window on the same function, and labelled
concavity. Calc AB 1.3 is the one that pinned the design — two windows on one function.

> **BUILT 2026-10-11.** Not an *expression* evaluated over a domain: functions are TYPED with
> numeric parameters, because a parsed string cannot be evaluated identically in Python and
> JavaScript and the two renderers must agree byte for byte. The window pair became two figures
> on one entry rather than two panels in one figure, which is the same per-entry coverage the
> p-value directions use.

**Precalculus has no `kind='diagram'` entries at all**, which is exactly why Lane A's original
filter left the entire subject with one figure.

## 3. Lane A, needing a new family

| Entries | Family | Note |
|---|---|---|
| ~~Stats 2.11 ×4, 3.14 Shape of chi-square, 3.3 Critical value z*, 3.6 p-value by direction~~ | **`density_curve`** | **BUILT 2026-10-11** — 10 figures over **8** entries (2.11 ×5 including Comparing relative position, 3.14, 3.3, and 3.6's three directions as three figures on one entry). In Development; `ap-prep-blueprint#12` ports it at 147/147 parity. **Stats 3.6 Simulated p-value is NOT in it**: a simulated null distribution is a dotplot of simulated statistics, not a density curve, and belongs with `dotplot`. |
| Stats 2.12 ×4 (Sampling distribution, Randomization distribution, CLT, Simulating a sampling distribution) | `density_curve` + panels | the CLT entry needs the *narrowing with n* comparison, which is a panel set rather than one curve |
| Stats 2.8 ×2 (Valid discrete probability distribution, Cumulative probability distribution) | discrete probability chart | spikes summing to 1, and the step function beside it |
| Chem 5.3 Linear plot that identifies reaction order (3 items) | **three linearised panels** | [A], ln[A], 1/[A] against t. The teaching point is *which one is straight*, so three separate figures would destroy it — same argument as `kinematic_panels` |
| Chem 3.11 Spectral region and associated transition (3 items) | labelled spectrum band | a band of the electromagnetic spectrum with regions marked, not a stick spectrum |

## 4. Lane A, extending a family that already exists

| Entry | Family | Note |
|---|---|---|
| Chem 8.5 Polyprotic acid titration curves (3 items) | `titration_curve` | needs a second equivalence point and a second pKa |
| Precalc 2.15 Semi-log plot (vocabulary) and Using a semi-log plot to justify an exponential model (convention) | `xy_series` | needs a **log y axis**, which the family does not have |
| ~~Chem 9.1 Entropy increases with temperature~~ | `mb_distribution` | **BUILT 2026-10-15, live in Production (`APPROVAL-0165`)** as `chem-mb-entropy`, a marker-free two-temperature figure, not a reuse of `chem-mb-energy`: that figure's activation-energy marker and shaded tail are not in the 9.1 entry, and route (b) requires every carried label to be supported by the entry's body |
| ~~Chem 5.6 Reaction coordinate~~ | `energy_profile` | **BUILT 2026-10-15, live in Production (`APPROVAL-0165`)** as `chem-reaction-coordinate` (a minimal profile with the axis named), for the same reason as 9.1; `chem-energy-profile-single` belongs to a different 5.6 entry |

**Chem 9.1 and 5.6 may be free `figure_uses` rows** against `chem-mb-energy` and an existing energy
profile. Check the label strings first — protocol v1.5 §4a — and note both entries author no
`items[]`, so they are route (b) under `DECISION-0116`.

## 5. Probably free reuse of figures built this session or already live

| Entry | Candidate figure | Check before believing |
|---|---|---|
| Stats 1.4 Comparing categorical data sets | the published bar chart / pie chart | the entry is about *comparing two sets*; one chart may not satisfy it |
| Stats 2.1 Judging association from two categorical variables | the published two-categorical figures | same caution |
| Stats 1.9 Which graphs compare which features | histogram / stem-and-leaf / dotplot | names three figure types; may need all three as uses |
| Stats 1.6 Skew direction is named by the longer tail; 1.8 Mean vs. median under skew; 1.6 Gap | `density_curve`, or the published histogram | skew and gap are features of a distribution already drawn |

## 6. Lane B (spatial or schematic — stops here)

Chem 3.9 Chromatography (apparatus); Physics 1 2.1 and Physics C Mechanics 2.1 Centre of mass
(spatial); Physics 2 10.2 and Physics C E&M 8.2 Induced charge separation (particulate — the
**`particulate_box`** family built this session may serve both); Physics C E&M 8.3 Field outside a
spherically symmetric charge, 8.4 Use symmetry / Distributions requiring calculus, 8.6 Cylindrical
Gaussian surface (the **`field_map`** family built this session is a plausible base for 8.3).

## 7. Not a figure

Roughly twenty entries match the keywords and are prose, a formula, or a list of conditions:
Calc AB 1.2 Ways a limit can be expressed; Stats 1.13 Purpose of random assignment; Stats 2.9
Parameter; Stats 3.14 Homogeneity versus independence and Hypotheses for chi-square tests; Stats
3.2 Interpret sampling distribution results in context; and every `kind='formula'` entry whose body
is a bare equation (binomial mean and standard deviation, the sampling-distribution means and
standard deviations, the Physics C E&M integrals for E and V) together with the `Conditions for…`
lists. **A formula about a distribution is not a picture of one**, and that distinction is most of
the difference between this list and the keyword scan.

## 8. Suggested order

1. ~~**`density_curve`**~~ **BUILT** (2026-10-11): 10 figures, 8 entries. The §3 sampling-distribution
   rows (2.12 ×4) are still open and are the natural extension — the CLT entry needs a *narrowing
   with n* comparison, which is a panel set rather than one curve.
2. ~~**`function_plot`**~~ **BUILT** (2026-10-11): 19 figures over all 15 entries, in Development.
   AP Precalculus goes from 1 covered entry to 15, AP Calculus AB from 0 to 1.
3. The §4 extensions and the §5 reuse checks — cheap, and two may be single rows.
4. §3's remaining families (linearised panels, spectrum band, discrete probability).

§5 before anything else if a quick win is wanted: those are `figure_uses` rows against figures that
already exist, and protocol v1.5 §4a says to compare the label strings before assuming they are free.
