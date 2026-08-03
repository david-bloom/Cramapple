-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260722151608
-- recorded name: fix_biology_scatterplot_correlations_and_stimulus
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

begin;

-- APBIO-HDG-2026-GRAPH-009 (r=0.849)
update app.content_item_versions
set stimulus = 'A student measured initial reaction rate at nine substrate concentrations, below saturation. Construct a scatterplot, sketch a reasonable trend line, and describe the direction, form, and strength of the association in context.

| Substrate concentration (mM) | Reaction rate (umol/min) |
| --- | --- |
| 1 | 7 |
| 2 | 10 |
| 3 | 20 |
| 4 | 13 |
| 5 | 26 |
| 6 | 17 |
| 7 | 33 |
| 8 | 23 |
| 9 | 37 |',
    prompt_json = jsonb_set(
      jsonb_set(prompt_json, '{stimulus}', to_jsonb('A student measured initial reaction rate at nine substrate concentrations, below saturation. Construct a scatterplot, sketch a reasonable trend line, and describe the direction, form, and strength of the association in context.

| Substrate concentration (mM) | Reaction rate (umol/min) |
| --- | --- |
| 1 | 7 |
| 2 | 10 |
| 3 | 20 |
| 4 | 13 |
| 5 | 26 |
| 6 | 17 |
| 7 | 33 |
| 8 | 23 |
| 9 | 37 |'::text)),
      '{stimulus_table}', '[{"Reaction rate (umol/min)": 7, "Substrate concentration (mM)": 1}, {"Reaction rate (umol/min)": 10, "Substrate concentration (mM)": 2}, {"Reaction rate (umol/min)": 20, "Substrate concentration (mM)": 3}, {"Reaction rate (umol/min)": 13, "Substrate concentration (mM)": 4}, {"Reaction rate (umol/min)": 26, "Substrate concentration (mM)": 5}, {"Reaction rate (umol/min)": 17, "Substrate concentration (mM)": 6}, {"Reaction rate (umol/min)": 33, "Substrate concentration (mM)": 7}, {"Reaction rate (umol/min)": 23, "Substrate concentration (mM)": 8}, {"Reaction rate (umol/min)": 37, "Substrate concentration (mM)": 9}]'::jsonb
    )
where id = '510acbb8-f5ac-4706-a4ec-5853621293a4';

-- APBIO-HDG-2026-GRAPH-010 (r=0.817)
update app.content_item_versions
set stimulus = 'Ecologists recorded rabbit population size and available forage biomass across nine sample plots. Construct a scatterplot, sketch a reasonable trend line, and describe the direction, form, and strength of the association in context.

| Forage biomass (kg/hectare) | Rabbit population size |
| --- | --- |
| 10 | 16 |
| 20 | 20 |
| 30 | 36 |
| 40 | 22 |
| 50 | 45 |
| 60 | 30 |
| 70 | 56 |
| 80 | 38 |
| 90 | 64 |',
    prompt_json = jsonb_set(
      jsonb_set(prompt_json, '{stimulus}', to_jsonb('Ecologists recorded rabbit population size and available forage biomass across nine sample plots. Construct a scatterplot, sketch a reasonable trend line, and describe the direction, form, and strength of the association in context.

| Forage biomass (kg/hectare) | Rabbit population size |
| --- | --- |
| 10 | 16 |
| 20 | 20 |
| 30 | 36 |
| 40 | 22 |
| 50 | 45 |
| 60 | 30 |
| 70 | 56 |
| 80 | 38 |
| 90 | 64 |'::text)),
      '{stimulus_table}', '[{"Rabbit population size": 16, "Forage biomass (kg/hectare)": 10}, {"Rabbit population size": 20, "Forage biomass (kg/hectare)": 20}, {"Rabbit population size": 36, "Forage biomass (kg/hectare)": 30}, {"Rabbit population size": 22, "Forage biomass (kg/hectare)": 40}, {"Rabbit population size": 45, "Forage biomass (kg/hectare)": 50}, {"Rabbit population size": 30, "Forage biomass (kg/hectare)": 60}, {"Rabbit population size": 56, "Forage biomass (kg/hectare)": 70}, {"Rabbit population size": 38, "Forage biomass (kg/hectare)": 80}, {"Rabbit population size": 64, "Forage biomass (kg/hectare)": 90}]'::jsonb
    )
where id = 'ab86de77-e453-4434-a2d4-bf778619cb9e';

commit;
;
