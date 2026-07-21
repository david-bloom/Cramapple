-- Draft repair for the 6 published, live FRQs found incomplete in Production
-- (apchem-frq-l-001, apchem-sfrq-001, apphy1-frq-001, apphy2-frq-001,
-- apphycem-frq-001, apphycm-frq-001 — 15 criteria total, all currently NULL
-- evidence_requirements/minimum_fix, empty accepted_variants).
--
-- NOT APPLIED. Draft only, for review. Each evidence_requirements/minimum_fix
-- is written from that criterion's actual stem/canonical_answer/learner_facing_text
-- (pulled read-only from Production on 2026-07-20) — no templated language.
-- accepted_variants are the grading-relevant numeric/phrase equivalents a
-- correct response might use.

begin;

-- apchem-frq-l-001 — carbonate mass-fraction stoichiometry (2.50 g sample, 0.0118 mol CO2)
update app.frq_criteria set
  evidence_requirements = 'Response states the 1:1 mole ratio between CO2 produced and carbonate consumed, and computes mass fraction as (0.0118 mol x carbonate molar mass) / 2.50 g.',
  minimum_fix = 'To earn this point, state that moles of carbonate = moles of CO2 (0.0118 mol) from the 1:1 stoichiometric ratio, then divide (moles x molar mass) by the 2.50 g sample mass to get the mass fraction.',
  accepted_variants = '["0.0118 mol carbonate", "1:1 mole ratio of CO2 to carbonate", "mass fraction = (0.0118 x M) / 2.50"]'::jsonb
where content_item_version_id = 'd8d7751b-fd46-4dc8-b468-13549dcc9a7e' and criterion_key = 'part-a';

update app.frq_criteria set
  evidence_requirements = 'Response cites the balanced equation''s mole ratio (conservation of mass) as the basis for converting CO2 moles to carbonate moles, and states that the reaction is assumed to have gone to completion.',
  minimum_fix = 'To earn this point, state explicitly that the reaction is assumed to go to completion, and cite the balanced equation''s mole ratio as what allows converting moles of CO2 to moles of carbonate.',
  accepted_variants = '["assumes complete reaction", "reaction goes to completion", "conservation of mass via the balanced equation"]'::jsonb
where content_item_version_id = 'd8d7751b-fd46-4dc8-b468-13549dcc9a7e' and criterion_key = 'part-b';

update app.frq_criteria set
  evidence_requirements = 'Response identifies mass of CO2 evolved as the measured (dependent) variable and initial sample mass as the variable held constant across trials.',
  minimum_fix = 'To earn this point, state that you would measure the mass of CO2 evolved (the dependent variable) while holding the initial sample mass constant across trials.',
  accepted_variants = '["measure mass of CO2 evolved", "hold sample mass constant", "control the initial mass"]'::jsonb
where content_item_version_id = 'd8d7751b-fd46-4dc8-b468-13549dcc9a7e' and criterion_key = 'part-c';

update app.frq_criteria set
  evidence_requirements = 'Response names a specific systematic error (e.g., CO2 escaping before capture) and correctly predicts that it makes the calculated carbonate mass fraction too low.',
  minimum_fix = 'To earn this point, name a specific systematic error (e.g., CO2 escaping before it is captured) and state that it would make the calculated carbonate mass fraction too low, since measuring less CO2 implies less carbonate.',
  accepted_variants = '["CO2 escapes before capture", "too low", "undercounts CO2 evolved"]'::jsonb
where content_item_version_id = 'd8d7751b-fd46-4dc8-b468-13549dcc9a7e' and criterion_key = 'part-d';

-- apchem-sfrq-001 — equilibrium shift (A<=>B, K=4.0, Q=0.50)
update app.frq_criteria set
  evidence_requirements = 'Response states the reaction shifts toward products (right, forming more B) and that [A] decreases while [B] increases until Q rises to equal K.',
  minimum_fix = 'To earn this point, state that the reaction shifts right (toward B) and that [A] decreases while [B] increases until Q rises to equal K (4.0).',
  accepted_variants = '["shifts toward products", "shifts right", "Q increases until Q=K"]'::jsonb
