# AP Statistics Unit 1 topics 1.1 to 1.7: harder seeds

DRAFT. Author-in-session; every key derived independently and numbers recomputed in Python. Two new seeds per topic (A and B), each with three variants, written at the interpretation and multi-step level and avoiding the existing single-step items; nothing is retired.

| Seed | Topic | Replaces |
|---|---|---|
| N-1.1-A | 1.1 | new |
| N-1.1-B | 1.1 | new |
| N-1.2-A | 1.2 | new |
| N-1.2-B | 1.2 | new |
| N-1.3-A | 1.3 | new |
| N-1.3-B | 1.3 | new |
| N-1.4-A | 1.4 | new |
| N-1.4-B | 1.4 | new |
| N-1.5-A | 1.5 | new |
| N-1.5-B | 1.5 | new |
| N-1.6-A | 1.6 | new |
| N-1.6-B | 1.6 | new |
| N-1.7-A | 1.7 | new |
| N-1.7-B | 1.7 | new |

---

## Seed N-1.1-A (new) — Topic 1.1 Introducing Statistics: What Can We Learn from Data?
**Skill:** recognize a statistical question (one that anticipates variability in data) among questions that have a single fixed answer.

Maya wants to learn about how long it takes students at her school, Kestrel High, to get to school each morning. She plans to collect commute times from a sample of Kestrel students. Which of these is a statistical question that her data could help answer?

- **A. What is a typical morning commute time for Kestrel High students, and how much do the times vary from student to student?**
- B. How long did Maya's own commute take this morning?
- C. How many students attend Kestrel High?
- D. What is the speed limit posted on the road in front of Kestrel High?

Check: A statistical question anticipates variability in the data, and only the question about typical commute time and variation among students does; the other three each have a single answer.
Rationales: B: This asks about one student on one morning, so the answer is a single value and there is no variability to investigate. C: Enrollment is one count that can be looked up in a school record, so no variation is anticipated and no sample of students is needed. D: The posted limit is a fixed fact printed on a sign, so answering it does not require collecting data that vary.

**N-1.1-A-v1.** A baker sells cupcakes advertised as weighing 85 grams. She wants to investigate whether that is accurate. Which of these is a statistical question that weighing a sample of her cupcakes could help answer?

- A. How much does the cupcake on the scale right now weigh?
- **B. Do the cupcakes she sells tend to weigh about 85 grams, and how much do the weights differ from cupcake to cupcake?**
- C. What price is printed on the bakery's cupcake menu?
- D. How many cupcakes did the baker bake at 6 a.m. today?

Check: The question about the typical weight and the differences among cupcakes anticipates variability; the others ask for one measurement, one printed price or one count.
Rationales: A: This asks about one particular cupcake at one moment, so it has a single answer and no variability to study. C: A menu price is a fixed fact that is read off the menu, so it is not answered by studying data that vary. D: A count of cupcakes baked at one time is a single number from the baker's records, not a question about variation.

**N-1.1-A-v2.** A counselor at Ridgeway Middle School wants to learn about the sleep students get on school nights. She will ask a sample of students how long they slept last night. Which of these is a statistical question that the responses could help answer?

- A. How many hours of sleep did the counselor get last night?
- B. How many hours are there between 10 p.m. and 6 a.m.?
- **C. How many hours of sleep do Ridgeway students typically get on a school night, and how do the amounts differ across students?**
- D. What time does first period begin at Ridgeway?

Check: Only the question about typical sleep and differences among students has answers that vary from student to student and so needs data from a sample.
Rationales: A: This concerns one person on one night, so the answer is one value and no variability is anticipated. B: The time between two clock times is fixed arithmetic, so no data need to be collected and none vary. D: A bell schedule is a fixed fact in the school handbook, not something that varies across the students surveyed.

**N-1.1-A-v3.** A biologist grows tomato plants for 30 days with a new fertilizer and grows other plants without it. Which of these is a statistical question that the plant heights could help answer?

- A. How tall is the plant in pot 7 today?
- B. What is the chemical formula of the main nutrient in the fertilizer?
- C. How many pots are on the greenhouse shelf?
- **D. How do the heights after 30 days of plants grown with the fertilizer compare, in center and spread, with the heights of plants grown without it?**

Check: Comparing the centers and spreads of two groups of heights anticipates plant-to-plant variability, while each other question has one fixed answer.
Rationales: A: One plant on one day gives a single measurement, so there is no variability to describe or compare. B: A chemical formula is a fixed fact from a reference, not a question whose answer varies from plant to plant. C: The number of pots is a single count, so nothing about it varies and no distribution of data is involved.

---

## Seed N-1.1-B (new) — Topic 1.1 Introducing Statistics: What Can We Learn from Data?
**Skill:** identify the population of interest from an investigative question and judge what a sample taken from a different group can support.

The Dunmore city council wants to know whether residents support longer public library hours. A researcher stands outside the central library on a Saturday and surveys 150 patrons as they leave; 117 of them say they support longer hours. Which statement correctly identifies the population of interest and what the survey result supports?

- A. The population is the 150 patrons surveyed, so 78% is the exact proportion of the population who support longer hours.
- **B. The population of interest is all Dunmore residents; the 78% describes only the 150 patrons surveyed and may not represent all residents.**
- C. The population is all Dunmore residents, and 78% is a parameter because it describes support among the residents.
- D. The population is all Dunmore residents, and because 150 is a large sample the 78% can be generalized to every resident.

Check: 117/150 = 0.78; the question concerns all residents, but the data come only from people who happened to be leaving the library, so 78% is a statistic for that group.
Rationales: A: The 150 patrons are a sample taken from the group the council cares about, not the population, so 78% is not the population proportion. C: A value computed from a sample is a statistic; a parameter is the value for the whole population, which is unknown here. D: A large sample does not fix a sample that was not chosen to represent all residents, since library patrons may differ from other residents.

**N-1.1-B-v1.** The principal of Harlow High wants to know whether Harlow students support starting school 30 minutes later. A researcher surveys 60 members of the school's varsity sports teams during practice; 21 of them support the change. Which statement correctly identifies the population of interest and what the survey result supports?

- **A. The population of interest is all Harlow students; the 35% describes only the 60 athletes surveyed and may not represent all students.**
- B. The population is the 60 athletes, so 35% is the exact proportion of Harlow students who support the change.
- C. The population is all Harlow students, and 35% is a parameter because it describes the opinion of the students.
- D. The population is all Harlow students, and because the teams include students from every grade, 35% can be generalized to every student.

Check: 21/60 = 0.35; the population is every Harlow student, while the data come from athletes only, so 35% describes that group.
Rationales: B: The athletes are the sample that was observed, not the population the principal asks about, so 35% is not the school-wide proportion. C: A number computed from the 60 athletes is a statistic, and the parameter is the unknown proportion for all students. D: Having every grade represented among athletes does not make them representative of all students on the issue of start times.

**N-1.1-B-v2.** A county health office wants to know the typical resting blood pressure of adults in Calloway County. A nurse measures the 200 adults who attend a free health clinic one weekend and finds a mean systolic pressure of 132. Which statement correctly identifies the population of interest and what the result supports?

- A. The population is the 200 adults measured, so 132 is the population mean for the county.
- B. The population is all adults in the county, and 132 is a parameter because it summarizes their blood pressures.
- **C. The population of interest is all adults in Calloway County; the mean of 132 describes only the 200 clinic attendees and may differ from the county mean.**
- D. The population is all adults in the county, and since 200 adults were measured, 132 can be generalized to the whole county.

Check: The county mean is a parameter for all adults; 132 is a statistic computed from adults who chose to attend a free clinic, who may not be typical.
Rationales: A: The 200 adults are the sample, and the county's adults are the population the health office asks about. B: A parameter describes the entire population; a mean computed from 200 measured adults is a statistic. D: Sample size cannot repair a sample of people who chose a health clinic, since they may differ from other adults in the county.

