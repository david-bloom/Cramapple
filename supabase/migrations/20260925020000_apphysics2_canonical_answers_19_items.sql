-- AP Physics 2 servability work (docs/product/SUBJECT_SERVABILITY_CRITERIA.md), criterion 4.
-- Authors canonical_answer_1 + canonical_answer_spans for the 19 published Physics 2 FRQ items that
-- had a blank canonical_answer_1 (apphy2-frq-001/004/005/007/008/010/011/012/014/015/020/021/022/025/
-- 029/031/035/036/037), following the same pattern as
-- supabase/migrations/20260925010000_apcalcab_canonical_answers_33_items.sql: each answer's text is
-- composed of criterion-exclusive spans (one span per frq_criteria.criterion_key, plus
-- assembly_literal separators), verified to concatenate exactly to canonical_answer_1.
--
-- Every value in every canonical answer was independently re-derived from first principles (not
-- copied from the rubric's learner_facing_text) before this migration was authored.
--
-- Verification before writing this migration:
-- (1) every one of the 19 items' full criterion_key set was matched exactly against the authored
--     spans -- no criterion missing, none extra, none duplicated;
-- (2) span concatenation per item was verified to equal canonical_answer_1 byte for byte before
--     generating this SQL;
-- (3) all 19 target rows were confirmed to have canonical_answer_1 IS NULL beforehand -- this is a
--     pure addition, nothing is overwritten.
-- A second, live verification (concatenation of the actually-inserted spans vs. the actually-written
-- canonical_answer_1, re-queried from Production after apply) confirmed total_items=19,
-- has_canonical=19, concat_matches=19.
--
-- This file concatenates five originally-separate, independently-applied transactions
-- (physics2_batch_1.sql, physics2_batch_2.sql, physics2_batch_3.sql, physics2_batch_4a.sql,
-- physics2_batch_4b.sql), each of which was applied to Production individually and each of which
-- carries its own internal concatenation-verification check. They are kept as separate begin/commit
-- blocks below, in the order they were applied.

begin;

-- apphy2-frq-001 (b77b444d-0a37-4e02-a3d3-64095326722d)
update app.content_item_versions set canonical_answer_1 = '(a) At constant volume, W=0. By the first law, Q=ΔU. For n=1 mol of a monatomic ideal gas, Cv=(3/2)R, so ΔU=(3/2)nRΔT=(3/2)(1)(8.314 J/(mol*K))(60 K)=748 J. So Q≈748 J.

(b) The first law states ΔU=Q-W. Since volume is constant, W=∫PdV=0, so Q=ΔU. The ideal-gas assumption means the gas''s internal energy depends only on its temperature, and the monatomic assumption is what fixes the molar specific heat used in this calculation to Cv=(3/2)R (a different molecular structure would give a different Cv and thus a different ΔU for the same ΔT).' where id = 'b77b444d-0a37-4e02-a3d3-64095326722d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b77b444d-0a37-4e02-a3d3-64095326722d', 'canonical_answer_1', 1, '(a) At constant volume, W=0. By the first law, Q=ΔU. For n=1 mol of a monatomic ideal gas, Cv=(3/2)R, so ΔU=(3/2)nRΔT=(3/2)(1)(8.314 J/(mol*K))(60 K)=748 J. So Q≈748 J.', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b77b444d-0a37-4e02-a3d3-64095326722d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b77b444d-0a37-4e02-a3d3-64095326722d', 'canonical_answer_1', 3, '(b) The first law states ΔU=Q-W. Since volume is constant, W=∫PdV=0, so Q=ΔU. The ideal-gas assumption means the gas''s internal energy depends only on its temperature, and the monatomic assumption is what fixes the molar specific heat used in this calculation to Cv=(3/2)R (a different molecular structure would give a different Cv and thus a different ΔU for the same ΔT).', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-004 (ec3ef759-ee9c-4043-992a-4fecb183edbf)
update app.content_item_versions set canonical_answer_1 = '(a) The magnetic force magnitude is F=qvB=(1.602x10^-19 C)(3.00x10^5 m/s)(0.200 T)=9.61x10^-15 N. Since this force is always perpendicular to the ion''s velocity, it acts as a centripetal force, so the ion follows a circular path.

(b) Newton''s second law gives F_net=ma_c, and here the magnetic force supplies the centripetal force: qvB=mv^2/r. This is an independent application of Newton''s second law, not a restatement of part (a). The expression F=qvB comes from F=qv x B, and only the component of v perpendicular to B contributes to this cross product -- if v had a component parallel to B, that component would produce no force, so F=qvB (using the full speed) requires v to be exactly perpendicular to B.' where id = 'ec3ef759-ee9c-4043-992a-4fecb183edbf';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ec3ef759-ee9c-4043-992a-4fecb183edbf', 'canonical_answer_1', 1, '(a) The magnetic force magnitude is F=qvB=(1.602x10^-19 C)(3.00x10^5 m/s)(0.200 T)=9.61x10^-15 N. Since this force is always perpendicular to the ion''s velocity, it acts as a centripetal force, so the ion follows a circular path.', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ec3ef759-ee9c-4043-992a-4fecb183edbf', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ec3ef759-ee9c-4043-992a-4fecb183edbf', 'canonical_answer_1', 3, '(b) Newton''s second law gives F_net=ma_c, and here the magnetic force supplies the centripetal force: qvB=mv^2/r. This is an independent application of Newton''s second law, not a restatement of part (a). The expression F=qvB comes from F=qv x B, and only the component of v perpendicular to B contributes to this cross product -- if v had a component parallel to B, that component would produce no force, so F=qvB (using the full speed) requires v to be exactly perpendicular to B.', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-005 (8a400fdc-60fa-400f-a083-bad4519b47c4)
update app.content_item_versions set canonical_answer_1 = '(a) Using the thin-lens equation 1/f=1/do+1/di with f=0.200 m and do=0.600 m: 1/0.200=1/0.600+1/di, so 5.00=1.667+1/di, giving 1/di=3.333 and di=0.300 m. The magnification is m=-di/do=-0.300/0.600=-0.500. The positive di indicates a real image, and the negative m indicates it is inverted.

(b) The thin-lens equation holds because the lens is modeled as infinitely thin (so object and image distances are measured from the same plane) with paraxial rays (small angles, so sin(theta)≈tan(theta)≈theta). The sign convention assigns a positive image distance to a real image (formed on the far side of the lens from the object) and a negative magnification to an inverted image -- both match the computed values here.' where id = '8a400fdc-60fa-400f-a083-bad4519b47c4';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8a400fdc-60fa-400f-a083-bad4519b47c4', 'canonical_answer_1', 1, '(a) Using the thin-lens equation 1/f=1/do+1/di with f=0.200 m and do=0.600 m: 1/0.200=1/0.600+1/di, so 5.00=1.667+1/di, giving 1/di=3.333 and di=0.300 m. The magnification is m=-di/do=-0.300/0.600=-0.500. The positive di indicates a real image, and the negative m indicates it is inverted.', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8a400fdc-60fa-400f-a083-bad4519b47c4', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8a400fdc-60fa-400f-a083-bad4519b47c4', 'canonical_answer_1', 3, '(b) The thin-lens equation holds because the lens is modeled as infinitely thin (so object and image distances are measured from the same plane) with paraxial rays (small angles, so sin(theta)≈tan(theta)≈theta). The sign convention assigns a positive image distance to a real image (formed on the far side of the lens from the object) and a negative magnification to an inverted image -- both match the computed values here.', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-007 (bb482f33-f989-45e7-84a9-665cf2f7431f)
update app.content_item_versions set canonical_answer_1 = '(a) The maximum photoelectron kinetic energy is KEmax=3.20 eV-2.00 eV=1.20 eV. Since KEmax=eVs, the stopping potential magnitude is Vs=KEmax/e=1.20 V.

(b) Einstein''s photoelectric equation KEmax=hf-phi follows from conservation of energy: a single photon of energy hf is absorbed by a single electron, phi of that energy is used to free the electron from the metal (the work function), and the remainder becomes the electron''s kinetic energy. "Least-bound" electrons are those that escape using exactly phi of energy with no additional loss to collisions inside the metal, so their kinetic energy hf-phi is the maximum possible, not the typical, photoelectron energy -- most photoelectrons emerge with less kinetic energy than this.' where id = 'bb482f33-f989-45e7-84a9-665cf2f7431f';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bb482f33-f989-45e7-84a9-665cf2f7431f', 'canonical_answer_1', 1, '(a) The maximum photoelectron kinetic energy is KEmax=3.20 eV-2.00 eV=1.20 eV. Since KEmax=eVs, the stopping potential magnitude is Vs=KEmax/e=1.20 V.', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bb482f33-f989-45e7-84a9-665cf2f7431f', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bb482f33-f989-45e7-84a9-665cf2f7431f', 'canonical_answer_1', 3, '(b) Einstein''s photoelectric equation KEmax=hf-phi follows from conservation of energy: a single photon of energy hf is absorbed by a single electron, phi of that energy is used to free the electron from the metal (the work function), and the remainder becomes the electron''s kinetic energy. "Least-bound" electrons are those that escape using exactly phi of energy with no additional loss to collisions inside the metal, so their kinetic energy hf-phi is the maximum possible, not the typical, photoelectron energy -- most photoelectrons emerge with less kinetic energy than this.', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-008 (c0855f07-9d7e-497a-860f-34eb0d63e6cb)
update app.content_item_versions set canonical_answer_1 = '(a) On a P-V diagram, this process is a vertical line segment: pressure increases from its initial to final value while volume stays fixed at V0, with the volume axis horizontal and pressure axis vertical, and an arrow showing the direction of heating (upward). Since work equals the area under a process path on a P-V diagram, and a vertical line segment encloses zero area, W=0, and Q=ΔU=(3/2)nRΔT=(3/2)(1)(8.314)(60)≈748 J.

(b) Work equals W=∫PdV, which is zero whenever volume does not change, as it does not here. The monatomic ideal-gas assumption is what fixes the molar specific heat Cv=(3/2)R used to compute ΔU=nCvΔT -- a different molecular structure (e.g. diatomic) would give a different Cv and thus a different heat requirement for the same temperature change.' where id = 'c0855f07-9d7e-497a-860f-34eb0d63e6cb';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c0855f07-9d7e-497a-860f-34eb0d63e6cb', 'canonical_answer_1', 1, '(a) On a P-V diagram, this process is a vertical line segment: pressure increases from its initial to final value while volume stays fixed at V0, with the volume axis horizontal and pressure axis vertical, and an arrow showing the direction of heating (upward). Since work equals the area under a process path on a P-V diagram, and a vertical line segment encloses zero area, W=0, and Q=ΔU=(3/2)nRΔT=(3/2)(1)(8.314)(60)≈748 J.', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c0855f07-9d7e-497a-860f-34eb0d63e6cb', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c0855f07-9d7e-497a-860f-34eb0d63e6cb', 'canonical_answer_1', 3, '(b) Work equals W=∫PdV, which is zero whenever volume does not change, as it does not here. The monatomic ideal-gas assumption is what fixes the molar specific heat Cv=(3/2)R used to compute ΔU=nCvΔT -- a different molecular structure (e.g. diatomic) would give a different Cv and thus a different heat requirement for the same temperature change.', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-010 (e3a69010-4244-4967-9539-7ecd326a251a)
update app.content_item_versions set canonical_answer_1 = '(a) A feasible measurement: close the switch at t=0 and record the capacitor voltage Vc(t) at successive short time intervals as it charges. From the recorded data, determine the experimental time constant (for example, the elapsed time at which Vc has reached 63% of its final value), and compare this measured time constant with the predicted value tau=RC=(100x10^3 ohm)(20.0x10^-6 F)=2.00 s. The independent variable is elapsed time, the dependent variable is the measured capacitor voltage Vc(t), and a control is holding R, C, and the battery voltage fixed across trials (or varying them one at a time to test the general relationship tau=RC).

(b) The time constant tau=RC governs the exponential approach to full charge because it sets the characteristic timescale in the solution to the charging differential equation, q(t)=Q_f(1-e^(-t/RC)) -- larger R or C makes the approach slower. Using tau=2.00 s directly relies on the resistor and capacitor actually having their stated values, the capacitor having negligible leakage (so charge does not drain away separately from the charging process), and the battery or measuring device not adding significant extra resistance to the circuit -- not that any real resistor is lossless, since a real resistor always dissipates energy as heat.' where id = 'e3a69010-4244-4967-9539-7ecd326a251a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e3a69010-4244-4967-9539-7ecd326a251a', 'canonical_answer_1', 1, '(a) A feasible measurement: close the switch at t=0 and record the capacitor voltage Vc(t) at successive short time intervals as it charges. From the recorded data, determine the experimental time constant (for example, the elapsed time at which Vc has reached 63% of its final value), and compare this measured time constant with the predicted value tau=RC=(100x10^3 ohm)(20.0x10^-6 F)=2.00 s. The independent variable is elapsed time, the dependent variable is the measured capacitor voltage Vc(t), and a control is holding R, C, and the battery voltage fixed across trials (or varying them one at a time to test the general relationship tau=RC).', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e3a69010-4244-4967-9539-7ecd326a251a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e3a69010-4244-4967-9539-7ecd326a251a', 'canonical_answer_1', 3, '(b) The time constant tau=RC governs the exponential approach to full charge because it sets the characteristic timescale in the solution to the charging differential equation, q(t)=Q_f(1-e^(-t/RC)) -- larger R or C makes the approach slower. Using tau=2.00 s directly relies on the resistor and capacitor actually having their stated values, the capacitor having negligible leakage (so charge does not drain away separately from the charging process), and the battery or measuring device not adding significant extra resistance to the circuit -- not that any real resistor is lossless, since a real resistor always dissipates energy as heat.', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('b77b444d-0a37-4e02-a3d3-64095326722d'::uuid),('ec3ef759-ee9c-4043-992a-4fecb183edbf'::uuid),('8a400fdc-60fa-400f-a083-bad4519b47c4'::uuid),('bb482f33-f989-45e7-84a9-665cf2f7431f'::uuid),('c0855f07-9d7e-497a-860f-34eb0d63e6cb'::uuid),('e3a69010-4244-4967-9539-7ecd326a251a'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apphy2-frq-011 (57ffba8b-d120-43ef-b943-7451060d3832)
update app.content_item_versions set canonical_answer_1 = '(a) A feasible measurement design uses the same ion species in every trial, so charge and mass stay fixed: vary the ion''s speed v (for example by adjusting an accelerating voltage before it enters the field) and measure the resulting radius r of its circular path, while holding the magnetic field strength fixed. Compare the measured radii with the radius predicted by qvB=mv^2/r, i.e. r=mv/(qB). The independent variable is the ion speed v, the dependent variable is the measured radius r, and the controls are the magnetic field strength and the ion species (which fixes charge and mass).

(b) The ion moves perpendicular to a uniform magnetic field with other forces assumed negligible, so the net force is entirely magnetic and centripetal. At the stated speed of 3.00x10^5 m/s, which is far below the speed of light, relativistic effects on momentum and mass are negligible, so the non-relativistic relation qvB=mv^2/r applies without correction. A numeric value for the radius cannot actually be computed here, because the ion''s mass is not given in this problem.' where id = '57ffba8b-d120-43ef-b943-7451060d3832';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57ffba8b-d120-43ef-b943-7451060d3832', 'canonical_answer_1', 1, '(a) A feasible measurement design uses the same ion species in every trial, so charge and mass stay fixed: vary the ion''s speed v (for example by adjusting an accelerating voltage before it enters the field) and measure the resulting radius r of its circular path, while holding the magnetic field strength fixed. Compare the measured radii with the radius predicted by qvB=mv^2/r, i.e. r=mv/(qB). The independent variable is the ion speed v, the dependent variable is the measured radius r, and the controls are the magnetic field strength and the ion species (which fixes charge and mass).', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57ffba8b-d120-43ef-b943-7451060d3832', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57ffba8b-d120-43ef-b943-7451060d3832', 'canonical_answer_1', 3, '(b) The ion moves perpendicular to a uniform magnetic field with other forces assumed negligible, so the net force is entirely magnetic and centripetal. At the stated speed of 3.00x10^5 m/s, which is far below the speed of light, relativistic effects on momentum and mass are negligible, so the non-relativistic relation qvB=mv^2/r applies without correction. A numeric value for the radius cannot actually be computed here, because the ion''s mass is not given in this problem.', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-012 (2e9c108b-23c3-4ca9-a995-03d6122206da)
update app.content_item_versions set canonical_answer_1 = '(a) A feasible measurement design: place the illuminated object at several distances do from the lens, each greater than the lens''s focal length so that a real image forms, and for each position locate the sharp image on a screen and measure the image distance di. Compare the measured image distances (or a focal length computed from each trial via 1/f=1/do+1/di) with the values the thin-lens equation predicts. The independent variable is the object distance do, the dependent variable is the measured image distance di, and a control is the lens''s focal length being held fixed (consistent alignment, object height, or a consistent sharpness criterion for measurement are also acceptable controls).

(b) Assuming the lens thickness is negligible compared to the object and image distances means both distances can be measured from a single reference plane at the lens, which is exactly what the thin-lens equation assumes. A thick lens, by contrast, requires tracking two separate principal planes and refraction at each surface individually, which the simple thin-lens equation does not account for.' where id = '2e9c108b-23c3-4ca9-a995-03d6122206da';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2e9c108b-23c3-4ca9-a995-03d6122206da', 'canonical_answer_1', 1, '(a) A feasible measurement design: place the illuminated object at several distances do from the lens, each greater than the lens''s focal length so that a real image forms, and for each position locate the sharp image on a screen and measure the image distance di. Compare the measured image distances (or a focal length computed from each trial via 1/f=1/do+1/di) with the values the thin-lens equation predicts. The independent variable is the object distance do, the dependent variable is the measured image distance di, and a control is the lens''s focal length being held fixed (consistent alignment, object height, or a consistent sharpness criterion for measurement are also acceptable controls).', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2e9c108b-23c3-4ca9-a995-03d6122206da', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2e9c108b-23c3-4ca9-a995-03d6122206da', 'canonical_answer_1', 3, '(b) Assuming the lens thickness is negligible compared to the object and image distances means both distances can be measured from a single reference plane at the lens, which is exactly what the thin-lens equation assumes. A thick lens, by contrast, requires tracking two separate principal planes and refraction at each surface individually, which the simple thin-lens equation does not account for.', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-014 (6689e2ee-48a9-4766-aed1-19c8ead7b205)
update app.content_item_versions set canonical_answer_1 = '(a) The original values are KEmax=1.20 eV and stopping potential 1.20 V. Doubling the photon energy gives 2(3.20 eV)=6.40 eV. The new maximum kinetic energy is KEmax=6.40 eV-2.00 eV=4.40 eV, with a stopping potential of 4.40 V. Note that KEmax increased from 1.20 eV to 4.40 eV, more than doubling, even though the photon energy exactly doubled.

(b) The work function is a fixed subtraction from the photon energy, not a quantity that scales along with it -- KEmax=hf-phi always subtracts the same phi regardless of hf. So any increase in photon energy passes entirely into KEmax above that fixed floor. This means doubling the photon energy always increases KEmax by more than a factor of two whenever the work function is nonzero: doubling hf doubles the total, but since phi does not also double, the same phi is subtracted from a larger number, leaving proportionally more than double the original KEmax. This is a general consequence of the equation''s structure, not a coincidence of this problem''s specific numbers.' where id = '6689e2ee-48a9-4766-aed1-19c8ead7b205';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6689e2ee-48a9-4766-aed1-19c8ead7b205', 'canonical_answer_1', 1, '(a) The original values are KEmax=1.20 eV and stopping potential 1.20 V. Doubling the photon energy gives 2(3.20 eV)=6.40 eV. The new maximum kinetic energy is KEmax=6.40 eV-2.00 eV=4.40 eV, with a stopping potential of 4.40 V. Note that KEmax increased from 1.20 eV to 4.40 eV, more than doubling, even though the photon energy exactly doubled.', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6689e2ee-48a9-4766-aed1-19c8ead7b205', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6689e2ee-48a9-4766-aed1-19c8ead7b205', 'canonical_answer_1', 3, '(b) The work function is a fixed subtraction from the photon energy, not a quantity that scales along with it -- KEmax=hf-phi always subtracts the same phi regardless of hf. So any increase in photon energy passes entirely into KEmax above that fixed floor. This means doubling the photon energy always increases KEmax by more than a factor of two whenever the work function is nonzero: doubling hf doubles the total, but since phi does not also double, the same phi is subtracted from a larger number, leaving proportionally more than double the original KEmax. This is a general consequence of the equation''s structure, not a coincidence of this problem''s specific numbers.', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-015 (a0a4ecc3-d184-4473-8233-73319d29ac3a)
update app.content_item_versions set canonical_answer_1 = '(a) Doubling the temperature change from 60 K to 120 K doubles the heat added. At constant volume W=0, so Q=ΔU=(3/2)nRΔT, which is directly proportional to ΔT. The new value is Q=(3/2)(1)(8.314)(120)≈1496 J, twice the original 748 J.

(b) Q is directly proportional to ΔT in this process because an ideal gas''s internal energy depends only on its temperature, so ΔU depends only on ΔT (and on the fixed molar specific heat Cv, which does not change with temperature for an ideal monatomic gas). Since the process is at constant volume, W=0, so Q=ΔU=nCvΔT -- a linear function of ΔT with no other ΔT-dependence anywhere in the relationship. This proportionality holds generally for this process, not just for the specific temperature values used to compute 1496 J.' where id = 'a0a4ecc3-d184-4473-8233-73319d29ac3a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a0a4ecc3-d184-4473-8233-73319d29ac3a', 'canonical_answer_1', 1, '(a) Doubling the temperature change from 60 K to 120 K doubles the heat added. At constant volume W=0, so Q=ΔU=(3/2)nRΔT, which is directly proportional to ΔT. The new value is Q=(3/2)(1)(8.314)(120)≈1496 J, twice the original 748 J.', ARRAY['part-a'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a0a4ecc3-d184-4473-8233-73319d29ac3a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a0a4ecc3-d184-4473-8233-73319d29ac3a', 'canonical_answer_1', 3, '(b) Q is directly proportional to ΔT in this process because an ideal gas''s internal energy depends only on its temperature, so ΔU depends only on ΔT (and on the fixed molar specific heat Cv, which does not change with temperature for an ideal monatomic gas). Since the process is at constant volume, W=0, so Q=ΔU=nCvΔT -- a linear function of ΔT with no other ΔT-dependence anywhere in the relationship. This proportionality holds generally for this process, not just for the specific temperature values used to compute 1496 J.', ARRAY['part-b'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-020 (6737066b-2224-409c-8aa3-1d1ccf7fa5e3)
update app.content_item_versions set canonical_answer_1 = '(a) Capacitance halves: C=epsilon0*A/d, and doubling the plate separation d halves C for fixed plate area A.

Voltage doubles: V=Q/C. Since the capacitor is disconnected, charge Q stays fixed, and C has halved, so V=Q/C doubles.

The electric field between the plates stays the same: for a parallel-plate capacitor, E=Q/(A*epsilon0) (equivalently E=sigma/epsilon0), which depends only on the fixed charge and fixed plate area, not on the plate separation.

Stored energy doubles: U=Q^2/(2C). With Q fixed and C halved, U=Q^2/(2C) doubles.

(b) If the battery remained connected, it would hold the voltage V fixed across the capacitor instead of the charge Q, because an ideal battery maintains a constant potential difference between its terminals regardless of what is connected to it. As the plate separation increased and capacitance dropped, charge would flow off the plates (through the battery) to keep V=Q/C equal to the fixed battery voltage.

In the connected case, with V fixed and C halved, the charge Q=CV halves, so the field E=Q/(A*epsilon0) would halve (unlike the disconnected case, where E stayed the same), and the stored energy U=(1/2)CV^2, with C halved and V fixed, would halve (unlike the disconnected case, where U doubled).' where id = '6737066b-2224-409c-8aa3-1d1ccf7fa5e3';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 1, '(a) Capacitance halves: C=epsilon0*A/d, and doubling the plate separation d halves C for fixed plate area A.', ARRAY['a-C'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 3, 'Voltage doubles: V=Q/C. Since the capacitor is disconnected, charge Q stays fixed, and C has halved, so V=Q/C doubles.', ARRAY['a-V'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 5, 'The electric field between the plates stays the same: for a parallel-plate capacitor, E=Q/(A*epsilon0) (equivalently E=sigma/epsilon0), which depends only on the fixed charge and fixed plate area, not on the plate separation.', ARRAY['a-E'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 7, 'Stored energy doubles: U=Q^2/(2C). With Q fixed and C halved, U=Q^2/(2C) doubles.', ARRAY['a-U'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 9, '(b) If the battery remained connected, it would hold the voltage V fixed across the capacitor instead of the charge Q, because an ideal battery maintains a constant potential difference between its terminals regardless of what is connected to it. As the plate separation increased and capacitance dropped, charge would flow off the plates (through the battery) to keep V=Q/C equal to the fixed battery voltage.', ARRAY['b-connected'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6737066b-2224-409c-8aa3-1d1ccf7fa5e3', 'canonical_answer_1', 11, 'In the connected case, with V fixed and C halved, the charge Q=CV halves, so the field E=Q/(A*epsilon0) would halve (unlike the disconnected case, where E stayed the same), and the stored energy U=(1/2)CV^2, with C halved and V fixed, would halve (unlike the disconnected case, where U doubled).', ARRAY['b-energy'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-021 (c6205508-e95b-47ef-9b9c-58bde42cab25)
update app.content_item_versions set canonical_answer_1 = '(a) Using the voltmeter probe, locate multiple points on the conductive paper that all read the same potential (relative to a fixed reference point), and connect each such set of equal-potential points into a smooth equipotential line; repeat for several different potential values to build up a map of equipotential lines.

The electric field at any point is perpendicular to the equipotential line through that point, and points in the direction from high potential toward low potential. The field is stronger where the equipotential lines are drawn more closely together -- but this comparison of spacing is only meaningful if each line represents an equal potential interval from its neighbors, since otherwise closer spacing could simply reflect a smaller chosen interval rather than a genuinely stronger field.

(b) One control: keep the two conducting shapes'' applied potentials fixed at their set values throughout the entire mapping session, so that all sampled points are describing the same static field configuration.

One measurement practice that improves the map: sample the paper on a regular, sufficiently fine grid of points (or repeat readings at each point and average them) so that the equipotential lines drawn through the found points are not distorted by sparse or noisy sampling.' where id = 'c6205508-e95b-47ef-9b9c-58bde42cab25';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c6205508-e95b-47ef-9b9c-58bde42cab25', 'canonical_answer_1', 1, '(a) Using the voltmeter probe, locate multiple points on the conductive paper that all read the same potential (relative to a fixed reference point), and connect each such set of equal-potential points into a smooth equipotential line; repeat for several different potential values to build up a map of equipotential lines.', ARRAY['a-map'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c6205508-e95b-47ef-9b9c-58bde42cab25', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c6205508-e95b-47ef-9b9c-58bde42cab25', 'canonical_answer_1', 3, 'The electric field at any point is perpendicular to the equipotential line through that point, and points in the direction from high potential toward low potential. The field is stronger where the equipotential lines are drawn more closely together -- but this comparison of spacing is only meaningful if each line represents an equal potential interval from its neighbors, since otherwise closer spacing could simply reflect a smaller chosen interval rather than a genuinely stronger field.', ARRAY['a-field'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c6205508-e95b-47ef-9b9c-58bde42cab25', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c6205508-e95b-47ef-9b9c-58bde42cab25', 'canonical_answer_1', 5, '(b) One control: keep the two conducting shapes'' applied potentials fixed at their set values throughout the entire mapping session, so that all sampled points are describing the same static field configuration.', ARRAY['b-control'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c6205508-e95b-47ef-9b9c-58bde42cab25', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c6205508-e95b-47ef-9b9c-58bde42cab25', 'canonical_answer_1', 7, 'One measurement practice that improves the map: sample the paper on a regular, sufficiently fine grid of points (or repeat readings at each point and average them) so that the equipotential lines drawn through the found points are not distorted by sparse or noisy sampling.', ARRAY['b-precision'], 'drafted', 'apphysics2_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('57ffba8b-d120-43ef-b943-7451060d3832'::uuid),('2e9c108b-23c3-4ca9-a995-03d6122206da'::uuid),('6689e2ee-48a9-4766-aed1-19c8ead7b205'::uuid),('a0a4ecc3-d184-4473-8233-73319d29ac3a'::uuid),('6737066b-2224-409c-8aa3-1d1ccf7fa5e3'::uuid),('c6205508-e95b-47ef-9b9c-58bde42cab25'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apphy2-frq-022 (5ba47ced-b8ae-4731-9046-75198e152c2a)
update app.content_item_versions set canonical_answer_1 = '(a) An energy bar chart shows the proton''s electric potential energy decreasing by 600 eV (since U=qV and the proton, with positive charge, loses potential energy as it moves from higher potential 800 V to lower potential 200 V) while its kinetic energy increases by the same 600 eV, since total mechanical energy is conserved and gravity is neglected.

(b) The proton''s kinetic energy equals the magnitude of potential energy lost: KE=q*ΔV=e*(800 V-200 V)=e*600 V=600 eV.

Converting to joules: 600 eV * 1.602x10^-19 J/eV = 9.61x10^-17 J.

Using KE=(1/2)mv^2 with the proton mass m=1.673x10^-27 kg: v=sqrt(2*KE/m)=sqrt(2*(9.61x10^-17 J)/(1.673x10^-27 kg))≈3.39x10^5 m/s.

For an electron released from rest at 200 V and accelerated toward 800 V: since the electron has negative charge, its potential energy U=qV decreases as V increases, so its potential energy decreases (by the same 600 V magnitude) while its kinetic energy increases, exactly analogous in energy terms to the proton''s case but with the electron moving toward higher, not lower, potential (since electron flow is opposite to conventional current/positive-charge motion for the same energy change).

The electron gains the same 600 eV of kinetic energy as the proton did, since both experience the same magnitude of potential difference (600 V) and both carry the same magnitude of elementary charge.

The electron''s speed is much greater than the proton''s for this same 600 eV of kinetic energy, because KE=(1/2)mv^2 means a much smaller mass (the electron''s mass is about 1/1836 the proton''s mass) requires a much larger speed to store the same kinetic energy.' where id = '5ba47ced-b8ae-4731-9046-75198e152c2a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 1, '(a) An energy bar chart shows the proton''s electric potential energy decreasing by 600 eV (since U=qV and the proton, with positive charge, loses potential energy as it moves from higher potential 800 V to lower potential 200 V) while its kinetic energy increases by the same 600 eV, since total mechanical energy is conserved and gravity is neglected.', ARRAY['a-bars'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 3, '(b) The proton''s kinetic energy equals the magnitude of potential energy lost: KE=q*ΔV=e*(800 V-200 V)=e*600 V=600 eV.', ARRAY['b-ev'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 5, 'Converting to joules: 600 eV * 1.602x10^-19 J/eV = 9.61x10^-17 J.', ARRAY['b-joule'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 7, 'Using KE=(1/2)mv^2 with the proton mass m=1.673x10^-27 kg: v=sqrt(2*KE/m)=sqrt(2*(9.61x10^-17 J)/(1.673x10^-27 kg))≈3.39x10^5 m/s.', ARRAY['c-speed'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 9, 'For an electron released from rest at 200 V and accelerated toward 800 V: since the electron has negative charge, its potential energy U=qV decreases as V increases, so its potential energy decreases (by the same 600 V magnitude) while its kinetic energy increases, exactly analogous in energy terms to the proton''s case but with the electron moving toward higher, not lower, potential (since electron flow is opposite to conventional current/positive-charge motion for the same energy change).', ARRAY['c-electron-pe'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 11, 'The electron gains the same 600 eV of kinetic energy as the proton did, since both experience the same magnitude of potential difference (600 V) and both carry the same magnitude of elementary charge.', ARRAY['c-electron-energy'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ba47ced-b8ae-4731-9046-75198e152c2a', 'canonical_answer_1', 13, 'The electron''s speed is much greater than the proton''s for this same 600 eV of kinetic energy, because KE=(1/2)mv^2 means a much smaller mass (the electron''s mass is about 1/1836 the proton''s mass) requires a much larger speed to store the same kinetic energy.', ARRAY['c-electron-speed'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-025 (096f1fa1-0735-4caa-81ce-3051d81549e6)
update app.content_item_versions set canonical_answer_1 = '(a) At t=0: Vc=0 (the capacitor starts uncharged). At t=tau: Vc≈0.63*eps (63% of the way to full charge, by definition of the time constant). As t approaches infinity: Vc approaches eps (fully charged, matching the battery''s emf).

At t=0: V_R=eps (all the emf initially appears across the resistor, since Vc=0). At t=tau: V_R≈0.37*eps (since V_R=eps-Vc and Vc≈0.63*eps at that time). As t approaches infinity: V_R approaches 0 (since Vc approaches eps).

At t=0: I=eps/R (maximum current, since the full emf drives current through R with Vc=0). At t=tau: I≈0.37*eps/R (proportional to V_R at that time, since I=V_R/R). As t approaches infinity: I approaches 0 (as the capacitor becomes fully charged and stops drawing current).

As the capacitor charges, its voltage rises monotonically from 0 toward eps, while the resistor voltage and the current both fall monotonically from their initial maximum toward 0.

By Kirchhoff''s loop rule applied to this single-loop circuit, the emf equals the sum of the voltage drops around the loop: eps=Vc+V_R at every instant, not only at the three specific times listed above. Rearranging gives V_R=eps-Vc as a relationship that holds continuously throughout the charging process, which is the reasoning connecting the values at all three times (and at every time in between), not a set of three separately memorized facts.

(b) The total charge that eventually flows onto the capacitor is Q=C*eps, so the total energy delivered by the battery over the full charging process is Q*eps=C*eps^2 (since the battery delivers energy eps per unit charge that flows through it). The capacitor ends up storing U_C=(1/2)*C*eps^2, using U=(1/2)*C*V^2 evaluated at the final voltage V=eps. The remaining energy, C*eps^2-(1/2)*C*eps^2=(1/2)*C*eps^2, is dissipated as heat in the resistor over the course of charging.

This 50/50 split of delivered energy between the capacitor and the resistor does not depend on the value of R: the final expressions C*eps^2 (delivered), (1/2)*C*eps^2 (stored), and (1/2)*C*eps^2 (dissipated) depend only on C and eps, not on R. A larger R makes the process slower (since tau=RC is larger) but does not change how the total energy is ultimately divided between storage and dissipation.' where id = '096f1fa1-0735-4caa-81ce-3051d81549e6';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 1, '(a) At t=0: Vc=0 (the capacitor starts uncharged). At t=tau: Vc≈0.63*eps (63% of the way to full charge, by definition of the time constant). As t approaches infinity: Vc approaches eps (fully charged, matching the battery''s emf).', ARRAY['a-values-VC'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 3, 'At t=0: V_R=eps (all the emf initially appears across the resistor, since Vc=0). At t=tau: V_R≈0.37*eps (since V_R=eps-Vc and Vc≈0.63*eps at that time). As t approaches infinity: V_R approaches 0 (since Vc approaches eps).', ARRAY['a-values-VR'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 5, 'At t=0: I=eps/R (maximum current, since the full emf drives current through R with Vc=0). At t=tau: I≈0.37*eps/R (proportional to V_R at that time, since I=V_R/R). As t approaches infinity: I approaches 0 (as the capacitor becomes fully charged and stops drawing current).', ARRAY['a-values-I'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 7, 'As the capacitor charges, its voltage rises monotonically from 0 toward eps, while the resistor voltage and the current both fall monotonically from their initial maximum toward 0.', ARRAY['a-trends'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 9, 'By Kirchhoff''s loop rule applied to this single-loop circuit, the emf equals the sum of the voltage drops around the loop: eps=Vc+V_R at every instant, not only at the three specific times listed above. Rearranging gives V_R=eps-Vc as a relationship that holds continuously throughout the charging process, which is the reasoning connecting the values at all three times (and at every time in between), not a set of three separately memorized facts.', ARRAY['a-loop-rule'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 11, '(b) The total charge that eventually flows onto the capacitor is Q=C*eps, so the total energy delivered by the battery over the full charging process is Q*eps=C*eps^2 (since the battery delivers energy eps per unit charge that flows through it). The capacitor ends up storing U_C=(1/2)*C*eps^2, using U=(1/2)*C*V^2 evaluated at the final voltage V=eps. The remaining energy, C*eps^2-(1/2)*C*eps^2=(1/2)*C*eps^2, is dissipated as heat in the resistor over the course of charging.', ARRAY['b-energy'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('096f1fa1-0735-4caa-81ce-3051d81549e6', 'canonical_answer_1', 13, 'This 50/50 split of delivered energy between the capacitor and the resistor does not depend on the value of R: the final expressions C*eps^2 (delivered), (1/2)*C*eps^2 (stored), and (1/2)*C*eps^2 (dissipated) depend only on C and eps, not on R. A larger R makes the process slower (since tau=RC is larger) but does not change how the total energy is ultimately divided between storage and dissipation.', ARRAY['b-r-independence'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-029 (dd97ff0f-7ce0-42d6-8f01-cf6270f20216)
update app.content_item_versions set canonical_answer_1 = '(a) For several different object distances (each large enough to produce a real image, i.e. greater than the lens''s focal length), place the illuminated object at that distance, move the screen until a sharp, in-focus real image appears, and measure both the object distance do and the resulting image distance di using the meterstick, for each trial.

(b) Rearranging the thin-lens equation 1/f=1/do+1/di gives 1/di=-1/do+1/f (a linear relationship in the form y=mx+b). Plotting 1/di on the vertical axis against 1/do on the horizontal axis should give a line with slope -1 and vertical intercept 1/f, so the focal length can be extracted as f=1/(intercept).

One uncertainty precaution: repeat the sharp-focus judgment for each object position several times (and average the resulting image-distance readings), and consistently measure both do and di from the same reference point (the lens''s optical center) each time, to reduce random and systematic error in locating the sharpest image position.' where id = 'dd97ff0f-7ce0-42d6-8f01-cf6270f20216';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dd97ff0f-7ce0-42d6-8f01-cf6270f20216', 'canonical_answer_1', 1, '(a) For several different object distances (each large enough to produce a real image, i.e. greater than the lens''s focal length), place the illuminated object at that distance, move the screen until a sharp, in-focus real image appears, and measure both the object distance do and the resulting image distance di using the meterstick, for each trial.', ARRAY['a-procedure'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dd97ff0f-7ce0-42d6-8f01-cf6270f20216', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dd97ff0f-7ce0-42d6-8f01-cf6270f20216', 'canonical_answer_1', 3, '(b) Rearranging the thin-lens equation 1/f=1/do+1/di gives 1/di=-1/do+1/f (a linear relationship in the form y=mx+b). Plotting 1/di on the vertical axis against 1/do on the horizontal axis should give a line with slope -1 and vertical intercept 1/f, so the focal length can be extracted as f=1/(intercept).', ARRAY['b-graph'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dd97ff0f-7ce0-42d6-8f01-cf6270f20216', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dd97ff0f-7ce0-42d6-8f01-cf6270f20216', 'canonical_answer_1', 5, 'One uncertainty precaution: repeat the sharp-focus judgment for each object position several times (and average the resulting image-distance readings), and consistently measure both do and di from the same reference point (the lens''s optical center) each time, to reduce random and systematic error in locating the sharpest image position.', ARRAY['b-quality'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-031 (a98745c9-03fb-4fe8-9f11-6286b83fedcf)
update app.content_item_versions set canonical_answer_1 = '(a) With the first polarizer fixed, rotate the second polarizer to a series of relative angles theta spanning 0 degrees to 90 degrees, and record the light sensor''s transmitted-intensity reading at each angle.

(b) Malus''s law predicts I=I_max*cos^2(theta). Plotting the measured intensity I against cos^2(theta) (rather than against theta directly) should produce a linear relationship -- passing through the origin only if background light and any sensor offset are negligible or have been subtracted out; otherwise the line will be linear but may have a nonzero intercept representing that background/offset contribution.

One controlled variable to hold fixed across all trials: the incident light source''s intensity (or equivalently the sensor''s position and the spacing between the two polarizers) should be kept the same for every angle measured, so that intensity changes observed are due only to the changing relative polarizer angle.' where id = 'a98745c9-03fb-4fe8-9f11-6286b83fedcf';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a98745c9-03fb-4fe8-9f11-6286b83fedcf', 'canonical_answer_1', 1, '(a) With the first polarizer fixed, rotate the second polarizer to a series of relative angles theta spanning 0 degrees to 90 degrees, and record the light sensor''s transmitted-intensity reading at each angle.', ARRAY['a-procedure'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a98745c9-03fb-4fe8-9f11-6286b83fedcf', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a98745c9-03fb-4fe8-9f11-6286b83fedcf', 'canonical_answer_1', 3, '(b) Malus''s law predicts I=I_max*cos^2(theta). Plotting the measured intensity I against cos^2(theta) (rather than against theta directly) should produce a linear relationship -- passing through the origin only if background light and any sensor offset are negligible or have been subtracted out; otherwise the line will be linear but may have a nonzero intercept representing that background/offset contribution.', ARRAY['b-model'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a98745c9-03fb-4fe8-9f11-6286b83fedcf', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a98745c9-03fb-4fe8-9f11-6286b83fedcf', 'canonical_answer_1', 5, 'One controlled variable to hold fixed across all trials: the incident light source''s intensity (or equivalently the sensor''s position and the spacing between the two polarizers) should be kept the same for every angle measured, so that intensity changes observed are due only to the changing relative polarizer angle.', ARRAY['b-control'], 'drafted', 'apphysics2_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('5ba47ced-b8ae-4731-9046-75198e152c2a'::uuid),('096f1fa1-0735-4caa-81ce-3051d81549e6'::uuid),('dd97ff0f-7ce0-42d6-8f01-cf6270f20216'::uuid),('a98745c9-03fb-4fe8-9f11-6286b83fedcf'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apphy2-frq-035 (dc4bd46a-9418-40ab-aa2d-5117b7392347)
update app.content_item_versions set canonical_answer_1 = '(a) Since R and 2R are in series with each other (and with the capacitor and battery), the equivalent series resistance is R+2R=3R.

As t approaches infinity, no current flows and there is no voltage drop across either resistor, so the full emf appears across the capacitor: the final capacitor voltage is eps, giving a final charge Q_f=C*eps.

The time constant for this circuit is tau=(equivalent resistance)*C=(3R)*C=3RC.

Using the given standard charging form with Q_f=C*eps and tau=3RC: q(t)=C*eps*(1-e^(-t/(3RC))).

The current is the time derivative of charge: I(t)=dq/dt=C*eps*(1/(3RC))*e^(-t/(3RC))=(eps/(3R))*e^(-t/(3RC)).

The voltage across the 2R resistor is V_2R(t)=I(t)*2R=(eps/(3R))*2R*e^(-t/(3RC))=(2*eps/3)*e^(-t/(3RC)).

Kirchhoff''s loop rule requires V_R+V_2R+V_C=eps at every instant. Here V_R+V_2R=I(t)*3R=eps*e^(-t/(3RC)), and V_C=eps*(1-e^(-t/(3RC))); adding these gives eps*e^(-t/(3RC))+eps-eps*e^(-t/(3RC))=eps, confirming the loop rule holds at all times.

(b) The energy stored in the capacitor is U_C=(1/2)*C*V_C^2, and the final stored energy is U_final=(1/2)*C*eps^2. Setting U_C/U_final=(V_C/eps)^2=1/4 (a stored-energy fraction of one quarter) gives V_C/eps=1/2, so V_C=eps/2.

Since V_C(t)=eps*(1-e^(-t/(3RC))), setting V_C=eps/2 gives 1-e^(-t/(3RC))=1/2, so e^(-t/(3RC))=1/2, and solving gives t=3RC*ln(2).

Up to this time, the battery has delivered charge Q=C*V_C=C*(eps/2), so it has delivered energy eps*Q=C*eps^2/2. Of this, the capacitor has stored U_C=(1/8)*C*eps^2 (one quarter of the final (1/2)*C*eps^2). The combined resistor dissipation is the difference: E_diss=(1/2)*C*eps^2-(1/8)*C*eps^2=(3/8)*C*eps^2.' where id = 'dc4bd46a-9418-40ab-aa2d-5117b7392347';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 1, '(a) Since R and 2R are in series with each other (and with the capacitor and battery), the equivalent series resistance is R+2R=3R.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 3, 'As t approaches infinity, no current flows and there is no voltage drop across either resistor, so the full emf appears across the capacitor: the final capacitor voltage is eps, giving a final charge Q_f=C*eps.', ARRAY['part-a-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 5, 'The time constant for this circuit is tau=(equivalent resistance)*C=(3R)*C=3RC.', ARRAY['part-a-criterion-03'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 7, 'Using the given standard charging form with Q_f=C*eps and tau=3RC: q(t)=C*eps*(1-e^(-t/(3RC))).', ARRAY['part-a-criterion-04'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 9, 'The current is the time derivative of charge: I(t)=dq/dt=C*eps*(1/(3RC))*e^(-t/(3RC))=(eps/(3R))*e^(-t/(3RC)).', ARRAY['part-a-criterion-05'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 11, 'The voltage across the 2R resistor is V_2R(t)=I(t)*2R=(eps/(3R))*2R*e^(-t/(3RC))=(2*eps/3)*e^(-t/(3RC)).', ARRAY['part-a-criterion-06'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 13, 'Kirchhoff''s loop rule requires V_R+V_2R+V_C=eps at every instant. Here V_R+V_2R=I(t)*3R=eps*e^(-t/(3RC)), and V_C=eps*(1-e^(-t/(3RC))); adding these gives eps*e^(-t/(3RC))+eps-eps*e^(-t/(3RC))=eps, confirming the loop rule holds at all times.', ARRAY['part-a-criterion-07'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 15, '(b) The energy stored in the capacitor is U_C=(1/2)*C*V_C^2, and the final stored energy is U_final=(1/2)*C*eps^2. Setting U_C/U_final=(V_C/eps)^2=1/4 (a stored-energy fraction of one quarter) gives V_C/eps=1/2, so V_C=eps/2.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 17, 'Since V_C(t)=eps*(1-e^(-t/(3RC))), setting V_C=eps/2 gives 1-e^(-t/(3RC))=1/2, so e^(-t/(3RC))=1/2, and solving gives t=3RC*ln(2).', ARRAY['part-b-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc4bd46a-9418-40ab-aa2d-5117b7392347', 'canonical_answer_1', 19, 'Up to this time, the battery has delivered charge Q=C*V_C=C*(eps/2), so it has delivered energy eps*Q=C*eps^2/2. Of this, the capacitor has stored U_C=(1/8)*C*eps^2 (one quarter of the final (1/2)*C*eps^2). The combined resistor dissipation is the difference: E_diss=(1/2)*C*eps^2-(1/8)*C*eps^2=(3/8)*C*eps^2.', ARRAY['part-b-criterion-03'], 'drafted', 'apphysics2_canonical_2026_09_25');

-- apphy2-frq-036 (20f62599-5631-4e16-86a7-33c2091f7637)
update app.content_item_versions set canonical_answer_1 = '(a) Plot point A at (V0,P0), point B at (2V0,P0), and point C at (2V0,P0/2). Connect A to B with a horizontal segment (isobaric), B to C with a vertical segment (isochoric), and C back to A with a straight line segment.

The cycle proceeds in the direction A to B to C and back to A, as stated.

Since T is proportional to PV for a fixed amount of ideal gas (PV=nRT), T_A is proportional to P0*V0, T_B is proportional to P0*(2V0)=2*P0*V0, and T_C is proportional to (P0/2)*(2V0)=P0*V0. So T_B is the greatest of the three temperatures, and T_A equals T_C.

(b) The work done by the gas during the isobaric expansion A to B is W_AB=P0*(2V0-V0)=P0*V0.

The work done during the isochoric process B to C is zero, since volume does not change: W_BC=0.

During the straight-line process C to A, the pressure varies linearly between P0/2 (at C) and P0 (at A), so the average pressure along this path is (P0/2+P0)/2=3*P0/4. The volume change is V0-2V0=-V0, so the work done by the gas is W_CA=(3*P0/4)*(-V0)=-(3/4)*P0*V0.

The net work done by the gas over the full cycle is W_net=W_AB+W_BC+W_CA=P0*V0+0-(3/4)*P0*V0=(1/4)*P0*V0, which equals the enclosed area of the cycle traced clockwise on the P-V diagram.

(c) From A to B (constant pressure P0), T=PV/(nR)=(P0/(nR))*V, so T increases linearly with V as a straight increasing line as V goes from V0 to 2V0.

From B to C (constant volume 2V0), the T-V diagram shows a vertical segment at V=2V0, since T changes (decreases) while V stays fixed.

From C to A, since P varies linearly with V along this path (not held constant), T=PV/(nR) is a curved (not straight) path in the T-V diagram, because T is now the product of two linearly-varying quantities (P and V) rather than a linear function of V alone.

(d) Since internal energy is a state function and this is a complete cycle returning to the starting state A, the total change in internal energy over the full cycle is zero: ΔU_cycle=0.

Applying the first law over the full cycle, ΔU=Q_net-W_net, and since ΔU_cycle=0, Q_net=W_net=(1/4)*P0*V0 (the same net work found in part (b)).' where id = '20f62599-5631-4e16-86a7-33c2091f7637';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 1, '(a) Plot point A at (V0,P0), point B at (2V0,P0), and point C at (2V0,P0/2). Connect A to B with a horizontal segment (isobaric), B to C with a vertical segment (isochoric), and C back to A with a straight line segment.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 3, 'The cycle proceeds in the direction A to B to C and back to A, as stated.', ARRAY['part-a-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 5, 'Since T is proportional to PV for a fixed amount of ideal gas (PV=nRT), T_A is proportional to P0*V0, T_B is proportional to P0*(2V0)=2*P0*V0, and T_C is proportional to (P0/2)*(2V0)=P0*V0. So T_B is the greatest of the three temperatures, and T_A equals T_C.', ARRAY['part-a-criterion-03'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 7, '(b) The work done by the gas during the isobaric expansion A to B is W_AB=P0*(2V0-V0)=P0*V0.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 9, 'The work done during the isochoric process B to C is zero, since volume does not change: W_BC=0.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 11, 'During the straight-line process C to A, the pressure varies linearly between P0/2 (at C) and P0 (at A), so the average pressure along this path is (P0/2+P0)/2=3*P0/4. The volume change is V0-2V0=-V0, so the work done by the gas is W_CA=(3*P0/4)*(-V0)=-(3/4)*P0*V0.', ARRAY['part-b-criterion-03'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 13, 'The net work done by the gas over the full cycle is W_net=W_AB+W_BC+W_CA=P0*V0+0-(3/4)*P0*V0=(1/4)*P0*V0, which equals the enclosed area of the cycle traced clockwise on the P-V diagram.', ARRAY['part-b-criterion-04'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 15, '(c) From A to B (constant pressure P0), T=PV/(nR)=(P0/(nR))*V, so T increases linearly with V as a straight increasing line as V goes from V0 to 2V0.', ARRAY['part-c-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 17, 'From B to C (constant volume 2V0), the T-V diagram shows a vertical segment at V=2V0, since T changes (decreases) while V stays fixed.', ARRAY['part-c-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 19, 'From C to A, since P varies linearly with V along this path (not held constant), T=PV/(nR) is a curved (not straight) path in the T-V diagram, because T is now the product of two linearly-varying quantities (P and V) rather than a linear function of V alone.', ARRAY['part-c-criterion-03'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 20, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 21, '(d) Since internal energy is a state function and this is a complete cycle returning to the starting state A, the total change in internal energy over the full cycle is zero: ΔU_cycle=0.', ARRAY['part-d-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 22, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('20f62599-5631-4e16-86a7-33c2091f7637', 'canonical_answer_1', 23, 'Applying the first law over the full cycle, ΔU=Q_net-W_net, and since ΔU_cycle=0, Q_net=W_net=(1/4)*P0*V0 (the same net work found in part (b)).', ARRAY['part-d-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('dc4bd46a-9418-40ab-aa2d-5117b7392347'::uuid),('20f62599-5631-4e16-86a7-33c2091f7637'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apphy2-frq-037 (0a0c9b28-f027-486a-8e74-300adadea454)
update app.content_item_versions set canonical_answer_1 = '(a) Starting from the thin-lens equation 1/f=1/do+1/di, rearrange to isolate 1/di as a linear function of 1/do: 1/di=-1/do+1/f.

This has the form of a line y=mx+b with y=1/di, x=1/do, slope m=-1, and vertical intercept b=1/f -- so a plot of 1/di versus 1/do should be a line of slope -1 and intercept 1/f.

(b) For each of several different object positions with do greater than the focal length, move the screen along the optical bench until the sharpest possible real image appears, and record the paired values of do and di for that trial.

Measure both the object distance and the image distance from the same reference point -- the lens''s optical center -- along the bench, and use a consistent, repeatable criterion for judging when the image is "sharpest" across all trials.

(c) Plot 1/di on the vertical axis against 1/do on the horizontal axis for all the recorded trials, and fit a best-fit straight line through the points.

From the fitted line''s vertical intercept b, the focal length is obtained as f=1/b.

Uncertainty in the focal length is propagated from the uncertainty in the fitted intercept using the relation for propagating error through a reciprocal, delta_f is approximately delta_b/b^2 (or equivalently, taking the reciprocals of the intercepts from the steepest and shallowest acceptable fit lines to bound f).

As a check on the fit''s validity, confirm that the fitted slope is consistent with the predicted value of -1, and that the residuals (differences between the data points and the fitted line) show no systematic curvature or trend with position, which would indicate a violation of the assumed linear model.

(d) A common additive offset applied to every absolute position reading on the bench (for example, if the ruler''s zero mark is shifted) cancels out when computing do and di, since both are differences between two positions (the lens position and the object or image position) -- so such an offset does not affect the measured values of do or di.

Consequently, the calculated focal length from the fitted line is unchanged by this kind of offset, provided the lens-center reference point used to define do and di is located consistently across all trials.' where id = '0a0c9b28-f027-486a-8e74-300adadea454';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 1, '(a) Starting from the thin-lens equation 1/f=1/do+1/di, rearrange to isolate 1/di as a linear function of 1/do: 1/di=-1/do+1/f.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 3, 'This has the form of a line y=mx+b with y=1/di, x=1/do, slope m=-1, and vertical intercept b=1/f -- so a plot of 1/di versus 1/do should be a line of slope -1 and intercept 1/f.', ARRAY['part-a-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 5, '(b) For each of several different object positions with do greater than the focal length, move the screen along the optical bench until the sharpest possible real image appears, and record the paired values of do and di for that trial.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 7, 'Measure both the object distance and the image distance from the same reference point -- the lens''s optical center -- along the bench, and use a consistent, repeatable criterion for judging when the image is "sharpest" across all trials.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 9, '(c) Plot 1/di on the vertical axis against 1/do on the horizontal axis for all the recorded trials, and fit a best-fit straight line through the points.', ARRAY['part-c-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 11, 'From the fitted line''s vertical intercept b, the focal length is obtained as f=1/b.', ARRAY['part-c-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 13, 'Uncertainty in the focal length is propagated from the uncertainty in the fitted intercept using the relation for propagating error through a reciprocal, delta_f is approximately delta_b/b^2 (or equivalently, taking the reciprocals of the intercepts from the steepest and shallowest acceptable fit lines to bound f).', ARRAY['part-c-criterion-03'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 15, 'As a check on the fit''s validity, confirm that the fitted slope is consistent with the predicted value of -1, and that the residuals (differences between the data points and the fitted line) show no systematic curvature or trend with position, which would indicate a violation of the assumed linear model.', ARRAY['part-c-criterion-04'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 17, '(d) A common additive offset applied to every absolute position reading on the bench (for example, if the ruler''s zero mark is shifted) cancels out when computing do and di, since both are differences between two positions (the lens position and the object or image position) -- so such an offset does not affect the measured values of do or di.', ARRAY['part-d-criterion-01'], 'drafted', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphysics2_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0a0c9b28-f027-486a-8e74-300adadea454', 'canonical_answer_1', 19, 'Consequently, the calculated focal length from the fitted line is unchanged by this kind of offset, provided the lens-center reference point used to define do and di is located consistently across all trials.', ARRAY['part-d-criterion-02'], 'drafted', 'apphysics2_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('0a0c9b28-f027-486a-8e74-300adadea454'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;
