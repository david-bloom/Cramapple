-- AP Chemistry 1.5 explainer: structured pieces test (batch 2026-11-12). Development only until Production is approved.
-- Rollback: re-apply the 'current' values in scripts/content-seed/ap-chemistry-explainer-u1-1-5-structured-test-2026-11-12/proposed.json.
-- published_at is left unchanged on purpose. Guarded on the row still holding the text this was built on.
begin;
update app.topic_explainers set
  core_idea = $q$- An atom is a nucleus (protons and neutrons) with electrons around it.
- Coulomb's law: the pull between charges grows with the charges and shrinks with distance, F proportional to q1q2/r^2.
- Configuration notation and Aufbau filling order are tested; assigning n, l, ml, ms to single electrons is not.$q$,
  what_students_need_to_understand = $q$- A correct configuration earns the reasoning point only when it is tied to nuclear charge and electron distance or shielding.
- "Periodic trend" names a pattern; it does not explain one.
- Topic 1.6 reads these same configurations as photoelectron spectra.$q$,
  how_this_becomes_points = $q$1. Write the ground-state configuration in Aufbau order.
2. Compare the two atoms on nuclear charge and on shell and shielding.
3. State the Coulomb's law result: stronger attraction, so more energy to remove an electron.$q$,
  point_attaining_answer = $q$S: 1s2 2s2 2p6 3s2 3p4. Al: 1s2 2s2 2p6 3s2 3p1.

| Factor | S | Al |
| Nuclear charge | +16 | +13 |
| Valence shell | n = 3 | n = 3 |
| Core electrons (shielding) | 10 | 10 |

The distance and shielding are about the same, but sulfur's nuclear charge is larger. By Coulomb's law the attraction on its valence electrons is stronger, so more energy is needed to remove one: sulfur's first ionization energy is higher.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-12 (recommendation #3 test, AP Chem 1.5): Claude-authored in session; core_idea, what_students_need_to_understand, how_this_becomes_points and point_attaining_answer reshaped into bullets, numbered steps and a table (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro (0 findings each, planted-defect control caught by both); deepseek/deepseek-v4-pro returned no output and is not counted. Rollback snapshot in scripts/content-seed/ap-chemistry-explainer-u1-1-5-structured-test-2026-11-12/proposed.json (current).$q$
where subject_key='ap_chemistry' and unit_number=1 and topic_code='1.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='9c9a479ad5284e0cbf0f9adced8c98fe';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_chemistry' and unit_number=1 and topic_code='1.5' and source_note like '%Structured 2026-11-12%')<>1 then raise exception 'expected exactly 1 row updated'; end if; end $$;
commit;