**N-1.1-B-v3.** A park manager wants to know the typical length of the fish in Lake Verity. An angler uses a net with large mesh, catches 40 fish and measures them, finding a mean length of 31 cm. Which statement correctly identifies the population of interest and what the result supports?

- A. The population is the 40 fish netted, so 31 cm is the mean length of the fish in the lake.
- B. The population is all the fish in the lake, and 31 cm is a parameter because it describes the fish.
- C. The population is all the fish in the lake, and since 40 fish were measured the 31 cm applies to the whole lake.
- **D. The population of interest is all the fish in the lake; the 31 cm describes only the 40 fish netted and may overstate the lake's typical length.**

Check: The question is about every fish in the lake, but a large-mesh net tends to keep only larger fish, so the sample mean of 31 cm may not describe the lake.
Rationales: A: The netted fish are a sample from the lake's fish, and the manager's question is about all of the fish in the lake. B: A mean from the 40 measured fish is a statistic; the lake-wide mean length is the unknown parameter. C: A sample of 40 does not make up for a net that tends to catch larger fish, so the result may not generalize.

---

## Seed N-1.2-A (new) — Topic 1.2 Variables
**Skill:** classify variables in a data set, recognizing numeric identifiers and ordered categories as categorical and counts as quantitative.

A streaming service stores these four items for each subscriber: a 7-digit account ID, a plan tier (Basic, Standard or Premium), the number of hours watched last month, and the number of user profiles on the account. Which choice lists exactly the variables that are quantitative?

- **A. Hours watched last month and number of user profiles.**
- B. Account ID, hours watched last month and number of user profiles, because each is recorded as a number.
- C. Only hours watched last month, because a count of profiles takes whole-number values and so is categorical.
- D. Plan tier, hours watched last month and number of user profiles, because the tiers can be put in order.

Check: A quantitative variable takes numerical values for which arithmetic such as averaging is meaningful; an ID is a label and a tier is an ordered category, while hours and a count of profiles can be averaged.
Rationales: B: An ID number only labels subscribers, so the average of the IDs would be meaningless; being written with digits does not make it quantitative. C: A count of profiles is numerical and can be averaged, so it is quantitative even though it takes only whole-number values. D: A plan tier is a category even though it can be ordered, so it is not quantitative; ordering alone does not make a variable numerical.

**N-1.2-A-v1.** A clinic keeps these four items for each patient: a chart number, blood type (A, B, AB or O), resting heart rate in beats per minute, and number of visits last year. Which choice lists exactly the variables that are quantitative?

- A. Chart number, resting heart rate and number of visits last year, because each is recorded as a number.
- B. Only resting heart rate, because visits are counted in whole numbers and so are categorical.
- C. Blood type, resting heart rate and number of visits, because blood types can be listed in an order.
- **D. Resting heart rate and number of visits last year.**

Check: Averages make sense for heart rate and for visits, but not for chart numbers, which only identify patients, or for blood types, which are categories.
Rationales: A: A chart number identifies a patient, so averaging chart numbers is meaningless and the variable is categorical. B: A count of visits is numerical and averaging counts is meaningful, so it is quantitative. C: Blood type is a category regardless of any listing order, so it is not quantitative.

**N-1.2-A-v2.** A youth league records these four items for each player: jersey number, skill level (Beginner, Intermediate or Advanced), minutes played in the last game, and number of fouls committed. Which choice lists exactly the variables that are quantitative?

- A. Jersey number, minutes played and number of fouls, because each is written as a number.
- B. Only minutes played, because fouls are counted in whole numbers and so are categorical.
- **C. Minutes played and number of fouls committed.**
- D. Skill level, minutes played and number of fouls, because the levels are ordered from low to high.

Check: A jersey number labels a player and skill level is an ordered category; minutes and fouls are numerical measures that can be averaged.
Rationales: A: A jersey number only labels a player, so the average jersey number says nothing and the variable is categorical. B: Fouls are a count, and counts are quantitative because their sums and averages are meaningful. D: Skill level places players in ordered categories, but it is not recorded as a numerical amount, so it is categorical.

**N-1.2-A-v3.** A car lot records these four items for each used car: a five-digit stock number, body style (sedan, SUV or truck), mileage on the odometer, and number of previous owners. Which choice lists exactly the variables that are quantitative?

- A. Stock number, mileage and number of previous owners, because each is recorded as a number.
- **B. Mileage and number of previous owners.**
- C. Only mileage, because the number of previous owners takes whole-number values and so is categorical.
- D. Body style, mileage and number of previous owners, because the styles are listed in the order the lot sells them.

Check: Mileage and the count of owners can be averaged meaningfully, whereas a stock number is an identifier and body style is a category.
Rationales: A: A stock number labels a car, so arithmetic on stock numbers has no meaning and the variable is categorical. C: A count of owners is quantitative, because it is numerical and its average can be interpreted. D: A body style is a category of car, and listing categories in some order does not make it a number.

---

## Seed N-1.2-B (new) — Topic 1.2 Variables
**Skill:** identify the individuals and the type of each variable in a described data set, where one variable summarizes many subjects as a percentage.

A researcher records data on 45 hospitals in a state. For each hospital she records its county, its number of beds, and the percentage of its patients who were readmitted within 30 days. Which statement correctly describes the data?

- A. The individuals are the patients; county is categorical, and number of beds and percentage readmitted are quantitative.
- B. The individuals are the hospitals; county and number of beds are categorical, and only percentage readmitted is quantitative.
- **C. The individuals are the hospitals; county is categorical, and number of beds and percentage readmitted are quantitative.**
- D. The individuals are the hospitals; county and number of beds are quantitative, and percentage readmitted is categorical because each patient was either readmitted or not.

Check: One row describes each hospital, so hospitals are the individuals; a county name is a category, while a bed count and a percentage readmitted are numerical values that can be averaged.
Rationales: A: The rows of data describe hospitals, and the patients are only summarized within each hospital, so they are not the individuals. B: The number of beds is a count and is numerical, so it is quantitative; being a count does not make it a category. D: The data value recorded for each hospital is a percentage, which is numerical, even though each patient's own outcome was yes or no.

**N-1.2-B-v1.** A researcher records data on 32 lakes. For each lake she records the state it lies in, its surface area in acres, and the percentage of fish sampled that had detectable mercury. Which statement correctly describes the data?

- A. The individuals are the fish sampled; state is categorical, and surface area and percentage with mercury are quantitative.
- B. The individuals are the lakes; state and surface area are categorical, and only the percentage with mercury is quantitative.
- C. The individuals are the lakes; state and surface area are quantitative, and the percentage with mercury is categorical because each fish either had mercury or did not.
- **D. The individuals are the lakes; state is categorical, and surface area and percentage with mercury are quantitative.**

Check: Each row is a lake, so lakes are the individuals; state names are categories, while an area and a percentage are numerical.
Rationales: A: The fish are only summarized within each lake, so the lakes, and not the fish, are the individuals described by each row. B: Surface area is a measured amount that can be averaged, so it is quantitative rather than categorical. C: The value recorded for each lake is a percentage, which is numerical, even though each fish was classified yes or no.

**N-1.2-B-v2.** A state agency records data on 28 school districts. For each district it records the region (North, South, East or West), the number of students enrolled, and the percentage of students who graduated within four years. Which statement correctly describes the data?

- **A. The individuals are the districts; region is categorical, and enrollment and graduation percentage are quantitative.**
- B. The individuals are the students; region is categorical, and enrollment and graduation percentage are quantitative.
- C. The individuals are the districts; region and enrollment are categorical, and only graduation percentage is quantitative.
- D. The individuals are the districts; region and enrollment are quantitative, and graduation percentage is categorical because each student either graduated or did not.