where content_item_version_id = '7e040a80-1158-4c59-a800-a0941c111950' and criterion_key = 'part-a';

update app.frq_criteria set
  evidence_requirements = 'Response names Le Chatelier''s principle or the Q-vs-K comparison as the justification for the shift, and states the assumption that temperature is constant so K does not change.',
  minimum_fix = 'To earn this point, name Le Chatelier''s principle (or explicitly compare Q to K) as the reason for the shift, and state that temperature is assumed constant so K stays at 4.0.',
  accepted_variants = '["Le Chatelier''s principle", "Q < K so reaction proceeds forward", "constant temperature assumption"]'::jsonb
where content_item_version_id = '7e040a80-1158-4c59-a800-a0941c111950' and criterion_key = 'part-b';

-- apphy1-frq-001 — kinematics (a=1.50 m/s^2, t=4.00 s, from rest)
update app.frq_criteria set
  evidence_requirements = 'Response reports v = 6.00 m/s and Delta-x = 12.0 m, computed via constant-acceleration kinematics.',
  minimum_fix = 'To earn this point, report v = 6.00 m/s and Delta-x = 12.0 m, computed using the constant-acceleration kinematics equations with a = 1.50 m/s^2 and t = 4.00 s.',
  accepted_variants = '["v=6.00 m/s", "6 m/s", "Δx=12.0 m", "12 m"]'::jsonb
where content_item_version_id = '16ca97bd-8222-4dd2-81dc-40a8568abdfd' and criterion_key = 'part-a';

update app.frq_criteria set
  evidence_requirements = 'Response names the specific kinematics equation(s) used (v = v0 + at and/or Delta-x = v0t + (1/2)at^2), and explicitly states that friction/air resistance is negligible so acceleration stays constant at 1.50 m/s^2.',
  minimum_fix = 'To earn this point, name the specific kinematics equation(s) used (v = v0 + at and Delta-x = v0t + (1/2)at^2) and state that friction/air resistance is assumed negligible so the acceleration stays constant at 1.50 m/s^2.',
  accepted_variants = '["v = v0 + at", "Δx = v0t + ½at²", "negligible friction", "frictionless"]'::jsonb
where content_item_version_id = '16ca97bd-8222-4dd2-81dc-40a8568abdfd' and criterion_key = 'part-b';

-- apphy2-frq-001 — thermodynamics, constant-volume heating (1 mol monatomic ideal gas, 300K->360K)
update app.frq_criteria set
  evidence_requirements = 'Response states W=0 (constant volume), computes Delta-U=(3/2)nR(Delta-T) for Delta-T=60 K giving approximately 748 J, and reports Q approximately 748 J.',
  minimum_fix = 'To earn this point, state that W=0 (constant volume), compute Delta-U = (3/2)nR(Delta-T) with Delta-T = 60 K to get approximately 748 J, and report Q approximately 748 J.',
  accepted_variants = '["748 J", "≈748 J", "W=0", "ΔU=(3/2)nRΔT"]'::jsonb
where content_item_version_id = 'f2e357a2-b035-494e-a190-666b5af41639' and criterion_key = 'part-a';

update app.frq_criteria set
  evidence_requirements = 'Response cites the first law (Delta-U = Q - W), states W=0 because volume is constant, and concludes that all added heat becomes a change in internal energy (Q = Delta-U).',
  minimum_fix = 'To earn this point, cite the first law of thermodynamics (Delta-U = Q - W), state that W = 0 because volume is constant, and conclude that all the heat added equals the change in internal energy (Q = Delta-U).',
  accepted_variants = '["first law of thermodynamics", "ΔU = Q − W", "Q = ΔU at constant volume"]'::jsonb
where content_item_version_id = 'f2e357a2-b035-494e-a190-666b5af41639' and criterion_key = 'part-b';

