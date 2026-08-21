# AP Physics 1 Unit 1 Topic Point Briefs

Status: Draft content system seed for new-user home and unit selector planning.

Purpose: preserve Cramapple-original topic point brief content for AP
Physics 1 Unit 1 (Kinematics, algebra-based). These briefs help a new
student understand how each topic turns into point-attainment behavior
without replacing a full lesson.

Source basis: AP Physics 1: Algebra-Based Course and Exam Description, plus
the local CED fact pack in `docs/product/AP_PHYSICS_1_CED_FACT_PACK.md`
(Unit 1 deep-tier detail, including verbatim CED boundary statements).

Content rules: same as `docs/product/AP_CHEMISTRY_UNIT1_TOPIC_POINT_BRIEFS.md`
and the original Calculus/Biology Unit 1 briefs — no external links, no
copied third-party language, subject- and topic-specific, concept tied to
point-earning behavior.

Course note: AP Physics 1 never uses derivative or integral notation.
Instantaneous velocity/acceleration are defined as the limit of an average
over a very small time interval, described in words. Contrast with
AP Physics C: Mechanics, which treats the same quantities as true
derivatives (see the companion Physics C: Mechanics Unit 1 brief file).

## Type

```ts
type Importance = "not-important" | "somewhat-important" | "very-important";

type TopicPointBrief = {
  unitId: string;
  topicId: string;
  title: string;
  classImportance: Importance;
  examImportance: Importance;
  whatItIs: string;
  whyItMatters: string;
  howPointsAreEarned: string;
  answerMove: string;
  commonPointLoss: string;
  learnMorePath: string;
  practiceParams: {
    subject: string;
    unit: string;
    topic: string;
  };
};
```

## Unit 1 Seed Content