Check: One row describes each district, so districts are the individuals; a region is a category, and enrollment and a percentage are numerical.
Rationales: B: Students appear only through the district totals, so they are not the individuals that the rows describe. C: Enrollment is a count that can be averaged across districts, so it is quantitative. D: A district's graduation percentage is a number, and the yes-or-no outcome of each student does not make this variable categorical.

**N-1.2-B-v3.** An airport analyst records data on 36 flights on one day. For each flight she records the airline, the number of passengers, and the percentage of the scheduled seats that were filled. Which statement correctly describes the data?

- A. The individuals are the airlines; airline is categorical, and number of passengers and percentage of seats filled are quantitative.
- **B. The individuals are the flights; airline is categorical, and number of passengers and percentage of seats filled are quantitative.**
- C. The individuals are the flights; airline and number of passengers are categorical, and only percentage of seats filled is quantitative.
- D. The individuals are the flights; airline and number of passengers are quantitative, and percentage of seats filled is categorical because each seat was either filled or empty.

Check: Each row is one flight, so flights are the individuals; an airline name is a category, while a passenger count and a percentage are numerical.
Rationales: A: Several flights belong to the same airline, so an airline is a category of the flights and is not the individual described by each row. C: A passenger count is numerical and can be averaged over flights, so it is quantitative. D: The value recorded for each flight is a percentage, which is numerical, even though each seat was either filled or empty.

---

## Seed N-1.3-A (new) — Topic 1.3 Tabular Representation and Summary Statistics for One Categorical Variable
**Skill:** use a relative frequency and a count to recover the total of a categorical table, then find a conditional percentage among a subset of categories.

In a survey about how they usually get to school, 27 students chose the bus, which was 18% of all students surveyed. Another 34% of all students surveyed chose a car. Among the students who did NOT choose the bus, what percent chose a car, to the nearest tenth of a percent?

- A. 34.0%
- **B. 41.5%**
- C. 52.0%
- D. 51.0%

Check: 27/0.18 = 150 students; 0.34(150) = 51 car riders; 150 − 27 = 123 non-bus students; 51/123 = 0.415.
Rationales: A: 34% is the percent of all 150 students who chose a car, and the question restricts attention to the 123 who did not choose the bus. C: Adding 18% and 34% combines the bus and car percentages, which does not answer a question about cars among non-bus riders. D: 51 is the number of car riders, not a percent, and it has not been divided by the 123 students in the group.

**N-1.3-A-v1.** An online pizzeria recorded the orders placed in one week. There were 45 delivery orders, which was 15% of all orders, and 40% of all orders were for pickup. Among the orders that were NOT for delivery, what percent were for pickup, to the nearest tenth of a percent?

- A. 40.0%
- B. 55.0%
- C. 85.0%
- **D. 47.1%**

Check: 45/0.15 = 300 orders; 0.40(300) = 120 pickup orders; 300 − 45 = 255 non-delivery orders; 120/255 = 0.471.
Rationales: A: 40% is the share of all 300 orders; the question is about the 255 orders that were not for delivery. B: Adding 15% and 40% does not describe pickup orders within the non-delivery group. C: 85% is the share of all orders that were not for delivery, not the share of those orders that were for pickup.

**N-1.3-A-v2.** A librarian recorded the favorite genre of each student in a reading survey. Mystery was chosen by 18 students, which was 12% of all students surveyed, and fantasy was chosen by 28% of all students surveyed. Among the students who did NOT choose mystery, what percent chose fantasy, to the nearest tenth of a percent?

- **A. 31.8%**
- B. 28.0%
- C. 40.0%
- D. 42.0%

Check: 18/0.12 = 150 students; 0.28(150) = 42 fantasy fans; 150 − 18 = 132 non-mystery students; 42/132 = 0.318.
Rationales: B: 28% is the share of all 150 students and ignores the condition that the student did not choose mystery. C: Adding 12% and 28% combines two categories and does not answer the question about fantasy among non-mystery students. D: 42 is the number of students who chose fantasy, not a percent, and it has not been divided by the 132 non-mystery students.

**N-1.3-A-v3.** In a survey of pet ownership, 30 students said cat, which was 20% of all students surveyed, and 38% of all students surveyed said dog. Among the students who did NOT say cat, what percent said something other than dog, to the nearest tenth of a percent?

- A. 47.5%
- B. 62.0%
- **C. 52.5%**
- D. 80.0%

Check: 30/0.20 = 150 students; 0.38(150) = 57 dog owners; 150 − 30 = 120 non-cat students; (120 − 57)/120 = 63/120 = 0.525.
Rationales: A: 47.5% is the percent of the non-cat students who said dog, the complement of what was asked. B: 62% is the percent of all 150 students who did not say dog, which ignores the condition that the student did not say cat. D: 80% is the percent of all students who did not say cat, which is not a percent of that group that avoided dog.

---

## Seed N-1.3-B (new) — Topic 1.3 Tabular Representation and Summary Statistics for One Categorical Variable
**Skill:** compare two groups of different sizes using relative frequencies, and distinguish a difference in percentage points from a relative difference or a difference in counts.

Two towns were surveyed about a proposed park. In Town A, 120 of the 400 residents surveyed supported the plan. In Town B, 90 of the 225 residents surveyed supported it. Which statement about the survey results is correct?

- A. Support is stronger in Town A, because 120 supporters is more than 90 supporters.
- B. The towns cannot be compared, because different numbers of residents were surveyed in each.
- C. Support in Town B is 10% greater than in Town A, because 40% minus 30% is 10%.
- **D. A larger share of the Town B residents surveyed supported the plan, 40% compared with 30%, even though Town A had more supporters.**

Check: Relative frequencies are 120/400 = 30% and 90/225 = 40%; the gap is 10 percentage points, while 40/30 is about a 33% relative increase.
Rationales: A: Counts depend on how many people were surveyed, so more supporters in Town A comes from the larger group surveyed and does not show stronger support. B: Relative frequencies adjust for different group sizes, so proportions can be compared even when the numbers surveyed differ. C: The 10 is a difference in percentage points; Town B's share is about 33% greater in relative terms, so 10% misdescribes the comparison.

**N-1.3-B-v1.** A district asked students at two schools whether they prefer an online option for a course. At School X, 84 of the 240 students asked said yes. At School Y, 60 of the 120 students asked said yes. Which statement about the results is correct?

- A. Preference is stronger at School X, because 84 students is more than 60 students.
- **B. A larger share of the School Y students asked preferred the online option, 50% compared with 35%, even though School X had more students saying yes.**
- C. The schools cannot be compared, because a different number of students was asked at each.
- D. Preference at School Y is 15% greater than at School X, because 50% minus 35% is 15%.

Check: The shares are 84/240 = 35% and 60/120 = 50%; the gap is 15 percentage points, and 50/35 is a relative increase of about 43%.
Rationales: A: More yes answers at School X come from asking twice as many students, which does not show that a larger share preferred the option. C: Percentages put the schools on a common scale, so they can be compared even though the group sizes differ. D: A gap of 15 is in percentage points; School Y's share is about 43% greater in relative terms, so saying 15% greater misdescribes it.

**N-1.3-B-v2.** A city surveyed residents of two wards about a new recycling schedule. In Ward 1, 66 of the 300 residents surveyed favored it. In Ward 2, 40 of the 160 residents surveyed favored it. Which statement about the results is correct?

- A. Favor is higher in Ward 1, because 66 people is more than 40 people.
- B. The wards cannot be compared, because the numbers of residents surveyed were not equal.
- **C. A larger share of the Ward 2 residents surveyed favored the schedule, 25% compared with 22%, even though Ward 1 had more people in favor.**
- D. Favor in Ward 2 is 3% greater than in Ward 1, because 25% minus 22% is 3%.

