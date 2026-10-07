-- APPROVAL-0129 (David, 2026-10-07): fix the AP Statistics 2.12 topic point brief.
-- The brief told students they earn credit for "explaining that increasing sample size tightens the spread of the
-- statistic". The CED's required content for 2.12 (EK 2.12.A.1-A.4) covers the definition of a sampling distribution,
-- simulating one, the randomization distribution, and the CLT's statement about SHAPE only; the mean and standard
-- deviation of the sampling distribution of a sample mean are CED 4.1. Found by the TASK-0065 method test: the
-- overreach produced the same out-of-scope defect in all three arms.
update app.topic_point_briefs
set how_points_are_earned = 'You earn credit for identifying which distribution a graph or description shows -- population, a single sample, or the sampling distribution of a statistic -- for distinguishing a sampling distribution from a randomization distribution, and for stating that the Central Limit Theorem makes the sampling distribution of a sample mean approximately normal, with the approximation improving as sample size grows.',
    updated_at = now()
where subject_key = 'ap_statistics' and topic_code = '2.12';
