begin;

-- Re-author AP Statistics Unit 1 topic guides under the 2026-08-27
-- Course Mode score-impact protocol. This migration is intentionally scoped
-- to ap_statistics / unit_number = 1 only. Do not extend this pattern to
-- Units 2 or 3 until the Unit 1 pilot is reviewed.
--
-- Rights policy: Cramapple-authored original content only. No College Board
-- copyrighted questions, rubrics, scoring-language passages, or answer keys
-- were used to author this rewrite.

with brief_updates (
  topic_code, title, class_importance, exam_importance, what_it_is,
  why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path
) as (
  values
  ('1.1','Introducing Statistics: What Can We Learn from Data?','somewhat-important','not-important',
   'Score-impact skill: keep the real question attached to the data. Statistics starts with variability in a real situation, then uses data to answer a question about that situation.',
   'The reason this skill matters here is that later calculations only earn their full value when the student connects the number back to the investigative question.',
   'A strong answer does not stop at a number. It labels what the number measures, connects it to the original question, and states what the data suggest in context.',
   'Open hand: ask, "What question is this dataset trying to answer?" before calculating. Then make every final sentence return to that question.',
   'Treating the task as number-crunching and leaving the result disconnected from the real-world question.',
   '/learn/ap-statistics/unit-1/investigative-question'),
  ('1.2','Variables','very-important','somewhat-important',
   'Score-impact skill: classify a variable by what its values mean, not by how they look. A variable is categorical when its values are labels or groups, and quantitative when arithmetic on the values is meaningful.',
   'The reason this skill matters here is that variable type controls which graphs, summaries, and later procedures are valid. A wrong classification can make the rest of the answer use the wrong tool.',
   'A point-protecting answer identifies what the value represents, decides categorical or quantitative, and explains the decision with a meaning test such as whether averaging or subtracting values would make sense.',
   'Open hand: ask, "Would arithmetic on this value produce a meaningful measurement?" If not, treat it as categorical even when it is written with digits.',
   'Calling a numeric label, such as an ID number or ZIP code, quantitative just because it is written with digits.',
   '/learn/ap-statistics/unit-1/variables-vocabulary'),
  ('1.3','Tabular Representation and Summary Statistics for One Categorical Variable','somewhat-important','somewhat-important',
   'Score-impact skill: read a categorical table by separating counts from proportions. A frequency is a count; a relative frequency is that count divided by the correct total.',
   'The reason this skill matters here is that the denominator tells what group a percentage describes. The same count can mean different things depending on whether it is divided by the whole table or by a smaller group.',
   'A strong answer labels the value as a count, proportion, or percent; shows the correct denominator; and writes what the result means for the category in context.',
   'Open hand: ask, "What total is this question asking me to divide by?" before computing any relative frequency.',
   'Dividing by the number of categories, or by the wrong total, instead of by the total number of observational units requested.',
   '/learn/ap-statistics/unit-1/categorical-tables'),
  ('1.4','Graphical Representations for One Categorical Variable','somewhat-important','somewhat-important',
   'Score-impact skill: match the graph to the variable type and read the scale before comparing. Bar charts show categories with separated bars; the vertical axis may show counts or relative frequencies.',
   'The reason this skill matters here is that visual comparisons earn points only when the graph type and axis scale support the comparison being made.',
   'A strong answer identifies the categories, checks whether the axis is counts or percentages, and compares bar heights only when the graphs use compatible scales.',
   'Open hand: ask, "Am I comparing categories, and are these bars using the same scale?" before making a visual claim.',
   'Comparing bar heights across graphs with different vertical scales, or treating a categorical bar chart like a quantitative histogram.',
   '/learn/ap-statistics/unit-1/categorical-bar-charts'),
  ('1.5','Graphical Representations for One Quantitative Variable','very-important','very-important',
   'Score-impact skill: choose the graph that preserves the feature the question asks about. Dotplots and stem plots keep individual values visible; histograms group values into intervals.',
   'The reason this skill matters here is that the same quantitative data can reveal different features depending on the display. A graph that hides individual values can hide small gaps or clusters.',
   'A point-max answer names the graph type, names the feature being inspected, and explains why that display does or does not preserve the needed information.',
   'Open hand: ask, "What feature am I supposed to see, and does this graph keep the needed detail visible?"',
   'Assuming every graph of the same quantitative data shows the same information, even when grouping into bins hides detail.',
   '/learn/ap-statistics/unit-1/quantitative-graphs'),
  ('1.6','Descriptions for One Quantitative Variable Distributions','very-important','very-important',
   'Score-impact skill: describe only the features the graph actually supports. Shape, center, spread, and unusual features must be read from the display given.',
   'The reason this skill matters here is that distribution descriptions become evidence for later choices about summaries and comparisons.',
   'A strong answer labels the variable and group, states the visible feature, and explains it using evidence from the graph rather than unsupported shape words.',
   'Open hand: ask, "What features can this graph type actually show me?" Then describe only those features with context.',
   'Using unsupported shape claims from a display that does not show enough detail, or naming shape without evidence from the graph.',
   '/learn/ap-statistics/unit-1/distribution-shape'),
  ('1.7','Summary Statistics for One Quantitative Variable','very-important','very-important',
   'Score-impact skill: choose and interpret summary statistics based on what they measure and whether they resist outliers. Mean and standard deviation are sensitive; median and IQR are resistant.',
   'The reason this skill matters here is that a correct calculation is not enough if the answer does not label the statistic and explain what it means for the data.',
   'A strong answer names the statistic, shows or states the relevant value, labels the variable and units, and explains why that statistic fits the distribution or question.',
   'Open hand: ask, "Am I describing center, spread, position, or outliers, and which statistic does that job?"',
   'Reporting a summary number without labeling what it summarizes, or using a nonresistant statistic when the question calls attention to outliers or skew.',
   '/learn/ap-statistics/unit-1/summary-statistics'),
  ('1.8','Graphical Representations of Summary Statistics for One Quantitative Variable','very-important','very-important',
   'Score-impact skill: read and build a boxplot as a five-number-summary display, with outliers handled separately when present.',
   'The reason this skill matters here is that boxplots are a compact way to compare distributions, but they only work when the quartiles, whiskers, and outliers are interpreted correctly.',
   'A strong answer identifies the five-number summary pieces, explains what the box and whiskers represent, and treats outliers as separate points rather than stretching the whisker to them.',
   'Open hand: ask, "Which part of the five-number summary or outlier rule is this question testing?"',
   'Extending a whisker to an outlier or reading a boxplot as if it shows every individual data value.',
   '/learn/ap-statistics/unit-1/boxplot-construction'),
  ('1.9','Comparisons of the Distributions for One Quantitative Variable','very-important','very-important',
   'Score-impact skill: compare distributions with matching features, not vague impressions. Strong comparisons address center, spread, and notable features in context.',
   'The reason this skill matters here is that comparison questions reward relative language: higher/lower center, greater/less spread, more/less variable, and unusual features tied to the groups.',
   'A point-max answer labels both groups, compares the same feature across groups, gives evidence from the display or summary, and states the comparison in context.',
   'Open hand: ask, "Which feature am I comparing, and have I named both groups and the variable?"',
   'Listing values for each group without directly comparing them, or comparing raw values across different distributions without using the proper relative measure.',
   '/learn/ap-statistics/unit-1/comparing-distributions'),
  ('1.10','The Investigative Question Revisited and Data Collection','very-important','somewhat-important',
   'Score-impact skill: classify a study by what the researcher did. An experiment imposes treatments; an observational study records existing conditions or outcomes.',
   'The reason this skill matters here is that study type controls what conclusion is allowed, especially whether a causal claim is justified.',
   'A strong answer states whether a treatment was imposed, names the study type, and connects that classification to the kind of conclusion the study can support.',
   'Open hand: ask, "Did the researcher impose a treatment, or only observe/record?" before naming the study.',
   'Calling a study an experiment merely because researchers collected data over time, without checking whether they assigned a treatment.',
   '/learn/ap-statistics/unit-1/observational-vs-experiment'),
  ('1.11','Random Sampling','very-important','very-important',
   'Score-impact skill: identify a sampling method by its selection mechanism. Randomness alone is not enough; SRS, stratified, cluster, and systematic samples are different moves.',
   'The reason this skill matters here is that the sampling method determines how well the sample can represent the population and what sampling error or bias concerns remain.',
   'A point-max answer names the population, describes exactly how units are selected, and matches that mechanism to the correct sampling-method name.',
   'Open hand: ask, "Who could be selected, and by what exact random mechanism?"',
   'Confusing stratified and cluster sampling, or using a vague phrase like random sample without describing the actual selection mechanism.',
   '/learn/ap-statistics/unit-1/sampling-methods'),
  ('1.12','Potential Problems with Sampling','somewhat-important','very-important',
   'Score-impact skill: diagnose the specific sampling problem, not just that the sample is bad. Common problems include undercoverage, nonresponse, voluntary response, and wording or response bias.',
   'The reason this skill matters here is that different sampling problems damage conclusions in different ways, so the fix depends on naming the flaw precisely.',
   'A strong answer identifies who is missing, who chose not to respond, who self-selected, or how wording influenced responses, then names the specific bias in context.',
   'Open hand: ask, "What exactly went wrong in how the data were collected?"',
   'Noticing bias but naming the wrong type, such as blaming sample size when the real issue is undercoverage or voluntary response.',
   '/learn/ap-statistics/unit-1/sampling-problems'),
  ('1.13','Experimental Design','very-important','very-important',
   'Score-impact skill: judge whether an experiment can support a cause-and-effect conclusion. Look for comparison, random assignment, replication, and control of outside variables.',
   'The reason this skill matters here is that experimental design is the Unit 1 bridge from describing data to making defensible causal claims.',
   'A point-max answer names the design element, explains what it does, and ties it to the conclusion the experiment can or cannot support.',
   'Open hand: ask, "What design feature protects the causal claim here?"',
   'Saying an experiment proves causation without checking random assignment, comparison, replication, and control.',
   '/learn/ap-statistics/unit-1/experimental-design')
),
updated_briefs as (
  update app.topic_point_briefs b
  set
    title = u.title,
    class_importance = u.class_importance,
    exam_importance = u.exam_importance,
    what_it_is = u.what_it_is,
    why_it_matters = u.why_it_matters,
    how_points_are_earned = u.how_points_are_earned,
    answer_move = u.answer_move,
    common_point_loss = u.common_point_loss,
    learn_more_path = u.learn_more_path,
    practice_subject_key = 'ap_statistics',
    practice_unit_number = 1,
    practice_topic_code = u.topic_code,
    source_note = 'cramapple-authored; AP Statistics Unit 1 score-impact protocol rewrite 2026-08-27; original examples and explanations only; no College Board copyrighted questions, rubrics, scoring-language passages, or answer keys used; pending SME review',
    status = 'published',
    published_at = coalesce(b.published_at, now())
  from brief_updates u
  where b.subject_key = 'ap_statistics'
    and b.unit_number = 1
    and b.topic_code = u.topic_code
  returning b.topic_code
),
explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('1.1',
   'The score-impact move is keeping the investigative question attached to the data from the first line to the final sentence.',
   'A calculation becomes useful only when the student can say what question the data help answer and what the result suggests in context.',
   'Students protect points by labeling the variable, naming the group or population, and writing a final sentence that answers the original question rather than leaving a bare number.',
   'Open hand: ask, "What question is this dataset trying to answer?" before calculating. Then make every final sentence return to that question.',
   'A class survey asks whether juniors sleep fewer hours on school nights than seniors. The summary shows juniors average 6.4 hours and seniors average 7.1 hours.',
   'The answer is 6.4 and 7.1.',
   'The juniors in this survey averaged 6.4 hours of sleep and the seniors averaged 7.1 hours, so the data suggest juniors slept less on school nights in this sample. The answer labels the groups, the variable, and the comparison.',
   'Treating the task as number-crunching and leaving the result disconnected from the real-world question.',
   'Before submitting, underline the sentence that answers the original question in context.'),
  ('1.2',
   'The score-impact move is classifying a variable by meaning: labels and groups are categorical; meaningful measurements or counts are quantitative.',
   'A number-looking value can still be categorical. The test is whether arithmetic on the values would produce a meaningful measurement.',
   'Students protect points by naming what the value represents, deciding categorical or quantitative, and explaining the decision with the meaning/arithmetic test.',
   'Open hand: ask, "Would arithmetic on this value produce a meaningful measurement?" If not, treat it as categorical even when it is written with digits.',
   'A dataset records each student''s five-digit school ID number. Which type of variable is school ID number?',
   'School ID number is quantitative because it uses digits.',
   'School ID number is categorical because it labels a student record. Averaging two ID numbers would not create a meaningful measurement, so the digits are labels, not quantities.',
   'Calling a numeric label, such as an ID number or ZIP code, quantitative just because it is written with digits.',
   'On variable questions, run the arithmetic test before looking at the choices.'),
  ('1.3',
   'The score-impact move is choosing the denominator that matches the question, then labeling the result as a count, proportion, or percent.',
   'Relative frequency is not just a calculation; it is a sentence about a group. The denominator tells which group the sentence is about.',
   'Students protect points by writing the fraction they used, naming the denominator group, and interpreting the result in words.',
   'Open hand: ask, "What total is this question asking me to divide by?" before computing any relative frequency.',
   'In a table of 80 students, 20 choose art as their favorite elective. What is the relative frequency for art?',
   'The relative frequency is 20 because 20 students chose art.',
   'The relative frequency is 20/80 = 0.25, or 25%. This means 25% of the students in the table chose art as their favorite elective.',
   'Dividing by the number of categories, or by the wrong total, instead of by the total number of observational units requested.',
   'Write relative frequencies as "of the ___, ___ are ___" to check the denominator.'),
  ('1.4',
   'The score-impact move is reading categorical graphs through their categories and scales before comparing bar heights.',
   'Separated bars signal categories, but the axis tells what the bar height means. Counts and percents cannot be compared as if they were the same scale.',
   'Students protect points by naming the category, checking the vertical-axis unit, and comparing only compatible heights or converted values.',
   'Open hand: ask, "Am I comparing categories, and are these bars using the same scale?" before making a visual claim.',
   'Two bar charts show favorite sports at two schools. One chart uses counts, and the other uses percentages.',
   'The taller soccer bar means that school has more soccer fans.',
   'You cannot compare the bar heights directly until both charts use the same scale. A count bar and a percent bar answer different questions.',
   'Comparing bar heights across graphs with different vertical scales, or treating a categorical bar chart like a quantitative histogram.',
   'Before comparing bars, point to the axis label and say whether it is count or percent.'),
  ('1.5',
   'The score-impact move is choosing the quantitative display that shows the feature the question asks about.',
   'A histogram can be efficient, but bins hide individual values. Dotplots and stem plots are better when the tested feature depends on seeing individual observations.',
   'Students protect points by naming the requested feature and explaining why the chosen graph preserves or hides that feature.',
   'Open hand: ask, "What feature am I supposed to see, and does this graph keep the needed detail visible?"',
   'A teacher wants students to see whether two quiz scores are isolated from the rest of the class. Which display is more helpful: a histogram or dotplot?',
   'A histogram is always best for quantitative data.',
   'A dotplot is more helpful for isolated values because it shows individual quiz scores. A histogram could group those values into a bin and hide that separation.',
   'Assuming every graph of the same quantitative data shows the same information, even when grouping into bins hides detail.',
   'When the question asks about gaps, clusters, or individual values, favor displays that keep individual values visible.'),
  ('1.6',
   'The score-impact move is describing distribution features with evidence from the graph that is actually shown.',
   'A good description does not just list shape words. It names the variable, identifies visible features, and cites graph evidence.',
   'Students protect points by comparing center, spread, shape, and unusual features only when those features are visible from the display.',
   'Open hand: ask, "What features can this graph type actually show me?" Then describe only those features with context.',
   'A dotplot of commute times has most values near 10-20 minutes and a few values near 60 minutes.',
   'The graph is weird.',
   'The commute-time distribution is right-skewed because most commute times are lower, with a few much larger commute times stretching the graph to the right.',
   'Using unsupported shape claims from a display that does not show enough detail, or naming shape without evidence from the graph.',
   'For every shape word you write, add the graph evidence that made you choose it.'),
  ('1.7',
   'The score-impact move is choosing the statistic that matches the job: center, spread, position, or resistance to outliers.',
   'Summary statistics are point-earning only when the student labels what they summarize and interprets them with units and context.',
   'Students protect points by showing the value, naming the statistic, including units when available, and explaining why that statistic fits the distribution or question.',
   'Open hand: ask, "Am I describing center, spread, position, or outliers, and which statistic does that job?"',
   'A dataset of home prices has one extremely expensive house. Which center should a student report for a typical price?',
   'Use the mean because it uses all the numbers.',
   'Use the median to describe a typical price because it is resistant to the extremely expensive house. The mean would be pulled upward by the outlier.',
   'Reporting a summary number without labeling what it summarizes, or using a nonresistant statistic when the question calls attention to outliers or skew.',
   'When outliers are present, ask whether the question wants a resistant summary before choosing mean or median.'),
  ('1.8',
   'The score-impact move is reading the boxplot as a five-number-summary display rather than as a picture of every data value.',
   'The box, median line, whiskers, and outlier points each have a role. Misreading one part changes the comparison.',
   'Students protect points by naming which part of the boxplot they are using and explaining what that part represents.',
   'Open hand: ask, "Which part of the five-number summary or outlier rule is this question testing?"',
   'A boxplot shows one point far beyond the right whisker. A student says the whisker should extend to that point.',
   'The whisker should go to the farthest point because it is the maximum.',
   'If the far point is marked separately as an outlier, the whisker stops at the most extreme non-outlier value. The outlier is shown as its own point.',
   'Extending a whisker to an outlier or reading a boxplot as if it shows every individual data value.',
   'Before interpreting a whisker, check whether any separate outlier points are shown.'),
  ('1.9',
   'The score-impact move is making direct, feature-matched comparisons between groups or distributions.',
   'A comparison earns only when it compares the same feature across both groups and includes the variable in context.',
   'Students protect points by naming both groups, naming the feature, stating the relative relationship, and citing evidence from the display or summary.',
   'Open hand: ask, "Which feature am I comparing, and have I named both groups and the variable?"',
   'Two classes have test-score boxplots. Class A has a median of 82 and Class B has a median of 76.',
   'Class A is 82 and Class B is 76.',
   'Class A has a higher median test score than Class B, because the median for Class A is 82 compared with 76 for Class B. This labels both groups, the feature, and the variable.',
   'Listing values for each group without directly comparing them, or comparing raw values across different distributions without using the proper relative measure.',
   'Use comparison verbs: higher, lower, greater spread, less variable, more unusual.'),
  ('1.10',
   'The score-impact move is identifying whether researchers imposed a treatment or only observed what happened.',
   'This classification protects the conclusion. Experiments can support stronger causal claims than observational studies when designed well.',
   'Students protect points by stating what the researchers did, naming the study type, and explaining what conclusion that study type can support.',
   'Open hand: ask, "Did the researcher impose a treatment, or only observe/record?" before naming the study.',
   'Researchers record how much students exercise and compare it with their stress levels.',
   'This is an experiment because researchers compared exercise and stress.',
   'This is an observational study because researchers recorded existing exercise habits; they did not assign students to exercise amounts. The study can show an association, not prove exercise caused the stress difference.',
   'Calling a study an experiment merely because researchers collected data over time, without checking whether they assigned a treatment.',
   'Circle the verb in the study description: assigned/imposed usually points to experiment; recorded/observed points to observational study.'),
  ('1.11',
   'The score-impact move is matching the sampling name to the selection mechanism.',
   'Sampling method names are easy to confuse because many involve randomness. The difference is which units or groups are randomly selected and what happens after selection.',
   'Students protect points by naming the population, explaining the selection steps, and matching those steps to the correct method.',
   'Open hand: ask, "Who could be selected, and by what exact random mechanism?"',
   'A city randomly selects 10 neighborhoods and surveys every household in those neighborhoods.',
   'This is stratified sampling because neighborhoods are groups.',
   'This is cluster sampling because whole neighborhoods are randomly selected and then every household in the selected neighborhoods is surveyed. Stratified sampling would sample from every group, not only selected groups.',
   'Confusing stratified and cluster sampling, or using a vague phrase like random sample without describing the actual selection mechanism.',
   'For grouped populations, ask whether every group is sampled from or only some whole groups are selected.'),
  ('1.12',
   'The score-impact move is naming the exact sampling flaw and explaining whose voices or responses are distorted.',
   'Bias labels are not interchangeable. The point is to identify what went wrong in collection and how that flaw could push the result.',
   'Students protect points by naming the flaw, identifying the affected group or response pattern, and explaining the likely direction or consequence when possible.',
   'Open hand: ask, "What exactly went wrong in how the data were collected?"',
   'A website poll asks visitors whether homework should be banned. Only students who choose to visit and respond are counted.',
   'This is nonresponse bias because some people did not answer.',
   'This is voluntary response bias because people chose for themselves whether to participate. The sample may overrepresent students with strong opinions about homework.',
   'Noticing bias but naming the wrong type, such as blaming sample size when the real issue is undercoverage or voluntary response.',
   'After naming a bias, add one sentence explaining who is missing, self-selected, or influenced.'),
  ('1.13',
   'The score-impact move is checking whether the design protects a causal claim.',
   'A causal conclusion depends on design features, not on how convincing the result sounds after the fact.',
   'Students protect points by identifying comparison, random assignment, replication, and control, then explaining what each feature does for the claim.',
   'Open hand: ask, "What design feature protects the causal claim here?"',
   'A teacher lets students choose whether to use a study app, then compares test scores between app users and nonusers.',
   'The app caused higher scores because app users scored higher.',
   'This design does not by itself prove the app caused higher scores because students chose whether to use it. Without random assignment, app users may differ from nonusers in other ways.',
   'Saying an experiment proves causation without checking random assignment, comparison, replication, and control.',
   'Before writing "causes," verify random assignment and a comparison group.')
),
updated_explainers as (
  update app.topic_explainers e
  set
    core_idea = u.core_idea,
    what_students_need_to_understand = u.what_students_need_to_understand,
    how_this_becomes_points = u.how_this_becomes_points,
    answer_move = u.answer_move,
    mini_example_question = u.mini_example_question,
    weak_answer = u.weak_answer,
    point_attaining_answer = u.point_attaining_answer,
    common_point_loss = u.common_point_loss,
    practice_bridge = u.practice_bridge,
    source_note = 'cramapple-authored; AP Statistics Unit 1 score-impact protocol rewrite 2026-08-27; original examples and explanations only; no College Board copyrighted questions, rubrics, scoring-language passages, or answer keys used; pending SME review',
    status = 'published',
    published_at = coalesce(e.published_at, now())
  from explainer_updates u
  where e.subject_key = 'ap_statistics'
    and e.unit_number = 1
    and e.topic_code = u.topic_code
  returning e.topic_code
)
select
  (select count(*) from updated_briefs) as updated_briefs,
  (select count(*) from updated_explainers) as updated_explainers;

do $$
declare
  v_briefs integer;
  v_explainers integer;
begin
  select count(*) into v_briefs
  from app.topic_point_briefs
  where subject_key = 'ap_statistics'
    and unit_number = 1
    and source_note like '%score-impact protocol rewrite 2026-08-27%';

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_statistics'
    and unit_number = 1
    and source_note like '%score-impact protocol rewrite 2026-08-27%';

  if v_briefs <> 13 then
    raise exception 'expected 13 AP Statistics Unit 1 score-impact briefs, got %', v_briefs;
  end if;

  if v_explainers <> 13 then
    raise exception 'expected 13 AP Statistics Unit 1 score-impact explainers, got %', v_explainers;
  end if;
end $$;

commit;
