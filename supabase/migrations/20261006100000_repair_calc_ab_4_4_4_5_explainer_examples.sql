-- Repair AP Calculus AB topic explainers 4.4 and 4.5: each mini example used a point
-- that is not on its own curve. Product Owner approval: David, 2026-10-06
-- ("I approve the repair of calc ab 4.4 and 4.5"). Found during TASK-0065 authoring.
--
-- 4.4: x^2 + 3xy = 20 at (2, 4) gives 4 + 24 = 28. Keep the point; the constant becomes 28.
--      Check: 2x x' + 3x'y + 3x y' = 0 -> 8 + 24 + 6y' = 0 -> dy/dt = -16/3 (well defined).
-- 4.5: 2xy + ln(y) = 8 at (1, 4) gives 8 + ln 4. Keep the curve; the point becomes (4, 1).
--      Check: 2(4)(1) + ln 1 = 8. 2x y' + 2y x' + y'/y = 0 -> 8y' + 6 + y' = 0 -> dy/dt = -2/3.
-- Guarded on the old text, so re-running is a no-op. Provenance is recorded in APPROVAL-0123, not source_note.

update app.topic_explainers
set mini_example_question = replace(mini_example_question, 'x^2 + 3xy = 20', 'x^2 + 3xy = 28'),
    updated_at = now()
where subject_key = 'ap_calculus_ab' and topic_code = '4.4'
  and mini_example_question like '%x^2 + 3xy = 20%';

update app.topic_explainers
set mini_example_question = replace(mini_example_question, 'x = 1, y = 4, and dx/dt = 3', 'x = 4, y = 1, and dx/dt = 3'),
    point_attaining_answer = replace(point_attaining_answer, 'substituting x=1, y=4, dx/dt=3', 'substituting x=4, y=1, dx/dt=3'),
    updated_at = now()
where subject_key = 'ap_calculus_ab' and topic_code = '4.5'
  and mini_example_question like '%x = 1, y = 4, and dx/dt = 3%';
