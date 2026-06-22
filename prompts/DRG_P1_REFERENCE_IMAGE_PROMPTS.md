# DRG-P1 Reference Image Generation Prompts (10 items x 2 variants = 20)

Generated from the corrected, verified `DRAWN_RESPONSE_FRQs_v1.1.md`
(all 10 drafts confirmed clean -- no uniform-step replicate groups,
see `docs/research/DRAWN_RESPONSE_ITEM_DRAFT_REVIEWS.md`).

Run each prompt below once through the image-generation tool. Each
produces one image; save it with the exact filename given in that
prompt's OUTPUT NAMING section. Orly and Micah will hand-draw and
photograph a replica of each of these 20 reference images.

---

## DRG-P1-01A -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Plant biologists studied how growth light affects stomatal density in `Asarum canadense`. Clonal segments were grown under four light treatments: Deep Shade, Partial Shade, Ambient Sun, and High Light. After 60 days, stomata were counted from leaf epidermal impressions. Using the table, construct an appropriately scaled and labeled graph to compare mean stomatal density across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Growth light treatment | Mean stomatal density (stomata/mm2) | SEM |
| --- | ---: | ---: |
| Deep Shade | 33.8 | 0.9 |
| Partial Shade | 40.8 | 1.1 |
| Ambient Sun | 52.8 | 0.9 |
| High Light | 64.0 | 0.7 |

