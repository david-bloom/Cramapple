"""Author-in-session deterministic drafts for AP Statistics Unit 5.

The scenarios and distractor reasoning are authored here; this script only expands
four distinct contexts per family into the repository's reviewable draft format.
"""
from pathlib import Path

OUT = Path(__file__).with_name("source_draft.md")
blocks = [
    "# AP Statistics Unit 5: harder seed drafts (Regression Analysis)",
    "DRAFT. Author-in-session, 2026-11-12. Two seed families per topic; four contexts per family. CED: effective fall 2026, Unit 5, topics 5.1–5.5. No Production write.",
]


def add(topic, family, title, skill, cases):
    assert len(cases) == 4
    for i, (stem, choices, check, reasons) in enumerate(cases):
        assert len(choices) == 4 and len(reasons) == 3
        ident = f"N-{topic}-{family}"
        if i == 0:
            blocks.extend(["---", f"## Seed {ident} (new) — Topic {topic} {title}", f"**Skill:** {skill}", "", stem, ""])
        else:
            blocks.extend(["", f"**{ident}-v{i}.** {stem}", ""])
        blocks.extend([f"- **A. {choices[0]}**", *[f"- {letter}. {choice}" for letter, choice in zip("BCD", choices[1:])], "", f"Check: {check}", "Rationales: " + " ".join(f"{letter}: {reason}" for letter, reason in zip("BCD", reasons))])


scatter_contexts = [
    ("Hours of sunlight", "daily plant growth", [2, 4, 6, 8, 10], [3, 6, 9, 12, 2]),
    ("Minutes of exercise", "resting pulse reduction", [10, 20, 30, 40, 50], [1, 3, 5, 7, 0]),
    ("Study sessions", "quiz score", [1, 2, 3, 4, 5], [55, 63, 71, 79, 54]),
    ("Rainfall in centimeters", "seedling height", [1, 2, 3, 4, 5], [4, 7, 10, 13, 3]),
]
cases=[]
for xname,yname,xs,ys in scatter_contexts:
    pairs=", ".join(f"({x}, {y})" for x,y in zip(xs,ys))
    stem=f"A researcher records ({xname.lower()}, {yname}) for five independent observations: {pairs}. The first quantity is used to explain the second. Which description of the scatterplot is best supported?"
    choices=[f"Put {xname.lower()} on the horizontal axis and {yname} on the vertical axis; four points follow a positive, roughly linear pattern, with the last point unusually low.",f"Put {yname} on the horizontal axis and {xname.lower()} on the vertical axis; the last point proves that the response causes the explanatory variable.","The association is negative and roughly linear because the final response is smaller than the first response.","No pattern is visible because one unusual point cancels the consistent increase in the other four observations."]
    check="The explanatory variable is the first coordinate. The first four response values rise with x; the fifth lies well below that pattern. One unusual point does not reverse the four-point direction."
    reasons=["The variables were recorded as explanatory then response; exchanging the axes changes the intended prediction, and a scatterplot alone does not establish causation.","The direction of the main pattern comes from all observations rather than comparing only the first and last response values.","The first four points form a visible positive pattern; the unusual fifth point should be named rather than erasing that pattern."]
    cases.append((stem,choices,check,reasons))
add("5.1","A","Graphical Representations Between Two Quantitative Variables","read axes, form, direction, and an unusual point together",cases)

curve_contexts=[
    ("fertilizer dose", "crop yield", [2,5,8,5,2]),
    ("time after sunrise", "solar output", [1,4,7,4,1]),
    ("distance from a heater", "sensor response", [2,6,9,6,2]),
    ("training load", "performance score", [3,7,10,7,3]),
]
cases=[]
for xname,yname,ys in curve_contexts:
    pairs=", ".join(f"({x}, {y})" for x,y in zip(range(1,6),ys))
    stem=f"Five observations of ({xname}, {yname}) are {pairs}, with {xname} explanatory. A classmate describes the scatterplot as having 'no relationship' because the first and last responses match. Which reply best uses the entire plot?"
    choices=[f"The response rises then falls as {xname} increases, so the plotted association is curved even though the endpoint responses match.","The association is perfectly positive and linear because the response increases over the first three observations.","The association is perfectly negative and linear because the response decreases over the last three observations.","A scatterplot cannot show an association when the first and last response values are equal."]
    check="Reading the five ordered pairs in x order gives a rise to the middle point and a fall afterward. Matching endpoints do not erase the curved form."
    reasons=["The later observations reverse the early rise, so a single positive straight-line description omits half the data.","The earlier observations rise before the later fall, so a single negative straight-line description omits half the data.","The middle observations reveal a strong curved association despite equal response values at the two endpoints."]
    cases.append((stem,choices,check,reasons))
