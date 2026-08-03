# DRAWN_RESPONSE_FRQs_v1.1 - 10 Draft Run

This file records ten independently written item-authoring packages produced from the supplied prompt. Each package is one draft response and uses the required field set.

---

## Draft 1 - DRG-P1-01

### item_id
`DRG-P1-01`

### item_version
`v0.1-ai-draft`

### student_prompt
Plant biologists studied how growth light affects stomatal density in `Asarum canadense`. Clonal segments were grown under four light treatments: Deep Shade, Partial Shade, Ambient Sun, and High Light. After 60 days, stomata were counted from leaf epidermal impressions. Using the table, construct an appropriately scaled and labeled graph to compare mean stomatal density across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five leaves per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

- Deep Shade: `31, 33, 34, 36, 35` -> mean `33.8`; `s = 1.92`; `SEM = 1.92/sqrt(5) = 0.86 -> 0.9`
- Partial Shade: `38, 39, 41, 42, 44` -> mean `40.8`; `s = 2.39`; `SEM = 2.39/sqrt(5) = 1.07 -> 1.1`
- Ambient Sun: `50, 52, 53, 55, 54` -> mean `52.8`; `s = 1.92`; `SEM = 1.92/sqrt(5) = 0.86 -> 0.9`
- High Light: `62.1, 63.3, 64.6, 66.2, 63.8` -> mean `64.0`; `s = 1.53`; `SEM = 1.53/sqrt(5) = 0.68 -> 0.7`

### display_table

| Growth light treatment | Mean stomatal density (stomata/mm2) | SEM |
| --- | ---: | ---: |
| Deep Shade | 33.8 | 0.9 |
| Partial Shade | 40.8 | 1.1 |
| Ambient Sun | 52.8 | 0.9 |
| High Light | 64.0 | 0.7 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `stomata/mm2` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places growth-light treatment on the x-axis.
- `Y_VARIABLE`: Places mean stomatal density on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `stomata/mm2`.
- `X_SCALE`: Keeps the category order shown in the table.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
- Proposed development tolerances, not validated thresholds: mean placement within 0.1 stomata/mm2; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move stomatal density to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `stomata/mm2` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the scale so the vertical axis begins at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

---

## Additional Question Bank - 80 New Draft Prompts

These are prompt-only additions to broaden the bank. Each line varies the topic, numbers, and graph requirement while staying in the same AP Biology hand-drawn quantitative graph family.

### Categorical Comparison Prompts

- `DRG-P2-01` | Categorical comparison | Mean stomatal density in basil leaves across four nitrate treatments: `0, 10, 25, 50 mM` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-02` | Categorical comparison | Mean membrane leakage in onion epidermis across four salt baths: `0, 50, 100, 200 mM NaCl` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-03` | Categorical comparison | Mean catalase activity across four buffer pH values: `4, 6, 8, 10` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-04` | Categorical comparison | Mean root hair density across four soil-moisture regimes: `10, 20, 35, 50%` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-05` | Categorical comparison | Mean chlorophyll content under four light filters: blue, green, red, white | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-06` | Categorical comparison | Mean pollen tube length in four sucrose media: `5, 10, 15, 20%` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-07` | Categorical comparison | Mean seedling biomass across four CO2 treatments: `400, 600, 800, 1000 ppm` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-08` | Categorical comparison | Mean guard-cell aperture across four ABA doses: `0, 1, 5, 10 uM` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-09` | Categorical comparison | Mean leaf thickness under four UV-filter treatments: `0, 1, 2, 3 blockers` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-10` | Categorical comparison | Mean electrolyte leakage after four heat-shock durations: `0, 10, 20, 30 min` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-11` | Categorical comparison | Mean enzyme secretion after four hormone doses: `0, 2, 5, 10 ng/mL` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-12` | Categorical comparison | Mean algal pigment density across four nitrate levels: `0, 5, 15, 30 mg/L` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-13` | Categorical comparison | Mean xylem cavitation across four drought treatments: well-watered, mild, moderate, severe | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-14` | Categorical comparison | Mean biomass across four salinity levels: `0, 25, 50, 75 mM` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-15` | Categorical comparison | Mean leaf area across four wind exposures: `0, 10, 20, 30 km/h` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-16` | Categorical comparison | Mean transpiration rate across four humidity conditions: `30, 45, 60, 80%` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-17` | Categorical comparison | Mean pigment ratio across four photoperiods: `8, 10, 12, 14 hr` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-18` | Categorical comparison | Mean chloroplast count across four nutrient mixes: `N-only, P-only, K-only, NPK` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-19` | Categorical comparison | Mean germination percentage across four temperature bins: `10, 15, 20, 25 degC` | Plot group means with symmetric `±1 SEM` bars.
- `DRG-P2-20` | Categorical comparison | Mean enzyme inhibition across four drug treatments: `0, low, medium, high` | Plot group means with symmetric `±1 SEM` bars.

### Continuous Measured Series Prompts

- `DRG-P2-21` | Continuous measured series | Enzyme reaction rate at eight temperatures: `5, 15, 25, 35, 45, 55, 65, 75 degC` | Plot means at measured temperatures, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-22` | Continuous measured series | Photosynthesis rate at seven light intensities: `0, 200, 400, 600, 800, 1000, 1200 umol photons/m2/s` | Plot means at measured intensities, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-23` | Continuous measured series | Heart rate recovery over six minutes: `0, 2, 4, 6, 8, 10 min` | Plot means at measured times, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-24` | Continuous measured series | Transpiration rate at seven wind speeds: `0, 5, 10, 15, 20, 25, 30 km/h` | Plot means at measured speeds, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-25` | Continuous measured series | Membrane potential shift across eight seconds after stimulus: `0, 1, 2, 3, 4, 5, 6, 7 s` | Plot means at measured times, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-26` | Continuous measured series | Oxygen consumption at seven temperatures: `10, 20, 30, 37, 45, 55, 65 degC` | Plot means at measured temperatures, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-27` | Continuous measured series | Leaf fluorescence over eight minutes of stress exposure: `0, 1, 2, 3, 4, 5, 6, 8 min` | Plot means at measured times, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-28` | Continuous measured series | Nutrient uptake over six time points: `0, 4, 8, 12, 18, 24 hr` | Plot means at measured times, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-29` | Continuous measured series | Stomatal aperture across seven humidity values: `20, 30, 40, 50, 60, 75, 90%` | Plot means at measured humidities, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-30` | Continuous measured series | Enzyme rate across seven pH values: `4, 5, 6, 7, 8, 9, 10` | Plot means at measured pH values, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-31` | Continuous measured series | Chlorophyll fluorescence at eight light intensities: `0, 100, 200, 400, 600, 800, 1000, 1200` | Plot means at measured intensities, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-32` | Continuous measured series | Growth rate at seven salinity steps: `0, 10, 20, 30, 40, 50, 60 mM` | Plot means at measured salinities, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-33` | Continuous measured series | Phloem transport rate across six sucrose concentrations: `0, 2, 4, 6, 8, 10%` | Plot means at measured concentrations, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-34` | Continuous measured series | Microbial respiration at seven temperatures: `15, 25, 30, 37, 45, 55, 65 degC` | Plot means at measured temperatures, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-35` | Continuous measured series | ATP yield over seven exercise durations: `0, 5, 10, 15, 20, 25, 30 min` | Plot means at measured times, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-36` | Continuous measured series | Water potential across seven soil-moisture values: `10, 20, 30, 40, 50, 65, 80%` | Plot means at measured values, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-37` | Continuous measured series | Virus replication over eight hours: `0, 1, 2, 3, 4, 5, 6, 8 hr` | Plot means at measured times, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-38` | Continuous measured series | Enzyme fluorescence across seven metal concentrations: `0, 1, 2, 4, 6, 8, 10 mM` | Plot means at measured concentrations, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-39` | Continuous measured series | Seedling elongation over eight photoperiods: `8, 9, 10, 11, 12, 13, 14, 16 hr` | Plot means at measured photoperiods, connect adjacent values, include symmetric `±1 SEM` bars.
- `DRG-P2-40` | Continuous measured series | Algal photosynthesis across eight water depths: `0, 2, 4, 6, 8, 12, 20, 30 m` | Plot means at measured depths, connect adjacent values, include symmetric `±1 SEM` bars.

### Relationship and Estimate Prompts

- `DRG-P2-41` | Relationship and estimate | Percent mass change versus sucrose concentration with negative and positive values; estimate the zero-crossing at about `0.4 M` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-42` | Relationship and estimate | Percent turgor change versus salinity with values crossing zero near `120 mM` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-43` | Relationship and estimate | Enzyme activity versus inhibitor concentration with values crossing zero near `15 uM` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-44` | Relationship and estimate | Leaf wilting index versus humidity with values crossing zero near `55%` | Plot paired points, draw one best-fit line, mark the x-intercept, report the humidity with units.
- `DRG-P2-45` | Relationship and estimate | Membrane-potential shift versus extracellular `K+` concentration crossing zero near `6 mM` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-46` | Relationship and estimate | Root growth change versus auxin concentration crossing zero near `2 ng/mL` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-47` | Relationship and estimate | Germination success versus nitrate concentration crossing zero near `18 mg/L` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-48` | Relationship and estimate | Photosynthetic delta versus CO2 enrichment crossing zero near `380 ppm` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-49` | Relationship and estimate | Osmotic mass change versus PEG concentration crossing zero near `8%` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-50` | Relationship and estimate | Stomatal aperture change versus ABA concentration crossing zero near `0.8 uM` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-51` | Relationship and estimate | Cell elongation change versus gibberellin concentration crossing zero near `1.5 uM` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-52` | Relationship and estimate | Respiration change versus temperature acclimation crossing zero near `24 degC` | Plot paired points, draw one best-fit line, mark the x-intercept, report the temperature with units.
- `DRG-P2-53` | Relationship and estimate | Electrolyte leakage change versus cold-exposure duration crossing zero near `5 min` | Plot paired points, draw one best-fit line, mark the x-intercept, report the duration with units.
- `DRG-P2-54` | Relationship and estimate | Biomass change versus salinity crossing zero near `20 mM` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-55` | Relationship and estimate | Pigment loss versus pH crossing zero near `6.2` | Plot paired points, draw one best-fit line, mark the x-intercept, report the pH estimate.
- `DRG-P2-56` | Relationship and estimate | Enzyme `kcat` change versus substrate-analog concentration crossing zero near `3 mM` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-57` | Relationship and estimate | Seedling height change versus photoperiod crossing zero near `11 hr` | Plot paired points, draw one best-fit line, mark the x-intercept, report the photoperiod with units.
- `DRG-P2-58` | Relationship and estimate | Nitrate uptake change versus phosphate concentration crossing zero near `12 mg/L` | Plot paired points, draw one best-fit line, mark the x-intercept, report the concentration with units.
- `DRG-P2-59` | Relationship and estimate | Algal mass change versus light attenuation crossing zero near `0.7 absorbance` | Plot paired points, draw one best-fit line, mark the x-intercept, report the value with units.
- `DRG-P2-60` | Relationship and estimate | Transpiration change versus wind speed crossing zero near `4 km/h` | Plot paired points, draw one best-fit line, mark the x-intercept, report the speed with units.

### Plateau Estimate Prompts