expected_graph_spec:
- Categorical x-axis in the stated order.
- Y-axis labeled `stomata/mm2` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-01A_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-01A -- Bad (missing `Y_SCALE`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Plant biologists studied how growth light affects stomatal density in `Asarum canadense`. Clonal segments were grown under four light treatments: Deep Shade, Partial Shade, Ambient Sun, and High Light. After 60 days, stomata were counted from leaf epidermal impressions. Using the table, construct an appropriately scaled and labeled graph to compare mean stomatal density across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Growth light treatment | Mean stomatal density (stomata/mm2) | SEM |
| --- | ---: | ---: |
| Deep Shade | 33.8 | 0.9 |
| Partial Shade | 40.8 | 1.1 |
| Ambient Sun | 52.8 | 0.9 |
| High Light | 64.0 | 0.7 |

expected_graph_spec:
- Categorical x-axis in the stated order.
- Y-axis labeled `stomata/mm2` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.
- Either point-with-whisker or bar-with-whisker is acceptable.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing Y_SCALE
The y-axis starts above zero (for example at 20 instead of 0) instead of at zero. Everything else -- category order, axis labels, plotted means, and error bars -- is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-01A_master_partial_y_scale.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---

## DRG-P1-02 -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Physiologists measured membrane leakage from equine red blood cells after exposure to four solution treatments: Solution A, Solution B, Solution C, and Solution D. Multiple replicates were run for each solution. Using the data provided, construct an appropriately scaled and labeled graph to compare mean membrane leakage across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Solution treatment | Mean leakage (absorbance at 540 nm) | SEM |
| --- | ---: | ---: |
| Solution A | 0.05 | 0.01 |
| Solution B | 0.10 | 0.02 |
| Solution C | 0.76 | 0.02 |
| Solution D | 0.81 | 0.03 |

expected_graph_spec:
- Categorical x-axis in the table order.
- Y-axis labeled `absorbance at 540 nm` and starting at 0.
- Plot one mean per solution.
- Add symmetric plus or minus 1 SEM bars around each mean.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-02_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-02 -- Bad (missing `Y_SCALE`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Physiologists measured membrane leakage from equine red blood cells after exposure to four solution treatments: Solution A, Solution B, Solution C, and Solution D. Multiple replicates were run for each solution. Using the data provided, construct an appropriately scaled and labeled graph to compare mean membrane leakage across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Solution treatment | Mean leakage (absorbance at 540 nm) | SEM |
| --- | ---: | ---: |
| Solution A | 0.05 | 0.01 |
| Solution B | 0.10 | 0.02 |
| Solution C | 0.76 | 0.02 |
| Solution D | 0.81 | 0.03 |

expected_graph_spec:
- Categorical x-axis in the table order.
- Y-axis labeled `absorbance at 540 nm` and starting at 0.
- Plot one mean per solution.
- Add symmetric plus or minus 1 SEM bars around each mean.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing Y_SCALE
The y-axis starts above zero instead of at zero. Everything else -- category order, axis labels, plotted means, and error bars -- is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-02_master_partial_y_scale.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---

## DRG-P1-03A -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Researchers measured the reaction rate of an enzyme across eight temperatures. Using the data provided, construct an appropriately scaled and labeled graph of mean reaction rate versus temperature. Plot the means at their measured temperatures, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
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

expected_graph_spec:
- X-axis is temperature with actual numeric spacing.
- Y-axis is reaction rate and starts at zero.
- Plot the mean at each measured temperature.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-03A_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-03A -- Bad (missing `UNCERTAINTY_MARKS`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Researchers measured the reaction rate of an enzyme across eight temperatures. Using the data provided, construct an appropriately scaled and labeled graph of mean reaction rate versus temperature. Plot the means at their measured temperatures, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
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

expected_graph_spec:
- X-axis is temperature with actual numeric spacing.
- Y-axis is reaction rate and starts at zero.
- Plot the mean at each measured temperature.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing UNCERTAINTY_MARKS
The error bars are omitted entirely -- only the plotted mean points and connecting line segments appear, no vertical whiskers at all. Everything else is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-03A_master_partial_uncertainty_marks.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---

## DRG-P1-04A -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Researchers measured photosynthetic rate at seven light intensities in shade-grown tomato leaves. Using the data provided, construct an appropriately scaled and labeled graph of mean photosynthetic rate versus light intensity. Plot the means at their measured intensities, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Light intensity (umol photons/m2/s) | Mean photosynthetic rate (umol CO2/m2/s) | SEM |
| --- | ---: | ---: |
| 0 | 4.2 | 0.4 |
| 100 | 11.1 | 0.5 |
| 250 | 21.9 | 0.7 |
| 500 | 34.8 | 0.7 |
| 750 | 42.1 | 0.5 |
| 1000 | 43.2 | 0.5 |
| 1500 | 43.5 | 0.3 |

expected_graph_spec:
- X-axis is light intensity with actual numeric spacing.
- Y-axis is photosynthetic rate and starts at zero.
- Plot the mean at each measured intensity.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured values in order.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-04A_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-04A -- Bad (missing `UNCERTAINTY_MARKS`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Researchers measured photosynthetic rate at seven light intensities in shade-grown tomato leaves. Using the data provided, construct an appropriately scaled and labeled graph of mean photosynthetic rate versus light intensity. Plot the means at their measured intensities, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Light intensity (umol photons/m2/s) | Mean photosynthetic rate (umol CO2/m2/s) | SEM |
| --- | ---: | ---: |
| 0 | 4.2 | 0.4 |
| 100 | 11.1 | 0.5 |
| 250 | 21.9 | 0.7 |
| 500 | 34.8 | 0.7 |
| 750 | 42.1 | 0.5 |
| 1000 | 43.2 | 0.5 |
| 1500 | 43.5 | 0.3 |

expected_graph_spec:
- X-axis is light intensity with actual numeric spacing.
- Y-axis is photosynthetic rate and starts at zero.
- Plot the mean at each measured intensity.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured values in order.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing UNCERTAINTY_MARKS
The error bars are omitted entirely -- only the plotted mean points and connecting line segments appear, no vertical whiskers at all. Everything else is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-04A_master_partial_uncertainty_marks.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---

## DRG-P1-05 -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Students tested synthetic membrane-bound tissue samples in external solute solutions of different molarities and measured percent mass change after equilibration. Using the data provided, construct a graph of percent mass change versus solute concentration, draw one best-fit relationship, mark the zero-change intercept, and estimate the concentration where percent mass change is zero. Include units with your estimate.

display_table:
| Solute concentration (M) | Percent mass change |
| --- | ---: |
| 0.0 | 12.6 |
| 0.2 | 7.8 |
| 0.4 | 2.7 |
| 0.6 | -2.6 |
| 0.8 | -7.1 |
| 1.0 | -11.8 |

expected_graph_spec:
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where percent mass change crosses zero, near `0.5 M`.
- Label the intercept estimate in M.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-05_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-05 -- Bad (missing `BEST_FIT_RELATIONSHIP`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Students tested synthetic membrane-bound tissue samples in external solute solutions of different molarities and measured percent mass change after equilibration. Using the data provided, construct a graph of percent mass change versus solute concentration, draw one best-fit relationship, mark the zero-change intercept, and estimate the concentration where percent mass change is zero. Include units with your estimate.

display_table:
| Solute concentration (M) | Percent mass change |
| --- | ---: |
| 0.0 | 12.6 |
| 0.2 | 7.8 |
| 0.4 | 2.7 |
| 0.6 | -2.6 |
| 0.8 | -7.1 |
| 1.0 | -11.8 |

expected_graph_spec:
- Plot the paired observations on linear axes.
- Y-axis includes zero and all positive and negative observations.
- Draw one best-fit line through the trend.
- Mark the x-intercept where percent mass change crosses zero, near `0.5 M`.
- Label the intercept estimate in M.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing BEST_FIT_RELATIONSHIP
Instead of drawing one single straight best-fit line through the data, the points are connected directly to each other in table order with straight dot-to-dot segments (a jagged path through every point, not one overall trend line). Do not include a zero-intercept annotation in this variant, since there is no single fitted line to mark an intercept on. Everything else -- axes, labels, scale, and plotted point positions -- is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-05_master_partial_best_fit_relationship.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---

## DRG-P1-06A -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
A microbial culture was grown in a resource-bounded bioreactor and its density was measured over time. Using the data provided, construct a graph of culture density over time on linear axes, draw a smooth trend, visually indicate the level-off region, and estimate the population density around which the culture levels off under these conditions. Include units with your estimate.

display_table:
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

expected_graph_spec:
- Plot paired observations on linear axes.
- Use a single linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the population density around which the curve levels off at about `18.0 x 10^5 cells/mL`.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-06A_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-06A -- Bad (missing `BEST_FIT_RELATIONSHIP`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
A microbial culture was grown in a resource-bounded bioreactor and its density was measured over time. Using the data provided, construct a graph of culture density over time on linear axes, draw a smooth trend, visually indicate the level-off region, and estimate the population density around which the culture levels off under these conditions. Include units with your estimate.

display_table:
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

expected_graph_spec:
- Plot paired observations on linear axes.
- Use a single linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the population density around which the curve levels off at about `18.0 x 10^5 cells/mL`.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing BEST_FIT_RELATIONSHIP
Instead of drawing one single smooth trend curve, the points are connected directly to each other in table order with straight dot-to-dot segments (a jagged path through every point, not a smooth curve). Do not include a plateau annotation in this variant, since there is no smooth curve to mark a level-off region on. Everything else -- axes, labels, scale, and plotted point positions -- is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-06A_master_partial_best_fit_relationship.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---

## DRG-P1-01B -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Plant biologists studied how LED spectrum during growth shapes leaf anatomy in basil seedlings. Clonal cuttings were propagated under four light treatments: Cool White, Warm White, Red-Enriched, and Far-Red Filtered. After growth, leaf epidermal impressions were analyzed to count stomata per square millimeter. Using the data provided, construct an appropriately scaled and labeled graph to compare mean stomatal density across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Growth light treatment | Mean stomatal density (stomata/mm2) | SEM |
| --- | ---: | ---: |
| Cool White | 30.2 | 0.9 |
| Warm White | 37.6 | 0.9 |
| Red-Enriched | 46.8 | 0.9 |
| Far-Red Filtered | 55.0 | 1.0 |

expected_graph_spec:
- Categorical x-axis in the stated order.
- Y-axis labeled `stomata/mm2` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-01B_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-01B -- Bad (missing `UNCERTAINTY_MARKS`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Plant biologists studied how LED spectrum during growth shapes leaf anatomy in basil seedlings. Clonal cuttings were propagated under four light treatments: Cool White, Warm White, Red-Enriched, and Far-Red Filtered. After growth, leaf epidermal impressions were analyzed to count stomata per square millimeter. Using the data provided, construct an appropriately scaled and labeled graph to compare mean stomatal density across the four treatments. Plot the group means and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Growth light treatment | Mean stomatal density (stomata/mm2) | SEM |
| --- | ---: | ---: |
| Cool White | 30.2 | 0.9 |
| Warm White | 37.6 | 0.9 |
| Red-Enriched | 46.8 | 0.9 |
| Far-Red Filtered | 55.0 | 1.0 |

expected_graph_spec:
- Categorical x-axis in the stated order.
- Y-axis labeled `stomata/mm2` and starting at 0.
- Plot one mean per treatment.
- Add symmetric vertical error bars of plus or minus 1 SEM.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing UNCERTAINTY_MARKS
The error bars are missing entirely -- only the plotted mean points appear, no vertical whiskers at all. Everything else -- category order, axis labels, and plotted means -- is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-01B_master_partial_uncertainty_marks.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---

## DRG-P1-03B -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Researchers measured the reaction rate of a heat-stable digestive enzyme from a desert beetle across eight temperatures. Using the data provided, construct an appropriately scaled and labeled graph of mean reaction rate versus temperature. Plot the means at their measured temperatures, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
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

expected_graph_spec:
- X-axis is temperature with actual numeric spacing.
- Y-axis is reaction rate and starts at zero.
- Plot the mean at each measured temperature.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-03B_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-03B -- Bad (missing `POINT_CONNECTION`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Researchers measured the reaction rate of a heat-stable digestive enzyme from a desert beetle across eight temperatures. Using the data provided, construct an appropriately scaled and labeled graph of mean reaction rate versus temperature. Plot the means at their measured temperatures, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
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

expected_graph_spec:
- X-axis is temperature with actual numeric spacing.
- Y-axis is reaction rate and starts at zero.
- Plot the mean at each measured temperature.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured points from left to right with straight segments.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing POINT_CONNECTION
Instead of connecting adjacent measured points with straight segments that pass exactly through each plotted mean, a smoothed curve is drawn that passes near the points but visibly does not touch their exact plotted positions -- the curve drifts slightly off each measured point rather than connecting them exactly. Everything else -- axes, labels, scale, error bars -- is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-03B_master_partial_point_connection.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---

## DRG-P1-04B -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Researchers measured photosynthetic rate at seven light intensities. Using the data provided, construct an appropriately scaled and labeled graph of mean photosynthetic rate versus light intensity. Plot the means at their measured intensities, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Light intensity (umol photons/m2/s) | Mean photosynthetic rate (umol CO2/m2/s) | SEM |
| --- | ---: | ---: |
| 0 | 4.5 | 0.4 |
| 75 | 9.7 | 0.4 |
| 175 | 16.8 | 0.5 |
| 350 | 26.6 | 0.7 |
| 650 | 35.6 | 0.7 |
| 950 | 39.5 | 0.4 |
| 1400 | 40.7 | 0.3 |

expected_graph_spec:
- X-axis is light intensity with actual numeric spacing.
- Y-axis is photosynthetic rate and starts at zero.
- Plot the mean at each measured intensity.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured values in order.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-04B_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-04B -- Bad (missing `POINT_CONNECTION`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
Researchers measured photosynthetic rate at seven light intensities. Using the data provided, construct an appropriately scaled and labeled graph of mean photosynthetic rate versus light intensity. Plot the means at their measured intensities, connect adjacent measured values, and include symmetric error bars representing plus or minus 1 SEM around each mean.

display_table:
| Light intensity (umol photons/m2/s) | Mean photosynthetic rate (umol CO2/m2/s) | SEM |
| --- | ---: | ---: |
| 0 | 4.5 | 0.4 |
| 75 | 9.7 | 0.4 |
| 175 | 16.8 | 0.5 |
| 350 | 26.6 | 0.7 |
| 650 | 35.6 | 0.7 |
| 950 | 39.5 | 0.4 |
| 1400 | 40.7 | 0.3 |

expected_graph_spec:
- X-axis is light intensity with actual numeric spacing.
- Y-axis is photosynthetic rate and starts at zero.
- Plot the mean at each measured intensity.
- Add symmetric plus or minus 1 SEM bars.
- Connect adjacent measured values in order.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing POINT_CONNECTION
Instead of connecting adjacent measured points with straight segments that pass exactly through each plotted mean, a smoothed curve is drawn that passes near the points but visibly does not touch their exact plotted positions -- the curve drifts slightly off each measured point rather than connecting them exactly. Everything else -- axes, labels, scale, error bars -- is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-04B_master_partial_point_connection.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---

## DRG-P1-06B -- Good (Full Credit)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
A freshwater cyanobacterium was grown in a bench-top reactor and its density was measured over time. Using the data provided, construct a graph of culture density over time on linear axes, draw a smooth trend, visually indicate the level-off region, and estimate the population density around which the culture levels off under these conditions. Include units with your estimate.

display_table:
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

expected_graph_spec:
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the population density around which the curve levels off at about `16.0 x 10^5 cells/mL`.

criterion_definitions:
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

TARGET VARIANT TO RENDER: FULL_CREDIT
Every criterion in criterion_definitions is satisfied exactly as specified.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-06B_master_full_credit.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

## DRG-P1-06B -- Bad (missing `Y_SCALE`)

```
Generate a single image of a hand-drawn graph on plain graph paper,
exactly as if drawn by a student with a pencil or pen, for use as a
tracing reference. A human will redraw this by hand from your image, so
every plotted value, label, and line must be precisely accurate and
legible -- this is a precision reference, not loose sketch art.

ITEM CONTENT:

student_prompt:
A freshwater cyanobacterium was grown in a bench-top reactor and its density was measured over time. Using the data provided, construct a graph of culture density over time on linear axes, draw a smooth trend, visually indicate the level-off region, and estimate the population density around which the culture levels off under these conditions. Include units with your estimate.

display_table:
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

expected_graph_spec:
- Plot paired observations on linear axes.
- Use one linear y-axis with the display unit `10^5 cells/mL`.
- Draw a smooth trend that rises and then levels off.
- Mark the level-off region with a visible annotation.
- Estimate the population density around which the curve levels off at about `16.0 x 10^5 cells/mL`.

criterion_definitions:
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

TARGET VARIANT TO RENDER: PARTIAL_CREDIT, missing Y_SCALE
The y-axis uses a log scale instead of a single linear scale (unevenly spaced gridlines that compress at higher values) instead of one linear y-axis with the rescaled display unit. Everything else -- axes labels, plotted points, smooth trend curve, and plateau annotation -- is drawn exactly correctly.

HARD CONSTRAINTS:
1. Render ONLY the single requested variant. Do not show multiple
   versions, side-by-side comparisons, or any "answer key" annotations
   explaining what's right or wrong -- output exactly what a student's
   single graph would look like, nothing else.
2. Plotted point positions, axis scale, and any required annotation must
   be precisely placed according to the display_table and
   expected_graph_spec -- a human tracing this needs to be able to read
   exact values, not estimate them. Use fine enough gridlines or tick
   marks that every plotted value can be read off exactly, not just
   approximated to the nearest major gridline.
3. Use the same line weight, label neatness, and overall drawing
   complexity regardless of which variant this is. Do not make the
   correct version look more polished or the flawed version look
   messier -- the only difference between variants must be the specified
   content, never the rendering quality.
4. Plain graph paper or grid background, pencil or pen line style, no
   color beyond black/blue ink and pencil gray. No digital chart styling
   (no smooth vector lines, drop shadows, or typeset fonts standing in
   for handwriting).
5. No student name, identifying marks, or decorative elements anywhere
   in the image.

OUTPUT NAMING:
Save the generated image as exactly: DRG-P1-06B_master_partial_y_scale.png
Do not rename or alter this filename -- it is the only thing binding
this image back to its source item and variant. Do not render this
filename as visible text inside the image itself.

Output the image only.
```

---