add("5.1","B","Graphical Representations Between Two Quantitative Variables","recognize a curved association rather than infer from endpoints",cases)

correlation_contexts=[
    ("distance in miles", "delivery time",0.78),
    ("temperature in degrees Celsius", "electricity use",0.64),
    ("hours of sleep", "reaction time",-0.71),
    ("practice hours", "completion time",-0.83),
]
cases=[]
for xname,yname,r in correlation_contexts:
    flipped=-r
    stem=f"In a sample, the correlation between {xname} and {yname} is {r:+.2f}. An analyst converts the first variable to a new unit using a positive scale factor, then reports the negative of the second variable instead. Which statement is justified about the new correlation and a possible causal claim?"
    choices=[f"The new correlation is {flipped:+.2f}; the sign reverses because one variable was negated, and neither correlation establishes causation.",f"The new correlation is {r:+.2f}; changing units and negating a variable cannot change correlation's direction.",f"The new correlation is {flipped:+.2f}; its magnitude establishes that changing {xname} causes a change in {yname}.","The new correlation is 0 because both variables were transformed before it was computed."]
    check=f"A positive rescaling preserves r={r:+.2f}; multiplying one variable by -1 changes its sign to {flipped:+.2f}. Association alone cannot prove causation."
    reasons=["Positive rescaling preserves correlation, but negating one of the variables reverses its sign.","The sign calculation is right, but the size of a correlation does not by itself identify a causal effect.","Linear transformations do not in general destroy association; a positive rescaling and a sign reversal leave the magnitude unchanged."]
    cases.append((stem,choices,check,reasons))
add("5.2","A","Correlation","track correlation through transformations and avoid causal inference",cases)

compare_contexts=[
    ("school attendance and test scores",0.84,"hours of exercise and pulse rate",-0.61),
    ("rainfall and crop yield",0.57,"altitude and air pressure",-0.91),
    ("practice time and task score",0.76,"travel speed and trip time",-0.48),
    ("sunlight and plant height",0.42,"age of a device and battery capacity",-0.88),
]
cases=[]
for an,ar,bn,br in compare_contexts:
    strong="A" if abs(ar)>abs(br) else "B"; weak="B" if strong=="A" else "A"; sr=ar if strong=="A" else br; direction="positive" if sr>0 else "negative"
    stem=f"Study A reports r={ar:+.2f} for {an}. Study B reports r={br:+.2f} for {bn}. Both use quantitative variables. Which comparison is supported by these summaries alone?"
    choices=[f"Study {strong} has the stronger linear association because |r| is larger; its direction is {direction}, but neither study establishes causation.",f"Study {weak} has the stronger linear association because its sign makes its correlation more meaningful than Study {strong}'s.","The study with the larger |r| proves that its explanatory variable causes the response.","The two studies have the same strength because both correlations lie between -1 and 1."]
    check=f"Compare magnitudes: |{ar:+.2f}|={abs(ar):.2f}, |{br:+.2f}|={abs(br):.2f}. Study {strong} is stronger and has a {direction} direction; causal claims require more evidence."
    reasons=["A positive or negative sign gives direction, while strength is based on distance from zero; the named study has the smaller magnitude.","Correlation measures linear association; even a large magnitude does not prove that one variable caused the other.","Both coefficients being in the valid range says nothing about equality of their magnitudes or strengths."]
    cases.append((stem,choices,check,reasons))
add("5.2","B","Correlation","compare strength and direction while limiting causal claims",cases)

