begin;

-- Add AP Physics 2 Unit 13 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 4 AP Physics 2 Unit 13 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_2_CED_FACT_PACK.md Unit 13 (Geometric
-- Optics). The fact pack confirms rays and wavefronts, the law of reflection,
-- diffuse/specular reflection, plane/concave/convex spherical mirror scope,
-- mirror equation and magnification, refraction from speed change at media
-- boundaries, n=c/v, Snell's law, total internal reflection and critical
-- angle, thin convex/concave lens scope, thin-lens equation, magnification,
-- and ray-diagram image classifications. It also notes no released FRQ-level
-- Unit 13 misconception evidence in the checked 2025/2026 sources.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_2', 13, '13.1', 'Reflection',
    'very-important', 'very-important',
    'Reflection redirects a light ray at a surface. The law of reflection says angle of incidence equals angle of reflection, with both angles measured from the surface normal.',
    'Reflection is the foundation for mirror diagrams and geometric optics. Correct normals and angle measurements determine ray paths before image equations are useful.',
    'You earn points by drawing the normal, measuring both angles from that normal, distinguishing specular from diffuse reflection, and tracing ray paths consistently.',
    'Draw the normal first; then make theta_i and theta_r equal on opposite sides of the normal, not the surface.',
    'Measuring reflection angles from the mirror surface instead of from the normal.',
    '/learn/ap-physics-2/unit-13/reflection'
  ),
  (
    'ap_physics_2', 13, '13.2', 'Images Formed by Mirrors',
    'very-important', 'very-important',
    'Mirrors form images by reflected rays. Real images form where rays actually meet; virtual images form where reflected rays appear to diverge from.',
    'Mirror questions combine ray diagrams, sign conventions, and magnification. Plane, concave spherical, and convex spherical mirrors are the AP Physics 2 mirror scope.',
    'You earn points by choosing principal rays, applying 1/si + 1/so = 1/f when needed, and classifying image type, orientation, size, and location.',
    'Use a ray diagram to predict image type first, then use the mirror equation and magnification to calculate distances or size ratios.',
    'Calling a virtual image real because your eye can see it behind the mirror.',
    '/learn/ap-physics-2/unit-13/images-formed-by-mirrors'
  ),
  (
    'ap_physics_2', 13, '13.3', 'Refraction',
    'very-important', 'very-important',
    'Refraction is a ray direction change when light crosses into a medium where its speed changes. Index of refraction is n = c/v, and Snell''s law relates the angles.',
    'Refraction explains bending at boundaries, critical angles, and total internal reflection. The direction depends on relative refractive index, not simply on which side the ray enters.',
    'You earn points by measuring angles from the normal, applying n1 sin(theta1) = n2 sin(theta2), and identifying when total internal reflection is possible.',
    'Compare indices first: into higher n bends toward the normal; into lower n bends away, and total internal reflection can occur only from higher n to lower n.',
    'Saying a ray always bends toward the normal whenever it enters a new medium.',
    '/learn/ap-physics-2/unit-13/refraction'
  ),
  (
    'ap_physics_2', 13, '13.4', 'Images Formed by Lenses',
    'very-important', 'very-important',
    'Thin lenses form images by refracting rays. Convex lenses converge parallel rays; concave lenses diverge rays as if from a focal point.',
    'Lens questions look like mirror questions but use transmitted rays. Ray diagrams, sign conventions, the thin-lens equation, and magnification all work together.',
    'You earn points by choosing the correct lens type, tracing principal rays, applying 1/si + 1/so = 1/f, and classifying real/virtual, upright/inverted, and size.',
    'Trace principal rays before calculating: parallel-through-focus, through center, and through or toward the focal point depending on lens type.',
    'Using mirror reflection rays for a lens problem instead of tracing refracted rays through the lens.',
    '/learn/ap-physics-2/unit-13/images-formed-by-lenses'
  )
),
explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  (
    'ap_physics_2', 13, '13.1', 'Reflection',
    'Reflection geometry is built around the normal line, not the surface. A ray strikes the surface, the normal is drawn perpendicular to the surface at that point, and theta_i equals theta_r when both angles are measured from the normal.',
    'Students need to distinguish ray models from wave behavior. Rays work for geometric optics when interference and diffraction can be ignored. Smooth surfaces produce specular reflection because the local normal is nearly constant; rough surfaces produce diffuse reflection because the local normal changes across the surface.',
    'Points come from drawing the normal, labeling incident and reflected rays, measuring angles from the normal, and explaining whether the reflected light is specular or diffuse based on surface roughness.',
    'Draw the normal first; then make theta_i and theta_r equal on opposite sides of the normal, not the surface.',
    'A ray hits a flat mirror at an angle of 30 degrees measured from the normal. What is the angle of reflection?',
    'The reflected ray is 60 degrees from the normal because 30 degrees was measured from the surface.',
    'The angle of reflection is 30 degrees from the normal. The law of reflection uses angles measured relative to the normal line, so theta_i = theta_r = 30 degrees. If the problem gives an angle from the surface, convert it before applying the law.',
    'Measuring reflection angles from the mirror surface instead of from the normal.',
    'Back in practice, draw a little right-angle mark between the normal and the surface. That makes the angle reference visible before you calculate.'
  ),
  (
    'ap_physics_2', 13, '13.2', 'Images Formed by Mirrors',
    'Mirror images are determined by where reflected rays meet or appear to meet. Real images come from actual ray intersections; virtual images come from extensions of rays that appear to diverge from behind the mirror.',
    'Students need to connect ray diagrams with equations. Plane mirrors place the image the same distance behind the mirror as the object is in front. Concave and convex spherical mirrors use focal-point behavior, the mirror equation, and magnification to determine image position, size, and orientation.',
    'Points are earned by tracing principal rays, using the correct focal point for the mirror type, applying 1/si + 1/so = 1/f when quantitative information is needed, and interpreting magnification as an image/object size ratio.',
    'Use a ray diagram to predict image type first, then use the mirror equation and magnification to calculate distances or size ratios.',
    'A student sees their face in a plane mirror and says the image is real because it is visible. What should be corrected?',
    'Visible images are real images, so the plane mirror image is real.',
    'A plane mirror image is virtual. The reflected rays reaching the eye appear to come from behind the mirror, but the rays do not actually intersect behind the mirror. Visibility does not decide real versus virtual; actual ray intersection does.',
    'Calling a virtual image real because your eye can see it behind the mirror.',
    'In practice, ask whether the rays actually meet at the image location. If only backward extensions meet, call it virtual.'
  ),
  (
    'ap_physics_2', 13, '13.3', 'Refraction',
    'Refraction happens because light speed changes across a boundary. A larger index means lower light speed in that medium, and Snell''s law connects the two angles measured from the normal on either side.',
    'Students need to reason from relative index. Moving into a higher-index medium bends the ray toward the normal; moving into a lower-index medium bends it away. Total internal reflection can happen only when light tries to pass from higher index to lower index and the incident angle exceeds the critical angle.',
    'Points come from using n = c/v, setting up n1 sin(theta1) = n2 sin(theta2), measuring both angles from the normal, and checking the high-to-low condition before using a critical angle.',
    'Compare indices first: into higher n bends toward the normal; into lower n bends away, and total internal reflection can occur only from higher n to lower n.',
    'A ray travels from glass into air at an angle larger than the critical angle. What happens at the boundary?',
    'The ray bends into the air but makes a larger angle with the normal.',
    'Because the ray is traveling from higher index glass to lower index air and the incident angle is greater than the critical angle, total internal reflection occurs. No refracted ray transmits into the air; the light reflects back into the glass.',
    'Saying a ray always bends toward the normal whenever it enters a new medium.',
    'Back in practice, write high-to-low beside any critical-angle question. Without that condition, total internal reflection is not available.'
  ),
  (
    'ap_physics_2', 13, '13.4', 'Images Formed by Lenses',
    'Lens images are made by refraction through the lens. A convex lens makes initially parallel rays converge toward a focal point on the transmitted side; a concave lens makes them diverge as if from a focal point on the incident side.',
    'Students need to keep mirror and lens ray rules separate. Lenses transmit and refract rays rather than reflecting them. The thin-lens equation has the same form as the mirror equation, but the ray diagram determines whether the image is real or virtual, upright or inverted, and enlarged or reduced.',
    'Points are earned by selecting the correct principal rays, using 1/si + 1/so = 1/f with the appropriate sign convention, and interpreting magnification as |hi/ho| = |si/so| for size comparison.',
    'Trace principal rays before calculating: parallel-through-focus, through center, and through or toward the focal point depending on lens type.',
    'A convex lens forms an image where refracted rays actually meet on the far side of the lens. Is the image real or virtual?',
    'It is virtual because lenses bend rays and the image is not on the object side.',
    'The image is real because the refracted rays actually intersect at the image location. For lenses, a real image can form on the transmitted side when the rays physically meet. Real versus virtual depends on actual intersection, not on whether the optic is a mirror or a lens.',
    'Using mirror reflection rays for a lens problem instead of tracing refracted rays through the lens.',
    'In practice, trace rays with arrows through the lens. If the outgoing rays meet, mark the image real; if only backward extensions meet, mark it virtual.'
  )
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, practice_subject_key,
  practice_unit_number, practice_topic_code, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, subject_key,
  unit_number, topic_code, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 13 Geometric Optics; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 13: ray model and wavefronts, law of reflection, diffuse/specular reflection, plane/concave/convex spherical mirror scope, mirror equation and magnification, refraction from speed changes, n=c/v, Snell law, total internal reflection and critical angle, thin convex/concave lens scope, thin-lens equation, magnification, ray-diagram image classification, and explicit note that no released FRQ-level Unit 13 misconception evidence was available in checked 2025/2026 sources; batch 2026-08-25-ap-physics-2-unit13-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_point_briefs.published_at, excluded.published_at);

with explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  (
    'ap_physics_2', 13, '13.1', 'Reflection',
    'Reflection geometry is built around the normal line, not the surface. A ray strikes the surface, the normal is drawn perpendicular to the surface at that point, and theta_i equals theta_r when both angles are measured from the normal.',
    'Students need to distinguish ray models from wave behavior. Rays work for geometric optics when interference and diffraction can be ignored. Smooth surfaces produce specular reflection because the local normal is nearly constant; rough surfaces produce diffuse reflection because the local normal changes across the surface.',
    'Points come from drawing the normal, labeling incident and reflected rays, measuring angles from the normal, and explaining whether the reflected light is specular or diffuse based on surface roughness.',
    'Draw the normal first; then make theta_i and theta_r equal on opposite sides of the normal, not the surface.',
    'A ray hits a flat mirror at an angle of 30 degrees measured from the normal. What is the angle of reflection?',
    'The reflected ray is 60 degrees from the normal because 30 degrees was measured from the surface.',
    'The angle of reflection is 30 degrees from the normal. The law of reflection uses angles measured relative to the normal line, so theta_i = theta_r = 30 degrees. If the problem gives an angle from the surface, convert it before applying the law.',
    'Measuring reflection angles from the mirror surface instead of from the normal.',
    'Back in practice, draw a little right-angle mark between the normal and the surface. That makes the angle reference visible before you calculate.'
  ),
  (
    'ap_physics_2', 13, '13.2', 'Images Formed by Mirrors',
    'Mirror images are determined by where reflected rays meet or appear to meet. Real images come from actual ray intersections; virtual images come from extensions of rays that appear to diverge from behind the mirror.',
    'Students need to connect ray diagrams with equations. Plane mirrors place the image the same distance behind the mirror as the object is in front. Concave and convex spherical mirrors use focal-point behavior, the mirror equation, and magnification to determine image position, size, and orientation.',
    'Points are earned by tracing principal rays, using the correct focal point for the mirror type, applying 1/si + 1/so = 1/f when quantitative information is needed, and interpreting magnification as an image/object size ratio.',
    'Use a ray diagram to predict image type first, then use the mirror equation and magnification to calculate distances or size ratios.',
    'A student sees their face in a plane mirror and says the image is real because it is visible. What should be corrected?',
    'Visible images are real images, so the plane mirror image is real.',
    'A plane mirror image is virtual. The reflected rays reaching the eye appear to come from behind the mirror, but the rays do not actually intersect behind the mirror. Visibility does not decide real versus virtual; actual ray intersection does.',
    'Calling a virtual image real because your eye can see it behind the mirror.',
    'In practice, ask whether the rays actually meet at the image location. If only backward extensions meet, call it virtual.'
  ),
  (
    'ap_physics_2', 13, '13.3', 'Refraction',
    'Refraction happens because light speed changes across a boundary. A larger index means lower light speed in that medium, and Snell''s law connects the two angles measured from the normal on either side.',
    'Students need to reason from relative index. Moving into a higher-index medium bends the ray toward the normal; moving into a lower-index medium bends it away. Total internal reflection can happen only when light tries to pass from higher index to lower index and the incident angle exceeds the critical angle.',
    'Points come from using n = c/v, setting up n1 sin(theta1) = n2 sin(theta2), measuring both angles from the normal, and checking the high-to-low condition before using a critical angle.',
    'Compare indices first: into higher n bends toward the normal; into lower n bends away, and total internal reflection can occur only from higher n to lower n.',
    'A ray travels from glass into air at an angle larger than the critical angle. What happens at the boundary?',
    'The ray bends into the air but makes a larger angle with the normal.',
    'Because the ray is traveling from higher index glass to lower index air and the incident angle is greater than the critical angle, total internal reflection occurs. No refracted ray transmits into the air; the light reflects back into the glass.',
    'Saying a ray always bends toward the normal whenever it enters a new medium.',
    'Back in practice, write high-to-low beside any critical-angle question. Without that condition, total internal reflection is not available.'
  ),
  (
    'ap_physics_2', 13, '13.4', 'Images Formed by Lenses',
    'Lens images are made by refraction through the lens. A convex lens makes initially parallel rays converge toward a focal point on the transmitted side; a concave lens makes them diverge as if from a focal point on the incident side.',
    'Students need to keep mirror and lens ray rules separate. Lenses transmit and refract rays rather than reflecting them. The thin-lens equation has the same form as the mirror equation, but the ray diagram determines whether the image is real or virtual, upright or inverted, and enlarged or reduced.',
    'Points are earned by selecting the correct principal rays, using 1/si + 1/so = 1/f with the appropriate sign convention, and interpreting magnification as |hi/ho| = |si/so| for size comparison.',
    'Trace principal rays before calculating: parallel-through-focus, through center, and through or toward the focal point depending on lens type.',
    'A convex lens forms an image where refracted rays actually meet on the far side of the lens. Is the image real or virtual?',
    'It is virtual because lenses bend rays and the image is not on the object side.',
    'The image is real because the refracted rays actually intersect at the image location. For lenses, a real image can form on the transmitted side when the rays physically meet. Real versus virtual depends on actual intersection, not on whether the optic is a mirror or a lens.',
    'Using mirror reflection rays for a lens problem instead of tracing refracted rays through the lens.',
    'In practice, trace rays with arrows through the lens. If the outgoing rays meet, mark the image real; if only backward extensions meet, mark it virtual.'
  )
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 13 Geometric Optics; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 13: ray model and wavefronts, law of reflection, diffuse/specular reflection, plane/concave/convex spherical mirror scope, mirror equation and magnification, refraction from speed changes, n=c/v, Snell law, total internal reflection and critical angle, thin convex/concave lens scope, thin-lens equation, magnification, ray-diagram image classification, and explicit note that no released FRQ-level Unit 13 misconception evidence was available in checked 2025/2026 sources; batch 2026-08-25-ap-physics-2-unit13-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  core_idea = excluded.core_idea,
  what_students_need_to_understand = excluded.what_students_need_to_understand,
  how_this_becomes_points = excluded.how_this_becomes_points,
  answer_move = excluded.answer_move,
  mini_example_question = excluded.mini_example_question,
  weak_answer = excluded.weak_answer,
  point_attaining_answer = excluded.point_attaining_answer,
  common_point_loss = excluded.common_point_loss,
  practice_bridge = excluded.practice_bridge,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_explainers.published_at, excluded.published_at);