Check: The shares are 66/300 = 22% and 40/160 = 25%; the gap is 3 percentage points, and 25/22 is a relative increase of about 14%.
Rationales: A: Ward 1 has more people in favor only because more residents were surveyed there; the counts do not compare the shares. B: Proportions allow groups of unequal size to be compared fairly, so unequal numbers surveyed do not prevent a comparison. D: A gap of 3 is in percentage points; Ward 2's share is about 14% greater in relative terms, so saying 3% greater is a misreading.

**N-1.3-B-v3.** A school surveyed two grades about a later start time. In Grade 9, 52 of the 130 students surveyed said yes. In Grade 10, 78 of the 260 students surveyed said yes. Which statement about the results is correct?

- **A. A larger share of the Grade 9 students surveyed said yes, 40% compared with 30%, even though Grade 10 had more students saying yes.**
- B. Support is stronger in Grade 10, because 78 students is more than 52 students.
- C. The grades cannot be compared, because a different number of students was surveyed in each grade.
- D. Support in Grade 9 is 10% greater than in Grade 10, because 40% minus 30% is 10%.

Check: The shares are 52/130 = 40% and 78/260 = 30%; the gap is 10 percentage points, and 40/30 is a relative increase of about 33%.
Rationales: B: More yes answers in Grade 10 come from surveying twice as many students and do not show that a larger share supported the change. C: Using percentages removes the effect of different group sizes, so the grades can be compared directly. D: The gap is 10 percentage points; Grade 9's share is about 33% greater in relative terms, so describing it as 10% greater is a misreading.

---

## Seed N-1.4-A (new) — Topic 1.4 Graphical Representations for One Categorical Variable
**Skill:** evaluate a claim drawn from a bar chart whose vertical axis does not start at zero, comparing visual height with the actual counts.

A bar chart shows the number of complaints received by two branches of a bank last month. The vertical axis starts at 40 instead of 0. The bar for Branch 1 reaches 46 complaints and the bar for Branch 2 reaches 52 complaints. A viewer says, "Branch 2's bar is twice as tall as Branch 1's, so Branch 2 had twice as many complaints." Which statement best evaluates the claim?

- A. The claim is correct, because the bar for Branch 2 is twice as tall and the height of a bar shows how many times larger a count is.
- **B. The claim is incorrect: the axis starts at 40, so the visible bar heights are 6 and 12, but Branch 2 had 52 complaints compared with 46, about 13% more.**
- C. The claim is incorrect: Branch 2 had 6 more complaints than Branch 1, so Branch 2 had 6% more complaints.
- D. The claim is incorrect: Branch 1 had about 13% more complaints than Branch 2, because 52 divided by 46 is about 1.13.

Check: Visible heights above the axis are 46 − 40 = 6 and 52 − 40 = 12; the counts compare as 52/46 = 1.13, so Branch 2 had about 13% more complaints.
Rationales: A: Bar heights are proportional to counts only when the axis starts at zero; with an axis starting at 40, the picture exaggerates the difference. C: The difference of 6 complaints is not a percent; as a fraction of Branch 1's 46 complaints, it is about 13%. D: 52/46 compares Branch 2 to Branch 1, so Branch 2, not Branch 1, had the larger count and the percent increase is for Branch 2.

**N-1.4-A-v1.** A bar chart shows the sales, in thousands of dollars, of two stores last month. The vertical axis starts at 200 instead of 0. The bar for Store A reaches 215 and the bar for Store B reaches 230. A viewer says, "Store B's bar is twice as tall as Store A's, so Store B sold twice as much." Which statement best evaluates the claim?

- **A. The claim is incorrect: the axis starts at 200, so the visible bar heights are 15 and 30, but Store B sold 230 thousand compared with 215 thousand, about 7% more.**
- B. The claim is correct, because Store B's bar is twice as tall, and a taller bar always shows proportionally greater sales.
- C. The claim is incorrect: Store B sold 15 thousand dollars more than Store A, so it sold 15% more.
- D. The claim is incorrect: Store A sold about 7% more than Store B, because 230 divided by 215 is about 1.07.

Check: Visible heights are 215 − 200 = 15 and 230 − 200 = 30, but the sales compare as 230/215 = 1.07, so Store B sold about 7% more.
Rationales: B: Bars compare sizes in proportion only when the axis starts at 0, and starting at 200 makes the second bar look twice as large. C: A difference of 15 thousand dollars is not 15%; relative to Store A's 215 thousand, it is about 7%. D: 230/215 puts Store B over Store A, so it is Store B that sold about 7% more, and the claim reversed the stores.

**N-1.4-A-v2.** A bar chart shows the number of defective parts produced by two machines in one shift. The vertical axis starts at 60 instead of 0. The bar for Machine 1 reaches 66 and the bar for Machine 2 reaches 78. A viewer says, "Machine 2's bar is three times as tall as Machine 1's, so Machine 2 made three times as many defective parts." Which statement best evaluates the claim?

- A. The claim is correct, because Machine 2's bar is three times as tall, and bar height shows the size of the count directly.
- B. The claim is incorrect: Machine 2 made 12 more defective parts than Machine 1, so it made 12% more.
- **C. The claim is incorrect: the axis starts at 60, so the visible bar heights are 6 and 18, but Machine 2 made 78 defective parts compared with 66, about 18% more.**
- D. The claim is incorrect: Machine 1 made about 18% more defective parts than Machine 2, because 78 divided by 66 is about 1.18.

Check: Visible heights are 66 − 60 = 6 and 78 − 60 = 18, which look like a ratio of 3, but 78/66 = 1.18, so Machine 2 made about 18% more defective parts.
Rationales: A: Bars show ratios of counts only if the axis starts at 0; the axis here starts at 60, which stretches the visible difference. B: The difference of 12 parts is not a percent; relative to Machine 1's 66, it is about 18%. D: 78/66 divides Machine 2 by Machine 1, so Machine 2 had the larger count; Machine 1 did not make 18% more.

**N-1.4-A-v3.** A bar chart shows the enrollment of two regional campuses. The vertical axis starts at 1000 instead of 0. The bar for Campus 1 reaches 1100 students and the bar for Campus 2 reaches 1250 students. A viewer says, "Campus 2's bar is two and a half times as tall as Campus 1's, so Campus 2 enrolls two and a half times as many students." Which statement best evaluates the claim?

- A. The claim is correct, because the bar for Campus 2 is two and a half times as tall as the bar for Campus 1 and bar heights show enrollment.
- B. The claim is incorrect: Campus 2 enrolls 150 more students than Campus 1, so it enrolls 150% more students.
- C. The claim is incorrect: Campus 1 enrolls about 14% more students than Campus 2, because 1250 divided by 1100 is about 1.14.
- **D. The claim is incorrect: the axis starts at 1000, so the visible bar heights are 100 and 250, but Campus 2 enrolls 1250 students compared with 1100, about 14% more.**

Check: Visible heights are 1100 − 1000 = 100 and 1250 − 1000 = 250, but 1250/1100 = 1.136, so Campus 2 has about 14% more students.
Rationales: A: Heights reflect the counts proportionally only when the axis begins at 0; here the axis cuts off most of each bar. B: A difference of 150 students is not 150 percent; relative to Campus 1's 1100 students, it is about 14%. C: 1250/1100 places Campus 2 over Campus 1, so Campus 2 is the larger campus and Campus 1 does not enroll 14% more.

---

## Seed N-1.4-B (new) — Topic 1.4 Graphical Representations for One Categorical Variable
**Skill:** choose a display for a categorical variable that allows multiple responses, recognizing when a pie chart is inappropriate.