prediction_contexts=[
    ("practice sessions", "score points",[1,10],42,4,12),
    ("machine hours", "units of output",[2,14],15,3,17),
    ("weeks after planting", "plant height in cm",[1,8],5,2,10),
    ("daily temperature in degrees", "ice cream sales",[12,30],20,5,34),
]
cases=[]
for xname,yname,interval,a,b,x in prediction_contexts:
    y=a+b*x; wrong=a+b*(x-interval[1]);
    stem=f"A linear model fitted using {xname} from {interval[0]} to {interval[1]} predicts {yname} by y-hat={a}+{b}x. What should an analyst report for x={x}?"
    choices=[f"The model predicts {y} {yname}, but this is extrapolation beyond the fitted x-range and is less reliable.",f"The model predicts {y} {yname}, and this is interpolation because the equation accepts x={x}.",f"The model predicts {wrong} {yname}, since the model input must be the distance past the largest observed x.","No predicted value can be calculated once x lies outside the observed range."]
    check=f"Substitute x={x}: {a}+{b}({x})={y}. Since {x}>{interval[1]}, the prediction extrapolates; the equation yields a value but reliability is weaker outside the data range."
    reasons=["A fitted equation can be evaluated outside the observed x-range, but that use is extrapolation, not interpolation.","The model uses the actual explanatory value x, not the distance past the edge of the data range.","Extrapolation is less reliable, yet the model still produces a numerical prediction when x is substituted."]
    cases.append((stem,choices,check,reasons))
add("5.3","A","Linear Regression Models","compute a prediction and judge extrapolation",cases)

unit_contexts=[
    ("distance", "kilometers", "meters",1000,10,2,3),
    ("time", "hours", "minutes",60,20,5,2),
    ("mass", "kilograms", "grams",1000,8,4,6),
    ("volume", "liters", "milliliters",1000,12,3,5),
]
cases=[]
for name,old,new,factor,a,b,x in unit_contexts:
    pred=a+b*x; slope=b/factor; xnew=x*factor
    stem=f"A model predicts a response y from {name} x measured in {old}: y-hat={a}+{b}x. The same observation has x={x} {old}. If x is instead recorded in {new} ({factor} {new} per {old}), which equation and prediction describe the same model?"
    choices=[f"y-hat={a}+({slope:g})x_new, which predicts {pred} at x_new={xnew}.",f"y-hat={a}+({b*factor})x_new, which predicts {a+b*factor*xnew} at x_new={xnew}.",f"y-hat={a}+{b}x_new, which predicts {a+b*xnew} at x_new={xnew}.",f"y-hat={a*factor}+({slope:g})x_new, which predicts {a*factor+slope*xnew:g} at x_new={xnew}."]
    check=f"x_new={factor}x, so x=x_new/{factor}. Substitute into the original equation: y-hat={a}+({slope:g})x_new. At x_new={xnew}, the prediction is {pred}."
    reasons=["The slope per new unit is the old slope divided by the number of new units in one old unit; multiplying it gives a different prediction.","Keeping the numerical slope after changing the x-unit changes the model and inflates the predicted response.","Only the explanatory variable's unit changed; multiplying the response intercept by the conversion factor changes the response scale incorrectly."]
    cases.append((stem,choices,check,reasons))
add("5.3","B","Linear Regression Models","preserve a model prediction after changing explanatory units",cases)

residual_contexts=[
    ("training hours", "fitness score",12,3,4,21,5,32),
    ("daily rainfall", "crop yield",7,5,3,26,4,21),
    ("advertising hours", "sales",15,4,5,31,6,44),
    ("machine temperature", "output",30,-2,6,21,8,9),
]
cases=[]
for xname,yname,a,b,x,observed,x2,observed2 in residual_contexts:
    predicted=a+b*x; resid=observed-predicted; predicted2=a+b*x2; resid2=observed2-predicted2
    larger="first" if abs(resid)>abs(resid2) else "second"
    other="second" if larger=="first" else "first"
    stem=f"A fitted line for {yname} versus {xname} is y-hat={a}{b:+d}x. The observed responses are {observed} at x={x} and {observed2} at x={x2}. Which statement correctly compares the two prediction errors?"
    choices=[f"The residuals are {resid:+d} and {resid2:+d}; the {larger} observation has the larger absolute prediction error.",f"The residuals are {-resid:+d} and {-resid2:+d}; the {larger} observation has the larger absolute prediction error.",f"The residuals are {resid:+d} and {resid2:+d}; the {other} observation has the larger absolute prediction error.",f"The residuals are the predicted responses {predicted} and {predicted2}; the larger prediction is always the larger error."]
    check=f"Predictions are {predicted} and {predicted2}. Observed minus predicted gives residuals {resid:+d} and {resid2:+d}; compare their absolute values, {abs(resid)} and {abs(resid2)}."
    reasons=["Residuals subtract predicted from observed, not observed from predicted, so both signs are reversed.","The residual values are correct, but comparing absolute errors selects the other observation.","Predicted values are not residuals; the size of a prediction does not by itself show its error."]
    cases.append((stem,choices,check,reasons))
