-- Seed the AP Statistics taxonomy topic map (55 topics across 5 units).
--
-- Source: AP Statistics Course and Exam Description, Effective Fall 2026,
-- "Course at a Glance", printed pp. 15-17
-- (docs/teaching/ap-statistics-course-and-exam-description.pdf).
-- Topic codes and titles are transcribed from the Course-at-a-Glance tables:
--   Unit 1  13 topics (1.1-1.13)
--   Unit 2  12 topics (2.1-2.12)
--   Unit 3  15 topics (3.1-3.15)
--   Unit 4  10 topics (4.1-4.10)
--   Unit 5   5 topics (5.1-5.5)
-- 55 total, matching docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md §3,
-- whose 55-row anchoring table was source-verified against the same CED on
-- 2026-08-02.
--
-- Why this was missing: app.taxonomy_units for AP Statistics was seeded on
-- 2026-08-04, but app.taxonomy_topics never was. AP Statistics, AP Chemistry
-- and all four AP Physics subjects were left with units but zero topics.
-- This migration closes the AP Statistics half; Chemistry and Physics remain
-- open (see TASK-0027).
--
-- Governance note: this is structural transcription (topic code + title) of
-- the published unit/topic map, not authored teaching content. Jill's SME
-- confirmation of the §3 skill anchoring remains DEFERRED per the fact pack;
-- it is not a gate on the structural map itself.

insert into app.taxonomy_topics (taxonomy_source_version, unit_number, unit_title, topic_code, topic_title)
select tsv.taxonomy_source_version, v.unit_number, tu.unit_title, v.topic_code, v.topic_title
from app.taxonomy_source_versions tsv
join app.taxonomy_units tu
  on tu.taxonomy_source_version = tsv.taxonomy_source_version
join (values
  (1,'1.1','Introducing Statistics: What Can We Learn from Data?'),
  (1,'1.2','Variables'),
  (1,'1.3','Tabular Representation and Summary Statistics for One Categorical Variable'),
  (1,'1.4','Graphical Representations for One Categorical Variable'),
  (1,'1.5','Graphical Representations for One Quantitative Variable'),
  (1,'1.6','Descriptions for One Quantitative Variable Distributions'),
  (1,'1.7','Summary Statistics for One Quantitative Variable'),
  (1,'1.8','Graphical Representations of Summary Statistics for One Quantitative Variable'),
  (1,'1.9','Comparisons of the Distributions for One Quantitative Variable'),
  (1,'1.10','The Investigative Question Revisited and Data Collection'),
  (1,'1.11','Random Sampling'),
  (1,'1.12','Potential Problems with Sampling'),
  (1,'1.13','Experimental Design'),
  (2,'2.1','Tabular and Graphical Representations for the Distributions of Two Categorical Variables'),
  (2,'2.2','Summary Statistics for Two Categorical Variables'),
  (2,'2.3','Estimating Probabilities Using Simulation'),
  (2,'2.4','Introduction to Probability'),
  (2,'2.5','Mutually Exclusive Events'),
  (2,'2.6','Conditional Probability'),
  (2,'2.7','Independent Events and Unions of Events'),
  (2,'2.8','Introduction to Random Variables and Probability Distributions'),
  (2,'2.9','Parameters of Random Variables'),
  (2,'2.10','The Binomial Distribution'),
  (2,'2.11','The Normal Distribution'),
  (2,'2.12','Sampling Distributions and the Central Limit Theorem'),
  (3,'3.1','Estimators'),
  (3,'3.2','Sampling Distributions for Sample Proportions'),
  (3,'3.3','Constructing a Confidence Interval for a Population Proportion'),
  (3,'3.4','Justifying a Claim Based on a Confidence Interval for a Population Proportion'),
  (3,'3.5','Setting Up a Test for a Population Proportion'),
  (3,'3.6','p-Values'),
  (3,'3.7','Carrying Out a Test for a Population Proportion'),
  (3,'3.8','Potential Errors When Performing Tests'),
  (3,'3.9','Sampling Distributions for the Difference Between Sample Proportions'),
  (3,'3.10','Constructing a Confidence Interval for the Difference Between Two Population Proportions'),
  (3,'3.11','Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Proportions'),
  (3,'3.12','Setting Up a Test for the Difference Between Two Population Proportions'),
  (3,'3.13','Carrying Out a Test for the Difference Between Two Population Proportions'),
  (3,'3.14','Setting Up a Chi-Square Test for Homogeneity or Independence'),
  (3,'3.15','Carrying Out a Chi-Square Test for Homogeneity or Independence'),
  (4,'4.1','Sampling Distributions for Sample Means'),
  (4,'4.2','Constructing a Confidence Interval for a Population Mean or Population Mean Difference'),
  (4,'4.3','Justifying a Claim Based on a Confidence Interval for a Population Mean or Population Mean Difference'),
  (4,'4.4','Setting Up a Test for a Population Mean or Population Mean Difference'),
  (4,'4.5','Carrying Out a Test for a Population Mean or Population Mean Difference'),
  (4,'4.6','Sampling Distributions for the Difference Between Two Sample Means'),
  (4,'4.7','Constructing a Confidence Interval for the Difference Between Two Population Means'),
  (4,'4.8','Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Means'),
  (4,'4.9','Setting Up a Test for the Difference Between Two Population Means'),
  (4,'4.10','Carrying Out a Test for the Difference Between Two Population Means'),
  (5,'5.1','Graphical Representations Between Two Quantitative Variables'),
  (5,'5.2','Correlation'),
  (5,'5.3','Linear Regression Models'),
  (5,'5.4','Residuals'),
  (5,'5.5','Least-Squares Regression')
) as v(unit_number, topic_code, topic_title)
  on v.unit_number = tu.unit_number
where tsv.subject_key = 'ap_statistics'
  and tsv.taxonomy_confidence = 'verified'
on conflict (taxonomy_source_version, topic_code) do nothing;

do $$
declare n integer;
begin
  select count(*) into n
    from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv
      on tsv.taxonomy_source_version = tt.taxonomy_source_version
   where tsv.subject_key = 'ap_statistics';
  if n <> 55 then
    raise exception 'AP Statistics taxonomy topics: expected 55, found %', n;
  end if;
end $$;