```ts
const apPhysics1Unit1TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-1",
    topicId: "1.1",
    title: "Scalars and Vectors in One Dimension",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A scalar is a quantity with only a size (like speed or distance), while a vector has both size and direction (like velocity or displacement). In one dimension, direction collapses down to a plus or minus sign along a chosen axis.",
    whyItMatters:
      "Every kinematics equation you'll use this unit depends on getting signs right. If you can't tell a scalar from a vector, you'll add speeds when you should be subtracting velocities, and every later unit (forces, momentum, energy) builds on this same signed-quantity habit.",
    howPointsAreEarned:
      "Credit comes from consistently assigning and using a sign convention (e.g., positive = rightward or upward) for every vector quantity in a problem, and from correctly identifying which given quantities are scalars (speed, distance, time) versus vectors (velocity, displacement, acceleration).",
    answerMove:
      "Before solving, state your positive direction in words or with an arrow, then attach the correct sign to every velocity, displacement, and acceleration value you write down — a bare number without an implied or stated sign is not a complete vector value in 1-D.",
    commonPointLoss:
      "Treating speed and velocity as interchangeable, or dropping the negative sign on a value once it's plugged into an equation.",
    learnMorePath: "/learn/ap-physics-1/unit-1/scalars-and-vectors",
    practiceParams: { subject: "ap_physics_1", unit: "1", topic: "1.1" },
  },
  {
    unitId: "unit-1",
    topicId: "1.2",
    title: "Displacement, Velocity, and Acceleration",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Displacement (Δx = x − x0) is the change in position; average velocity is displacement divided by elapsed time (Δx/Δt); average acceleration is the change in velocity divided by elapsed time (Δv/Δt). Instantaneous velocity and acceleration are what those averages approach as you shrink the time interval to something very small.",
    whyItMatters:
      "These three definitions are the vocabulary every other kinematics topic is written in — the constant-acceleration equations, the graph slopes, and the relative-motion rules in this unit all reduce back to Δx/Δt and Δv/Δt.",
    howPointsAreEarned:
      "Points come from correctly computing Δx, Δv, average velocity, or average acceleration from given position/velocity/time data, and from correctly distinguishing an instantaneous value (read at one moment) from an average value (computed over an interval).",
    answerMove:
      "When a problem gives you two positions or two velocities at two different times, explicitly compute the change (final minus initial) before dividing by Δt — don't skip straight to a memorized formula without showing the subtraction that defines it.",
    commonPointLoss:
      "Reporting a velocity or acceleration found from a slope calculation as if it were instantaneous when the problem actually asked for (or gave data for) an average over an interval.",
    learnMorePath: "/learn/ap-physics-1/unit-1/displacement-velocity-acceleration",
    practiceParams: { subject: "ap_physics_1", unit: "1", topic: "1.2" },
  },
  {
    unitId: "unit-1",
    topicId: "1.3",
    title: "Representing Motion",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "This topic covers the three constant-acceleration kinematic equations (v = v0 + at; x = x0 + v0t + ½at²; v² = v0² + 2a(x − x0)) and how motion appears on position-time, velocity-time, and acceleration-time graphs — slopes give instantaneous rates, and areas give net changes.",
    whyItMatters:
      "Most quantitative kinematics problems on the exam are solved by picking the one correct equation from this set or by reading a value off a graph, so fluency here is the single biggest lever for points in this unit.",
    howPointsAreEarned:
      "Points require selecting the kinematic equation that matches the known and unknown quantities, substituting correctly, and — for graph items — correctly matching slope-of-x-t to velocity, slope-of-v-t to acceleration, area-under-v-t to displacement, and area-under-a-t to change in velocity; nonuniform-acceleration graphs are scored on qualitative shape/reasoning, not on plugging into the three equations.",
    answerMove:
      "Before using v = v0 + at, x = x0 + v0t + ½at², or v² = v0² + 2a(x − x0), confirm acceleration is actually constant over the interval in question — if the acceleration is changing, switch to reading slopes and areas off the graph instead, since these three equations don't apply there.",
    commonPointLoss:
      "Plugging numbers into a constant-acceleration equation for a motion segment where the acceleration is actually changing, instead of switching to graphical/qualitative reasoning.",
    learnMorePath: "/learn/ap-physics-1/unit-1/representing-motion",
    practiceParams: { subject: "ap_physics_1", unit: "1", topic: "1.3" },
  },
  {
    unitId: "unit-1",
    topicId: "1.4",
    title: "Reference Frames and Relative Motion",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A reference frame is the viewpoint (moving or stationary) from which motion is measured. Acceleration comes out the same in every inertial frame, but velocity does not — an object's velocity in one frame differs from its velocity in another by the relative velocity between the frames.",
    whyItMatters:
      "Problems describing motion 'as seen from' a moving platform (a walkway, a train, another car) only make sense once you recognize that velocities must be combined between frames while accelerations transfer over unchanged.",
    howPointsAreEarned:
      "Points come from correctly adding or subtracting one-dimensional velocities to convert between reference frames, and from correctly stating that the acceleration of an object is the same as measured in any inertial frame.",
    answerMove:
      "When a problem gives motion relative to a moving frame (like a person walking on a moving walkway) restricted to one dimension, add the object's velocity in that frame to the frame's own velocity (with correct signs) to get velocity in the ground frame — do not attempt this as a 2-D vector-addition problem, since 2-D relative-velocity situations are outside this course.",
    commonPointLoss:
      "Trying to combine relative velocities using two-dimensional vector addition (like a boat crossing a river) when this course only holds students responsible for one-dimensional relative motion.",
    learnMorePath: "/learn/ap-physics-1/unit-1/reference-frames-relative-motion",
    practiceParams: { subject: "ap_physics_1", unit: "1", topic: "1.4" },
  },
  {
    unitId: "unit-1",
    topicId: "1.5",
    title: "Vectors and Motion in Two Dimensions",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Two-dimensional motion, most often projectile motion, is analyzed by resolving vectors into perpendicular components using right-triangle trigonometry (sinθ, cosθ, tanθ, and the Pythagorean relationship), then treating each axis as its own independent one-dimensional motion problem.",
    whyItMatters:
      "Projectile motion is the main way the course tests whether you can combine vector resolution with the kinematics equations from 1.3, since horizontal and vertical motion happen simultaneously but must be solved separately.",
    howPointsAreEarned:
      "Points come from correctly resolving an initial velocity into horizontal and vertical components, recognizing horizontal acceleration is zero while vertical acceleration is constant (g = 10 m/s², or 9.8/9.81 m/s² without penalty), and solving each axis with the appropriate 1-D kinematic equation before recombining results if needed.",
    answerMove:
      "For projectile motion, split the initial velocity into vx = v·cosθ and vy = v·sinθ immediately, then solve the vertical axis (constant acceleration g) and horizontal axis (constant velocity) as two separate 1-D kinematics problems linked only by a shared time variable.",
    commonPointLoss:
      "Using the initial launch speed directly in a kinematics equation instead of first resolving it into horizontal and vertical components.",
    learnMorePath: "/learn/ap-physics-1/unit-1/vectors-and-2d-motion",
    practiceParams: { subject: "ap_physics_1", unit: "1", topic: "1.5" },
  },
];
```