- `DRG-P2-61` | Relationship and estimate | Bacterial culture density over `0, 4, 8, 12, 16, 20, 24, 36 hr`; estimate the population density around which the culture levels off | Plot a smooth trend, mark the level-off region, report the plateau with rescaled units.
- `DRG-P2-62` | Relationship and estimate | Yeast density over `0, 3, 6, 9, 12, 15, 18, 24 hr`; estimate the population density around which the culture levels off | Plot a smooth trend, mark the level-off region, report the plateau with rescaled units.
- `DRG-P2-63` | Relationship and estimate | Algae biomass over `0, 6, 12, 18, 24, 30, 36, 48 hr`; estimate the population density around which the culture levels off | Plot a smooth trend, mark the level-off region, report the plateau with rescaled units.
- `DRG-P2-64` | Relationship and estimate | Protist density over `0, 2, 4, 6, 8, 10, 12, 16 hr`; estimate the population density around which the culture levels off | Plot a smooth trend, mark the level-off region, report the plateau with rescaled units.
- `DRG-P2-65` | Relationship and estimate | Leaf area expansion over `0, 2, 4, 6, 8, 10, 12, 16 days`; estimate the level-off area | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-66` | Relationship and estimate | Seedling height over `0, 3, 6, 9, 12, 15, 18, 24 days`; estimate the level-off height | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-67` | Relationship and estimate | Chlorophyll content over `0, 5, 10, 20, 40, 60, 80, 100 mg/L` nitrate supply; estimate the level-off chlorophyll concentration | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-68` | Relationship and estimate | Product accumulation over `0, 2, 4, 6, 8, 10, 12, 16 hr`; estimate the level-off product concentration | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-69` | Relationship and estimate | Biofilm coverage over `0, 4, 8, 12, 16, 20, 24, 32 hr`; estimate the level-off coverage | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-70` | Relationship and estimate | Coral colony coverage over `0, 1, 2, 3, 4, 5, 6, 8 weeks`; estimate the level-off coverage | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-71` | Relationship and estimate | Fungal colony diameter over `0, 1, 2, 3, 4, 5, 6, 8 days`; estimate the level-off diameter | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-72` | Relationship and estimate | Tadpole mass over `0, 2, 4, 6, 8, 10, 12, 16 weeks`; estimate the level-off mass | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-73` | Relationship and estimate | Moss mat depth over `0, 1, 2, 3, 4, 5, 6, 8 months`; estimate the level-off depth | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-74` | Relationship and estimate | Plankton density over `0, 2, 4, 6, 8, 10, 12, 16 days`; estimate the level-off density | Plot a smooth trend, mark the level-off region, report the plateau with rescaled units.
- `DRG-P2-75` | Relationship and estimate | Plant biomass across `0, 25, 50, 100, 150, 200, 300, 400 kg/ha` fertilizer additions; estimate the level-off biomass | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-76` | Relationship and estimate | Culture optical density over `0, 2, 4, 6, 8, 10, 12, 16 hr`; estimate the level-off optical density | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-77` | Relationship and estimate | Antibody titer over `0, 3, 6, 9, 12, 15, 18, 24 days`; estimate the level-off titer | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-78` | Relationship and estimate | Metabolite concentration over `0, 1, 2, 3, 4, 5, 6, 8 hr`; estimate the level-off concentration | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-79` | Relationship and estimate | Root length over `0, 2, 4, 6, 8, 10, 12, 16 days`; estimate the level-off length | Plot a smooth trend, mark the level-off region, report the plateau with units.
- `DRG-P2-80` | Relationship and estimate | Cumulative oxygen production over `0, 1, 2, 3, 4, 5, 6, 8 hr`; estimate the level-off rate | Plot a smooth trend, mark the level-off region, report the plateau with units.

---

## Draft 2 - DRG-P1-02

### item_id
`DRG-P1-02`

### item_version
`v0.1-ai-draft`

### student_prompt
Physiologists measured membrane leakage from equine red blood cells after exposure to four solution treatments: Solution A, Solution B, Solution C, and Solution D. Multiple replicates were run for each solution. Using the data provided, construct an appropriately scaled and labeled graph to compare mean membrane leakage across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five trials per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

- Solution A: `0.02, 0.04, 0.05, 0.06, 0.07` -> mean `0.048`; `SEM = 0.009 -> 0.01`
- Solution B: `0.05, 0.08, 0.10, 0.13, 0.16` -> mean `0.104`; `SEM = 0.019 -> 0.02`
- Solution C: `0.69, 0.72, 0.76, 0.79, 0.82` -> mean `0.756`; `SEM = 0.023 -> 0.02`
- Solution D: `0.71, 0.78, 0.83, 0.87, 0.86` -> mean `0.810`; `SEM = 0.0295 -> 0.03`

### display_table

| Solution treatment | Mean leakage (absorbance at 540 nm) | SEM |
| --- | ---: | ---: |
| Solution A | 0.05 | 0.01 |
| Solution B | 0.10 | 0.02 |
| Solution C | 0.76 | 0.02 |
| Solution D | 0.81 | 0.03 |

### expected_graph_spec
- Categorical x-axis in the table order.
- Y-axis labeled `absorbance at 540 nm` and starting at 0.
- Plot one mean per solution.
- Add symmetric plus or minus 1 SEM bars around each mean.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph.
- `X_VARIABLE`: Places solution treatment on the x-axis.
- `Y_VARIABLE`: Places mean membrane leakage on the y-axis.
- `X_UNIT`: Uses treatment names, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with the absorbance measurement.
- `X_SCALE`: Keeps the four solutions in the stated order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four separate solution identities.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Absorbance label may be written as `A540` if still clear.
- Category labels may be shortened as long as identity is preserved.

### contradictions
- Replacing the four categories with a continuous concentration axis.
- Missing error bars.
- A y-axis that does not start at zero.

### development_tolerances
- Proposed development tolerances, not validated thresholds: mean placement within 0.01 absorbance units; SEM within 0.01; category order exact; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Turn the table into a graph with plotted means and error bars.
- `X_VARIABLE`: Put the solution names on the horizontal axis.
- `Y_VARIABLE`: Show leakage on the vertical axis instead of in the table only.
- `X_UNIT`: Keep the x-axis as categories, not numbers.
- `Y_UNIT`: Include the absorbance unit in the axis label.
- `X_SCALE`: Leave the solution order unchanged.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Keep each solution separate and labeled.
- `PLOT_VALUES`: Place each point at the mean given in the table.
- `UNCERTAINTY_MARKS`: Add symmetric SEM bars to each point.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

---

## Draft 3 - DRG-P1-03

### item_id
`DRG-P1-03`

### item_version
`v0.1-ai-draft`

### student_prompt
Researchers measured the reaction rate of an enzyme across eight temperatures. Using the data provided, construct an appropriately scaled and labeled graph of mean reaction rate versus temperature. Plot the means at their measured temperatures, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four assays per temperature. The replicate values are intentionally irregular rather than consecutive-integer sequences.

- 10 degC: `11.4, 12.0, 12.7, 11.9` -> mean `12.0`; `SEM = 0.268 -> 0.3`
- 20 degC: `17.1, 18.2, 18.8, 19.5` -> mean `18.4`; `SEM = 0.508 -> 0.5`
- 30 degC: `25.6, 26.5, 27.1, 28.0` -> mean `26.8`; `SEM = 0.505 -> 0.5`
- 40 degC: `36.7, 37.8, 38.4, 38.7` -> mean `37.9`; `SEM = 0.442 -> 0.4`
- 50 degC: `46.0, 46.8, 47.3, 48.7` -> mean `47.2`; `SEM = 0.567 -> 0.6`
- 60 degC: `42.6, 43.3, 44.2, 44.0` -> mean `43.5`; `SEM = 0.364 -> 0.4`
- 70 degC: `30.8, 31.2, 31.7, 32.9` -> mean `31.7`; `SEM = 0.456 -> 0.5`
- 80 degC: `16.0, 16.5, 17.2, 18.5` -> mean `17.1`; `SEM = 0.542 -> 0.5`

### display_table

| Temperature (degC) | Mean reaction rate (umol product/min) | SEM |
| --- | ---: | ---: |
| 10 | 12.0 | 0.3 |
| 20 | 18.4 | 0.5 |
| 30 | 26.8 | 0.5 |
| 40 | 37.9 | 0.4 |
| 50 | 47.2 | 0.6 |
| 60 | 43.5 | 0.4 |
| 70 | 31.7 | 0.5 |
| 80 | 17.1 | 0.5 |

### expected_graph_spec
- X-axis is temperature with actual numeric spacing.
- Y-axis is reaction rate and starts at zero.
- Plot the mean at each measured temperature.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places temperature on the x-axis.
- `Y_VARIABLE`: Places mean reaction rate on the y-axis.
- `X_UNIT`: Labels the x-axis in degC.
- `Y_UNIT`: Labels the y-axis in umol product/min.
- `X_SCALE`: Uses actual numeric spacing between temperatures.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct temperature and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured points are acceptable.
- The y-axis may be truncated only if it still begins at zero.
- Temperature labels may be rotated if needed for space.

### contradictions
- Spacing the eight temperatures evenly as if they were categories.
- Replacing the data points with a smooth spline that moves the measured values.
- Leaving off the error bars.

### development_tolerances
- Proposed development tolerances, not validated thresholds: each mean within 0.1 rate units; SEM within 0.1; x positions must match the stated temperatures; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put temperature on the horizontal axis.
- `Y_VARIABLE`: Put reaction rate on the vertical axis.
- `X_UNIT`: Label the x-axis in degC.
- `Y_UNIT`: Label the y-axis in umol product/min.
- `X_SCALE`: Space the temperatures according to their numeric values.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right temperature and rate.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect each measured point to the next one in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

---

## Draft 4 - DRG-P1-04

### item_id
`DRG-P1-04`

### item_version
`v0.1-ai-draft`

### student_prompt
Researchers measured photosynthetic rate at seven light intensities in shade-grown tomato leaves. Using the data provided, construct an appropriately scaled and labeled graph of mean photosynthetic rate versus light intensity. Plot the means at their measured intensities, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four trials per light intensity. The replicate values are intentionally irregular rather than consecutive-integer sequences.

- 0: `3.4, 4.0, 4.3, 5.1` -> mean `4.2`; `SEM = 0.354 -> 0.4`
- 100: `10.0, 10.8, 11.3, 12.3` -> mean `11.1`; `SEM = 0.481 -> 0.5`
- 250: `20.5, 21.4, 22.1, 23.6` -> mean `21.9`; `SEM = 0.654 -> 0.7`
- 500: `33.1, 34.5, 35.0, 36.6` -> mean `34.8`; `SEM = 0.722 -> 0.7`
- 750: `41.0, 41.6, 42.4, 43.3` -> mean `42.1`; `SEM = 0.499 -> 0.5`
- 1000: `42.1, 42.8, 43.5, 44.4` -> mean `43.2`; `SEM = 0.492 -> 0.5`
- 1500: `42.8, 43.4, 43.8, 44.1` -> mean `43.5`; `SEM = 0.281 -> 0.3`

### display_table

| Light intensity (umol photons/m2/s) | Mean photosynthetic rate (umol CO2/m2/s) | SEM |
| --- | ---: | ---: |
| 0 | 4.2 | 0.4 |
| 100 | 11.1 | 0.5 |
| 250 | 21.9 | 0.7 |
| 500 | 34.8 | 0.7 |
| 750 | 42.1 | 0.5 |
| 1000 | 43.2 | 0.5 |
| 1500 | 43.5 | 0.3 |

### expected_graph_spec
- X-axis is light intensity with actual numeric spacing.
- Y-axis is photosynthetic rate and starts at zero.
- Plot the mean at each measured intensity.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured values in order.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places light intensity on the x-axis.
- `Y_VARIABLE`: Places mean photosynthetic rate on the y-axis.
- `X_UNIT`: Labels the x-axis in umol photons/m2/s.
- `Y_UNIT`: Labels the y-axis in umol CO2/m2/s.
- `X_SCALE`: Uses actual numeric spacing between intensity values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct intensity and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight segments between measured values are acceptable.
- The x-axis may be written as PAR if the meaning remains clear.
- The plateau can be shown with a nearly flat final segment.

### contradictions
- Treating the seven intensities as equally spaced categories.
- Smoothing the curve in a way that moves the measured points.
- Omitting the error bars.

### development_tolerances
- Proposed development tolerances, not validated thresholds: each mean within 0.1 rate units; SEM within 0.1; x positions must reflect actual intensity values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph rather than a category chart.
- `X_VARIABLE`: Put light intensity on the horizontal axis.
- `Y_VARIABLE`: Put photosynthetic rate on the vertical axis.
- `X_UNIT`: Label the x-axis in umol photons/m2/s.
- `Y_UNIT`: Label the y-axis in umol CO2/m2/s.
- `X_SCALE`: Space the intensity values by their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right intensity and rate.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

---

## Draft 5 - DRG-P1-05

### item_id
`DRG-P1-05`

### item_version
`v0.1-ai-draft`

### student_prompt
Students tested synthetic membrane-bound tissue samples in external solute solutions of different molarities and measured percent mass change after equilibration. Using the data provided, construct a graph of percent mass change versus solute concentration, draw one best-fit relationship, mark the zero-change intercept, and estimate the concentration where percent mass change is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each solute concentration; no replicate averaging was used.

- `0.0 M -> 12.6`
- `0.2 M -> 7.8`
- `0.4 M -> 2.7`
- `0.6 M -> -2.6`
- `0.8 M -> -7.1`
- `1.0 M -> -11.8`

### display_table

| Solute concentration (M) | Percent mass change |
| --- | ---: |
| 0.0 | 12.6 |
| 0.2 | 7.8 |
| 0.4 | 2.7 |
| 0.6 | -2.6 |
| 0.8 | -7.1 |
| 1.0 | -11.8 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where percent mass change crosses zero, near `0.5 M`.
- Label the intercept estimate in M.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places solute concentration on the x-axis.
- `Y_VARIABLE`: Places percent mass change on the y-axis.
- `X_UNIT`: Labels the x-axis in M.
- `Y_UNIT`: Labels the y-axis in percent mass change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change concentration in M.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in percent units rather than M.
- Omitting negative y-values from the scale.

### development_tolerances
- Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 percent mass change; intercept estimate within 0.05 M; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put solute concentration on the x-axis.
- `Y_VARIABLE`: Put percent mass change on the y-axis.
- `X_UNIT`: Add M to the concentration axis label.
- `Y_UNIT`: Label the response axis as percent mass change.
- `X_SCALE`: Use a linear concentration scale with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right concentration and mass change.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero on the y-axis.
- `ESTIMATE_VALUE`: State the zero-change concentration in M.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

---

## Draft 6 - DRG-P1-06

### item_id
`DRG-P1-06`

### item_version
`v0.1-ai-draft`

### student_prompt
A microbial culture was grown in a resource-bounded bioreactor and its density was measured over time. Using the data provided, construct a graph of culture density over time on linear axes, draw a smooth trend, visually indicate the level-off region, and estimate the population density around which the culture levels off under these conditions. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each time point; no replicate averaging was used.

- `0 hr -> 1.6`
- `4 hr -> 6.9`
- `8 hr -> 10.8`
- `12 hr -> 13.3`
- `16 hr -> 15.2`
- `20 hr -> 16.4`
- `24 hr -> 17.0`
- `28 hr -> 17.5`

### display_table

| Time (hr) | Culture density (10^5 cells/mL) |
| --- | ---: |
| 0 | 1.6 |
| 4 | 6.9 |
| 8 | 10.8 |
| 12 | 13.3 |
| 16 | 15.2 |
| 20 | 16.4 |
| 24 | 17.0 |
| 28 | 17.5 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use a single linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the population density around which the curve levels off at about `18.0 x 10^5 cells/mL`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places culture density on the y-axis.
- `X_UNIT`: Labels the x-axis in hours.
- `Y_UNIT`: Labels the y-axis in `10^5 cells/mL`.
- `X_SCALE`: Uses a linear time axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the rescaled display unit.
- `PLOT_VALUES`: Places each observation at the correct time and density.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the level-off region on the curve.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `10^5 cells/mL`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written as `12.0 x 10^5 cells/mL` or equivalent wording.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
- Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 `10^5 cells/mL`; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put culture density on the vertical axis.
- `X_UNIT`: Label the x-axis in hours.
- `Y_UNIT`: Use the rescaled density unit on the y-axis.
- `X_SCALE`: Keep the time axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right time and density.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off density with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

---

## Draft 7 - DRG-P1-01

### item_id
`DRG-P1-01`

### item_version
`v0.1-ai-draft`

### student_prompt
Plant biologists studied how LED spectrum during growth shapes leaf anatomy in basil seedlings. Clonal cuttings were propagated under four light treatments: Cool White, Warm White, Red-Enriched, and Far-Red Filtered. After growth, leaf epidermal impressions were analyzed to count stomata per square millimeter. Using the data provided, construct an appropriately scaled and labeled graph to compare mean stomatal density across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five leaves per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

- Cool White: `28, 30, 29, 31, 33` -> mean `30.2`; `s = 1.92`; `SEM = 1.92/sqrt(5) = 0.86 -> 0.9`
- Warm White: `35, 36, 38, 39, 40` -> mean `37.6`; `s = 1.92`; `SEM = 1.92/sqrt(5) = 0.86 -> 0.9`
- Red-Enriched: `44, 46, 47, 48, 49` -> mean `46.8`; `s = 1.92`; `SEM = 1.92/sqrt(5) = 0.86 -> 0.9`
- Far-Red Filtered: `52, 54, 55, 56, 58` -> mean `55.0`; `s = 2.24`; `SEM = 2.24/sqrt(5) = 1.00 -> 1.0`

### display_table

| Growth light treatment | Mean stomatal density (stomata/mm2) | SEM |
| --- | ---: | ---: |
| Cool White | 30.2 | 0.9 |
| Warm White | 37.6 | 0.9 |
| Red-Enriched | 46.8 | 0.9 |
| Far-Red Filtered | 55.0 | 1.0 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `stomata/mm2` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph.
- `X_VARIABLE`: Places growth-light treatment on the x-axis.
- `Y_VARIABLE`: Places mean stomatal density on the y-axis.
- `X_UNIT`: Uses category labels rather than numeric units.
- `Y_UNIT`: Labels the y-axis with `stomata/mm2`.
- `X_SCALE`: Keeps the treatments in the stated order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four distinct treatment names.
- `PLOT_VALUES`: Places each mean at the correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.

### accepted_variants
- Bar-with-whisker and point-with-whisker are both acceptable.
- Category labels may wrap to two lines.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Reordering the treatments without flagging it as an allowed variant.
- Starting the y-axis above zero.
- Missing the error bars entirely.

### development_tolerances
- Proposed development tolerances, not validated thresholds: mean placement within 0.1 stomata/mm2; SEM within 0.1; y-axis baseline exactly at zero; category order exact.

### minimum_feedback
- `REPRESENTATION_TYPE`: Turn the table into a graph with plotted means and error bars.
- `X_VARIABLE`: Put the treatment names on the horizontal axis.
- `Y_VARIABLE`: Put stomatal density on the vertical axis.
- `X_UNIT`: Use category labels on the x-axis.
- `Y_UNIT`: Add `stomata/mm2` to the y-axis label.
- `X_SCALE`: Keep the categories in the provided order.
- `Y_SCALE`: Redraw the scale so it begins at zero.
- `CATEGORY_IDENTITY`: Keep each treatment name separate.
- `PLOT_VALUES`: Place each mean at the right height.
- `UNCERTAINTY_MARKS`: Add symmetric SEM bars to each mean.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

---

## Draft 8 - DRG-P1-03

### item_id
`DRG-P1-03`

### item_version
`v0.1-ai-draft`

### student_prompt
Researchers measured the reaction rate of a heat-stable digestive enzyme from a desert beetle across eight temperatures. Using the data provided, construct an appropriately scaled and labeled graph of mean reaction rate versus temperature. Plot the means at their measured temperatures, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four assays per temperature. The replicate values are intentionally irregular rather than consecutive-integer sequences.

- 8 degC: `8.2, 8.9, 9.1, 9.8` -> mean `9.0`; `SEM = 0.329 -> 0.3`
- 18 degC: `14.1, 14.8, 15.6, 15.5` -> mean `15.0`; `SEM = 0.363 -> 0.4`
- 28 degC: `22.4, 23.0, 24.1, 24.5` -> mean `23.5`; `SEM = 0.484 -> 0.5`
- 38 degC: `33.0, 34.1, 35.0, 35.7` -> mean `34.5`; `SEM = 0.619 -> 0.6`
- 48 degC: `44.2, 45.0, 46.1, 46.7` -> mean `45.5`; `SEM = 0.545 -> 0.5`
- 58 degC: `50.2, 51.0, 52.1, 52.5` -> mean `51.5`; `SEM = 0.512 -> 0.5`
- 68 degC: `38.0, 38.8, 39.5, 40.2` -> mean `39.1`; `SEM = 0.476 -> 0.5`
- 78 degC: `19.2, 20.1, 21.0, 21.5` -> mean `20.5`; `SEM = 0.506 -> 0.5`

### display_table

| Temperature (degC) | Mean reaction rate (umol product/min) | SEM |
| --- | ---: | ---: |
| 8 | 9.0 | 0.3 |
| 18 | 15.0 | 0.4 |
| 28 | 23.5 | 0.5 |
| 38 | 34.5 | 0.6 |
| 48 | 45.5 | 0.5 |
| 58 | 51.5 | 0.5 |
| 68 | 39.1 | 0.5 |
| 78 | 20.5 | 0.5 |

### expected_graph_spec
- X-axis is temperature with actual numeric spacing.
- Y-axis is reaction rate and starts at zero.
- Plot the mean at each measured temperature.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places temperature on the x-axis.
- `Y_VARIABLE`: Places mean reaction rate on the y-axis.
- `X_UNIT`: Labels the x-axis in degC.
- `Y_UNIT`: Labels the y-axis in umol product/min.
- `X_SCALE`: Uses actual numeric spacing between temperatures.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct temperature and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight segments between adjacent measured points are acceptable.
- The x-axis may use whole numbers or tick labels matching the temperatures.
- The interior maximum may be shown as a broad peak if the measured points stay fixed.

### contradictions
- Spacing the temperatures evenly as if they were categories.
- Replacing the measured points with a smoothed curve that moves them.
- Leaving off the error bars.

### development_tolerances
- Proposed development tolerances, not validated thresholds: each mean within 0.1 rate units; SEM within 0.1; x positions must match the stated temperatures; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put temperature on the horizontal axis.
- `Y_VARIABLE`: Put reaction rate on the vertical axis.
- `X_UNIT`: Label the x-axis in degC.
- `Y_UNIT`: Label the y-axis in umol product/min.
- `X_SCALE`: Space the temperatures according to their numeric values.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right temperature and rate.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

---

## Draft 9 - DRG-P1-04

### item_id
`DRG-P1-04`

### item_version
`v0.1-ai-draft`

### student_prompt
Researchers measured photosynthetic rate at seven light intensities. Using the data provided, construct an appropriately scaled and labeled graph of mean photosynthetic rate versus light intensity. Plot the means at their measured intensities, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four trials per light intensity. The replicate values are intentionally irregular rather than consecutive-integer sequences.

- 0: `3.6, 4.1, 4.8, 5.5` -> mean `4.5`; `SEM = 0.433 -> 0.4`
- 75: `8.8, 9.4, 10.1, 10.6` -> mean `9.7`; `SEM = 0.395 -> 0.4`
- 175: `15.5, 16.5, 17.1, 18.1` -> mean `16.8`; `SEM = 0.545 -> 0.5`
- 350: `25.0, 26.2, 27.1, 28.0` -> mean `26.6`; `SEM = 0.657 -> 0.7`
- 650: `34.0, 35.2, 36.0, 37.1` -> mean `35.6`; `SEM = 0.655 -> 0.7`
- 950: `38.6, 39.1, 39.8, 40.5` -> mean `39.5`; `SEM = 0.376 -> 0.4`
- 1400: `40.0, 40.5, 41.0, 41.4` -> mean `40.7`; `SEM = 0.303 -> 0.3`

### display_table

| Light intensity (umol photons/m2/s) | Mean photosynthetic rate (umol CO2/m2/s) | SEM |
| --- | ---: | ---: |
| 0 | 4.5 | 0.4 |
| 75 | 9.7 | 0.4 |
| 175 | 16.8 | 0.5 |
| 350 | 26.6 | 0.7 |
| 650 | 35.6 | 0.7 |
| 950 | 39.5 | 0.4 |
| 1400 | 40.7 | 0.3 |

### expected_graph_spec
- X-axis is light intensity with actual numeric spacing.
- Y-axis is photosynthetic rate and starts at zero.
- Plot the mean at each measured intensity.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured values in order.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places light intensity on the x-axis.
- `Y_VARIABLE`: Places mean photosynthetic rate on the y-axis.
- `X_UNIT`: Labels the x-axis in umol photons/m2/s.
- `Y_UNIT`: Labels the y-axis in umol CO2/m2/s.
- `X_SCALE`: Uses actual numeric spacing between intensity values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct intensity and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight segments between measured values are acceptable.
- The x-axis may be labeled as PAR if the meaning is clear.
- The plateau can be shown as a nearly flat final segment.

### contradictions
- Treating the seven intensities as equally spaced categories.
- Smoothing the curve so the plotted means move off the measured points.
- Omitting the error bars.

### development_tolerances
- Proposed development tolerances, not validated thresholds: each mean within 0.1 rate units; SEM within 0.1; x positions must reflect actual intensity values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph rather than a category chart.
- `X_VARIABLE`: Put light intensity on the horizontal axis.
- `Y_VARIABLE`: Put photosynthetic rate on the vertical axis.
- `X_UNIT`: Label the x-axis in umol photons/m2/s.
- `Y_UNIT`: Label the y-axis in umol CO2/m2/s.
- `X_SCALE`: Space the intensity values by their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right intensity and rate.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

---

## Draft 10 - DRG-P1-06

### item_id
`DRG-P1-06`

### item_version
`v0.1-ai-draft`

### student_prompt
A freshwater cyanobacterium was grown in a bench-top reactor and its density was measured over time. Using the data provided, construct a graph of culture density over time on linear axes, draw a smooth trend, visually indicate the level-off region, and estimate the population density around which the culture levels off under these conditions. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each time point; no replicate averaging was used.

- `0 hr -> 1.4`
- `2 hr -> 4.9`
- `5 hr -> 8.7`
- `8 hr -> 11.8`
- `11 hr -> 13.7`
- `14 hr -> 14.8`
- `17 hr -> 15.4`
- `21 hr -> 15.7`

### display_table

| Time (hr) | Culture density (10^5 cells/mL) |
| --- | ---: |
| 0 | 1.4 |
| 2 | 4.9 |
| 5 | 8.7 |
| 8 | 11.8 |
| 11 | 13.7 |
| 14 | 14.8 |
| 17 | 15.4 |
| 21 | 15.7 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the population density around which the curve levels off at about `16.0 x 10^5 cells/mL`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places culture density on the y-axis.
- `X_UNIT`: Labels the x-axis in hours.
- `Y_UNIT`: Labels the y-axis in `10^5 cells/mL`.
- `X_SCALE`: Uses a linear time axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the rescaled display unit.
- `PLOT_VALUES`: Places each observation at the correct time and density.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `10^5 cells/mL`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written as `16.0 x 10^5 cells/mL` or equivalent wording.

### contradictions
- Using a log y-axis or scientific notation only.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Treating the plateau as a fixed species constant instead of a condition-specific level-off.

### development_tolerances
- Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 `10^5 cells/mL`; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put culture density on the vertical axis.
- `X_UNIT`: Label the x-axis in hours.
- `Y_UNIT`: Use the rescaled density unit on the y-axis.
- `X_SCALE`: Keep the time axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right time and density.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off density with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.
---
---
---

## Generated Full Item Packages

The following packages are expanded from the 80 prompt-only rows in the Additional Question Bank. They follow the same field set as the initial six drafts and are generated deterministically from the prompt rows.

## Draft 11 - DRG-P2-01

### item_id
`DRG-P2-01`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured stomatal density in basil leaves across four nitrate treatments. Using the data provided, construct an appropriately scaled and labeled graph to compare mean stomatal density in basil leaves across four nitrate treatments across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 21.3 | 0.6 |
| 10 | 28.8 | 0.9 |
| 25 | 35.9 | 0.6 |
| 50 mM | 35 | 0.8 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `stomata/mm2` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean stomatal density in basil leaves across four nitrate treatments on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `stomata/mm2`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move stomatal density in basil leaves across four nitrate treatments to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `stomata/mm2` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 12 - DRG-P2-02

### item_id
`DRG-P2-02`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured membrane leakage in onion epidermis across four salt baths. Using the data provided, construct an appropriately scaled and labeled graph to compare mean membrane leakage in onion epidermis across four salt baths across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 64.2 | 0.3 |
| 50 | 55 | 0.5 |
| 100 | 48 | 0.7 |
| 200 mM NaCl | 44.5 | 0.6 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `absorbance at 540 nm` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean membrane leakage in onion epidermis across four salt baths on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `absorbance at 540 nm`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move membrane leakage in onion epidermis across four salt baths to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `absorbance at 540 nm` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 13 - DRG-P2-03

### item_id
`DRG-P2-03`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured catalase activity across four buffer ph values. Using the data provided, construct an appropriately scaled and labeled graph to compare mean catalase activity across four buffer ph values across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 4 | 15.4 | 0.5 |
| 6 | 24.4 | 0.4 |
| 8 | 26.2 | 0.7 |
| 10 | 18.2 | 0.6 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `umol product/min` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean catalase activity across four buffer ph values on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `umol product/min`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move catalase activity across four buffer ph values to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `umol product/min` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 14 - DRG-P2-04

### item_id
`DRG-P2-04`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured root hair density across four soil-moisture regimes. Using the data provided, construct an appropriately scaled and labeled graph to compare mean root hair density across four soil-moisture regimes across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 10 | 17.9 | 1 |
| 20 | 28.4 | 0.7 |
| 35 | 41.3 | 0.8 |
| 50% | 47.3 | 0.3 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `hairs/mm2` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean root hair density across four soil-moisture regimes on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `hairs/mm2`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move root hair density across four soil-moisture regimes to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `hairs/mm2` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 15 - DRG-P2-05

### item_id
`DRG-P2-05`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured chlorophyll content under four light filters. Using the data provided, construct an appropriately scaled and labeled graph to compare mean chlorophyll content under four light filters across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| blue | 20 | 0.4 |
| green | 35.7 | 0.6 |
| red | 37.5 | 0.3 |
| white | 22.8 | 0.8 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `relative units` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean chlorophyll content under four light filters on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `relative units`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move chlorophyll content under four light filters to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `relative units` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 16 - DRG-P2-06

### item_id
`DRG-P2-06`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured pollen tube length in four sucrose media. Using the data provided, construct an appropriately scaled and labeled graph to compare mean pollen tube length in four sucrose media across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 5 | 16.5 | 0.6 |
| 10 | 27.2 | 0.3 |
| 15 | 38.8 | 0.7 |
| 20% | 40.9 | 0.7 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `mm` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean pollen tube length in four sucrose media on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `mm`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move pollen tube length in four sucrose media to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `mm` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 17 - DRG-P2-07

### item_id
`DRG-P2-07`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured seedling biomass across four co2 treatments. Using the data provided, construct an appropriately scaled and labeled graph to compare mean seedling biomass across four co2 treatments across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 400 | 14.9 | 0.3 |
| 600 | 24.9 | 0.4 |
| 800 | 38.1 | 1 |
| 1000 ppm | 42.1 | 0.3 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `g` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean seedling biomass across four co2 treatments on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `g`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move seedling biomass across four co2 treatments to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `g` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 18 - DRG-P2-08

### item_id
`DRG-P2-08`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured guard-cell aperture across four aba doses. Using the data provided, construct an appropriately scaled and labeled graph to compare mean guard-cell aperture across four aba doses across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 51.5 | 1 |
| 1 | 43.9 | 0.3 |
| 5 | 34.9 | 0.5 |
| 10 uM | 30.1 | 0.6 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `um` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean guard-cell aperture across four aba doses on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `um`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move guard-cell aperture across four aba doses to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `um` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 19 - DRG-P2-09

### item_id
`DRG-P2-09`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured leaf thickness under four uv-filter treatments. Using the data provided, construct an appropriately scaled and labeled graph to compare mean leaf thickness under four uv-filter treatments across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 56.1 | 0.9 |
| 1 | 46.4 | 0.3 |
| 2 | 41.4 | 0.4 |
| 3 blockers | 36.8 | 0.6 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `mm` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean leaf thickness under four uv-filter treatments on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `mm`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move leaf thickness under four uv-filter treatments to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `mm` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 20 - DRG-P2-10

### item_id
`DRG-P2-10`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured electrolyte leakage after four heat-shock durations. Using the data provided, construct an appropriately scaled and labeled graph to compare mean electrolyte leakage after four heat-shock durations across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 62 | 0.8 |
| 10 | 53.2 | 1 |
| 20 | 49.9 | 0.5 |
| 30 min | 42.2 | 0.4 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `%` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean electrolyte leakage after four heat-shock durations on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `%`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move electrolyte leakage after four heat-shock durations to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `%` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 21 - DRG-P2-11

### item_id
`DRG-P2-11`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured enzyme secretion after four hormone doses. Using the data provided, construct an appropriately scaled and labeled graph to compare mean enzyme secretion after four hormone doses across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 25.6 | 0.4 |
| 2 | 32.8 | 0.9 |
| 5 | 35.9 | 0.4 |
| 10 ng/mL | 39 | 0.3 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `arbitrary units` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean enzyme secretion after four hormone doses on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `arbitrary units`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move enzyme secretion after four hormone doses to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `arbitrary units` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 22 - DRG-P2-12

### item_id
`DRG-P2-12`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured algal pigment density across four nitrate levels. Using the data provided, construct an appropriately scaled and labeled graph to compare mean algal pigment density across four nitrate levels across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 18.2 | 0.7 |
| 5 | 25.5 | 0.8 |
| 15 | 30.4 | 0.5 |
| 30 mg/L | 34.4 | 0.8 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `relative units` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean algal pigment density across four nitrate levels on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `relative units`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move algal pigment density across four nitrate levels to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `relative units` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 23 - DRG-P2-13

### item_id
`DRG-P2-13`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured xylem cavitation across four drought treatments. Using the data provided, construct an appropriately scaled and labeled graph to compare mean xylem cavitation across four drought treatments across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| well-watered | 50.4 | 0.4 |
| mild | 40.6 | 0.6 |
| moderate | 36.4 | 0.8 |
| severe | 29.9 | 0.7 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `%` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean xylem cavitation across four drought treatments on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `%`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move xylem cavitation across four drought treatments to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `%` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 24 - DRG-P2-14

### item_id
`DRG-P2-14`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured biomass across four salinity levels. Using the data provided, construct an appropriately scaled and labeled graph to compare mean biomass across four salinity levels across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 53.8 | 0.7 |
| 25 | 46.2 | 0.5 |
| 50 | 37.9 | 0.4 |
| 75 mM | 33 | 0.3 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `g` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean biomass across four salinity levels on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `g`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move biomass across four salinity levels to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `g` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 25 - DRG-P2-15

### item_id
`DRG-P2-15`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured leaf area across four wind exposures. Using the data provided, construct an appropriately scaled and labeled graph to compare mean leaf area across four wind exposures across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 48.4 | 0.7 |
| 10 | 39.9 | 0.6 |
| 20 | 34.7 | 0.8 |
| 30 km/h | 29.6 | 0.6 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `cm2` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean leaf area across four wind exposures on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `cm2`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move leaf area across four wind exposures to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `cm2` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 26 - DRG-P2-16

### item_id
`DRG-P2-16`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured transpiration rate across four humidity conditions. Using the data provided, construct an appropriately scaled and labeled graph to compare mean transpiration rate across four humidity conditions across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 30 | 56.1 | 0.6 |
| 45 | 46.5 | 0.9 |
| 60 | 40.1 | 0.4 |
| 80% | 38.1 | 0.3 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `mg H2O/cm2/min` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean transpiration rate across four humidity conditions on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `mg H2O/cm2/min`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move transpiration rate across four humidity conditions to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `mg H2O/cm2/min` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 27 - DRG-P2-17

### item_id
`DRG-P2-17`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured pigment ratio across four photoperiods. Using the data provided, construct an appropriately scaled and labeled graph to compare mean pigment ratio across four photoperiods across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 8 | 14.9 | 0.8 |
| 10 | 26.9 | 0.4 |
| 12 | 28.7 | 0.4 |
| 14 hr | 17.7 | 0.4 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `ratio` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean pigment ratio across four photoperiods on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `ratio`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move pigment ratio across four photoperiods to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `ratio` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 28 - DRG-P2-18

### item_id
`DRG-P2-18`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured chloroplast count across four nutrient mixes. Using the data provided, construct an appropriately scaled and labeled graph to compare mean chloroplast count across four nutrient mixes across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| N-only | 17.3 | 0.6 |
| P-only | 26.1 | 0.6 |
| K-only | 39.8 | 0.7 |
| NPK | 43.4 | 0.3 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `chloroplasts/cell` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean chloroplast count across four nutrient mixes on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `chloroplasts/cell`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move chloroplast count across four nutrient mixes to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `chloroplasts/cell` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 29 - DRG-P2-19

### item_id
`DRG-P2-19`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured germination percentage across four temperature bins. Using the data provided, construct an appropriately scaled and labeled graph to compare mean germination percentage across four temperature bins across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 10 | 14.4 | 0.9 |
| 15 | 30.5 | 0.7 |
| 20 | 32.3 | 0.7 |
| 25 degC | 17.2 | 0.2 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `%` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean germination percentage across four temperature bins on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `%`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move germination percentage across four temperature bins to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `%` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 30 - DRG-P2-20

### item_id
`DRG-P2-20`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured enzyme inhibition across four drug treatments. Using the data provided, construct an appropriately scaled and labeled graph to compare mean enzyme inhibition across four drug treatments across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Five observations per group. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| Treatment | Mean | SEM |
| --- | ---: | ---: |
| 0 | 21.5 | 0.5 |
| low | 28.1 | 0.4 |
| medium | 35.1 | 0.3 |
| high | 37.5 | 0.6 |

### expected_graph_spec
- Categorical x-axis in the stated order.
- Y-axis labeled `%` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.
- `X_VARIABLE`: Places the treatment categories on the x-axis.
- `Y_VARIABLE`: Places mean enzyme inhibition across four drug treatments on the y-axis.
- `X_UNIT`: Uses category labels only, not a numeric x unit.
- `Y_UNIT`: Labels the y-axis with `%`.
- `X_SCALE`: Keeps the four treatment labels in the table order.
- `Y_SCALE`: Starts the y-axis at zero.
- `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.
- `PLOT_VALUES`: Places each mean at its correct height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.