add("5.4","A","Residuals","calculate a residual and interpret its sign in context",cases)

resid_pattern_contexts=[
    ("temperature", "electricity demand",[4,1,-2,1,4],"curve","A systematic U-shape remains, so the straight-line form misses structure."),
    ("dosage", "reaction time",[-3,0,2,0,-3],"curve","An inverted U-shape remains, so the straight-line form misses structure."),
    ("time of day", "pollution level",[-1,0,1,3,5],"trend","The residuals increase across x, so the line has a systematic bias rather than random error."),
    ("speed", "fuel use",[0,1,-1,2,-2],"spread","The residual magnitudes grow across x, so the errors have changing spread even without a curved mean pattern."),
]
cases=[]
for xname,yname,rs,pattern,correct in resid_pattern_contexts:
    vals=", ".join(f"({x},{r:+d})" for x,r in zip(range(1,6),rs))
    stem=f"For a proposed straight-line model predicting {yname} from {xname}, the residual plot gives (x, residual) values {vals}. Which assessment follows from the residual pattern?"
    choices=[correct,f"The errors for {yname} are randomly scattered because both positive and negative residuals occur.",f"The largest residual alone proves that every prediction of {yname} has the same error direction.",f"A fitted model of {yname} is useful only when every residual equals zero."]
    check=f"Read the residuals in {xname} order. The {pattern} pattern is systematic; positive and negative values alone do not establish random scatter."
    reasons=["The order across explanatory values matters; the visible systematic pattern is not erased by having both residual signs.","One residual gives the error for one observation, not the sign of every model error.","Useful fitted models can have nonzero residuals; the relevant diagnostic is their pattern and spread."]
    cases.append((stem,choices,check,reasons))
add("5.4","B","Residuals","use a residual pattern to judge a linear model",cases)

r2_contexts=[
    ("study time", "exam score",0.80,3),
    ("distance from shore", "water temperature",-0.70,-2),
    ("machine age", "output",-0.90,-4),
    ("practice sessions", "completion score",0.60,5),
]
cases=[]
for xname,yname,r,slope in r2_contexts:
    explained=round(100*r*r); sign="increase" if slope>0 else "decrease"
    stem=f"A least-squares line predicts {yname} from {xname}. Its slope is {slope:+d} response units per additional explanatory unit and r={r:+.2f}. Which interpretation combines the slope and coefficient of determination correctly?"
    choices=[f"For one more unit of {xname}, predicted {yname} tends to {sign} by {abs(slope)} units; about {explained}% of variation in {yname} is explained by its linear relationship with {xname}.",f"For one more unit of {xname}, observed {yname} must {sign} by exactly {abs(slope)} units; about {abs(round(100*r))}% of its variation is explained.",f"About {explained}% of variation in {xname} is explained by the linear relationship with {yname}, so the prediction direction can be reversed without refitting.",f"Because r is {r:+.2f}, changing {xname} causes the predicted {sign} in {yname} and explains all observed variation."]
    check=f"Slope concerns predicted response per one-unit explanatory increase. r²={r*r:.2f}, so {explained}% of variation in the response is explained by the linear relationship; neither exact outcomes nor causation follows."
    reasons=["A regression slope predicts an average change rather than a guaranteed change for each observation, and explained variation uses r squared rather than r.","The coefficient of determination describes variation in the response variable, not variation in the explanatory variable; reversing prediction changes the question.","A correlation and fitted slope alone do not establish causation or explain all variation in observed responses."]
    cases.append((stem,choices,check,reasons))
add("5.5","A","Least-Squares Regression","interpret slope and r-squared in the response direction",cases)