A survey of 200 students asked them to mark every after-school activity they take part in. The results: sports 120 students, music 90, art 70 and coding 50 (students could mark more than one). The researcher wants a graph showing the percent of the 200 students who take part in each activity. Which display is most appropriate?

- A. A pie chart with slices labeled 60%, 45%, 35% and 25%.
- **B. A bar graph with one bar per activity showing 60%, 45%, 35% and 25%.**
- C. A histogram with four touching bars of heights 120, 90, 70 and 50.
- D. A pie chart with slices proportional to the counts 120, 90, 70 and 50, which total 330.

Check: The percents 60 + 45 + 35 + 25 = 165% exceed 100%, so the categories are not parts of one whole and a pie chart cannot represent them; separate bars can.
Rationales: A: Slices of a pie must add to 100%, and these percents sum to 165%, so they cannot be slices because students are counted in several categories. C: A histogram displays a quantitative variable in intervals, and the activities are categories, so touching bars are not appropriate here. D: A pie of the 330 marks shows each activity's share of all marks, not the percent of the 200 students who do each activity, so it does not answer the question.

**N-1.4-B-v1.** A store surveyed 150 customers and asked which ways they have shopped there this year; customers could choose more than one. The counts: online 105, in store 75, by phone 60. The manager wants a graph showing the percent of the 150 customers who used each method. Which display is most appropriate?

- A. A pie chart with slices labeled 70%, 50% and 40%.
- B. A histogram with three touching bars of heights 105, 75 and 60.
- C. A pie chart with slices proportional to the counts 105, 75 and 60, which total 240.
- **D. A bar graph with one bar per method showing 70%, 50% and 40%.**

Check: The percents 70 + 50 + 40 = 160% exceed 100%, which means the methods overlap and cannot be slices of one pie, while a bar graph can show each.
Rationales: A: Pie slices must total 100%, and these total 160% because customers appear in several categories. B: Shopping methods are categories, and a histogram is meant for a quantitative variable grouped in intervals. C: A pie of the 240 marks gives each method's share of all marks and not the percent of the 150 customers who used it.

**N-1.4-B-v2.** A cable provider surveyed 250 households and asked which streaming services they subscribe to; households could name more than one. The counts: Service P 175, Service Q 125, Service R 100, Service S 25. The provider wants a graph showing the percent of the 250 households that subscribe to each service. Which display is most appropriate?

- A. A pie chart with slices labeled 70%, 50%, 40% and 10%.
- B. A histogram with four touching bars of heights 175, 125, 100 and 25.
- **C. A bar graph with one bar per service showing 70%, 50%, 40% and 10%.**
- D. A pie chart with slices proportional to the counts 175, 125, 100 and 25, which total 425.

Check: The percents 70 + 50 + 40 + 10 = 170%, more than 100%, so a household can fall in several categories and a pie chart would misrepresent the data.
Rationales: A: The slices of a pie represent parts of one whole and would have to sum to 100%, but these sum to 170%. B: The services are categories, and a histogram is for a quantitative variable, so it is not the right display for them. D: A pie of the 425 subscriptions shows shares of subscriptions, not the percent of the 250 households that subscribe to each service.

**N-1.4-B-v3.** A clinic recorded the symptoms of 80 patients with a virus; each patient could have several symptoms. The counts: fatigue 48, cough 56, fever 32, sore throat 24. The clinic wants a graph showing the percent of the 80 patients who had each symptom. Which display is most appropriate?

- **A. A bar graph with one bar per symptom showing 60%, 70%, 40% and 30%.**
- B. A pie chart with slices labeled 60%, 70%, 40% and 30%.
- C. A histogram with four touching bars of heights 48, 56, 32 and 24.
- D. A pie chart with slices proportional to the counts 48, 56, 32 and 24, which total 160.

Check: The percents 60 + 70 + 40 + 30 = 200%, so patients are counted under several symptoms and the categories do not make up one whole.
Rationales: B: A pie requires slices that total 100%, and these total 200% because many patients have more than one symptom. C: Symptoms are categories, and histograms apply to quantitative data grouped into intervals. D: A pie of the 160 symptoms reports shares of all symptoms, not the percent of the 80 patients who had each one.

---

## Seed N-1.5-A (new) — Topic 1.5 Graphical Representations for One Quantitative Variable
**Skill:** locate the interval containing the median from the bar heights of a histogram, avoiding the tallest-bar and axis-midpoint errors.

A histogram shows the daily screen time, in minutes, of 60 students. Each bin includes its left endpoint and excludes its right endpoint. The bar heights (numbers of students) are: 0–30: 3; 30–60: 7; 60–90: 12; 90–120: 11; 120–150: 15; 150–180: 6; 180–210: 4; 210–240: 2. Which statement about the median screen time is correct?

- A. The median is in the interval 120–150 minutes, because that bar is the tallest.
- **B. The median is in the interval 90–120 minutes.**
- C. The median is exactly 120 minutes, because 120 is the midpoint of the horizontal axis from 0 to 240.
- D. The median cannot be located from a histogram, because the individual data values are not shown.

Check: With 60 students the median is the mean of the 30th and 31st values; the cumulative counts are 3, 10, 22, 33, so both are in 90–120.
Rationales: A: The tallest bar marks the mode, not the median; only 33 students are below 120, so the 30th and 31st values are in the earlier interval. C: The middle of the axis is not the middle of the data; the median is determined by how many values lie on each side. D: A histogram does not show exact values but does show how many values lie in each interval, which is enough to locate the interval containing the median.

**N-1.5-A-v1.** A histogram shows the one-way commute times, in minutes, of 80 workers. Each bin includes its left endpoint and excludes its right endpoint. The bar heights (numbers of workers) are: 0–5: 4; 5–10: 10; 10–15: 18; 15–20: 14; 20–25: 16; 25–30: 10; 30–35: 6; 35–40: 2. Which statement about the median commute time is correct?

- A. The median is in the interval 10–15 minutes, because that bar is the tallest.
- B. The median is exactly 20 minutes, because 20 is the midpoint of the horizontal axis from 0 to 40.
- **C. The median is in the interval 15–20 minutes.**
- D. The median cannot be located from a histogram, because the individual commute times are not shown.

Check: With 80 workers the median is the mean of the 40th and 41st values; the cumulative counts are 4, 14, 32, 46, so both are in 15–20.
Rationales: A: The tallest bar shows the most common interval, not the median; only 32 workers have times below 15, which is fewer than 40. B: The midpoint of the axis is not the median, which depends on the counts of values on each side of it. D: A histogram does give the number of values in each interval, so the interval holding the 40th and 41st values can be found.

**N-1.5-A-v2.** A histogram shows the waiting times, in minutes, of 50 patients at a clinic. Each bin includes its left endpoint and excludes its right endpoint. The bar heights (numbers of patients) are: 0–10: 3; 10–20: 13; 20–30: 10; 30–40: 8; 40–50: 6; 50–60: 4; 60–70: 3; 70–80: 2; 80–90: 0; 90–100: 1. Which statement about the median waiting time is correct?

- A. The median is in the interval 10–20 minutes, because that bar is the tallest.
- B. The median is exactly 50 minutes, because 50 is the midpoint of the horizontal axis from 0 to 100.
- C. The median cannot be located from a histogram, because the individual waiting times are not shown.
- **D. The median is in the interval 20–30 minutes.**

Check: With 50 patients the median is the mean of the 25th and 26th values; the cumulative counts are 3, 16, 26, so both lie in 20–30.
Rationales: A: The tallest bar is the most common interval, but only 16 patients waited less than 20 minutes, so the 25th value is not in that interval. B: The center of the axis does not locate the median; the median has half of the patients on each side. C: Bar heights give the number of patients in each interval, so the interval containing the median can be identified.