### accepted_variants
- Point-with-whisker and bar-with-whisker are both acceptable.
- Category labels may wrap onto two lines if needed.
- SEM bars may be capped or uncapped if still symmetric.

### contradictions
- Treating the groups as a continuous numeric x-axis.
- Starting the y-axis above zero.
- Omitting the SEM bars or showing one-sided bars only.

### development_tolerances
Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.
- `X_VARIABLE`: Put the treatment names across the horizontal axis.
- `Y_VARIABLE`: Move enzyme inhibition across four drug treatments to the vertical axis.
- `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.
- `Y_UNIT`: Add `%` to the y-axis label.
- `X_SCALE`: Keep the treatments in the provided order.
- `Y_SCALE`: Redraw the vertical axis so it starts at zero.
- `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.
- `PLOT_VALUES`: Place each mean at the correct height from the table.
- `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 31 - DRG-P2-21

### item_id
`DRG-P2-21`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured enzyme reaction rate at eight temperatures. Using the data provided, construct an appropriately scaled and labeled graph of mean umol product/min versus temperature (degC). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| temperature (degC) | Mean umol product/min | SEM |
| --- | ---: | ---: |
| 5 | 1.4 | 0.3 |
| 15 | 4.3 | 0.3 |
| 25 | 14.6 | 0.2 |
| 35 | 29.2 | 0.6 |
| 45 | 37.7 | 0.5 |
| 55 | 28.7 | 0.3 |
| 65 | 14 | 0.4 |
| 75 | 3.4 | 0.6 |

### expected_graph_spec
- X-axis is temperature (degC) with actual numeric spacing.
- Y-axis is umol product/min and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places temperature (degC) on the x-axis.
- `Y_VARIABLE`: Places mean umol product/min on the y-axis.
- `X_UNIT`: Labels the x-axis in degC.
- `Y_UNIT`: Labels the y-axis in umol product/min.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put temperature (degC) on the horizontal axis.
- `Y_VARIABLE`: Put umol product/min on the vertical axis.
- `X_UNIT`: Label the x-axis in degC.
- `Y_UNIT`: Label the y-axis in umol product/min.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 32 - DRG-P2-22

### item_id
`DRG-P2-22`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured photosynthesis rate at seven light intensities. Using the data provided, construct an appropriately scaled and labeled graph of mean umol co2/m2/s versus light intensity (umol photons/m2/s). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| light intensity (umol photons/m2/s) | Mean umol CO2/m2/s | SEM |
| --- | ---: | ---: |
| 0 | 0.5 | 0.4 |
| 200 | 18.4 | 0.4 |
| 400 | 28 | 0.5 |
| 600 | 32.5 | 0.6 |
| 800 | 35.4 | 0.4 |
| 1000 | 36.5 | 0.4 |
| 1200 | 36.4 | 0.5 |

### expected_graph_spec
- X-axis is light intensity (umol photons/m2/s) with actual numeric spacing.
- Y-axis is umol CO2/m2/s and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places light intensity (umol photons/m2/s) on the x-axis.
- `Y_VARIABLE`: Places mean umol CO2/m2/s on the y-axis.
- `X_UNIT`: Labels the x-axis in umol photons/m2/s.
- `Y_UNIT`: Labels the y-axis in umol CO2/m2/s.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put light intensity (umol photons/m2/s) on the horizontal axis.
- `Y_VARIABLE`: Put umol CO2/m2/s on the vertical axis.
- `X_UNIT`: Label the x-axis in umol photons/m2/s.
- `Y_UNIT`: Label the y-axis in umol CO2/m2/s.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 33 - DRG-P2-23

### item_id
`DRG-P2-23`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured heart rate recovery over six minutes. Using the data provided, construct an appropriately scaled and labeled graph of mean beats/min versus time (min). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| time (min) | Mean beats/min | SEM |
| --- | ---: | ---: |
| 0 | 73.7 | 0.3 |
| 2 | 62.2 | 0.5 |
| 4 | 51.9 | 0.4 |
| 6 | 39.4 | 0.4 |
| 8 | 28.6 | 0.3 |
| 10 | 18.7 | 0.6 |

### expected_graph_spec
- X-axis is time (min) with actual numeric spacing.
- Y-axis is beats/min and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places time (min) on the x-axis.
- `Y_VARIABLE`: Places mean beats/min on the y-axis.
- `X_UNIT`: Labels the x-axis in min.
- `Y_UNIT`: Labels the y-axis in beats/min.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put time (min) on the horizontal axis.
- `Y_VARIABLE`: Put beats/min on the vertical axis.
- `X_UNIT`: Label the x-axis in min.
- `Y_UNIT`: Label the y-axis in beats/min.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 34 - DRG-P2-24

### item_id
`DRG-P2-24`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured transpiration rate at seven wind speeds. Using the data provided, construct an appropriately scaled and labeled graph of mean mg h2o/cm2/min versus wind speed (km/h). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| wind speed (km/h) | Mean mg H2O/cm2/min | SEM |
| --- | ---: | ---: |
| 0 | 9.1 | 0.3 |
| 5 | 12.8 | 0.6 |
| 10 | 17.9 | 0.4 |
| 15 | 22.5 | 0.2 |
| 20 | 26.2 | 0.5 |
| 25 | 30.1 | 0.3 |
| 30 | 34.8 | 0.7 |

### expected_graph_spec
- X-axis is wind speed (km/h) with actual numeric spacing.
- Y-axis is mg H2O/cm2/min and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places wind speed (km/h) on the x-axis.
- `Y_VARIABLE`: Places mean mg H2O/cm2/min on the y-axis.
- `X_UNIT`: Labels the x-axis in km/h.
- `Y_UNIT`: Labels the y-axis in mg H2O/cm2/min.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put wind speed (km/h) on the horizontal axis.
- `Y_VARIABLE`: Put mg H2O/cm2/min on the vertical axis.
- `X_UNIT`: Label the x-axis in km/h.
- `Y_UNIT`: Label the y-axis in mg H2O/cm2/min.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 35 - DRG-P2-25

### item_id
`DRG-P2-25`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured membrane potential shift across eight seconds after stimulus. Using the data provided, construct an appropriately scaled and labeled graph of mean mv versus time (s). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| time (s) | Mean mV | SEM |
| --- | ---: | ---: |
| 0 | 87 | 0.4 |
| 1 | 76.2 | 0.5 |
| 2 | 66.6 | 0.4 |
| 3 | 56.2 | 0.3 |
| 4 | 44.8 | 0.4 |
| 5 | 35.6 | 0.6 |
| 6 | 25.4 | 0.3 |
| 7 | 14.7 | 0.4 |

### expected_graph_spec
- X-axis is time (s) with actual numeric spacing.
- Y-axis is mV and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places time (s) on the x-axis.
- `Y_VARIABLE`: Places mean mV on the y-axis.
- `X_UNIT`: Labels the x-axis in s.
- `Y_UNIT`: Labels the y-axis in mV.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put time (s) on the horizontal axis.
- `Y_VARIABLE`: Put mV on the vertical axis.
- `X_UNIT`: Label the x-axis in s.
- `Y_UNIT`: Label the y-axis in mV.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 36 - DRG-P2-26

### item_id
`DRG-P2-26`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured oxygen consumption at seven temperatures. Using the data provided, construct an appropriately scaled and labeled graph of mean ml o2/min versus temperature (degC). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| temperature (degC) | Mean mL O2/min | SEM |
| --- | ---: | ---: |
| 10 | 3.2 | 0.5 |
| 20 | 15 | 0.3 |
| 30 | 37.8 | 0.4 |
| 37 | 46.7 | 0.3 |
| 45 | 36.5 | 0.6 |
| 55 | 11.9 | 0.4 |
| 65 | 1.4 | 0.2 |

### expected_graph_spec
- X-axis is temperature (degC) with actual numeric spacing.
- Y-axis is mL O2/min and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places temperature (degC) on the x-axis.
- `Y_VARIABLE`: Places mean mL O2/min on the y-axis.
- `X_UNIT`: Labels the x-axis in degC.
- `Y_UNIT`: Labels the y-axis in mL O2/min.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put temperature (degC) on the horizontal axis.
- `Y_VARIABLE`: Put mL O2/min on the vertical axis.
- `X_UNIT`: Label the x-axis in degC.
- `Y_UNIT`: Label the y-axis in mL O2/min.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 37 - DRG-P2-27

### item_id
`DRG-P2-27`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured leaf fluorescence over eight minutes of stress exposure. Using the data provided, construct an appropriately scaled and labeled graph of mean a.u. versus time (min). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| time (min) | Mean a.u. | SEM |
| --- | ---: | ---: |
| 0 | 9.3 | 0.4 |
| 1 | 15.3 | 0.3 |
| 2 | 18.5 | 0.2 |
| 3 | 23 | 0.5 |
| 4 | 28.8 | 0.6 |
| 5 | 44.5 | 0.5 |
| 6 | 39.8 | 0.3 |
| 8 | 49.9 | 0.6 |

### expected_graph_spec
- X-axis is time (min) with actual numeric spacing.
- Y-axis is a.u. and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places time (min) on the x-axis.
- `Y_VARIABLE`: Places mean a.u. on the y-axis.
- `X_UNIT`: Labels the x-axis in min.
- `Y_UNIT`: Labels the y-axis in a.u..
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put time (min) on the horizontal axis.
- `Y_VARIABLE`: Put a.u. on the vertical axis.
- `X_UNIT`: Label the x-axis in min.
- `Y_UNIT`: Label the y-axis in a.u..
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 38 - DRG-P2-28

### item_id
`DRG-P2-28`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured nutrient uptake over six time points. Using the data provided, construct an appropriately scaled and labeled graph of mean mg/g/hr versus time (hr). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| time (hr) | Mean mg/g/hr | SEM |
| --- | ---: | ---: |
| 0 | 0.5 | 0.5 |
| 4 | 17 | 0.2 |
| 8 | 27 | 0.5 |
| 12 | 30.6 | 0.6 |
| 18 | 34.5 | 0.3 |
| 24 | 34.8 | 0.3 |

### expected_graph_spec
- X-axis is time (hr) with actual numeric spacing.
- Y-axis is mg/g/hr and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places time (hr) on the x-axis.
- `Y_VARIABLE`: Places mean mg/g/hr on the y-axis.
- `X_UNIT`: Labels the x-axis in hr.
- `Y_UNIT`: Labels the y-axis in mg/g/hr.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put time (hr) on the horizontal axis.
- `Y_VARIABLE`: Put mg/g/hr on the vertical axis.
- `X_UNIT`: Label the x-axis in hr.
- `Y_UNIT`: Label the y-axis in mg/g/hr.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 39 - DRG-P2-29

### item_id
`DRG-P2-29`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured stomatal aperture across seven humidity values. Using the data provided, construct an appropriately scaled and labeled graph of mean um versus humidity (%). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| humidity (%) | Mean um | SEM |
| --- | ---: | ---: |
| 20 | 38.3 | 0.5 |
| 30 | 33 | 0.7 |
| 40 | 28.1 | 0.3 |
| 50 | 23.4 | 0.4 |
| 60 | 18 | 0.2 |
| 75 | 12.8 | 0.5 |
| 90 | 7.7 | 0.3 |

### expected_graph_spec
- X-axis is humidity (%) with actual numeric spacing.
- Y-axis is um and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places humidity (%) on the x-axis.
- `Y_VARIABLE`: Places mean um on the y-axis.
- `X_UNIT`: Labels the x-axis in %.
- `Y_UNIT`: Labels the y-axis in um.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put humidity (%) on the horizontal axis.
- `Y_VARIABLE`: Put um on the vertical axis.
- `X_UNIT`: Label the x-axis in %.
- `Y_UNIT`: Label the y-axis in um.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 40 - DRG-P2-30

### item_id
`DRG-P2-30`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured enzyme rate across seven ph values. Using the data provided, construct an appropriately scaled and labeled graph of mean a.u. versus pH. Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| pH | Mean a.u. | SEM |
| --- | ---: | ---: |
| 4 | 1.8 | 0.4 |
| 5 | 10.4 | 0.5 |
| 6 | 31.5 | 0.6 |
| 7 | 44 | 0.5 |
| 8 | 30.8 | 0.6 |
| 9 | 12.1 | 0.5 |
| 10 | 2.7 | 0.5 |

### expected_graph_spec
- X-axis is pH with actual numeric spacing.
- Y-axis is a.u. and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places pH on the x-axis.
- `Y_VARIABLE`: Places mean a.u. on the y-axis.
- `X_UNIT`: Labels the x-axis in pH.
- `Y_UNIT`: Labels the y-axis in a.u..
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put pH on the horizontal axis.
- `Y_VARIABLE`: Put a.u. on the vertical axis.
- `X_UNIT`: Label the x-axis in pH.
- `Y_UNIT`: Label the y-axis in a.u..
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 41 - DRG-P2-31

### item_id
`DRG-P2-31`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured chlorophyll fluorescence at eight light intensities. Using the data provided, construct an appropriately scaled and labeled graph of mean a.u. versus light intensity. Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| light intensity | Mean a.u. | SEM |
| --- | ---: | ---: |
| 0 | 0.5 | 0.4 |
| 100 | 13.4 | 0.2 |
| 200 | 21.9 | 0.5 |
| 400 | 33.1 | 0.4 |
| 600 | 38.9 | 0.5 |
| 800 | 42.6 | 0.5 |
| 1000 | 44.2 | 0.5 |
| 1200 | 44 | 0.5 |

### expected_graph_spec
- X-axis is light intensity with actual numeric spacing.
- Y-axis is a.u. and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places light intensity on the x-axis.
- `Y_VARIABLE`: Places mean a.u. on the y-axis.
- `X_UNIT`: Labels the x-axis in light intensity.
- `Y_UNIT`: Labels the y-axis in a.u..
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put light intensity on the horizontal axis.
- `Y_VARIABLE`: Put a.u. on the vertical axis.
- `X_UNIT`: Label the x-axis in light intensity.
- `Y_UNIT`: Label the y-axis in a.u..
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 42 - DRG-P2-32

### item_id
`DRG-P2-32`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured growth rate at seven salinity steps. Using the data provided, construct an appropriately scaled and labeled graph of mean mm/day versus salinity (mM). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| salinity (mM) | Mean mm/day | SEM |
| --- | ---: | ---: |
| 0 | 6.6 | 0.6 |
| 10 | 13.9 | 0.4 |
| 20 | 20 | 0.3 |
| 30 | 26.5 | 0.3 |
| 40 | 32.8 | 0.4 |
| 50 | 37.7 | 0.3 |
| 60 | 43.7 | 0.4 |

### expected_graph_spec
- X-axis is salinity (mM) with actual numeric spacing.
- Y-axis is mm/day and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places salinity (mM) on the x-axis.
- `Y_VARIABLE`: Places mean mm/day on the y-axis.
- `X_UNIT`: Labels the x-axis in mM.
- `Y_UNIT`: Labels the y-axis in mm/day.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put salinity (mM) on the horizontal axis.
- `Y_VARIABLE`: Put mm/day on the vertical axis.
- `X_UNIT`: Label the x-axis in mM.
- `Y_UNIT`: Label the y-axis in mm/day.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 43 - DRG-P2-33

### item_id
`DRG-P2-33`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured phloem transport rate across six sucrose concentrations. Using the data provided, construct an appropriately scaled and labeled graph of mean mg/hr versus sucrose concentration (%). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| sucrose concentration (%) | Mean mg/hr | SEM |
| --- | ---: | ---: |
| 0 | 0.6 | 0.2 |
| 2 | 28.9 | 0.2 |
| 4 | 41 | 0.5 |
| 6 | 47.7 | 0.4 |
| 8 | 49.1 | 0.4 |
| 10 | 50.1 | 0.2 |

### expected_graph_spec
- X-axis is sucrose concentration (%) with actual numeric spacing.
- Y-axis is mg/hr and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places sucrose concentration (%) on the x-axis.
- `Y_VARIABLE`: Places mean mg/hr on the y-axis.
- `X_UNIT`: Labels the x-axis in %.
- `Y_UNIT`: Labels the y-axis in mg/hr.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put sucrose concentration (%) on the horizontal axis.
- `Y_VARIABLE`: Put mg/hr on the vertical axis.
- `X_UNIT`: Label the x-axis in %.
- `Y_UNIT`: Label the y-axis in mg/hr.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 44 - DRG-P2-34

### item_id
`DRG-P2-34`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured microbial respiration at seven temperatures. Using the data provided, construct an appropriately scaled and labeled graph of mean co2 release rate versus temperature (degC). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| temperature (degC) | Mean CO2 release rate | SEM |
| --- | ---: | ---: |
| 15 | 5 | 0.4 |
| 25 | 22.5 | 0.4 |
| 30 | 35.6 | 0.4 |
| 37 | 45.1 | 0.6 |
| 45 | 33.7 | 0.2 |
| 55 | 8.3 | 0.5 |
| 65 | 1 | 0.5 |

### expected_graph_spec
- X-axis is temperature (degC) with actual numeric spacing.
- Y-axis is CO2 release rate and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places temperature (degC) on the x-axis.
- `Y_VARIABLE`: Places mean CO2 release rate on the y-axis.
- `X_UNIT`: Labels the x-axis in degC.
- `Y_UNIT`: Labels the y-axis in CO2 release rate.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put temperature (degC) on the horizontal axis.
- `Y_VARIABLE`: Put CO2 release rate on the vertical axis.
- `X_UNIT`: Label the x-axis in degC.
- `Y_UNIT`: Label the y-axis in CO2 release rate.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 45 - DRG-P2-35

### item_id
`DRG-P2-35`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured atp yield over seven exercise durations. Using the data provided, construct an appropriately scaled and labeled graph of mean a.u. versus exercise duration (min). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| exercise duration (min) | Mean a.u. | SEM |
| --- | ---: | ---: |
| 0 | 63.3 | 0.7 |
| 5 | 55.1 | 0.2 |
| 10 | 46.8 | 0.3 |
| 15 | 39.3 | 0.4 |
| 20 | 31.5 | 0.2 |
| 25 | 23.4 | 0.2 |
| 30 | 17.1 | 0.4 |

### expected_graph_spec
- X-axis is exercise duration (min) with actual numeric spacing.
- Y-axis is a.u. and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places exercise duration (min) on the x-axis.
- `Y_VARIABLE`: Places mean a.u. on the y-axis.
- `X_UNIT`: Labels the x-axis in min.
- `Y_UNIT`: Labels the y-axis in a.u..
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put exercise duration (min) on the horizontal axis.
- `Y_VARIABLE`: Put a.u. on the vertical axis.
- `X_UNIT`: Label the x-axis in min.
- `Y_UNIT`: Label the y-axis in a.u..
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 46 - DRG-P2-36

### item_id
`DRG-P2-36`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured water potential across seven soil-moisture values. Using the data provided, construct an appropriately scaled and labeled graph of mean mpa versus soil moisture (%). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| soil moisture (%) | Mean MPa | SEM |
| --- | ---: | ---: |
| 10 | 44.7 | 0.2 |
| 20 | 39.4 | 0.3 |
| 30 | 33.4 | 0.6 |
| 40 | 29 | 0.5 |
| 50 | 24.2 | 0.3 |
| 65 | 17.6 | 0.4 |
| 80 | 12.4 | 0.4 |

### expected_graph_spec
- X-axis is soil moisture (%) with actual numeric spacing.
- Y-axis is MPa and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places soil moisture (%) on the x-axis.
- `Y_VARIABLE`: Places mean MPa on the y-axis.
- `X_UNIT`: Labels the x-axis in %.
- `Y_UNIT`: Labels the y-axis in MPa.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put soil moisture (%) on the horizontal axis.
- `Y_VARIABLE`: Put MPa on the vertical axis.
- `X_UNIT`: Label the x-axis in %.
- `Y_UNIT`: Label the y-axis in MPa.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 47 - DRG-P2-37

### item_id
`DRG-P2-37`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured virus replication over eight hours. Using the data provided, construct an appropriately scaled and labeled graph of mean viral genomes/ml versus time (hr). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| time (hr) | Mean viral genomes/mL | SEM |
| --- | ---: | ---: |
| 0 | 87 | 0.5 |
| 1 | 74.9 | 0.2 |
| 2 | 64.6 | 0.4 |
| 3 | 54.2 | 0.4 |
| 4 | 44.2 | 0.5 |
| 5 | 33.9 | 0.6 |
| 6 | 23.9 | 0.3 |
| 8 | 14.1 | 0.7 |

### expected_graph_spec
- X-axis is time (hr) with actual numeric spacing.
- Y-axis is viral genomes/mL and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places time (hr) on the x-axis.
- `Y_VARIABLE`: Places mean viral genomes/mL on the y-axis.
- `X_UNIT`: Labels the x-axis in hr.
- `Y_UNIT`: Labels the y-axis in viral genomes/mL.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put time (hr) on the horizontal axis.
- `Y_VARIABLE`: Put viral genomes/mL on the vertical axis.
- `X_UNIT`: Label the x-axis in hr.
- `Y_UNIT`: Label the y-axis in viral genomes/mL.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 48 - DRG-P2-38

### item_id
`DRG-P2-38`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured enzyme fluorescence across seven metal concentrations. Using the data provided, construct an appropriately scaled and labeled graph of mean a.u. versus metal concentration (mM). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| metal concentration (mM) | Mean a.u. | SEM |
| --- | ---: | ---: |
| 0 | 13.3 | 0.5 |
| 1 | 19 | 0.3 |
| 2 | 25.5 | 0.4 |
| 4 | 32.1 | 0.5 |
| 6 | 31.7 | 0.2 |
| 8 | 45.1 | 0.3 |
| 10 | 54.4 | 0.6 |

### expected_graph_spec
- X-axis is metal concentration (mM) with actual numeric spacing.
- Y-axis is a.u. and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places metal concentration (mM) on the x-axis.
- `Y_VARIABLE`: Places mean a.u. on the y-axis.
- `X_UNIT`: Labels the x-axis in mM.
- `Y_UNIT`: Labels the y-axis in a.u..
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put metal concentration (mM) on the horizontal axis.
- `Y_VARIABLE`: Put a.u. on the vertical axis.
- `X_UNIT`: Label the x-axis in mM.
- `Y_UNIT`: Label the y-axis in a.u..
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 49 - DRG-P2-39

### item_id
`DRG-P2-39`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured seedling elongation over eight photoperiods. Using the data provided, construct an appropriately scaled and labeled graph of mean mm versus photoperiod (hr). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| photoperiod (hr) | Mean mm | SEM |
| --- | ---: | ---: |
| 8 | 0.5 | 0.4 |
| 9 | 19.4 | 0.3 |
| 10 | 31.6 | 0.2 |
| 11 | 39.4 | 0.2 |
| 12 | 44.8 | 0.4 |
| 13 | 47.2 | 0.5 |
| 14 | 49.1 | 0.3 |
| 16 | 49.4 | 0.5 |

### expected_graph_spec
- X-axis is photoperiod (hr) with actual numeric spacing.
- Y-axis is mm and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places photoperiod (hr) on the x-axis.
- `Y_VARIABLE`: Places mean mm on the y-axis.
- `X_UNIT`: Labels the x-axis in hr.
- `Y_UNIT`: Labels the y-axis in mm.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put photoperiod (hr) on the horizontal axis.
- `Y_VARIABLE`: Put mm on the vertical axis.
- `X_UNIT`: Label the x-axis in hr.
- `Y_UNIT`: Label the y-axis in mm.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 50 - DRG-P2-40

### item_id
`DRG-P2-40`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured algal photosynthesis across eight water depths. Using the data provided, construct an appropriately scaled and labeled graph of mean umol o2/m2/s versus water depth (m). Plot the means at their measured values, connect adjacent measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean.

### synthetic_data_source
Method b, explicit synthetic replicates. Four observations per measurement point. The replicate values are intentionally irregular rather than consecutive-integer sequences.

### display_table

| water depth (m) | Mean umol O2/m2/s | SEM |
| --- | ---: | ---: |
| 0 | 54.4 | 0.3 |
| 2 | 47 | 0.4 |
| 4 | 39.8 | 0.4 |
| 6 | 33.4 | 0.4 |
| 8 | 26.1 | 0.6 |
| 12 | 19.7 | 0.4 |
| 20 | 11.5 | 0.4 |
| 30 | 5 | 0.2 |

### expected_graph_spec
- X-axis is water depth (m) with actual numeric spacing.
- Y-axis is umol O2/m2/s and starts at zero.
- Plot the mean at each measured x-value.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required measured-series graph.
- `X_VARIABLE`: Places water depth (m) on the x-axis.
- `Y_VARIABLE`: Places mean umol O2/m2/s on the y-axis.
- `X_UNIT`: Labels the x-axis in m.
- `Y_UNIT`: Labels the y-axis in umol O2/m2/s.
- `X_SCALE`: Uses actual numeric spacing between measurement values.
- `Y_SCALE`: Starts the y-axis at zero.
- `PLOT_VALUES`: Places each mean at the correct x-value and height.
- `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.
- `POINT_CONNECTION`: Connects adjacent measured points in order.