mean_contexts=[
    ("practice hours", "test score",4,70,5,6),
    ("weekly rainfall", "crop height",3,18,2,5),
    ("machine age", "output",6,80,-4,8),
    ("distance traveled", "fuel remaining",5,30,-3,7),
]
cases=[]
for xname,yname,xbar,ybar,b,x in mean_contexts:
    a=ybar-b*xbar; pred=a+b*x; wrong=ybar+b*x
    stem=f"Technology gives a least-squares slope of {b:+d} for predicting {yname} from {xname}. The sample means are x-bar={xbar} and y-bar={ybar}. Using the fact that the line passes through the means, what is the predicted response at x={x}?"
    choices=[f"{pred}, because the intercept is {a} and y-hat={a}{b:+d}x.",f"{wrong}, because y-bar={ybar} is the intercept of the line.",f"{ybar+b*(x-xbar)+xbar}, because x-bar must be added to the predicted response after applying the slope.",f"{ybar}, because a least-squares line predicts the sample mean at every x-value."]
    check=f"The line passes through ({xbar},{ybar}), so a={ybar}-({b})({xbar})={a}; at x={x}, y-hat={a}+({b})({x})={pred}."
    reasons=["The least-squares line passes through the two means, but its y-intercept is y-bar minus slope times x-bar, not generally y-bar.","The explanatory mean is used to solve for the intercept; it is not added to a predicted response, which has different units.","The line predicts y-bar at x-bar, not at every explanatory value when its slope is nonzero."]
    cases.append((stem,choices,check,reasons))
add("5.5","B","Least-Squares Regression","use the means and slope to recover an intercept and predict",cases)

# Extra family in every thin topic: the served pack needs twelve published items
# after retiring its R1 family or families.
cases=[]
for xname,yname,early,late in [
    ("daily temperature", "electricity demand", "roughly flat", "rises sharply"),
    ("time since planting", "plant height", "rises sharply", "roughly flat"),
    ("wind speed", "turbine output", "roughly flat", "falls sharply"),
    ("dosage", "response", "falls sharply", "roughly flat"),
]:
    stem=f"A scatterplot of {yname} against {xname} has a {early} pattern over low x-values and then {late} over high x-values, with no isolated points. A student describes the association as one straight line. Which criticism best addresses the full plot?"
    choices=["The direction and steepness change across x, so describe the form as nonlinear and report the two regions rather than one linear trend.","Because there are no isolated points, the association must be linear even when its steepness changes.","The association has no form because its low and high x regions do not have identical slopes.","Changing the explanatory variable to the vertical axis would make the two regions one straight line."]
    check="The stated low- and high-x regions have different slopes; a single straight line does not describe both. Axes should retain explanatory x and response y."
    reasons=["A lack of outliers does not make a changing slope linear.","A relationship can have a clear curved or piecewise form even when a single slope is inadequate.","Swapping axes does not remove a change in slope and reverses the explanatory/response roles."]
    cases.append((stem,choices,check,reasons))
add("5.1","C","Graphical Representations Between Two Quantitative Variables","distinguish nonlinear form from absence of isolated points",cases)

cases=[]
for xname,yname,r,shape in [
    ("time of day","solar output",0.02,"arched"),
    ("dosage","pain relief",-0.04,"inverted U-shaped"),
    ("distance from a heater","sensor reading",0.01,"U-shaped"),
    ("training load","performance",-0.03,"W-shaped"),
]:
    stem=f"A scatterplot of {yname} against {xname} has a pronounced {shape} pattern, but its computed correlation is r={r:+.2f}. A student proposes using a straight-line equation to predict every response and claims the small r proves there is no relationship. Which critique addresses both parts of the proposal?"
    choices=[f"A straight line would miss the {shape} form; the small r describes weak linear association, not absence of every association.","The correlation proves the two variables are independent, so a straight line is the only model worth testing.","The curved pattern must be a plotting error because a correlation close to zero prohibits association.","The small r guarantees that a straight line predicts each observed response exactly despite the curve."]
    check="Pearson correlation measures linear association. The stated curved form warns that a single straight-line predictor misses systematic structure even if its r is close to zero."
    reasons=["Near-zero Pearson r does not establish independence when a nonlinear pattern is visible; a line would also miss that form.","The reported r and visible curvature can coexist because r describes only the linear component.","A small |r| does not guarantee small residuals; the visible curve is evidence against exact line predictions."]
    cases.append((stem,choices,check,reasons))
add("5.2","C","Correlation","interpret a small r alongside a nonlinear scatterplot",cases)