do $$
declare
  v_briefs integer;
  v_explainers integer;
  v_pairing_orphans integer;
  v_unit_mismatches integer;
  v_route_mismatches integer;
  v_core_matches integer;
  v_duplicate_explainer_fields integer;
begin
  select count(*) into v_briefs
  from app.topic_point_briefs
  where subject_key = 'ap_physics_2'
    and unit_number = 13
    and topic_code in ('13.1', '13.2', '13.3', '13.4')
    and status = 'published';

  if v_briefs <> 4 then
    raise exception 'expected 4 published AP Physics 2 Unit 13 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_2'
    and unit_number = 13
    and topic_code in ('13.1', '13.2', '13.3', '13.4')
    and status = 'published';

  if v_explainers <> 4 then
    raise exception 'expected 4 published AP Physics 2 Unit 13 explainers, got %', v_explainers;
  end if;

  select count(*) into v_pairing_orphans
  from (
    select b.subject_key, b.topic_code
    from app.topic_point_briefs b
    left join app.topic_explainers e
      on e.subject_key = b.subject_key
     and e.topic_code = b.topic_code
     and e.status = 'published'
    where b.subject_key = 'ap_physics_2'
      and b.unit_number = 13
      and b.topic_code in ('13.1', '13.2', '13.3', '13.4')
      and b.status = 'published'
      and e.topic_code is null
    union all
    select e.subject_key, e.topic_code
    from app.topic_explainers e
    left join app.topic_point_briefs b
      on b.subject_key = e.subject_key
     and b.topic_code = e.topic_code
     and b.status = 'published'
    where e.subject_key = 'ap_physics_2'
      and e.unit_number = 13
      and e.topic_code in ('13.1', '13.2', '13.3', '13.4')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 13 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('13.1', '13.2', '13.3', '13.4')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 13 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_2'
    and b.unit_number = 13
    and b.topic_code in ('13.1', '13.2', '13.3', '13.4')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-2/unit-13/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 13 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('13.1', '13.2', '13.3', '13.4')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 13 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select
      topic_explainer_id,
      mini_example_question,
      weak_answer,
      point_attaining_answer,
      practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_physics_2'
      and unit_number = 13
      and topic_code in ('13.1', '13.2', '13.3', '13.4')
      and status = 'published'
  ),
  field_values as (
    select 'mini_example_question' as field_name, mini_example_question as value from new_explainers
    union all
    select 'weak_answer', weak_answer from new_explainers
    union all
    select 'point_attaining_answer', point_attaining_answer from new_explainers
    union all
    select 'practice_bridge', practice_bridge from new_explainers
  )
  select count(*) into v_duplicate_explainer_fields
  from field_values fv
  join app.topic_explainers e
    on (
      e.mini_example_question = fv.value
      or e.weak_answer = fv.value
      or e.point_attaining_answer = fv.value
      or e.practice_bridge = fv.value
    )
  where e.status = 'published'
    and not (
      e.subject_key = 'ap_physics_2'
      and e.unit_number = 13
      and e.topic_code in ('13.1', '13.2', '13.3', '13.4')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 13 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