### accepted_variants
- Straight-line segments between adjacent measured values are acceptable.
- The x-axis may use whole-number or rotated tick labels if needed for space.
- The final segment may appear nearly flat if the data plateau.

### contradictions
- Spacing the x-values evenly as if they were categories.
- Replacing the measured values with a smooth spline that moves the points.
- Leaving off the error bars.

### development_tolerances
Proposed development tolerances, not validated thresholds: each mean within 0.1 units; SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero.

### minimum_feedback
- `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.
- `X_VARIABLE`: Put water depth (m) on the horizontal axis.
- `Y_VARIABLE`: Put umol O2/m2/s on the vertical axis.
- `X_UNIT`: Label the x-axis in m.
- `Y_UNIT`: Label the y-axis in umol O2/m2/s.
- `X_SCALE`: Space the x-values according to their numeric distance.
- `Y_SCALE`: Start the vertical axis at zero.
- `PLOT_VALUES`: Place each point at the right x-value and y-value.
- `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.
- `POINT_CONNECTION`: Connect the measured points in order.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 51 - DRG-P2-41

### item_id
`DRG-P2-41`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured percent mass change versus sucrose concentration with negative and positive values; estimate the zero-crossing at about `0.4 m`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the solute concentration (M) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| solute concentration (M) | percent mass change |
| --- | ---: |
| 1.7 | 7 |
| 1.9 | 4.3 |
| 2.1 | -0.7 |
| 2.3 | -4.1 |
| 2.5 | -6.3 |
| 2.7 | -11 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `2.1 M`.
- Label the intercept estimate in M.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places solute concentration (M) on the x-axis.
- `Y_VARIABLE`: Places percent mass change on the y-axis.
- `X_UNIT`: Labels the x-axis in M.
- `Y_UNIT`: Labels the y-axis in percent mass change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in M.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put solute concentration (M) on the x-axis.
- `Y_VARIABLE`: Put percent mass change on the y-axis.
- `X_UNIT`: Add M to the x-axis label.
- `Y_UNIT`: Label the response axis as percent mass change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in M.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 52 - DRG-P2-42