-- apphycem-frq-001 — Gauss's law, nonuniform sphere (rho(r)=rho0*r/R)
update app.frq_criteria set
  evidence_requirements = 'Response sets up Qenc = integral from 0 to r of rho0(r''/R)*4*pi*r''^2 dr'', evaluates it, and reports E(r) = rho0*r^2/(4*epsilon0*R) inside the sphere.',
  minimum_fix = 'To earn this point, set up and evaluate Qenc as the integral of rho0(r''/R)*4*pi*r''^2 from 0 to r, and report E(r) = rho0*r^2/(4*epsilon0*R) for the interior field.',
  accepted_variants = '["ρ₀r²/(4ε₀R)", "Qenc=πρ₀r⁴/R", "E(r)=ρ₀r²/(4ε₀R)"]'::jsonb
where content_item_version_id = '1b50facb-6d0c-42cd-9ba9-639fd4a5f5bf' and criterion_key = 'part-a';

update app.frq_criteria set
  evidence_requirements = 'Response states that the spherical symmetry of the charge distribution makes E have constant magnitude and radial direction on any concentric Gaussian sphere, which allows E to be factored out of the flux integral as E*4*pi*r^2.',
  minimum_fix = 'To earn this point, state that the spherical symmetry of the charge distribution makes E have constant magnitude and radial direction on any concentric Gaussian sphere, which is what lets E be pulled out of the flux integral as E times 4*pi*r^2.',
  accepted_variants = '["spherical symmetry", "E is radial and constant magnitude on the Gaussian surface", "∮E·dA=E·4πr²"]'::jsonb
where content_item_version_id = '1b50facb-6d0c-42cd-9ba9-639fd4a5f5bf' and criterion_key = 'part-b';

-- apphycm-frq-001 — kinematics via calculus (v(t)=alpha*t^2, x(0)=0)
update app.frq_criteria set
  evidence_requirements = 'Response integrates v(t)=alpha*t^2 (using x(0)=0) to get x(t)=alpha*t^3/3, and differentiates v(t) to get a(t)=2*alpha*t.',
  minimum_fix = 'To earn this point, integrate v(t)=alpha*t^2 with x(0)=0 to report x(t)=alpha*t^3/3, and differentiate v(t) to report a(t)=2*alpha*t.',
  accepted_variants = '["x(t)=αt³/3", "a(t)=2αt", "dv/dt=2αt"]'::jsonb
where content_item_version_id = '696ff831-99ac-4bc1-bae6-0b85d6a79e43' and criterion_key = 'part-a';

update app.frq_criteria set
  evidence_requirements = 'Response states that x(t) is the integral of v(t) (using x(0)=0 to fix the constant of integration) and that a(t) is the derivative of v(t), justifying both derived expressions.',
  minimum_fix = 'To earn this point, state that x(t) is obtained by integrating v(t)=alpha*t^2 and using x(0)=0 to eliminate the constant of integration, and that a(t) is obtained by differentiating v(t).',
  accepted_variants = '["x(t)=∫v(t)dt", "a(t)=dv/dt", "constant of integration is zero from x(0)=0"]'::jsonb
where content_item_version_id = '696ff831-99ac-4bc1-bae6-0b85d6a79e43' and criterion_key = 'part-b';

-- Fail-closed sanity check: every targeted row must now be complete.
do $$
begin
  if exists (
    select 1 from app.frq_criteria
    where content_item_version_id in (
      'd8d7751b-fd46-4dc8-b468-13549dcc9a7e', '7e040a80-1158-4c59-a800-a0941c111950',
      '16ca97bd-8222-4dd2-81dc-40a8568abdfd', 'f2e357a2-b035-494e-a190-666b5af41639',
      '1b50facb-6d0c-42cd-9ba9-639fd4a5f5bf', '696ff831-99ac-4bc1-bae6-0b85d6a79e43'
    )
    and (
      nullif(btrim(evidence_requirements), '') is null
      or nullif(btrim(minimum_fix), '') is null
      or accepted_variants is null or jsonb_array_length(accepted_variants) = 0
    )
  ) then
    raise exception 'published_frq_repair:row_still_incomplete';
  end if;
end;
$$;

commit;