cases=[]
for xname,yname,lo,hi,a,b,x1,x2 in [
    ("age of equipment","repair cost",2,8,20,6,5,11),
    ("practice sessions","score",1,10,42,4,7,14),
    ("weeks after planting","height",1,8,5,3,6,12),
    ("distance from shore","temperature",1,9,25,-2,4,13),
]:
    p1=a+b*x1; p2=a+b*x2
    stem=f"A least-squares line y-hat={a}{b:+d}x was fitted using {xname} values from {lo} through {hi} to predict {yname}. A report uses it at x={x1} and x={x2}. Which assessment correctly compares the two predictions?"
    choices=[f"The predictions are {p1} and {p2}; the first is interpolation, while the second extrapolates and deserves more caution.",f"The predictions are {p1} and {p2}; both are interpolation because the equation accepts both inputs.",f"The predictions are {p1} and {p2}; both are equally reliable because the fitted slope is constant.",f"Only the first prediction, {p1}, can be calculated; extrapolation makes the second value undefined."]
    check=f"Substituting the given x-values gives {p1} and {p2}. {x1} is inside [{lo},{hi}], while {x2} exceeds {hi}; numerical evaluation is possible but extrapolation is less dependable."
    reasons=["The second x-value is outside the observed range, so it is extrapolation.","A constant fitted slope does not guarantee a straight-line relationship beyond observed x-values.","Extrapolation still yields a numerical value; its reliability, not its algebraic existence, is in doubt."]
    cases.append((stem,choices,check,reasons))
add("5.3","C","Linear Regression Models","compare interpolation and extrapolation from one model",cases)

cases=[]
for xname,yname,r1,r2 in [
    ("temperature","energy use",[3,1,-2,1,3],[1,-1,0,1,-1]),
    ("dosage","reaction time",[-4,-1,2,-1,-4],[-1,1,0,-1,1]),
    ("speed","fuel use",[5,2,-1,2,5],[0,1,-1,0,1]),
    ("time","pollution",[-3,0,2,0,-3],[1,0,-1,1,0]),
]:
    stem=f"Two candidate models predict {yname} from {xname}. At five increasing x-values, model A has residuals {r1}, and model B has residuals {r2}. Which judgment about form follows from these residuals?"
    choices=[f"Model B has the more appropriate form for {yname}: A leaves a systematic curve across {xname}, whereas B's residuals fluctuate around zero.",f"Model A has the better form for {yname} because an orderly curve of residuals is desirable.","Both forms are equally supported because each list contains positive and negative residuals.","Neither form can be used because a fitted model must make every residual exactly zero."]
    check="Model A's endpoint and middle residuals trace a repeated high-low-high or low-high-low shape. B's signs fluctuate without that curve; zero residual at every point is unnecessary."
    reasons=["The orderly curve is evidence that A misses systematic structure, not evidence in its favor.","Having both signs is not enough; the order of residuals across x reveals A's pattern.","Residuals need not all be zero for a model to be useful; random scatter is the relevant form check."]
    cases.append((stem,choices,check,reasons))
add("5.4","C","Residuals","compare two candidate models using ordered residuals",cases)

cases=[]
for xname,yname,xbar,ybar,slope,delta in [
    ("study hours","score",4,70,5,2),
    ("machine age","output",6,80,-4,3),
    ("distance traveled","fuel remaining",5,30,-3,2),
    ("weekly rainfall","crop height",3,18,2,4),
]:
    pred=ybar+slope*delta
    stem=f"A least-squares line predicting {yname} from {xname} has slope {slope:+d} and passes through the sample means ({xbar},{ybar}). A student predicts at x={xbar+delta} by adding the slope directly to y-bar. What is the correct prediction and why?"
    choices=[f"{pred}; the x-value is {delta} units above x-bar, so the change from y-bar is {slope} times {delta}.",f"{ybar+slope}; the slope is added once whenever x exceeds its mean.",f"{ybar+slope*(xbar+delta)}; y-bar is the intercept for every least-squares line.",f"{ybar}; the mean response is the prediction at every x because the line passes through the means."]
    check=f"Use point-slope form y-hat={ybar}+({slope})(x-{xbar}). At x={xbar+delta}, y-hat={pred}. The slope multiplies change in x from x-bar."
    reasons=["The slope is a response change per one x-unit; the x-change here is not one.","The least-squares line passes through the means, so y-bar is its value at x-bar, not usually its intercept.","The line predicts y-bar at x-bar only; its slope is nonzero."]
    cases.append((stem,choices,check,reasons))
add("5.5","C","Least-Squares Regression","use point-slope reasoning around the sample means",cases)

OUT.write_text("\n\n".join(blocks) + "\n")
print(OUT)