### item_id
`DRG-P2-42`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured percent turgor change versus salinity with values crossing zero near `120 mm`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the salinity (mM) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| salinity (mM) | percent turgor change |
| --- | ---: |
| 119.6 | 3.9 |
| 119.8 | 2.8 |
| 120 | -0 |
| 120.2 | -2.8 |
| 120.4 | -4 |
| 120.6 | -8 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `120 mM`.
- Label the intercept estimate in mM.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places salinity (mM) on the x-axis.
- `Y_VARIABLE`: Places percent turgor change on the y-axis.
- `X_UNIT`: Labels the x-axis in mM.
- `Y_UNIT`: Labels the y-axis in percent turgor change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in mM.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put salinity (mM) on the x-axis.
- `Y_VARIABLE`: Put percent turgor change on the y-axis.
- `X_UNIT`: Add mM to the x-axis label.
- `Y_UNIT`: Label the response axis as percent turgor change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in mM.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 53 - DRG-P2-43

### item_id
`DRG-P2-43`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured enzyme activity versus inhibitor concentration with values crossing zero near `15 um`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the inhibitor concentration (uM) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| inhibitor concentration (uM) | enzyme activity |
| --- | ---: |
| 14.6 | -4.2 |
| 14.8 | -1.9 |
| 15 | -0.5 |
| 15.2 | 1.2 |
| 15.4 | 4 |
| 15.6 | 4.4 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `15 uM`.
- Label the intercept estimate in uM.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places inhibitor concentration (uM) on the x-axis.
- `Y_VARIABLE`: Places enzyme activity on the y-axis.
- `X_UNIT`: Labels the x-axis in uM.
- `Y_UNIT`: Labels the y-axis in enzyme activity.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in uM.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put inhibitor concentration (uM) on the x-axis.
- `Y_VARIABLE`: Put enzyme activity on the y-axis.
- `X_UNIT`: Add uM to the x-axis label.
- `Y_UNIT`: Label the response axis as enzyme activity.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in uM.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 54 - DRG-P2-44