**N-1.5-A-v3.** A histogram shows the scores of 100 students on a 90-point exam. Each bin includes its left endpoint and excludes its right endpoint. The bar heights (numbers of students) are: 50–55: 2; 55–60: 4; 60–65: 6; 65–70: 10; 70–75: 14; 75–80: 16; 80–85: 20; 85–90: 28. Which statement about the median score is correct?

- **A. The median is in the interval 75–80 points.**
- B. The median is in the interval 85–90 points, because that bar is the tallest.
- C. The median is exactly 70 points, because 70 is the midpoint of the horizontal axis from 50 to 90.
- D. The median cannot be located from a histogram, because the individual scores are not shown.

Check: With 100 students the median is the mean of the 50th and 51st scores; the cumulative counts are 2, 6, 12, 22, 36, 52, so both are in 75–80.
Rationales: B: The tallest bar shows where the most scores are, but 72 students score below 85 and the 50th and 51st scores are lower than that. C: The midpoint of the axis is not the median, which is determined by the number of scores on each side. D: A histogram shows how many scores fall in each interval, so it is possible to find the interval that holds the middle scores.

---

## Seed N-1.5-B (new) — Topic 1.5 Graphical Representations for One Quantitative Variable
**Skill:** read a relative frequency histogram, first recovering the sample size from two bars and then converting percentages of a subset of bins into a count.

A histogram shows the weights, in pounds, of packages shipped by a store. The bars give relative frequencies in percent, and each bin includes its left endpoint and excludes its right endpoint: 0–10: 5%; 10–20: 15%; 20–30: 30%; 30–40: 25%; 40–50: 15%; 50–60: 10%. The packages in the bars for 0–10 and 50–60 together number 18. How many packages weighed at least 20 pounds but less than 40 pounds?

- A. 55
- B. 36
- C. 84
- **D. 66**

Check: 5% + 10% = 15% of the packages is 18, so there are 120 packages; the bars for 20–30 and 30–40 total 55% and 0.55(120) = 66.
Rationales: A: 55 is the sum of the two bar heights read as a count, but the heights are percentages of the 120 packages. B: 36 is 30% of 120 and counts only the 20–30 bar, leaving out the 30–40 bar. C: 84 also includes the 40–50 bar, but a package of exactly 40 pounds falls in the 40–50 bin, and the question says less than 40 pounds.

**N-1.5-B-v1.** A histogram shows the waiting times, in minutes, of customers at a service desk. The bars give relative frequencies in percent, and each bin includes its left endpoint and excludes its right endpoint: 0–5: 8%; 5–10: 20%; 10–15: 32%; 15–20: 24%; 20–25: 12%; 25–30: 4%. The customers in the bars for 0–5 and 25–30 together number 30. How many customers waited at least 10 minutes but less than 20 minutes?

- **A. 140**
- B. 56
- C. 80
- D. 170

Check: 8% + 4% = 12% of the customers is 30, so there are 250 customers; the bars for 10–15 and 15–20 total 56% and 0.56(250) = 140.
Rationales: B: 56 is the total of the bar heights read as a count, but those heights are percentages of the 250 customers. C: 80 is 32% of 250 and uses only the 10–15 bar, leaving out the 15–20 bar. D: 170 adds the 20–25 bar as well, but a wait of exactly 20 minutes is in the 20–25 bin, and the question says less than 20.

**N-1.5-B-v2.** A histogram shows the ages, in years, of visitors to a museum. The bars give relative frequencies in percent, and each bin includes its left endpoint and excludes its right endpoint: 0–20: 10%; 20–40: 15%; 40–60: 35%; 60–80: 25%; 80–100: 15%. The visitors in the bars for 0–20 and 80–100 together number 40. How many visitors were younger than 60?

- A. 60
- B. 56
- **C. 96**
- D. 136

Check: 10% + 15% = 25% of the visitors is 40, so there are 160 visitors; the first three bars total 60% and 0.60(160) = 96.
Rationales: A: 60 is the total of the three bar heights read as a count, but the heights are percentages of the 160 visitors. B: 56 is 35% of 160 and uses only the tallest bar, leaving out the two younger bars. D: 136 includes the 60–80 bar, but a visitor who is exactly 60 is in the 60–80 bin, and the question says younger than 60.

**N-1.5-B-v3.** A histogram shows the scores of students on a 90-point exam. The bars give relative frequencies in percent, and each bin includes its left endpoint and excludes its right endpoint: 0–15: 4%; 15–30: 10%; 30–45: 26%; 45–60: 30%; 60–75: 20%; 75–90: 10%. The students in the bars for 15–30 and 75–90 together number 40. How many students scored at least 30 but less than 60?

- A. 56
- **B. 112**
- C. 52
- D. 152

Check: 10% + 10% = 20% of the students is 40, so there are 200 students; the bars for 30–45 and 45–60 total 56% and 0.56(200) = 112.
Rationales: A: 56 is the total of the bar heights read as a count, but the heights are percentages of the 200 students. C: 52 is 26% of 200 and uses only the 30–45 bar, leaving out the 45–60 bar. D: 152 adds the 60–75 bar, but a score of exactly 60 is in the 60–75 bin, and the question says less than 60.

---

## Seed N-1.6-A (new) — Topic 1.6 Descriptions for One Quantitative Variable Distributions
**Skill:** choose the description of a quantitative distribution that has shape, resistant center and spread, and unusual features, stated in context.

The annual salaries, in thousands of dollars, of the 38 employees of a small firm form a distribution with these features: most salaries are between 42 and 78, with a single peak, a median of 57, Q1 = 50 and Q3 = 64; two employees earn about 140 and 155, far above everyone else; the mean is about 63 and the standard deviation about 22. Which is the best description of the distribution of salaries?

- **A. The salaries are skewed to the right by two high outliers (about $140 thousand and $155 thousand); the typical salary is about $57 thousand, and the middle 50% span about $14 thousand.**
- B. The salaries are roughly symmetric and centered near $63 thousand, and they typically vary from the center by about $22 thousand.
- C. The distribution is skewed right, with a median of 57 and an interquartile range of 14.
- D. The salaries are bimodal, with one peak near $57 thousand and a second peak near $150 thousand.

Check: IQR = 64 − 50 = 14, and the fence 64 + 1.5(14) = 85 is below 140 and 155, so they are outliers; they pull the mean (63) above the median (57), so median and IQR describe the center and spread.
Rationales: B: The mean and standard deviation are pulled up by the two high salaries, and the description ignores that outliers make the shape skewed to the right. C: This gives shape, center and spread but with no units or context and no mention of the two unusually high salaries, so it is not a complete description in context. D: Two isolated values do not form a second peak; they are unusual values (outliers) in a distribution that has one peak.

**N-1.6-A-v1.** The scores of 30 students on a 100-point exam form a distribution with these features: most scores are between 72 and 96, with a single peak, a median of 85, Q1 = 80 and Q3 = 90; two students scored about 30 and 38, far below everyone else; the mean is about 80 and the standard deviation about 17. Which is the best description of the distribution of scores?

- A. The scores are roughly symmetric and centered near 80 points, and they typically vary from the center by about 17 points.
- B. The distribution is skewed left, with a median of 85 and an interquartile range of 10.
- **C. The scores are skewed to the left by two low outliers (about 30 and 38 points); the typical score is about 85 points, and the middle 50% span about 10 points.**
- D. The scores are bimodal, with one peak near 85 points and a second peak near 34 points.

Check: IQR = 90 − 80 = 10, and the fence 80 − 1.5(10) = 65 is above 30 and 38, so they are low outliers; they pull the mean (80) below the median (85), so median and IQR describe the center and spread.
Rationales: A: The mean and standard deviation are distorted by the two low scores, and this description misses that they make the shape skewed to the left. B: This states shape, center and spread without any context or units and does not mention the two unusually low scores. D: Two isolated low scores are unusual values (outliers), not a second peak in the distribution.

