begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-h-4.1-a','apcalcab-mcq-b4-sv-h-4.1-a-v1','apcalcab-mcq-b4-sv-h-4.1-a-v2','apcalcab-mcq-b4-sv-h-4.1-a-v3','apcalcab-mcq-b4-h-4.1-b','apcalcab-mcq-b4-sv-h-4.1-b-v1','apcalcab-mcq-b4-sv-h-4.1-b-v2','apcalcab-mcq-b4-sv-h-4.1-b-v3','apcalcab-mcq-b4-h-4.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b4-h-4.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.1-a', 'mcq', 'interpret a derivative value with units, separating marginal rate, average rate and percent change.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bakery''s total cost of producing n loaves of bread in one day is C(n) dollars. It is known that C(150) = 420 and C′(150) = 1.80. Which statement is the best interpretation of C′(150) = 1.80?', null, md5('apcalcab-mcq-b4-h-4.1-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average cost of each of the first 150 loaves is about 1.80 dollars.', false, 'The average cost per loaf is C(150)/150 = 420/150 = 2.80 dollars, which is a different quantity from the derivative C′(150).' from version_ins
union all select gen_random_uuid(), id, 'B', 'Each of the first 150 loaves costs 1.80 dollars, so the total cost is 270 dollars.', false, 'This treats the rate at n = 150 as a constant price for every loaf, and the resulting total of 270 contradicts the given value C(150) = 420.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Producing the 151st loaf adds about 1.80 dollars to the total cost.', true, 'Correct: C′(150) is the instantaneous rate of change of total cost, in dollars per loaf, so the next loaf costs about 1.80 dollars more. The average cost is 420/150 = 2.80 dollars per loaf and the relative rate is 1.80/420 ≈ 0.43%.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The total cost is increasing by 1.80 percent for each additional loaf.', false, 'C′ has units of dollars per loaf, not percent. The relative rate would be 1.80/420, about 0.43 percent per loaf.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.1-a-v1', 'mcq', 'interpret a derivative value with units, separating marginal rate, average rate and percent change. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The number of bacteria in a culture is B(t) thousand, where t is measured in hours. It is known that B(5) = 60 and B′(5) = −2.4. Which statement is the best interpretation of B′(5) = −2.4?', null, md5('apcalcab-mcq-b4-sv-h-4.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At t = 5 hours the culture contains 2.4 thousand bacteria.', false, 'The number of bacteria at t = 5 is B(5) = 60 thousand. The value B′(5) is a rate of change, not a population count.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At t = 5 hours the population is decreasing by 2.4 percent per hour.', false, 'B′ has units of thousands of bacteria per hour. As a percent of the current population the rate is 2.4/60 = 4 percent per hour, not 2.4 percent.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At t = 5 hours the population is decreasing at about 2.4 thousand bacteria per hour.', true, 'Correct: B′(5) = −2.4 thousand bacteria per hour is the instantaneous rate of change at t = 5. It is negative, so the population is falling; it equals 4% of B(5) = 60 only as a relative rate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The population was exactly 62.4 thousand at t = 4 hours.', false, 'B′(5) is an instantaneous rate and only approximates the change over the next or previous hour, so it does not give the exact value of B(4).' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.1-a-v2', 'mcq', 'interpret a derivative value with units, separating marginal rate, average rate and percent change. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A city''s total daily water use is W(h) gallons when the day''s high temperature is h degrees Fahrenheit. It is known that W(90) = 5000 and W′(90) = 120. Which statement is the best interpretation of W′(90) = 120?', null, md5('apcalcab-mcq-b4-sv-h-4.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The city uses 120 gallons of water for each degree of temperature from 0°F to 90°F, a total of 10,800 gallons.', false, 'This treats the rate at h = 90 as a constant rate over all temperatures, and the total of 10,800 gallons contradicts W(90) = 5000.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A change of 1 gallon in water use corresponds to a change of about 120 degrees in temperature.', false, 'The units are reversed. W′ is in gallons per degree, so it describes gallons of change in W per degree of change in h.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The city uses 120 gallons of water when the high temperature is 90°F.', false, 'The water use at 90°F is the function value W(90) = 5000 gallons. The derivative W′(90) is a rate, not an amount.' from version_ins
union all select gen_random_uuid(), id, 'D', 'When the high temperature is 90°F, each additional degree increases daily water use by about 120 gallons.', true, 'Correct: W′(90) = 120 gallons per degree is the instantaneous rate of change of water use with temperature at h = 90, so one more degree adds about 120 gallons. W(90) = 5000 is the amount itself.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.1-a-v3', 'mcq', 'interpret a derivative value with units, separating marginal rate, average rate and percent change. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The charge of a phone battery is B(t) percent after t hours of use. It is known that B(3) = 55 and B′(3) = −12. Which statement is the best interpretation of B′(3) = −12?', null, md5('apcalcab-mcq-b4-sv-h-4.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At t = 3 hours the battery charge is 12 percent.', false, 'The charge at t = 3 is B(3) = 55 percent. The derivative B′(3) is a rate of change in percentage points per hour.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At t = 3 hours the battery loses 12 percent of its remaining charge each hour.', false, 'B′ is in percentage points per hour. Twelve percent of the remaining 55 percent would be only 6.6 points, so this misreads the units.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The battery has lost exactly 12 percentage points every hour since t = 0.', false, 'B′(3) is the rate at one instant. It does not show that the rate was constant on [0, 3], so the earlier rates may have been different.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At t = 3 hours the battery charge is falling at a rate of about 12 percentage points per hour.', true, 'Correct: B′(3) = −12 percentage points per hour is the instantaneous rate at t = 3, negative because the charge is falling. It is not the charge (55), a percent of the charge, or a constant rate.' from version_ins;
-- apcalcab-mcq-b4-h-4.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.1-b', 'mcq', 'estimate a derivative from a table with uneven spacing and state its units when the function is itself a rate.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water leaks from a tank at a rate of L(t) liters per hour, where t is measured in hours. Selected values of L are given in the table.
t (hours):   0   2   5   9
L(t) (liters per hour):   40   34   22   14
Using the data in the table, which is the best estimate of L′(4), with units?', null, md5('apcalcab-mcq-b4-h-4.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4 liters per hour per hour', true, 'Correct: t = 4 lies in [2, 5], so L′(4) ≈ (L(5) − L(2))/(5 − 2) = (22 − 34)/3 = −4. L is a rate in liters per hour, so L′ has units liters per hour per hour: the leak rate is dropping by about 4 liters per hour each hour.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2 liters per hour per hour', false, 'This uses the interval from t = 5 to t = 9, (14 − 22)/4 = −2, which does not contain t = 4. The estimate needs the interval that straddles 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '−12 liters per hour per hour', false, 'The change in L over [2, 5] is −12, but it must be divided by the interval length 3 to get a rate of change.' from version_ins
union all select gen_random_uuid(), id, 'D', '−4 liters per hour', false, 'The number is right but the units are not. L is already in liters per hour, so its derivative is in liters per hour per hour.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.1-b-v1', 'mcq', 'estimate a derivative from a table with uneven spacing and state its units when the function is itself a rate. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The rate at which cars pass a toll booth is R(t) cars per minute, where t is the number of minutes after 7:00 am. Selected values of R are given in the table.
t (minutes):   0   10   25   30
R(t) (cars per minute):   18   24   39   33
Using the data in the table, which is the best estimate of R′(20), with units?', null, md5('apcalcab-mcq-b4-sv-h-4.1-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1.2 cars per minute per minute', false, 'This uses the interval from t = 25 to t = 30, (33 − 39)/5 = −1.2, which does not contain t = 20.' from version_ins
union all select gen_random_uuid(), id, 'B', '1 car per minute per minute', true, 'Correct: t = 20 lies in [10, 25], so R′(20) ≈ (R(25) − R(10))/(25 − 10) = (39 − 24)/15 = 1. R is a rate in cars per minute, so R′ is in cars per minute per minute.' from version_ins
union all select gen_random_uuid(), id, 'C', '15 cars per minute per minute', false, 'The change in R over [10, 25] is 15, but it must be divided by the interval length 15 to get a rate of change.' from version_ins
union all select gen_random_uuid(), id, 'D', '1 car per minute', false, 'The number is right but the units are not. R is already in cars per minute, so its derivative is in cars per minute per minute.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.1-b-v2', 'mcq', 'estimate a derivative from a table with uneven spacing and state its units when the function is itself a rate. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The amount of medicine in a patient''s bloodstream is M(t) milligrams, where t is the number of hours after an injection. Selected values of M are given in the table.
t (hours):   0   1   3   7
M(t) (milligrams):   0   50   38   22
Using the data in the table, which is the best estimate of M′(2), with units?', null, md5('apcalcab-mcq-b4-sv-h-4.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12 milligrams per hour', false, 'The change in M over [1, 3] is −12, but it must be divided by the interval length 2 to get a rate of change.' from version_ins
union all select gen_random_uuid(), id, 'B', '−6 milligrams per hour', true, 'Correct: t = 2 lies in [1, 3], so M′(2) ≈ (M(3) − M(1))/(3 − 1) = (38 − 50)/2 = −6 milligrams per hour, so the amount of medicine is falling.' from version_ins
union all select gen_random_uuid(), id, 'C', '−4 milligrams per hour', false, 'This uses the interval from t = 3 to t = 7, (22 − 38)/4 = −4, which does not contain t = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'about 3.1 milligrams per hour', false, 'This is the average rate over the whole table, (22 − 0)/7. It is a positive average over [0, 7] and ignores that M is falling near t = 2.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.1-b-v3', 'mcq', 'estimate a derivative from a table with uneven spacing and state its units when the function is itself a rate. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The height of a sunflower is H(d) centimeters, where d is the number of days after planting. Selected values of H are given in the table.
d (days):   0   4   10   14
H(d) (centimeters):   2   8   17   19
Using the data in the table, which is the best estimate of H′(7), with units?', null, md5('apcalcab-mcq-b4-sv-h-4.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.5 centimeters per day', false, 'This uses the interval from d = 10 to d = 14, (19 − 17)/4 = 0.5, which does not contain d = 7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'about 1.2 centimeters per day', false, 'This is the average rate over the whole table, (19 − 2)/14. It does not use the interval that straddles d = 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.5 centimeters per day', true, 'Correct: d = 7 lies in [4, 10], so H′(7) ≈ (H(10) − H(4))/(10 − 4) = (17 − 8)/6 = 1.5 centimeters per day.' from version_ins
union all select gen_random_uuid(), id, 'D', '9 centimeters per day', false, 'The change in H over [4, 10] is 9, but it must be divided by the interval length 6 to get a rate of change.' from version_ins;
-- apcalcab-mcq-b4-h-4.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.2-a', 'mcq', 'decide direction and speeding up or slowing down from the signs of v and a.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with velocity v(t) = t² − 5t + 4 for t ≥ 0. Which statement describes the particle''s motion at t = 3?', null, md5('apcalcab-mcq-b4-h-4.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The particle is moving left and slowing down.', true, 'Correct: v(3) = 9 − 15 + 4 = −2 (moving left). a(t) = 2t − 5, so a(3) = 1. Velocity and acceleration have opposite signs, so the speed |v| is decreasing: slowing down.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The particle is moving right and speeding up.', false, 'V(3) = −2 is negative, so the particle moves left. This answer reads the positive acceleration a(3) = 1 as the direction of motion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The particle is moving left and speeding up.', false, 'Speeding up needs v and a to have the same sign. Here v(3) = −2 and a(3) = 1 have opposite signs, so the particle is slowing down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The particle is moving right and slowing down.', false, 'This takes the direction from the sign of the acceleration. The direction comes from v(3) = −2, which is negative, so the motion is leftward.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-h-4.1-a','apcalcab-mcq-b4-sv-h-4.1-a-v1','apcalcab-mcq-b4-sv-h-4.1-a-v2','apcalcab-mcq-b4-sv-h-4.1-a-v3','apcalcab-mcq-b4-h-4.1-b','apcalcab-mcq-b4-sv-h-4.1-b-v1','apcalcab-mcq-b4-sv-h-4.1-b-v2','apcalcab-mcq-b4-sv-h-4.1-b-v3','apcalcab-mcq-b4-h-4.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b4-h-4.1-a','apcalcab-mcq-b4-sv-h-4.1-a-v1','apcalcab-mcq-b4-sv-h-4.1-a-v2','apcalcab-mcq-b4-sv-h-4.1-a-v3','apcalcab-mcq-b4-h-4.1-b','apcalcab-mcq-b4-sv-h-4.1-b-v1','apcalcab-mcq-b4-sv-h-4.1-b-v2','apcalcab-mcq-b4-sv-h-4.1-b-v3','apcalcab-mcq-b4-h-4.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