### item_id
`DRG-P2-44`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured leaf wilting index versus humidity with values crossing zero near `55%`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the humidity (%) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| humidity (%) | wilting index |
| --- | ---: |
| 54.6 | -5.7 |
| 54.8 | -4.3 |
| 55 | 0.4 |
| 55.2 | 2.6 |
| 55.4 | 6.9 |
| 55.6 | 9.5 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `55 %`.
- Label the intercept estimate in %.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places humidity (%) on the x-axis.
- `Y_VARIABLE`: Places wilting index on the y-axis.
- `X_UNIT`: Labels the x-axis in %.
- `Y_UNIT`: Labels the y-axis in wilting index.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in %.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put humidity (%) on the x-axis.
- `Y_VARIABLE`: Put wilting index on the y-axis.
- `X_UNIT`: Add % to the x-axis label.
- `Y_UNIT`: Label the response axis as wilting index.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in %.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 55 - DRG-P2-45

### item_id
`DRG-P2-45`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured membrane-potential shift versus extracellular `k+` concentration crossing zero near `6 mm`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the extracellular K+ concentration (mM) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| extracellular K+ concentration (mM) | membrane-potential shift |
| --- | ---: |
| 5.6 | -3.5 |
| 5.8 | -3 |
| 6 | 0.8 |
| 6.2 | 1.8 |
| 6.4 | 5.2 |
| 6.6 | 6.3 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `6 mM`.
- Label the intercept estimate in mM.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places extracellular K+ concentration (mM) on the x-axis.
- `Y_VARIABLE`: Places membrane-potential shift on the y-axis.
- `X_UNIT`: Labels the x-axis in mM.
- `Y_UNIT`: Labels the y-axis in membrane-potential shift.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in mM.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put extracellular K+ concentration (mM) on the x-axis.
- `Y_VARIABLE`: Put membrane-potential shift on the y-axis.
- `X_UNIT`: Add mM to the x-axis label.
- `Y_UNIT`: Label the response axis as membrane-potential shift.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in mM.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 56 - DRG-P2-46

### item_id
`DRG-P2-46`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured root growth change versus auxin concentration crossing zero near `2 ng/ml`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the auxin concentration (ng/mL) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| auxin concentration (ng/mL) | root growth change |
| --- | ---: |
| 1.6 | 2.3 |
| 1.8 | 2.6 |
| 2 | -0.8 |
| 2.2 | -0.9 |
| 2.4 | -3.7 |
| 2.6 | -4.5 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `2 ng/mL`.
- Label the intercept estimate in ng/mL.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places auxin concentration (ng/mL) on the x-axis.
- `Y_VARIABLE`: Places root growth change on the y-axis.
- `X_UNIT`: Labels the x-axis in ng/mL.
- `Y_UNIT`: Labels the y-axis in root growth change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in ng/mL.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put auxin concentration (ng/mL) on the x-axis.
- `Y_VARIABLE`: Put root growth change on the y-axis.
- `X_UNIT`: Add ng/mL to the x-axis label.
- `Y_UNIT`: Label the response axis as root growth change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in ng/mL.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 57 - DRG-P2-47

### item_id
`DRG-P2-47`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured germination success versus nitrate concentration crossing zero near `18 mg/l`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the nitrate concentration (mg/L) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| nitrate concentration (mg/L) | germination success |
| --- | ---: |
| 17.6 | -3.6 |
| 17.8 | -1 |
| 18 | -0.6 |
| 18.2 | 2.4 |
| 18.4 | 3.1 |
| 18.6 | 5.8 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `18 mg/L`.
- Label the intercept estimate in mg/L.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places nitrate concentration (mg/L) on the x-axis.
- `Y_VARIABLE`: Places germination success on the y-axis.
- `X_UNIT`: Labels the x-axis in mg/L.
- `Y_UNIT`: Labels the y-axis in germination success.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in mg/L.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put nitrate concentration (mg/L) on the x-axis.
- `Y_VARIABLE`: Put germination success on the y-axis.
- `X_UNIT`: Add mg/L to the x-axis label.
- `Y_UNIT`: Label the response axis as germination success.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in mg/L.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 58 - DRG-P2-48