**N-1.6-A-v2.** The numbers of text messages sent in one day by 50 teenagers form a distribution with these features: a single peak at low values and a long tail to the right, a median of 40, Q1 = 22 and Q3 = 60; the largest values are 150 and 190; the mean is about 52. Which is the best description of the distribution?

- A. The numbers of messages are skewed to the right; the typical number is about 52 messages, with no unusual values since the largest teens simply text the most.
- **B. The numbers of messages are skewed to the right; the typical number is about 40, the middle 50% span about 38 messages, and the two largest values, 150 and 190, are outliers.**
- C. The numbers of messages are roughly symmetric, with a center near 40 and a spread of about 38 messages.
- D. The numbers of messages are skewed to the right with a median of 40, and the values 150 and 190 are not outliers because the mean is only 52.

Check: IQR = 60 − 22 = 38, and the fence 60 + 1.5(38) = 117 is below 150 and 190, so both are high outliers; the mean (52) exceeds the median (40), consistent with right skew.
Rationales: A: The mean is pulled up by the long right tail, and the largest values are beyond the outlier fence, so this description misses an unusual feature. C: A single peak with a long right tail is not symmetric, and the mean being above the median also indicates right skew. D: The outlier rule uses the quartiles, not the mean, and 150 and 190 exceed the fence of 117.

**N-1.6-A-v3.** The heights of 40 adult visitors to a gym form a distribution with these features: a single peak, symmetric and mound-shaped, with mean 72 inches, standard deviation about 3 inches, Q1 = 70 and Q3 = 74; the smallest height is 65 and the largest is 79. Which is the best description of the distribution of heights?

- A. The heights are skewed to the left because the smallest height, 65, is farther from the mean than the largest, 79.
- B. The heights are roughly symmetric with a median of 72 inches, but 65 and 79 are outliers because they are the most extreme heights.
- C. The heights are roughly symmetric and mound-shaped, centered near 72, but a description cannot be given without the median.
- **D. The heights are roughly symmetric and mound-shaped with no outliers; the typical height is about 72 inches, and heights typically vary from the mean by about 3 inches.**

Check: IQR = 74 − 70 = 4, so the fences are 70 − 6 = 64 and 74 + 6 = 80, and 65 and 79 are inside them; with a symmetric mound shape the mean and standard deviation are appropriate.
Rationales: A: The mean is 72, so 65 is 7 below it and 79 is 7 above it, which is symmetric and not skewed. B: The most extreme values are not outliers just because they are extreme; they must lie beyond the fences, and 65 and 79 do not. C: For a roughly symmetric distribution with no outliers, the mean and standard deviation are appropriate summaries, so the median is not required.

---

## Seed N-1.6-B (new) — Topic 1.6 Descriptions for One Quantitative Variable Distributions
**Skill:** interpret a bimodal distribution, recognizing that a single mean can fall where few observations lie and that the data may mix two subgroups.

A teacher plots the exam scores of her 30 students. The histogram has two separate peaks, one near 60 and one near 90, with about 15 students at each peak and almost no scores between 70 and 80. The mean score is 75. Which interpretation is most appropriate?

- A. The mean of 75 describes a typical student well, because the mean is the center of the distribution and most students scored near it.
- B. Because the distribution has two peaks, it must be skewed, so the median should be reported in place of the mean.
- C. The two peaks are outliers, so they should be removed before the class scores are described.
- **D. The mean of 75 is a poor description of a typical student, because almost no one scored near 75; the class seems to consist of two groups that should be described separately.**

Check: Half of the scores cluster near 60 and half near 90, so the mean (75) lies in the gap where almost no student scored and is not a typical value.
Rationales: A: A mean can fall in a region with almost no data, and here few students are near 75, so it does not represent a typical score. B: A bimodal distribution with equal peaks is not skewed, and neither the mean nor the median would describe the two groups well. C: The peaks contain all of the students, so they are the main feature of the data and not unusual individual values to delete.

**N-1.6-B-v1.** A restaurant owner records the time, in minutes, it takes to prepare 40 orders. The histogram has two separate peaks, one near 5 minutes (simple drinks and sides) and one near 25 minutes (full meals), with about 20 orders at each peak and almost none between 12 and 18 minutes. The mean is 15 minutes. Which interpretation is most appropriate?

- **A. The mean of 15 minutes is a poor description of a typical order, because almost no order took about 15 minutes; the orders appear to be two types that should be described separately.**
- B. The mean of 15 minutes describes a typical order well, because it is the center and most orders took about that long.
- C. Because the distribution has two peaks, it must be skewed, so the median should be reported in place of the mean.
- D. The orders near 5 and 25 minutes are outliers, so they should be removed before describing the times.

Check: About half of the orders took near 5 minutes and half near 25, so the mean of 15 lies in the gap where almost no order falls.
Rationales: B: The mean falls in a region with almost no orders, so it is not a typical preparation time. C: Two peaks of similar size do not make a distribution skewed, and the median would also fall in the gap and be unrepresentative. D: Each peak contains about half of the orders, so these are the main groups in the data and not unusual values.

**N-1.6-B-v2.** A biologist measures the lengths, in centimeters, of 60 fish from one pond. The histogram has two separate peaks, one near 10 cm and one near 22 cm, with about 30 fish at each peak and very few between 14 and 18 cm. The mean length is 16 cm. Which interpretation is most appropriate?

- A. The mean of 16 cm describes a typical fish well, because the mean is the center and the fish are spread evenly around it.
- B. Because the distribution has two peaks, it must be skewed, so the median should be reported in place of the mean.
- **C. The mean of 16 cm is a poor description of a typical fish, because very few fish are near 16 cm; the sample appears to combine two groups, such as young and adult fish.**
- D. The fish near 10 cm and near 22 cm are outliers, so they should be removed before the lengths are described.

Check: Half of the fish are near 10 cm and half near 22 cm, so the mean of 16 cm lies in the gap and few fish are anywhere near it.
Rationales: A: A mean in a gap does not describe typical values, and the fish are clustered at two lengths rather than around 16 cm. B: A distribution with two equal peaks is not skewed, and the median would also land in the gap between the groups. D: Each cluster holds half of the fish, so they are the two main groups and not unusual observations to be dropped.

**N-1.6-B-v3.** A school counselor records the number of hours per week that 50 students spend on homework. The histogram has two separate peaks, one near 2 hours and one near 12 hours, with about 25 students at each peak and almost none between 6 and 8 hours. The mean is 7 hours. Which interpretation is most appropriate?

- A. The mean of 7 hours describes a typical student well, because the mean is the center and most students are close to it.
- **B. The mean of 7 hours is a poor description of a typical student, because almost no one studies about 7 hours; the students appear to form two groups that should be described separately.**
- C. Because the distribution has two peaks, it must be skewed, so the median should be reported in place of the mean.
- D. The students near 2 hours and near 12 hours are outliers, so they should be removed before the homework times are described.

Check: Half of the students are near 2 hours and half near 12 hours, so the mean of 7 falls where almost no student's time lies.
Rationales: A: Few students are near 7 hours, so the mean is not a typical value for them even though it is the arithmetic center. C: Two peaks of equal size are not a skewed shape, and the median would also fall between the groups. D: The two clusters include essentially all students, so they are the groups to describe and not outliers to delete.

---

## Seed N-1.7-A (new) — Topic 1.7 Summary Statistics for One Quantitative Variable
**Skill:** determine how a linear change of units (multiply then add) changes the mean and standard deviation.

A test is scored out of 50 points. The raw scores x have mean 31 and standard deviation 4.5. The teacher reports each student's percent score as y = 2x + 5. Which choice gives the mean and standard deviation of the reported scores y?

