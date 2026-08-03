-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260722145332
-- recorded name: fix_unrealistic_scatterplot_correlations
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

begin;

-- APSTATS-HDG-2026-GRAPH-005
update app.content_item_versions
set stimulus = 'A teacher recorded hours studied and test score for nine students. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Hours studied | Test score |
| --- | --- |
| 0 | 55 |
| 1 | 72 |
| 1 | 58 |
| 2 | 80 |
| 2 | 63 |
| 3 | 74 |
| 3 | 85 |
| 4 | 78 |
| 5 | 90 |',
    prompt_json = jsonb_set(
      jsonb_set(
        jsonb_set(prompt_json, '{stimulus}', to_jsonb('A teacher recorded hours studied and test score for nine students. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Hours studied | Test score |
| --- | --- |
| 0 | 55 |
| 1 | 72 |
| 1 | 58 |
| 2 | 80 |
| 2 | 63 |
| 3 | 74 |
| 3 | 85 |
| 4 | 78 |
| 5 | 90 |'::text)),
        '{parts,0,prompt_text}', to_jsonb('A teacher recorded hours studied and test score for nine students. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Hours studied | Test score |
| --- | --- |
| 0 | 55 |
| 1 | 72 |
| 1 | 58 |
| 2 | 80 |
| 2 | 63 |
| 3 | 74 |
| 3 | 85 |
| 4 | 78 |
| 5 | 90 |'::text)
      ),
      '{stimulus_table}', '[{"Test score": 55, "Hours studied": 0}, {"Test score": 72, "Hours studied": 1}, {"Test score": 58, "Hours studied": 1}, {"Test score": 80, "Hours studied": 2}, {"Test score": 63, "Hours studied": 2}, {"Test score": 74, "Hours studied": 3}, {"Test score": 85, "Hours studied": 3}, {"Test score": 78, "Hours studied": 4}, {"Test score": 90, "Hours studied": 5}]'::jsonb
    )
where id = '51978e67-36b4-4df8-847d-7b8d7f83261d';

-- APSTATS-HDG-2026-GRAPH-011
update app.content_item_versions
set stimulus = 'A technology club measured screen brightness and battery remaining after one hour for nine phones. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Screen brightness (%) | Battery remaining (%) |
| --- | --- |
| 12 | 92 |
| 14 | 76 |
| 15 | 86 |
| 17 | 70 |
| 18 | 80 |
| 20 | 62 |
| 21 | 72 |
| 23 | 58 |
| 25 | 65 |',
    prompt_json = jsonb_set(
      jsonb_set(
        jsonb_set(prompt_json, '{stimulus}', to_jsonb('A technology club measured screen brightness and battery remaining after one hour for nine phones. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Screen brightness (%) | Battery remaining (%) |
| --- | --- |
| 12 | 92 |
| 14 | 76 |
| 15 | 86 |
| 17 | 70 |
| 18 | 80 |
| 20 | 62 |
| 21 | 72 |
| 23 | 58 |
| 25 | 65 |'::text)),
        '{parts,0,prompt_text}', to_jsonb('A technology club measured screen brightness and battery remaining after one hour for nine phones. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Screen brightness (%) | Battery remaining (%) |
| --- | --- |
| 12 | 92 |
| 14 | 76 |
| 15 | 86 |
| 17 | 70 |
| 18 | 80 |
| 20 | 62 |
| 21 | 72 |
| 23 | 58 |
| 25 | 65 |'::text)
      ),
      '{stimulus_table}', '[{"Battery remaining (%)": 92, "Screen brightness (%)": 12}, {"Battery remaining (%)": 76, "Screen brightness (%)": 14}, {"Battery remaining (%)": 86, "Screen brightness (%)": 15}, {"Battery remaining (%)": 70, "Screen brightness (%)": 17}, {"Battery remaining (%)": 80, "Screen brightness (%)": 18}, {"Battery remaining (%)": 62, "Screen brightness (%)": 20}, {"Battery remaining (%)": 72, "Screen brightness (%)": 21}, {"Battery remaining (%)": 58, "Screen brightness (%)": 23}, {"Battery remaining (%)": 65, "Screen brightness (%)": 25}]'::jsonb
    )
where id = '4305674a-ad35-4192-abb1-d39f54482d4a';

-- APSTATS-HDG-2026-GRAPH-032
update app.content_item_versions
set stimulus = 'A researcher recorded advertising spend (thousands of dollars) and monthly sales (thousands of dollars) for nine stores. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Ad spend | Sales |
| --- | --- |
| 2 | 26 |
| 3 | 44 |
| 4 | 32 |
| 5 | 52 |
| 6 | 40 |
| 7 | 58 |
| 8 | 46 |
| 9 | 68 |
| 10 | 58 |',
    prompt_json = jsonb_set(
      jsonb_set(
        jsonb_set(prompt_json, '{stimulus}', to_jsonb('A researcher recorded advertising spend (thousands of dollars) and monthly sales (thousands of dollars) for nine stores. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Ad spend | Sales |
| --- | --- |
| 2 | 26 |
| 3 | 44 |
| 4 | 32 |
| 5 | 52 |
| 6 | 40 |
| 7 | 58 |
| 8 | 46 |
| 9 | 68 |
| 10 | 58 |'::text)),
        '{parts,0,prompt_text}', to_jsonb('A researcher recorded advertising spend (thousands of dollars) and monthly sales (thousands of dollars) for nine stores. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Ad spend | Sales |
| --- | --- |
| 2 | 26 |
| 3 | 44 |
| 4 | 32 |
| 5 | 52 |
| 6 | 40 |
| 7 | 58 |
| 8 | 46 |
| 9 | 68 |
| 10 | 58 |'::text)
      ),
      '{stimulus_table}', '[{"Sales": 26, "Ad spend": 2}, {"Sales": 44, "Ad spend": 3}, {"Sales": 32, "Ad spend": 4}, {"Sales": 52, "Ad spend": 5}, {"Sales": 40, "Ad spend": 6}, {"Sales": 58, "Ad spend": 7}, {"Sales": 46, "Ad spend": 8}, {"Sales": 68, "Ad spend": 9}, {"Sales": 58, "Ad spend": 10}]'::jsonb
    )
where id = '98e1db6e-ebee-48e2-8ef9-dfd00c10cc5e';

-- APSTATS-HDG-2026-GRAPH-033
update app.content_item_versions
set stimulus = 'A mechanic recorded a car''s age (years) and its resale value (thousands of dollars) for nine cars. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Age | Resale value |
| --- | --- |
| 1 | 31 |
| 2 | 20 |
| 3 | 27 |
| 4 | 15 |
| 5 | 23 |
| 6 | 10 |
| 7 | 18 |
| 8 | 6 |
| 9 | 13 |',
    prompt_json = jsonb_set(
      jsonb_set(
        jsonb_set(prompt_json, '{stimulus}', to_jsonb('A mechanic recorded a car''s age (years) and its resale value (thousands of dollars) for nine cars. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Age | Resale value |
| --- | --- |
| 1 | 31 |
| 2 | 20 |
| 3 | 27 |
| 4 | 15 |
| 5 | 23 |
| 6 | 10 |
| 7 | 18 |
| 8 | 6 |
| 9 | 13 |'::text)),
        '{parts,0,prompt_text}', to_jsonb('A mechanic recorded a car''s age (years) and its resale value (thousands of dollars) for nine cars. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Age | Resale value |
| --- | --- |
| 1 | 31 |
| 2 | 20 |
| 3 | 27 |
| 4 | 15 |
| 5 | 23 |
| 6 | 10 |
| 7 | 18 |
| 8 | 6 |
| 9 | 13 |'::text)
      ),
      '{stimulus_table}', '[{"Resale value": 31, "Age": 1}, {"Resale value": 20, "Age": 2}, {"Resale value": 27, "Age": 3}, {"Resale value": 15, "Age": 4}, {"Resale value": 23, "Age": 5}, {"Resale value": 10, "Age": 6}, {"Resale value": 18, "Age": 7}, {"Resale value": 6, "Age": 8}, {"Resale value": 13, "Age": 9}]'::jsonb
    )
where id = 'ae73241f-396f-4035-bbc9-fee852454969';

-- APSTATS-HDG-2026-GRAPH-034
update app.content_item_versions
set stimulus = 'A nutritionist recorded daily calorie intake (hundreds) and resting heart rate change (bpm) for nine participants in a controlled diet study. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Calorie intake (hundreds) | Heart rate change (bpm) |
| --- | --- |
| 14 | -3 |
| 16 | 1 |
| 18 | -2 |
| 18 | 3 |
| 20 | 0 |
| 22 | 4 |
| 24 | 2 |
| 26 | 6 |
| 28 | 5 |',
    prompt_json = jsonb_set(
      jsonb_set(
        jsonb_set(prompt_json, '{stimulus}', to_jsonb('A nutritionist recorded daily calorie intake (hundreds) and resting heart rate change (bpm) for nine participants in a controlled diet study. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Calorie intake (hundreds) | Heart rate change (bpm) |
| --- | --- |
| 14 | -3 |
| 16 | 1 |
| 18 | -2 |
| 18 | 3 |
| 20 | 0 |
| 22 | 4 |
| 24 | 2 |
| 26 | 6 |
| 28 | 5 |'::text)),
        '{parts,0,prompt_text}', to_jsonb('A nutritionist recorded daily calorie intake (hundreds) and resting heart rate change (bpm) for nine participants in a controlled diet study. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Calorie intake (hundreds) | Heart rate change (bpm) |
| --- | --- |
| 14 | -3 |
| 16 | 1 |
| 18 | -2 |
| 18 | 3 |
| 20 | 0 |
| 22 | 4 |
| 24 | 2 |
| 26 | 6 |
| 28 | 5 |'::text)
      ),
      '{stimulus_table}', '[{"Heart rate change (bpm)": -3, "Calorie intake (hundreds)": 14}, {"Heart rate change (bpm)": 1, "Calorie intake (hundreds)": 16}, {"Heart rate change (bpm)": -2, "Calorie intake (hundreds)": 18}, {"Heart rate change (bpm)": 3, "Calorie intake (hundreds)": 18}, {"Heart rate change (bpm)": 0, "Calorie intake (hundreds)": 20}, {"Heart rate change (bpm)": 4, "Calorie intake (hundreds)": 22}, {"Heart rate change (bpm)": 2, "Calorie intake (hundreds)": 24}, {"Heart rate change (bpm)": 6, "Calorie intake (hundreds)": 26}, {"Heart rate change (bpm)": 5, "Calorie intake (hundreds)": 28}]'::jsonb
    )
where id = '34679b73-2cfd-4c26-b02e-42f68f3d98b6';

-- APSTATS-HDG-2026-GRAPH-035
update app.content_item_versions
set stimulus = 'A city planner recorded a neighborhood''s distance from downtown (miles) and average commute time (minutes) for nine neighborhoods. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Distance (miles) | Commute time (min) |
| --- | --- |
| 1 | 8 |
| 3 | 26 |
| 5 | 16 |
| 7 | 34 |
| 9 | 22 |
| 11 | 46 |
| 13 | 30 |
| 15 | 55 |
| 17 | 38 |',
    prompt_json = jsonb_set(
      jsonb_set(
        jsonb_set(prompt_json, '{stimulus}', to_jsonb('A city planner recorded a neighborhood''s distance from downtown (miles) and average commute time (minutes) for nine neighborhoods. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Distance (miles) | Commute time (min) |
| --- | --- |
| 1 | 8 |
| 3 | 26 |
| 5 | 16 |
| 7 | 34 |
| 9 | 22 |
| 11 | 46 |
| 13 | 30 |
| 15 | 55 |
| 17 | 38 |'::text)),
        '{parts,0,prompt_text}', to_jsonb('A city planner recorded a neighborhood''s distance from downtown (miles) and average commute time (minutes) for nine neighborhoods. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Distance (miles) | Commute time (min) |
| --- | --- |
| 1 | 8 |
| 3 | 26 |
| 5 | 16 |
| 7 | 34 |
| 9 | 22 |
| 11 | 46 |
| 13 | 30 |
| 15 | 55 |
| 17 | 38 |'::text)
      ),
      '{stimulus_table}', '[{"Commute time (min)": 8, "Distance (miles)": 1}, {"Commute time (min)": 26, "Distance (miles)": 3}, {"Commute time (min)": 16, "Distance (miles)": 5}, {"Commute time (min)": 34, "Distance (miles)": 7}, {"Commute time (min)": 22, "Distance (miles)": 9}, {"Commute time (min)": 46, "Distance (miles)": 11}, {"Commute time (min)": 30, "Distance (miles)": 13}, {"Commute time (min)": 55, "Distance (miles)": 15}, {"Commute time (min)": 38, "Distance (miles)": 17}]'::jsonb
    )
where id = '12bbd5f6-964c-4075-823c-ce8ddf8d4608';

-- APSTATS-HDG-2026-GRAPH-036
update app.content_item_versions
set stimulus = 'A farmer recorded weekly irrigation amount (inches) and crop yield loss due to drought stress (percent) for nine plots, where more irrigation is associated with less drought stress. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Irrigation (in) | Yield loss (%) |
| --- | --- |
| 0.5 | 44 |
| 1 | 24 |
| 1.5 | 38 |
| 2 | 18 |
| 2.5 | 30 |
| 3 | 10 |
| 3.5 | 20 |
| 4 | 4 |
| 4.5 | 14 |',
    prompt_json = jsonb_set(
      jsonb_set(
        jsonb_set(prompt_json, '{stimulus}', to_jsonb('A farmer recorded weekly irrigation amount (inches) and crop yield loss due to drought stress (percent) for nine plots, where more irrigation is associated with less drought stress. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Irrigation (in) | Yield loss (%) |
| --- | --- |
| 0.5 | 44 |
| 1 | 24 |
| 1.5 | 38 |
| 2 | 18 |
| 2.5 | 30 |
| 3 | 10 |
| 3.5 | 20 |
| 4 | 4 |
| 4.5 | 14 |'::text)),
        '{parts,0,prompt_text}', to_jsonb('A farmer recorded weekly irrigation amount (inches) and crop yield loss due to drought stress (percent) for nine plots, where more irrigation is associated with less drought stress. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Irrigation (in) | Yield loss (%) |
| --- | --- |
| 0.5 | 44 |
| 1 | 24 |
| 1.5 | 38 |
| 2 | 18 |
| 2.5 | 30 |
| 3 | 10 |
| 3.5 | 20 |
| 4 | 4 |
| 4.5 | 14 |'::text)
      ),
      '{stimulus_table}', '[{"Yield loss (%)": 44, "Irrigation (in)": 0.5}, {"Yield loss (%)": 24, "Irrigation (in)": 1}, {"Yield loss (%)": 38, "Irrigation (in)": 1.5}, {"Yield loss (%)": 18, "Irrigation (in)": 2}, {"Yield loss (%)": 30, "Irrigation (in)": 2.5}, {"Yield loss (%)": 10, "Irrigation (in)": 3}, {"Yield loss (%)": 20, "Irrigation (in)": 3.5}, {"Yield loss (%)": 4, "Irrigation (in)": 4}, {"Yield loss (%)": 14, "Irrigation (in)": 4.5}]'::jsonb
    )
where id = '274d2e39-e4ca-435e-9d31-04d8b3fd0bdc';

commit;
;