### item_id
`DRG-P2-48`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured photosynthetic delta versus co2 enrichment crossing zero near `380 ppm`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the CO2 enrichment (ppm) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| CO2 enrichment (ppm) | photosynthetic delta |
| --- | ---: |
| 379.6 | 3.3 |
| 379.8 | 0.7 |
| 380 | -0.1 |
| 380.2 | -0.8 |
| 380.4 | -3.9 |
| 380.6 | -5.6 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `380 ppm`.
- Label the intercept estimate in ppm.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places CO2 enrichment (ppm) on the x-axis.
- `Y_VARIABLE`: Places photosynthetic delta on the y-axis.
- `X_UNIT`: Labels the x-axis in ppm.
- `Y_UNIT`: Labels the y-axis in photosynthetic delta.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in ppm.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put CO2 enrichment (ppm) on the x-axis.
- `Y_VARIABLE`: Put photosynthetic delta on the y-axis.
- `X_UNIT`: Add ppm to the x-axis label.
- `Y_UNIT`: Label the response axis as photosynthetic delta.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in ppm.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 59 - DRG-P2-49

### item_id
`DRG-P2-49`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured osmotic mass change versus peg concentration crossing zero near `8%`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the solute concentration (M) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| solute concentration (M) | percent mass change |
| --- | ---: |
| 7.6 | 6.8 |
| 7.8 | 4.2 |
| 8 | 0.1 |
| 8.2 | -4.5 |
| 8.4 | -7.6 |
| 8.6 | -9.7 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `8 %`.
- Label the intercept estimate in %.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places solute concentration (M) on the x-axis.
- `Y_VARIABLE`: Places percent mass change on the y-axis.
- `X_UNIT`: Labels the x-axis in %.
- `Y_UNIT`: Labels the y-axis in percent mass change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in %.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put solute concentration (M) on the x-axis.
- `Y_VARIABLE`: Put percent mass change on the y-axis.
- `X_UNIT`: Add % to the x-axis label.
- `Y_UNIT`: Label the response axis as percent mass change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in %.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 60 - DRG-P2-50

### item_id
`DRG-P2-50`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured stomatal aperture change versus aba concentration crossing zero near `0.8 um`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the ABA concentration (uM) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| ABA concentration (uM) | stomatal aperture change |
| --- | ---: |
| 0.4 | -6.9 |
| 0.6 | -2.4 |
| 0.8 | 0.3 |
| 1 | 2.8 |
| 1.2 | 6.4 |
| 1.4 | 9.3 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `0.8 uM`.
- Label the intercept estimate in uM.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places ABA concentration (uM) on the x-axis.
- `Y_VARIABLE`: Places stomatal aperture change on the y-axis.
- `X_UNIT`: Labels the x-axis in uM.
- `Y_UNIT`: Labels the y-axis in stomatal aperture change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in uM.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put ABA concentration (uM) on the x-axis.
- `Y_VARIABLE`: Put stomatal aperture change on the y-axis.
- `X_UNIT`: Add uM to the x-axis label.
- `Y_UNIT`: Label the response axis as stomatal aperture change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in uM.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 61 - DRG-P2-51

### item_id
`DRG-P2-51`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured cell elongation change versus gibberellin concentration crossing zero near `1.5 um`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the gibberellin concentration (uM) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| gibberellin concentration (uM) | cell elongation change |
| --- | ---: |
| 1.1 | -4.7 |
| 1.3 | -2.3 |
| 1.5 | 1 |
| 1.7 | 1.8 |
| 1.9 | 4.6 |
| 2.1 | 7.9 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `1.5 uM`.
- Label the intercept estimate in uM.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places gibberellin concentration (uM) on the x-axis.
- `Y_VARIABLE`: Places cell elongation change on the y-axis.
- `X_UNIT`: Labels the x-axis in uM.
- `Y_UNIT`: Labels the y-axis in cell elongation change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in uM.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put gibberellin concentration (uM) on the x-axis.
- `Y_VARIABLE`: Put cell elongation change on the y-axis.
- `X_UNIT`: Add uM to the x-axis label.
- `Y_UNIT`: Label the response axis as cell elongation change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in uM.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 62 - DRG-P2-52

### item_id
`DRG-P2-52`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured respiration change versus temperature acclimation crossing zero near `24 degc`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the acclimation temperature (degC) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| acclimation temperature (degC) | respiration change |
| --- | ---: |
| 23.6 | -4.8 |
| 23.8 | -2.5 |
| 24 | 0.1 |
| 24.2 | 1.6 |
| 24.4 | 3.9 |
| 24.6 | 6.8 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `24 degC`.
- Label the intercept estimate in degC.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places acclimation temperature (degC) on the x-axis.
- `Y_VARIABLE`: Places respiration change on the y-axis.
- `X_UNIT`: Labels the x-axis in degC.
- `Y_UNIT`: Labels the y-axis in respiration change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in degC.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put acclimation temperature (degC) on the x-axis.
- `Y_VARIABLE`: Put respiration change on the y-axis.
- `X_UNIT`: Add degC to the x-axis label.
- `Y_UNIT`: Label the response axis as respiration change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in degC.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 63 - DRG-P2-53

### item_id
`DRG-P2-53`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured electrolyte leakage change versus cold-exposure duration crossing zero near `5 min`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the cold-exposure duration (min) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| cold-exposure duration (min) | electrolyte leakage change |
| --- | ---: |
| 4.6 | -4.2 |
| 4.8 | -2.6 |
| 5 | -0.3 |
| 5.2 | 2.6 |
| 5.4 | 4.1 |
| 5.6 | 6.8 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `5 min`.
- Label the intercept estimate in min.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places cold-exposure duration (min) on the x-axis.
- `Y_VARIABLE`: Places electrolyte leakage change on the y-axis.
- `X_UNIT`: Labels the x-axis in min.
- `Y_UNIT`: Labels the y-axis in electrolyte leakage change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in min.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put cold-exposure duration (min) on the x-axis.
- `Y_VARIABLE`: Put electrolyte leakage change on the y-axis.
- `X_UNIT`: Add min to the x-axis label.
- `Y_UNIT`: Label the response axis as electrolyte leakage change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in min.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 64 - DRG-P2-54

### item_id
`DRG-P2-54`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured biomass change versus salinity crossing zero near `20 mm`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the solute concentration (M) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| solute concentration (M) | percent mass change |
| --- | ---: |
| 19.6 | 6.9 |
| 19.8 | 2.9 |
| 20 | -0.1 |
| 20.2 | -2.6 |
| 20.4 | -6.5 |
| 20.6 | -10.3 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `20 mM`.
- Label the intercept estimate in mM.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places solute concentration (M) on the x-axis.
- `Y_VARIABLE`: Places percent mass change on the y-axis.
- `X_UNIT`: Labels the x-axis in mM.
- `Y_UNIT`: Labels the y-axis in percent mass change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in mM.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put solute concentration (M) on the x-axis.
- `Y_VARIABLE`: Put percent mass change on the y-axis.
- `X_UNIT`: Add mM to the x-axis label.
- `Y_UNIT`: Label the response axis as percent mass change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in mM.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 65 - DRG-P2-55

### item_id
`DRG-P2-55`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured pigment loss versus ph crossing zero near `6.2`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the pH where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| pH | pigment loss |
| --- | ---: |
| 11.2 | -4.1 |
| 11.4 | -2.2 |
| 11.6 | -0.1 |
| 11.8 | 2.5 |
| 12 | 3.1 |
| 12.2 | 4.2 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `11.6 pH`.
- Label the intercept estimate in pH.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places pH on the x-axis.
- `Y_VARIABLE`: Places pigment loss on the y-axis.
- `X_UNIT`: Labels the x-axis in pH.
- `Y_UNIT`: Labels the y-axis in pigment loss.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in pH.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put pH on the x-axis.
- `Y_VARIABLE`: Put pigment loss on the y-axis.
- `X_UNIT`: Add pH to the x-axis label.
- `Y_UNIT`: Label the response axis as pigment loss.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in pH.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 66 - DRG-P2-56

### item_id
`DRG-P2-56`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured enzyme `kcat` change versus substrate-analog concentration crossing zero near `3 mm`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the substrate-analog concentration (mM) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| substrate-analog concentration (mM) | enzyme kcat change |
| --- | ---: |
| 2.6 | -6.6 |
| 2.8 | -3.3 |
| 3 | -0.5 |
| 3.2 | 2.9 |
| 3.4 | 6.8 |
| 3.6 | 9 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `3 mM`.
- Label the intercept estimate in mM.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places substrate-analog concentration (mM) on the x-axis.
- `Y_VARIABLE`: Places enzyme kcat change on the y-axis.
- `X_UNIT`: Labels the x-axis in mM.
- `Y_UNIT`: Labels the y-axis in enzyme kcat change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in mM.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put substrate-analog concentration (mM) on the x-axis.
- `Y_VARIABLE`: Put enzyme kcat change on the y-axis.
- `X_UNIT`: Add mM to the x-axis label.
- `Y_UNIT`: Label the response axis as enzyme kcat change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in mM.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 67 - DRG-P2-57

### item_id
`DRG-P2-57`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured seedling height change versus photoperiod crossing zero near `11 hr`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the photoperiod (hr) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| photoperiod (hr) | seedling height change |
| --- | ---: |
| 10.6 | -3 |
| 10.8 | -1.6 |
| 11 | -0.7 |
| 11.2 | 1 |
| 11.4 | 3 |
| 11.6 | 5.7 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `11 hr`.
- Label the intercept estimate in hr.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places photoperiod (hr) on the x-axis.
- `Y_VARIABLE`: Places seedling height change on the y-axis.
- `X_UNIT`: Labels the x-axis in hr.
- `Y_UNIT`: Labels the y-axis in seedling height change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in hr.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put photoperiod (hr) on the x-axis.
- `Y_VARIABLE`: Put seedling height change on the y-axis.
- `X_UNIT`: Add hr to the x-axis label.
- `Y_UNIT`: Label the response axis as seedling height change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in hr.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 68 - DRG-P2-58

### item_id
`DRG-P2-58`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured nitrate uptake change versus phosphate concentration crossing zero near `12 mg/l`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the nitrate concentration (mg/L) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| nitrate concentration (mg/L) | germination success |
| --- | ---: |
| 11.6 | -4 |
| 11.8 | -2.6 |
| 12 | -0.3 |
| 12.2 | 1.8 |
| 12.4 | 4.3 |
| 12.6 | 8.4 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `12 mg/L`.
- Label the intercept estimate in mg/L.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places nitrate concentration (mg/L) on the x-axis.
- `Y_VARIABLE`: Places germination success on the y-axis.
- `X_UNIT`: Labels the x-axis in mg/L.
- `Y_UNIT`: Labels the y-axis in germination success.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in mg/L.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put nitrate concentration (mg/L) on the x-axis.
- `Y_VARIABLE`: Put germination success on the y-axis.
- `X_UNIT`: Add mg/L to the x-axis label.
- `Y_UNIT`: Label the response axis as germination success.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in mg/L.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 69 - DRG-P2-59

### item_id
`DRG-P2-59`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured algal mass change versus light attenuation crossing zero near `0.7 absorbance`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the solute concentration (M) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| solute concentration (M) | percent mass change |
| --- | ---: |
| 0.3 | 6.2 |
| 0.5 | 4.1 |
| 0.7 | 0.6 |
| 0.9 | -3.2 |
| 1.1 | -5.5 |
| 1.3 | -10.5 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `0.7 absorbance`.
- Label the intercept estimate in absorbance.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places solute concentration (M) on the x-axis.
- `Y_VARIABLE`: Places percent mass change on the y-axis.
- `X_UNIT`: Labels the x-axis in absorbance.
- `Y_UNIT`: Labels the y-axis in percent mass change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in absorbance.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put solute concentration (M) on the x-axis.
- `Y_VARIABLE`: Put percent mass change on the y-axis.
- `X_UNIT`: Add absorbance to the x-axis label.
- `Y_UNIT`: Label the response axis as percent mass change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in absorbance.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 70 - DRG-P2-60

### item_id
`DRG-P2-60`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured transpiration change versus wind speed crossing zero near `4 km/h`. Using the data provided, plot the paired observations on linear axes, draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the wind speed (km/h) where the response is zero. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| wind speed (km/h) | transpiration change |
| --- | ---: |
| 3.6 | -7.4 |
| 3.8 | -3.9 |
| 4 | -0.3 |
| 4.2 | 3.5 |
| 4.4 | 6.4 |
| 4.6 | 9.6 |

### expected_graph_spec
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where the response crosses zero, near `4 km/h`.
- Label the intercept estimate in km/h.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places wind speed (km/h) on the x-axis.
- `Y_VARIABLE`: Places transpiration change on the y-axis.
- `X_UNIT`: Labels the x-axis in km/h.
- `Y_UNIT`: Labels the y-axis in transpiration change.
- `X_SCALE`: Uses a linear x-axis with correct numeric spacing.
- `Y_SCALE`: Includes zero and both positive and negative values.
- `PLOT_VALUES`: Places each paired observation at the correct coordinates.
- `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.
- `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.
- `ESTIMATE_VALUE`: Reports the zero-change estimate in km/h.

### accepted_variants
- The best-fit line may be drawn by eye or with a straightedge.
- The intercept may be annotated with an arrow or bracket.
- The estimate may be reported to one or two decimal places if consistent with the graph.

