# AP Physics C: Mechanics Unit 1 Topic Point Briefs

Status: Draft content system seed for new-user home and unit selector planning.

Purpose: preserve Cramapple-original topic point brief content for AP
Physics C: Mechanics Unit 1 (Kinematics, calculus-based). These briefs help
a new student understand how each topic turns into point-attainment
behavior without replacing a full lesson.

Source basis: AP Physics C: Mechanics Course and Exam Description, plus the
local CED fact pack in `docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md`
(Unit 1 deep-tier detail, including verbatim CED boundary statements and
verified differences from the algebra-based AP Physics 1 treatment of the
same topic names).

Content rules: same as the AP Chemistry / Calculus / Biology Unit 1 briefs —
no external links, no copied third-party language, subject- and
topic-specific, concept tied to point-earning behavior.

Course note: unlike AP Physics 1, this course treats instantaneous velocity
and acceleration as true derivatives (v = dr/dt, a = dv/dt) and uses integral
definitions for displacement and velocity change under non-constant
acceleration. Two-dimensional relative-velocity vector addition is in scope
here even though it is restricted to one dimension in AP Physics 1.

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
const apPhysicsCMechanicsUnit1TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-1",
    topicId: "1.1",
    title: "Scalars and Vectors",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A scalar is a quantity fully described by a magnitude alone (like speed or distance), while a vector requires both magnitude and direction (like velocity or displacement). In this course vectors are written in unit vector notation, r = A*i_hat + B*j_hat + C*k_hat, and combined by adding or subtracting their components separately.",
    whyItMatters:
      "Every kinematics quantity you build for the rest of Unit 1 — displacement, velocity, acceleration — is a vector, so component notation is the language the rest of the unit is written in. Getting comfortable decomposing and recombining vectors here is what makes 2D motion and relative motion problems tractable later.",
    howPointsAreEarned:
      "Points come from correctly resolving a given vector into i_hat/j_hat (and k_hat, if 3D) components, then adding or subtracting component-by-component to find a resultant — not from stating a final magnitude without showing the component work.",
    answerMove:
      "When asked for a resultant vector, add or subtract the i_hat, j_hat, and k_hat components separately before recombining, and keep each component's sign tied to its assigned axis direction throughout.",
    commonPointLoss:
      "Combining vector magnitudes directly (like adding lengths) instead of adding matching components separately.",
    learnMorePath: "/learn/ap-physics-c-mechanics/unit-1/scalars-and-vectors",
    practiceParams: { subject: "ap_physics_c_mechanics", unit: "1", topic: "1.1" },
  },
  {
    unitId: "unit-1",
    topicId: "1.2",
    title: "Displacement, Velocity, and Acceleration",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Displacement, average velocity (Δx/Δt), and average acceleration (Δv/Δt) describe motion over a finite time interval, but instantaneous velocity and acceleration are true derivatives: v = dr/dt (or v_x = dx/dt) and a = dv/dt (or a_x = dv_x/dt). This is the calculus-based definition — position, velocity, and acceleration are treated as functions of time that can be differentiated or integrated into one another.",
    whyItMatters:
      "This derivative relationship is the foundation the entire mechanics course is built on: forces, energy, and momentum problems all eventually come back to differentiating or integrating a position or velocity function. Unlike the algebra-based course, you're expected to work with x(t), v(t), and a(t) as genuine functions, not just plug numbers into formulas.",
    howPointsAreEarned:
      "Points are earned by correctly taking dx/dt or dv/dt of a given position or velocity function (or integrating in the reverse direction), and by clearly identifying whether a question is asking for an average quantity (Δx/Δt) versus an instantaneous one (dx/dt) — these are graded as distinct calculations.",
    answerMove:
      "When a position or velocity function is given as an explicit expression in t, differentiate it directly to get instantaneous velocity or acceleration — do not fall back on Δx/Δt or Δv/Δt average-rate formulas, which only apply when you're working from two data points, not a continuous function.",
    commonPointLoss:
      "Using the average velocity or average acceleration formula when the question actually asks for an instantaneous value at a specific time.",
    learnMorePath: "/learn/ap-physics-c-mechanics/unit-1/displacement-velocity-acceleration",
    practiceParams: { subject: "ap_physics_c_mechanics", unit: "1", topic: "1.2" },
  },
  {
    unitId: "unit-1",
    topicId: "1.3",
    title: "Representing Motion",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Under constant acceleration, motion is described by the familiar kinematic equations (v = v0 + at, x = x0 + v0t + ½at², v² = v0² + 2a(x − x0)). When acceleration or velocity is NOT constant, position and velocity changes are instead found from the integral definitions Δx = ∫v(t)dt and Δv = ∫a(t)dt — setting up and evaluating the correct integral over the given time interval.",
    whyItMatters:
      "Released free-response questions in this unit consistently reward setting up the correct integral for a changing quantity over plugging into a memorized formula, so recognizing which regime you're in (constant vs. non-constant acceleration) is the central skill of the unit.",
    howPointsAreEarned:
      "Points are earned by first identifying whether acceleration is constant (justifying use of the kinematic equations) or a function of time (requiring Δx = ∫v(t)dt or Δv = ∫a(t)dt), then executing the correct algebra or integral with correct limits of integration, and using g ≈ 10 m/s² unless told otherwise.",
    answerMove:
      "Before choosing a method, check whether acceleration is stated or shown to be constant; if it is not constant, set up Δx = ∫v(t)dt or Δv = ∫a(t)dt with the correct time bounds instead of reaching for the constant-acceleration equations, which do not apply.",
    commonPointLoss:
      "Applying the constant-acceleration kinematic equations to a situation where acceleration is explicitly given as a function of time.",
    learnMorePath: "/learn/ap-physics-c-mechanics/unit-1/representing-motion",
    practiceParams: { subject: "ap_physics_c_mechanics", unit: "1", topic: "1.3" },
  },
  {
    unitId: "unit-1",
    topicId: "1.4",
    title: "Reference Frames and Relative Motion",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "The reference frame you choose determines the magnitude and direction you measure for a moving object's velocity; converting a measurement from one inertial frame to another is done by vector addition or subtraction. Acceleration, however, is the same in every inertial frame. Unless a problem says otherwise, assume the frame given is inertial. Unlike the algebra-based course, relative-velocity vector addition here is not restricted to one dimension — full two-dimensional relative-velocity scenarios (such as a boat crossing a moving river) are in scope.",
    whyItMatters:
      "Relative motion problems test whether you can treat velocities as vectors that add and subtract across frames rather than as plain numbers, which becomes essential once 2D motion and later force/momentum problems involve multiple moving reference points.",
    howPointsAreEarned:
      "Points are earned by correctly setting up a vector equation relating the object's velocity in one frame to its velocity in another (e.g., v_object/ground = v_object/frame + v_frame/ground) and resolving it by components when the motion is two-dimensional, not by combining speeds as scalars.",
    answerMove:
      "For a relative-velocity problem, write the vector equation linking the two frames component-by-component (including both dimensions when the scenario is 2D, such as a boat-and-current problem) rather than adding or subtracting speeds directly.",
    commonPointLoss:
      "Adding relative velocities as plain numbers instead of as vectors, which drops the perpendicular component of motion entirely.",
    learnMorePath: "/learn/ap-physics-c-mechanics/unit-1/reference-frames-relative-motion",
    practiceParams: { subject: "ap_physics_c_mechanics", unit: "1", topic: "1.4" },
  },
  {
    unitId: "unit-1",
    topicId: "1.5",
    title: "Motion in Two or Three Dimensions",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Motion in two dimensions is analyzed by splitting it into independent one-dimensional components along each axis — each axis can have its own velocity and acceleration, and a change in motion along one axis does not affect the other. Projectile motion is the standard case: zero acceleration in one direction and constant nonzero acceleration (gravity) in the perpendicular direction. This course's quantitative ceiling is two dimensions; three-dimensional motion is only expected to be described qualitatively, not calculated.",
    whyItMatters:
      "Nearly every 2D exam question in this unit — projectiles, launched objects, curved paths — is really two separate 1D kinematics problems solved in parallel, so treating the axes as independent is what makes these problems manageable instead of overwhelming.",
    howPointsAreEarned:
      "Points are earned by explicitly separating the motion into x- and y-components, applying the correct kinematic or integral relationship independently to each axis, and only recombining components (e.g., for a final speed or direction) at the end.",
    answerMove:
      "Set up separate equations for each axis using that axis's own acceleration and initial velocity before solving, and only combine the two results at the very last step when a single resultant quantity (like speed or range) is requested.",
    commonPointLoss:
      "Letting the acceleration or time used in one direction's equation leak into the other direction's calculation instead of keeping the two axes fully separate.",
    learnMorePath: "/learn/ap-physics-c-mechanics/unit-1/motion-in-two-or-three-dimensions",
    practiceParams: { subject: "ap_physics_c_mechanics", unit: "1", topic: "1.5" },
  },
];
```