- A. Mean 67 and standard deviation 14
- B. Mean 62 and standard deviation 9
- C. Mean 36 and standard deviation 9.5
- **D. Mean 67 and standard deviation 9**

Check: The mean is transformed like each value, 2(31) + 5 = 67; the standard deviation is multiplied by |2| and unaffected by adding 5, so it is 2(4.5) = 9.
Rationales: A: Adding 5 shifts every score and does not change the spread, so the standard deviation is 2(4.5) = 9, not 9 + 5. B: The mean must also reflect the added 5 points, so it is 2(31) + 5 = 67 and not 2(31) = 62. C: This applies only the addition and ignores the multiplication by 2, which doubles both the center and the spread.

**N-1.7-A-v1.** Daily high temperatures in a city, in degrees Celsius C, have mean 21 and standard deviation 3. Each temperature is converted to degrees Fahrenheit using F = 1.8C + 32. Which choice gives the mean and standard deviation of the temperatures in Fahrenheit?

- **A. Mean 69.8 and standard deviation 5.4**
- B. Mean 69.8 and standard deviation 37.4
- C. Mean 37.8 and standard deviation 5.4
- D. Mean 53 and standard deviation 35

Check: Mean: 1.8(21) + 32 = 69.8; standard deviation: 1.8(3) = 5.4, since adding 32 does not change the spread.
Rationales: B: Adding 32 shifts all the temperatures by the same amount and leaves the spread unchanged, so the standard deviation is 1.8(3) = 5.4. C: The mean also gets the 32 added, so the mean is 1.8(21) + 32 = 69.8 and not just 1.8(21). D: This adds 32 to the mean and the standard deviation and ignores the multiplication by 1.8 that rescales both.

**N-1.7-A-v2.** The hours worked in a week by the employees of a shop have median 34 hours and IQR 6 hours. Each employee's weekly pay, in dollars, is y = 15x + 40, where x is hours worked. Which choice gives the median and IQR of the weekly pay?

- A. Median 550 dollars and IQR 130 dollars
- **B. Median 550 dollars and IQR 90 dollars**
- C. Median 510 dollars and IQR 90 dollars
- D. Median 74 dollars and IQR 46 dollars

Check: Median: 15(34) + 40 = 550; IQR: 15(6) = 90, because adding the fixed 40 does not change the distance between the quartiles.
Rationales: A: The fixed 40 raises every pay amount equally, so it does not change the IQR, which is 15(6) = 90. C: The median is also raised by the 40, so it is 15(34) + 40 = 550 and not 15(34) = 510. D: This only adds 40 to each summary and leaves out the multiplication by 15 that rescales both the center and the spread.

**N-1.7-A-v3.** A quiz deducts 4 points for each error from a starting score of 100, so the score is y = 100 − 4x, where x is the number of errors. The numbers of errors have mean 6.5 and standard deviation 2.5. Which choice gives the mean and standard deviation of the quiz scores?

- A. Mean 74 and standard deviation −10
- B. Mean 93.5 and standard deviation 10
- **C. Mean 74 and standard deviation 10**
- D. Mean 74 and standard deviation 90

Check: Mean: 100 − 4(6.5) = 74; standard deviation: |−4|(2.5) = 10, since a standard deviation cannot be negative and adding 100 does not change it.
Rationales: A: A standard deviation is a nonnegative measure of spread, so multiplying by −4 gives 4(2.5) = 10 and not a negative number. B: The mean must reflect both the multiplication by −4 and the 100 points, so it is 100 − 4(6.5) = 74. D: The 100 shifts every score and leaves the spread unchanged, so the standard deviation is 10 and not 100 − 10.

---

## Seed N-1.7-B (new) — Topic 1.7 Summary Statistics for One Quantitative Variable
**Skill:** find and interpret the mean of a combined group from the means and sizes of two subgroups, avoiding the unweighted average of the means.

Section 1 of a course has 12 students with a mean quiz score of 85, and Section 2 has 28 students with a mean quiz score of 75. The scores from both sections are combined. Which statement is correct?

- A. The combined mean is 80, the average of 85 and 75.
- B. The combined mean cannot be found without knowing the individual scores.
- C. The combined mean is 78, and the combined median must also be 78.
- **D. The combined mean is 78, which is closer to 75 because Section 2 has more students.**

Check: Total points = 12(85) + 28(75) = 1020 + 2100 = 3120, and 3120/40 = 78; each mean is weighted by its number of students.
Rationales: A: Averaging 85 and 75 gives each section equal weight, but Section 2 has more than twice as many students and so counts more. B: The sum of each section's scores is its mean times its size, so the combined mean can be computed from the means and sizes alone. C: The mean is 78, but the median of the combined scores cannot be determined from the means and sizes, and it need not equal the mean.

**N-1.7-B-v1.** A factory has two production lines. Line 1 has 18 machines with a mean output of 240 units per day, and Line 2 has 42 machines with a mean output of 200 units per day. Which statement about the mean output of all 60 machines is correct?

- A. The mean output of all 60 machines is 220 units, the average of 240 and 200.
- B. The mean output of all 60 machines cannot be found without the output of each machine.
- **C. The mean output of all 60 machines is 212 units, which is closer to 200 because Line 2 has more machines.**
- D. The mean output of all 60 machines is 212 units, and the median output of all 60 machines must also be 212.

Check: Total output = 18(240) + 42(200) = 4320 + 8400 = 12720, and 12720/60 = 212.
Rationales: A: The simple average of 240 and 200 gives the two lines equal weight, but Line 2 has more than twice as many machines. B: Each line's total output is its mean times its number of machines, so the overall mean can be found from the given means and sizes. D: The mean is 212, but the combined median cannot be determined from the means and sizes and need not equal the mean.

**N-1.7-B-v2.** A hiking club has 25 members with a mean age of 30 years and 15 guests with a mean age of 50 years. Which statement about the mean age of all 40 people is correct?

- A. The mean age of all 40 people is 40 years, the average of 30 and 50.
- **B. The mean age of all 40 people is 37.5 years, which is closer to 30 because the club has more members than guests.**
- C. The mean age of all 40 people cannot be found without the age of each person.
- D. The mean age of all 40 people is 37.5 years, and the median age of all 40 people must also be 37.5.

Check: Total age = 25(30) + 15(50) = 750 + 750 = 1500, and 1500/40 = 37.5.
Rationales: A: Averaging 30 and 50 treats the groups as equal in size, but there are 25 members and only 15 guests. C: Each group's total age is its mean times its size, so the overall mean can be calculated from the means and sizes. D: The mean is 37.5, but the median of the 40 ages cannot be found from the means and sizes and need not equal 37.5.

**N-1.7-B-v3.** Drivers on a highway are grouped by vehicle type. 60% are cars, with a mean speed of 62 miles per hour, and 40% are trucks, with a mean speed of 50 miles per hour. Which statement about the mean speed of all drivers is correct?

- **A. The mean speed of all drivers is 57.2 miles per hour, which is closer to 62 because more drivers are in cars.**
- B. The mean speed of all drivers is 56 miles per hour, the average of 62 and 50.
- C. The mean speed of all drivers cannot be found without the speed of every driver.
- D. The mean speed of all drivers is 57.2 miles per hour, and the median speed of all drivers must also be 57.2.

Check: Mean = 0.60(62) + 0.40(50) = 37.2 + 20 = 57.2 miles per hour, a weighted mean using the proportion in each group.
Rationales: B: The simple average of 62 and 50 ignores that 60% of the drivers are in cars and only 40% are in trucks. C: With the proportion of drivers in each group and each group's mean, the overall mean is a weighted average and can be found. D: The mean is 57.2, but the median of all speeds cannot be found from the group means and proportions and need not equal the mean.