### contradictions
- Connecting the points in table order instead of fitting one relationship.
- Reporting the intercept in the response variable unit rather than the x-axis unit.
- Omitting negative y-values from the scale.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; intercept estimate within 0.05 x-units; y-axis must include zero and the negative data.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.
- `X_VARIABLE`: Put wind speed (km/h) on the x-axis.
- `Y_VARIABLE`: Put transpiration change on the y-axis.
- `X_UNIT`: Add km/h to the x-axis label.
- `Y_UNIT`: Label the response axis as transpiration change.
- `X_SCALE`: Use a linear x-axis with the correct spacing.
- `Y_SCALE`: Extend the y-axis to show zero and the negative values.
- `PLOT_VALUES`: Place each point at the right x-value and response value.
- `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.
- `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.
- `ESTIMATE_VALUE`: State the zero-change estimate in km/h.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 71 - DRG-P2-61

### item_id
`DRG-P2-61`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured bacterial culture density over `0, 4, 8, 12, 16, 20, 24, 36 hr`; estimate the population density around which the culture levels off. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (hr) | 10^5 cells/mL |
| --- | ---: |
| 0 | 1.6 |
| 4 | 13.3 |
| 8 | 17.8 |
| 12 | 19.7 |
| 16 | 20.6 |
| 20 | 20.7 |
| 24 | 21 |
| 32 | 20.7 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `10^5 cells/mL`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (hr) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `10^5 cells/mL`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `10^5 cells/mL`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (hr) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `10^5 cells/mL` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 72 - DRG-P2-62

### item_id
`DRG-P2-62`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured yeast density over `0, 3, 6, 9, 12, 15, 18, 24 hr`; estimate the population density around which the culture levels off. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (hr) | 10^5 cells/mL |
| --- | ---: |
| 0 | 1.3 |
| 4 | 13.3 |
| 8 | 17.4 |
| 12 | 18.6 |
| 16 | 19.2 |
| 20 | 19.2 |
| 24 | 19.6 |
| 32 | 19.3 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `10^5 cells/mL`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (hr) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `10^5 cells/mL`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `10^5 cells/mL`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (hr) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `10^5 cells/mL` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 73 - DRG-P2-63

### item_id
`DRG-P2-63`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured algae biomass over `0, 6, 12, 18, 24, 30, 36, 48 hr`; estimate the population density around which the culture levels off. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (hr) | biomass units |
| --- | ---: |
| 0 | 2.4 |
| 4 | 12.9 |
| 8 | 16.5 |
| 12 | 18 |
| 16 | 18.2 |
| 20 | 18.6 |
| 24 | 18.8 |
| 32 | 18.6 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `biomass units`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `biomass units`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (hr) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `biomass units`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `biomass units`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (hr) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `biomass units` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 74 - DRG-P2-64

### item_id
`DRG-P2-64`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured protist density over `0, 2, 4, 6, 8, 10, 12, 16 hr`; estimate the population density around which the culture levels off. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (hr) | 10^5 cells/mL |
| --- | ---: |
| 0 | 3.4 |
| 4 | 15.2 |
| 8 | 19.6 |
| 12 | 21.1 |
| 16 | 21.5 |
| 20 | 21.9 |
| 24 | 21.8 |
| 32 | 22 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `10^5 cells/mL`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (hr) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `10^5 cells/mL`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `10^5 cells/mL`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (hr) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `10^5 cells/mL` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 75 - DRG-P2-65

### item_id
`DRG-P2-65`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured leaf area expansion over `0, 2, 4, 6, 8, 10, 12, 16 days`; estimate the level-off area. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (days) | cm2 |
| --- | ---: |
| 0 | 2.3 |
| 4 | 13.8 |
| 8 | 19.4 |
| 12 | 21.9 |
| 16 | 23.4 |
| 20 | 23.9 |
| 24 | 24.2 |
| 32 | 24.2 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `cm2`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `cm2`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (days) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `cm2`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `cm2`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (days) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `cm2` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 76 - DRG-P2-66

### item_id
`DRG-P2-66`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured seedling height over `0, 3, 6, 9, 12, 15, 18, 24 days`; estimate the level-off height. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (days) | cm |
| --- | ---: |
| 0 | 1.6 |
| 4 | 18.9 |
| 8 | 24.5 |
| 12 | 26.7 |
| 16 | 27.2 |
| 20 | 27.5 |
| 24 | 27.6 |
| 32 | 27.7 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `cm`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `cm`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (days) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `cm`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `cm`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (days) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `cm` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 77 - DRG-P2-67

### item_id
`DRG-P2-67`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured chlorophyll content over `0, 5, 10, 20, 40, 60, 80, 100 mg/l` nitrate supply; estimate the level-off chlorophyll concentration. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time | response units |
| --- | ---: |
| 0 | 1.1 |
| 4 | 11.9 |
| 8 | 16 |
| 12 | 17.4 |
| 16 | 17.7 |
| 20 | 17.8 |
| 24 | 18 |
| 32 | 18.3 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `response units`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `response units`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `response units`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `response units`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `response units` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 78 - DRG-P2-68

### item_id
`DRG-P2-68`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured product accumulation over `0, 2, 4, 6, 8, 10, 12, 16 hr`; estimate the level-off product concentration. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time | response units |
| --- | ---: |
| 0 | 2 |
| 4 | 12.3 |
| 8 | 17.2 |
| 12 | 19.7 |
| 16 | 20.5 |
| 20 | 21.2 |
| 24 | 21.2 |
| 32 | 21.3 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `response units`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `response units`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `response units`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `response units`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `response units` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 79 - DRG-P2-69

### item_id
`DRG-P2-69`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured biofilm coverage over `0, 4, 8, 12, 16, 20, 24, 32 hr`; estimate the level-off coverage. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time | % |
| --- | ---: |
| 0 | 3.2 |
| 4 | 9.8 |
| 8 | 11.9 |
| 12 | 12.7 |
| 16 | 13.2 |
| 20 | 13.1 |
| 24 | 12.9 |
| 32 | 13 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `%`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `%`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `%`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `%`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `%` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 80 - DRG-P2-70

### item_id
`DRG-P2-70`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured coral colony coverage over `0, 1, 2, 3, 4, 5, 6, 8 weeks`; estimate the level-off coverage. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time | % |
| --- | ---: |
| 0 | 2.4 |
| 4 | 12.7 |
| 8 | 16.8 |
| 12 | 18.6 |
| 16 | 19.1 |
| 20 | 19.3 |
| 24 | 19.4 |
| 32 | 19.7 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `%`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `%`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `%`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `%`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `%` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 81 - DRG-P2-71

### item_id
`DRG-P2-71`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured fungal colony diameter over `0, 1, 2, 3, 4, 5, 6, 8 days`; estimate the level-off diameter. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time | mm |
| --- | ---: |
| 0 | 2.8 |
| 4 | 12.3 |
| 8 | 17.5 |
| 12 | 20.3 |
| 16 | 21.9 |
| 20 | 22.6 |
| 24 | 23.1 |
| 32 | 23.7 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `mm`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `mm`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `mm`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `mm`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `mm` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 82 - DRG-P2-72

### item_id
`DRG-P2-72`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured tadpole mass over `0, 2, 4, 6, 8, 10, 12, 16 weeks`; estimate the level-off mass. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (weeks) | g |
| --- | ---: |
| 0 | 3.1 |
| 4 | 13 |
| 8 | 17.4 |
| 12 | 19.8 |
| 16 | 20.7 |
| 20 | 21.2 |
| 24 | 21.3 |
| 32 | 21.6 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `g`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `g`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (weeks) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `g`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `g`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (weeks) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `g` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 83 - DRG-P2-73

### item_id
`DRG-P2-73`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured moss mat depth over `0, 1, 2, 3, 4, 5, 6, 8 months`; estimate the level-off depth. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time | mm |
| --- | ---: |
| 0 | 1.8 |
| 4 | 14.9 |
| 8 | 19.6 |
| 12 | 21.3 |
| 16 | 21.8 |
| 20 | 22.1 |
| 24 | 22 |
| 32 | 22 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `mm`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `mm`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `mm`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `mm`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `mm` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 84 - DRG-P2-74

### item_id
`DRG-P2-74`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured plankton density over `0, 2, 4, 6, 8, 10, 12, 16 days`; estimate the level-off density. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (hr) | 10^5 cells/mL |
| --- | ---: |
| 0 | 1.5 |
| 4 | 8 |
| 8 | 11 |
| 12 | 12.6 |
| 16 | 13.3 |
| 20 | 13.3 |
| 24 | 13.5 |
| 32 | 13.7 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `10^5 cells/mL`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (hr) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `10^5 cells/mL`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `10^5 cells/mL`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (hr) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `10^5 cells/mL` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 85 - DRG-P2-75

### item_id
`DRG-P2-75`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured plant biomass across `0, 25, 50, 100, 150, 200, 300, 400 kg/ha` fertilizer additions; estimate the level-off biomass. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time | response units |
| --- | ---: |
| 0 | 2.2 |
| 4 | 13 |
| 8 | 16.8 |
| 12 | 18.4 |
| 16 | 19 |
| 20 | 19.5 |
| 24 | 19.6 |
| 32 | 19.5 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `response units`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `response units`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `response units`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `response units`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `response units` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 86 - DRG-P2-76

### item_id
`DRG-P2-76`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured culture optical density over `0, 2, 4, 6, 8, 10, 12, 16 hr`; estimate the level-off optical density. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time | response units |
| --- | ---: |
| 0 | 1.5 |
| 4 | 7.2 |
| 8 | 9.8 |
| 12 | 11.5 |
| 16 | 12 |
| 20 | 12.4 |
| 24 | 12.4 |
| 32 | 12.8 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `response units`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `response units`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `response units`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `response units`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `response units` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 87 - DRG-P2-77

### item_id
`DRG-P2-77`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured antibody titer over `0, 3, 6, 9, 12, 15, 18, 24 days`; estimate the level-off titer. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (days) | titer |
| --- | ---: |
| 0 | 2.3 |
| 4 | 12.2 |
| 8 | 16.6 |
| 12 | 18.6 |
| 16 | 19.7 |
| 20 | 19.8 |
| 24 | 20.2 |
| 32 | 20.3 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `titer`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `titer`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (days) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `titer`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `titer`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (days) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `titer` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 88 - DRG-P2-78

### item_id
`DRG-P2-78`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured metabolite concentration over `0, 1, 2, 3, 4, 5, 6, 8 hr`; estimate the level-off concentration. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (hr) | concentration |
| --- | ---: |
| 0 | 1.2 |
| 4 | 15.9 |
| 8 | 21.7 |
| 12 | 24.1 |
| 16 | 24.9 |
| 20 | 25.6 |
| 24 | 25.6 |
| 32 | 25.6 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `concentration`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `concentration`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (hr) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `concentration`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `concentration`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (hr) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `concentration` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 89 - DRG-P2-79

### item_id
`DRG-P2-79`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured root length over `0, 2, 4, 6, 8, 10, 12, 16 days`; estimate the level-off length. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (days) | cm |
| --- | ---: |
| 0 | 1.4 |
| 4 | 13.5 |
| 8 | 18.6 |
| 12 | 20.8 |
| 16 | 21.8 |
| 20 | 22.5 |
| 24 | 22.7 |
| 32 | 22.8 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `cm`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `cm`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (days) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `cm`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `cm`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (days) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `cm` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.


## Draft 90 - DRG-P2-80

### item_id
`DRG-P2-80`

### item_version
`v1.0-generated`

### student_prompt
Researchers measured cumulative oxygen production over `0, 1, 2, 3, 4, 5, 6, 8 hr`; estimate the level-off rate. Using the data provided, plot the paired observations on linear axes, draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the population value around which the curve levels off. Include units with your estimate.

### synthetic_data_source
Method b, explicit synthetic paired observations. One observation was recorded at each x-value; no replicate averaging was used.

### display_table

| time (hr) | umol O2 |
| --- | ---: |
| 0 | 1.4 |
| 4 | 7.9 |
| 8 | 11.1 |
| 12 | 12.9 |
| 16 | 13.6 |
| 20 | 14 |
| 24 | 14 |
| 32 | 14.1 |

### expected_graph_spec
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `umol O2`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the plateau value in `umol O2`.

### criterion_definitions
- `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.
- `X_VARIABLE`: Places time (hr) on the x-axis.
- `Y_VARIABLE`: Places the response on the y-axis.
- `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.
- `Y_UNIT`: Labels the y-axis in `umol O2`.
- `X_SCALE`: Uses a linear x-axis with correct spacing.
- `Y_SCALE`: Uses one linear y-axis with the display unit.
- `PLOT_VALUES`: Places each observation at the correct x-value and height.
- `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.
- `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.
- `ESTIMATE_VALUE`: Reports the plateau estimate in `umol O2`.

### accepted_variants
- The smooth trend may be a hand-drawn curve or a best-fit smooth line.
- The plateau annotation may be a bracket, arrow, or shaded band.
- The estimate may be written with equivalent wording if the unit is preserved.

### contradictions
- Using a log y-axis or scientific-notation-only scale.
- Drawing straight connect-the-dots segments instead of a smooth trend.
- Calling the plateau a fixed species constant rather than a condition-specific level-off.

### development_tolerances
Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; plateau estimate within 0.5 display units; annotation must clearly identify the level-off region.

### minimum_feedback
- `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.
- `X_VARIABLE`: Put time (hr) on the horizontal axis.
- `Y_VARIABLE`: Put the response on the vertical axis.
- `X_UNIT`: Label the x-axis in the measurement unit shown.
- `Y_UNIT`: Use `umol O2` on the y-axis.
- `X_SCALE`: Keep the x-axis linear and evenly scaled.
- `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.
- `PLOT_VALUES`: Place each measured value at the right x-value and y-value.
- `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.
- `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.
- `ESTIMATE_VALUE`: Give the level-off value with units.

### rights_and_similarity_record
Original content, independently generated for this draft. Novelty and similarity status: unverified, pending qualified human source-isolation and similarity review.

