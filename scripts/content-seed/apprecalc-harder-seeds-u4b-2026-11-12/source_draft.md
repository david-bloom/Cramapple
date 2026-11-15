# AP Precalculus topics 4.8 to 4.14: new seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. All matrix, vector and rate values recomputed in Python.
Scope: the published pool has no practice MCQs for Unit 4 topics 4.8 to 4.14, and the unit is not assessed on the AP exam, so there is one R3 or multi-step R2 seed per topic, each with three variants.
Target level: vector magnitude and direction in context, motion from component rates, matrix dimension and meaning, inverse and determinant, composition order, area scaling and orientation, and two-step transition predictions.

| Seed | Topic | Replaces |
|---|---|---|
| N-4.8-A | 4.8 Vectors | new |
| N-4.9-A | 4.9 Vector-Valued Functions | new |
| N-4.10-A | 4.10 Matrices | new |
| N-4.11-A | 4.11 The Inverse and Determinant of a Matrix | new |
| N-4.12-A | 4.12 Linear Transformations and Matrices | new |
| N-4.13-A | 4.13 Matrices as Functions | new |
| N-4.14-A | 4.14 Matrices Modeling Contexts | new |

---

## Seed N-4.8-A (new) — Topic 4.8 Vectors
**Skill:** combine two perpendicular velocity vectors, then find the resulting speed (magnitude) and direction without adding magnitudes.

A boat's velocity relative to the water is ⟨6, 0⟩ km/h (due east), and the river current's velocity is ⟨0, -8⟩ km/h (due south). Relative to the ground, what are the boat's speed and direction?

- A. 14 km/h, 53.1° south of east
- B. 10 km/h, 36.9° south of east
- **C. 10 km/h, 53.1° south of east**
- D. 10 km/h, 53.1° north of east

Check: the ground velocity is ⟨6, -8⟩, with magnitude √(6² + 8²) = 10 and direction arctan(8/6) ≈ 53.1° south of east.
Rationales: A: adding the magnitudes 6 and 8 gives 14, but perpendicular vectors combine with the Pythagorean theorem, so the speed is 10. B: the speed 10 is right, but the angle below the east axis is arctan(8/6) = 53.1°; 36.9° comes from dividing the components the wrong way round. D: the speed and angle size are right, but the current points south, so the second component pushes the boat south and not north.

**N-4.8-A-v1.** A drone's velocity relative to the air is ⟨5, 0⟩ m/s (due east), and the wind's velocity is ⟨0, -12⟩ m/s (due south). Relative to the ground, what are the drone's speed and direction?

- **A. 13 m/s, 67.4° south of east**
- B. 17 m/s, 67.4° south of east
- C. 13 m/s, 22.6° south of east
- D. 13 m/s, 67.4° north of east

Check: the ground velocity is ⟨5, -12⟩, with magnitude √(5² + 12²) = 13 and direction arctan(12/5) ≈ 67.4° south of east.
Rationales: B: adding the magnitudes 5 and 12 gives 17, but perpendicular vectors combine with the Pythagorean theorem, so the speed is 13. C: the speed 13 is right, but the angle below the east axis is arctan(12/5) = 67.4°; 22.6° comes from dividing the components the wrong way round. D: the speed and angle size are right, but the current points south, so the second component pushes the boat south and not north.

**N-4.8-A-v2.** A kayaker paddles with velocity ⟨8, 0⟩ km/h relative to the water (due east) in a tidal current of velocity ⟨0, 15⟩ km/h (due north). Relative to the shore, what are the kayaker's speed and direction?

- A. 23 km/h, 61.9° north of east
- B. 17 km/h, 28.1° north of east
- C. 17 km/h, 61.9° south of east
- **D. 17 km/h, 61.9° north of east**

Check: the ground velocity is ⟨8, 15⟩, with magnitude √(8² + 15²) = 17 and direction arctan(15/8) ≈ 61.9° north of east.
Rationales: A: adding the magnitudes 8 and 15 gives 23, but perpendicular vectors combine with the Pythagorean theorem, so the speed is 17. B: the speed 17 is right, but the angle below the east axis is arctan(15/8) = 61.9°; 28.1° comes from dividing the components the wrong way round. C: the speed and angle size are right, but the current points north, so the second component pushes the boat north and not south.

**N-4.8-A-v3.** A ferry's velocity relative to the water is ⟨7, 0⟩ knots (due east), and the current's velocity is ⟨0, -24⟩ knots (due south). Relative to the sea floor, what are the ferry's speed and direction?

- A. 31 knots, 73.7° south of east
- **B. 25 knots, 73.7° south of east**
- C. 25 knots, 16.3° south of east
- D. 25 knots, 73.7° north of east

Check: the ground velocity is ⟨7, -24⟩, with magnitude √(7² + 24²) = 25 and direction arctan(24/7) ≈ 73.7° south of east.
Rationales: A: adding the magnitudes 7 and 24 gives 31, but perpendicular vectors combine with the Pythagorean theorem, so the speed is 25. C: the speed 25 is right, but the angle below the east axis is arctan(24/7) = 73.7°; 16.3° comes from dividing the components the wrong way round. D: the speed and angle size are right, but the current points south, so the second component pushes the boat south and not north.

---

## Seed N-4.9-A (new) — Topic 4.9 Vector-Valued Functions
**Skill:** use the derivative of each component of a vector-valued position function to decide when the motion is rightward and upward, without confusing position with velocity.

A drone's position, in meters, at time t seconds (0 ≤ t ≤ 12) is r(t) = ⟨t² − 6t, 12t − t²⟩, with x measured east and y measured north. For which times is the drone moving east and north at the same time?

- **A. 3 < t < 6**
- B. t > 3
- C. 0 < t < 6
- D. t > 6

Check: the velocity is r′(t) = ⟨2t − 6, 12 − 2t⟩; the first component is positive for t > 3 and the second for t < 6, so both hold for 3 < t < 6.
Rationales: B: x′(t) = 2t − 6 is positive for t > 3, so the object is moving east, but y′(t) = 12 − 2t is negative once t > 6, so it stops moving north. C: y′(t) = 12 − 2t is positive for t < 6, so it is moving north, but x′(t) = 2t − 6 is negative until t = 3, so it is moving west at first. D: t > 6 is where the position x(t) = t² − 6t is positive, which says where the object is east of the origin, not where it is moving east.

**N-4.9-A-v1.** A robot's position, in meters, at time t seconds (0 ≤ t ≤ 18) is r(t) = ⟨t² − 4t, 18t − t²⟩, with x measured east and y measured north. For which times is the robot moving east and north at the same time?

- A. t > 2
- **B. 2 < t < 9**
- C. 0 < t < 9
- D. t > 4

Check: the velocity is r′(t) = ⟨2t − 4, 18 − 2t⟩; the first component is positive for t > 2 and the second for t < 9, so both hold for 2 < t < 9.
Rationales: A: x′(t) = 2t − 4 is positive for t > 2, so the object is moving east, but y′(t) = 18 − 2t is negative once t > 9, so it stops moving north. C: y′(t) = 18 − 2t is positive for t < 9, so it is moving north, but x′(t) = 2t − 4 is negative until t = 2, so it is moving west at first. D: t > 4 is where the position x(t) = t² − 4t is positive, which says where the object is east of the origin, not where it is moving east.

**N-4.9-A-v2.** A ball rolling across a table has position, in centimeters, r(t) = ⟨t² − 10t, 16t − t²⟩ for 0 ≤ t ≤ 16, with x to the right and y up. For which times is the ball moving right and up at the same time?

- A. t > 5
- B. 0 < t < 8
- **C. 5 < t < 8**
- D. t > 10

Check: the velocity is r′(t) = ⟨2t − 10, 16 − 2t⟩; the first component is positive for t > 5 and the second for t < 8, so both hold for 5 < t < 8.
Rationales: A: x′(t) = 2t − 10 is positive for t > 5, so the object is moving east, but y′(t) = 16 − 2t is negative once t > 8, so it stops moving north. B: y′(t) = 16 − 2t is positive for t < 8, so it is moving north, but x′(t) = 2t − 10 is negative until t = 5, so it is moving west at first. D: t > 10 is where the position x(t) = t² − 10t is positive, which says where the object is east of the origin, not where it is moving east.

**N-4.9-A-v3.** A skater's position, in meters, at time t seconds (0 ≤ t ≤ 20) is r(t) = ⟨t² − 6t, 20t − t²⟩, with x measured east and y measured north. For which times is the skater moving east and north at the same time?

- A. t > 3
- B. 0 < t < 10
- C. t > 6
- **D. 3 < t < 10**

Check: the velocity is r′(t) = ⟨2t − 6, 20 − 2t⟩; the first component is positive for t > 3 and the second for t < 10, so both hold for 3 < t < 10.
Rationales: A: x′(t) = 2t − 6 is positive for t > 3, so the object is moving east, but y′(t) = 20 − 2t is negative once t > 10, so it stops moving north. B: y′(t) = 20 − 2t is positive for t < 10, so it is moving north, but x′(t) = 2t − 6 is negative until t = 3, so it is moving west at first. C: t > 6 is where the position x(t) = t² − 6t is positive, which says where the object is east of the origin, not where it is moving east.

---

## Seed N-4.10-A (new) — Topic 4.10 Matrices
**Skill:** check dimension compatibility for a matrix product in context and interpret the dimensions and entries of the result.

A bakery chain's weekly sales matrix S has rows for 2 stores and columns for 3 products, so S = [10 20 5; 8 0 12] counts items sold. The price matrix P = [3; 2; 4] lists the price in dollars of each product. Which statement about computing the weekly revenue of each store is correct?

- A. PS is defined and gives the same totals, because matrix products can be taken in either order.
- B. SP is defined, is 3×1, and gives one total for each of the 3 columns of S.
- C. SP is undefined, because S has 2 rows while P has 3 rows.
- **D. SP is defined, is 2×1, and equals [90; 72], with one entry for each of the 2 rows of S.**

Check: S is 2×3 and P is 3×1, so SP is defined and 2×1: row 1: 10·3 + 20·2 + 5·4 = 90. row 2: 8·3 + 0·2 + 12·4 = 72.
Rationales: A: P is 3×1 and S is 2×3, so in PS the inner dimensions are 1 and 2, which do not match; PS is undefined, and products are not commutative anyway. B: the product of an 2×3 matrix and a 3×1 matrix has 2 rows and 1 column, so it has one entry for each row of S and not for each column. C: the rule for a product is that the number of columns of S (3) equals the number of rows of P (3); the row counts need not match.

**N-4.10-A-v1.** A café tracks hours worked with a matrix S whose rows are 3 employees and whose columns are 2 shifts, so S = [4 6; 5 2; 0 9]. The pay matrix P = [7; 3] gives the hourly wage in dollars for each shift. Which statement about computing each employee's total pay is correct?

- **A. SP is defined, is 3×1, and equals [46; 41; 27], with one entry for each of the 3 rows of S.**
- B. PS is defined and gives the same totals, because matrix products can be taken in either order.
- C. SP is defined, is 2×1, and gives one total for each of the 2 columns of S.
- D. SP is undefined, because S has 3 rows while P has 2 rows.

Check: S is 3×2 and P is 2×1, so SP is defined and 3×1: row 1: 4·7 + 6·3 = 46. row 2: 5·7 + 2·3 = 41. row 3: 0·7 + 9·3 = 27.
Rationales: B: P is 2×1 and S is 3×2, so in PS the inner dimensions are 1 and 3, which do not match; PS is undefined, and products are not commutative anyway. C: the product of an 3×2 matrix and a 2×1 matrix has 3 rows and 1 column, so it has one entry for each row of S and not for each column. D: the rule for a product is that the number of columns of S (2) equals the number of rows of P (2); the row counts need not match.

**N-4.10-A-v2.** A warehouse records shipments in a matrix S with rows for 2 trucks and columns for 4 goods, so S = [2 1 0 3; 4 5 1 0] counts crates. The weight matrix P = [5; 8; 2; 1] gives the weight in kilograms of one crate of each good. Which statement about computing the total weight carried by each truck is correct?

- A. PS is defined and gives the same totals, because matrix products can be taken in either order.
- B. SP is defined, is 4×1, and gives one total for each of the 4 columns of S.
- **C. SP is defined, is 2×1, and equals [21; 62], with one entry for each of the 2 rows of S.**
- D. SP is undefined, because S has 2 rows while P has 4 rows.

Check: S is 2×4 and P is 4×1, so SP is defined and 2×1: row 1: 2·5 + 1·8 + 0·2 + 3·1 = 21. row 2: 4·5 + 5·8 + 1·2 + 0·1 = 62.
Rationales: A: P is 4×1 and S is 2×4, so in PS the inner dimensions are 1 and 2, which do not match; PS is undefined, and products are not commutative anyway. B: the product of an 2×4 matrix and a 4×1 matrix has 2 rows and 1 column, so it has one entry for each row of S and not for each column. D: the rule for a product is that the number of columns of S (4) equals the number of rows of P (4); the row counts need not match.

**N-4.10-A-v3.** A theater's ticket matrix S has rows for 3 shows and columns for 2 ticket types, so S = [6 1; 2 3; 4 4] counts tickets sold. The price matrix P = [10; 5] lists the price in dollars of each ticket type. Which statement about computing the revenue from each show is correct?

- A. PS is defined and gives the same totals, because matrix products can be taken in either order.
- **B. SP is defined, is 3×1, and equals [65; 35; 60], with one entry for each of the 3 rows of S.**
- C. SP is defined, is 2×1, and gives one total for each of the 2 columns of S.
- D. SP is undefined, because S has 3 rows while P has 2 rows.

Check: S is 3×2 and P is 2×1, so SP is defined and 3×1: row 1: 6·10 + 1·5 = 65. row 2: 2·10 + 3·5 = 35. row 3: 4·10 + 4·5 = 60.
Rationales: A: P is 2×1 and S is 3×2, so in PS the inner dimensions are 1 and 3, which do not match; PS is undefined, and products are not commutative anyway. C: the product of an 3×2 matrix and a 2×1 matrix has 3 rows and 1 column, so it has one entry for each row of S and not for each column. D: the rule for a product is that the number of columns of S (2) equals the number of rows of P (2); the row counts need not match.

---

## Seed N-4.11-A (new) — Topic 4.11 The Inverse and Determinant of a Matrix
**Skill:** solve a 2×2 linear system AX = B with the inverse matrix, using the determinant and the correct adjugate.

The system 3x + y = 5 and 4x + 2y = 6 is written as AX = B with A = [3 1; 4 2], X = [x; y], and B = [5; 6]. Which ordered pair (x, y) solves it?

- A. (4, -2)
- **B. (2, -1)**
- C. (-2, 1)
- D. (-7, 6.5)

Check: det A = 3·2 − 1·4 = 2, A⁻¹ = (1/2)[2 -1; -4 3], and X = A⁻¹B = [2; -1].
Rationales: A: this uses the adjugate [2 -1; -4 3] but forgets to divide by the determinant 2, so each coordinate is 2 times too large. C: this uses the negative of the inverse, because the diagonal entries were negated as well as the off-diagonal entries, which reverses the sign of the solution. D: this puts the negated entries in the wrong places, using −c in the top right and −b in the bottom left, which is the transpose of the correct adjugate and so not the inverse of A.

**N-4.11-A-v1.** The system 4x + 3y = 10 and 2x + 2y = 6 is written as AX = B with A = [4 3; 2 2], X = [x; y], and B = [10; 6]. Which ordered pair (x, y) solves it?

- A. (2, 4)
- B. (-1, -2)
- C. (4, -3)
- **D. (1, 2)**

Check: det A = 4·2 − 3·2 = 2, A⁻¹ = (1/2)[2 -3; -2 4], and X = A⁻¹B = [1; 2].
Rationales: A: this uses the adjugate [2 -3; -2 4] but forgets to divide by the determinant 2, so each coordinate is 2 times too large. B: this uses the negative of the inverse, because the diagonal entries were negated as well as the off-diagonal entries, which reverses the sign of the solution. C: this puts the negated entries in the wrong places, using −c in the top right and −b in the bottom left, which is the transpose of the correct adjugate and so not the inverse of A.

**N-4.11-A-v2.** The system 2x + 5y = 1 and 1x + 4y = -1 is written as AX = B with A = [2 5; 1 4], X = [x; y], and B = [1; -1]. Which ordered pair (x, y) solves it?

- **A. (3, -1)**
- B. (9, -3)
- C. (-3, 1)
- D. (5/3, -7/3)

Check: det A = 2·4 − 5·1 = 3, A⁻¹ = (1/3)[4 -5; -1 2], and X = A⁻¹B = [3; -1].
Rationales: B: this uses the adjugate [4 -5; -1 2] but forgets to divide by the determinant 3, so each coordinate is 3 times too large. C: this uses the negative of the inverse, because the diagonal entries were negated as well as the off-diagonal entries, which reverses the sign of the solution. D: this puts the negated entries in the wrong places, using −c in the top right and −b in the bottom left, which is the transpose of the correct adjugate and so not the inverse of A.

**N-4.11-A-v3.** The system 5x + y = 13 and 3x + y = 9 is written as AX = B with A = [5 1; 3 1], X = [x; y], and B = [13; 9]. Which ordered pair (x, y) solves it?

- A. (4, 6)
- B. (-2, -3)
- **C. (2, 3)**
- D. (-7, 16)

Check: det A = 5·1 − 1·3 = 2, A⁻¹ = (1/2)[1 -1; -3 5], and X = A⁻¹B = [2; 3].
Rationales: A: this uses the adjugate [1 -1; -3 5] but forgets to divide by the determinant 2, so each coordinate is 2 times too large. B: this uses the negative of the inverse, because the diagonal entries were negated as well as the off-diagonal entries, which reverses the sign of the solution. D: this puts the negated entries in the wrong places, using −c in the top right and −b in the bottom left, which is the transpose of the correct adjugate and so not the inverse of A.

---

## Seed N-4.12-A (new) — Topic 4.12 Linear Transformations and Matrices
**Skill:** build the matrix of a composition of two linear transformations in the right order and use it to find the image of a point.

T first reflects the plane across the x-axis and then rotates it 90° counterclockwise. The reflection has matrix R = [1 0; 0 −1] and the rotation has matrix Q = [0 −1; 1 0]. Which choice gives the matrix of T and the image of the point (2, 3)?

- A. [0 -1; -1 0], and (2, 3) maps to (-3, -2)
- B. [1 -1; 1 -1], and (2, 3) maps to (-1, -1)
- **C. [0 1; 1 0], and (2, 3) maps to (3, 2)**
- D. [0 -1; 1 0], and (2, 3) maps to (-3, 2)

Check: the first step is applied first, so T = QR = [0 -1; 1 0][1 0; 0 -1] = [0 1; 1 0]; then T(2, 3) = (3, 2).
Rationales: A: this is RQ, the matrices multiplied in the order they are listed; the transformation done first must be written on the right, so T = QR. B: this adds the two matrices; applying one transformation after another corresponds to a matrix product, not a sum. D: this is the matrix of the second step alone, which ignores the first transformation.

**N-4.12-A-v1.** T first applies a horizontal shear with matrix H = [1 2; 0 1] and then reflects the plane across the y-axis with matrix R = [−1 0; 0 1]. Which choice gives the matrix of T and the image of the point (1, 3)?

- **A. [-1 -2; 0 1], and (1, 3) maps to (-7, 3)**
- B. [-1 2; 0 1], and (1, 3) maps to (5, 3)
- C. [0 2; 0 2], and (1, 3) maps to (6, 6)
- D. [-1 0; 0 1], and (1, 3) maps to (-1, 3)

Check: the first step is applied first, so T = RH = [-1 0; 0 1][1 2; 0 1] = [-1 -2; 0 1]; then T(1, 3) = (-7, 3).
Rationales: B: this is HR, the matrices multiplied in the order they are listed; the transformation done first must be written on the right, so T = RH. C: this adds the two matrices; applying one transformation after another corresponds to a matrix product, not a sum. D: this is the matrix of the second step alone, which ignores the first transformation.

**N-4.12-A-v2.** T first stretches the plane horizontally by a factor of 3, with matrix S = [3 0; 0 1], and then rotates it 90° counterclockwise, with matrix Q = [0 −1; 1 0]. Which choice gives the matrix of T and the image of the point (2, 1)?

- A. [0 -3; 1 0], and (2, 1) maps to (-3, 2)
- B. [3 -1; 1 1], and (2, 1) maps to (5, 3)
- C. [0 -1; 1 0], and (2, 1) maps to (-1, 2)
- **D. [0 -1; 3 0], and (2, 1) maps to (-1, 6)**

Check: the first step is applied first, so T = QS = [0 -1; 1 0][3 0; 0 1] = [0 -1; 3 0]; then T(2, 1) = (-1, 6).
Rationales: A: this is SQ, the matrices multiplied in the order they are listed; the transformation done first must be written on the right, so T = QS. B: this adds the two matrices; applying one transformation after another corresponds to a matrix product, not a sum. C: this is the matrix of the second step alone, which ignores the first transformation.

**N-4.12-A-v3.** T first rotates the plane 90° clockwise, with matrix C = [0 1; −1 0], and then reflects it across the line y = x, with matrix R = [0 1; 1 0]. Which choice gives the matrix of T and the image of the point (3, 4)?

- A. [1 0; 0 -1], and (3, 4) maps to (3, -4)
- **B. [-1 0; 0 1], and (3, 4) maps to (-3, 4)**
- C. [0 2; 0 0], and (3, 4) maps to (8, 0)
- D. [0 1; 1 0], and (3, 4) maps to (4, 3)

Check: the first step is applied first, so T = RC = [0 1; 1 0][0 1; -1 0] = [-1 0; 0 1]; then T(3, 4) = (-3, 4).
Rationales: A: this is CR, the matrices multiplied in the order they are listed; the transformation done first must be written on the right, so T = RC. C: this adds the two matrices; applying one transformation after another corresponds to a matrix product, not a sum. D: this is the matrix of the second step alone, which ignores the first transformation.

---

## Seed N-4.13-A (new) — Topic 4.13 Matrices as Functions
**Skill:** use the determinant of a matrix to find how the linear map it defines scales area and whether it reverses orientation.

A linear transformation T of the plane is given by T(v) = Av with A = [1 3; 2 1]. A triangle of area 6 square units is mapped by T to a new triangle. Which statement about the image is correct?

- **A. The image has area 30 square units, and its orientation is reversed.**
- B. The image has area 30 square units, and its orientation is preserved.
- C. The image has area 42 square units, and its orientation is reversed.
- D. The image has area -30 square units, and its orientation is reversed.

Check: det A = 1·1 − 3·2 = -5; areas scale by |-5|, giving 30, and the sign is negative, so orientation is reversed.
Rationales: B: the area factor |det A| = 5 is right, but the sign of det A = -5 is negative, so orientation is reversed. C: the area factor is the determinant 1·1 − 3·2 = -5 (in absolute value), not the sum of the entries 7. D: an area cannot be negative; the negative determinant -5 means orientation reverses, and the area is scaled by |det| = 5, giving 30.

**N-4.13-A-v1.** A linear transformation T of the plane is given by T(v) = Av with A = [4 1; 3 2]. A region of area 8 square units is mapped by T to a new region. Which statement about the image is correct?

- A. The image has area 40 square units, and its orientation is reversed.
- **B. The image has area 40 square units, and its orientation is preserved.**
- C. The image has area 80 square units, and its orientation is preserved.
- D. The image has area 8 square units, and its orientation is preserved.

Check: det A = 4·2 − 1·3 = 5; areas scale by |5|, giving 40, and the sign is positive, so orientation is preserved.
Rationales: A: the area factor |det A| = 5 is right, but the sign of det A = 5 is positive, so orientation is preserved. C: the area factor is the determinant 4·2 − 1·3 = 5 (in absolute value), not the sum of the entries 10. D: a linear map with det A = 5 scales areas by |det A| = 5, so the area is 40; areas are not preserved unless |det| = 1.

**N-4.13-A-v2.** A linear transformation T of the plane is given by T(v) = Av with A = [1 4; 2 2]. A triangle of area 4 square units is mapped by T to a new triangle. Which statement about the image is correct?

- A. The image has area 24 square units, and its orientation is preserved.
- B. The image has area 36 square units, and its orientation is reversed.
- **C. The image has area 24 square units, and its orientation is reversed.**
- D. The image has area -24 square units, and its orientation is reversed.

Check: det A = 1·2 − 4·2 = -6; areas scale by |-6|, giving 24, and the sign is negative, so orientation is reversed.
Rationales: A: the area factor |det A| = 6 is right, but the sign of det A = -6 is negative, so orientation is reversed. B: the area factor is the determinant 1·2 − 4·2 = -6 (in absolute value), not the sum of the entries 9. D: an area cannot be negative; the negative determinant -6 means orientation reverses, and the area is scaled by |det| = 6, giving 24.

**N-4.13-A-v3.** A linear transformation T of the plane is given by T(v) = Av with A = [5 2; 1 3]. A region of area 3 square units is mapped by T to a new region. Which statement about the image is correct?

- A. The image has area 39 square units, and its orientation is reversed.
- B. The image has area 33 square units, and its orientation is preserved.
- C. The image has area 3 square units, and its orientation is preserved.
- **D. The image has area 39 square units, and its orientation is preserved.**

Check: det A = 5·3 − 2·1 = 13; areas scale by |13|, giving 39, and the sign is positive, so orientation is preserved.
Rationales: A: the area factor |det A| = 13 is right, but the sign of det A = 13 is positive, so orientation is preserved. B: the area factor is the determinant 5·3 − 2·1 = 13 (in absolute value), not the sum of the entries 11. C: a linear map with det A = 13 scales areas by |det A| = 13, so the area is 39; areas are not preserved unless |det| = 1.

---

## Seed N-4.14-A (new) — Topic 4.14 Matrices Modeling Contexts
**Skill:** use a transition matrix to predict a two-step state, reading columns as the group being left and applying the matrix twice.

A streaming service has two plans, X and Y. Each week 80% of X subscribers stay on X and 20% move to Y; 30% of Y subscribers move to X and 70% stay on Y. The state vector is [X; Y], and M = [0.8 0.3; 0.2 0.7] updates it from one week to the next (each column describes where that plan's subscribers go). Now there are 500 subscribers on X and 300 on Y. How many are predicted on [X; Y] after two weeks?

- A. [490; 310]
- B. [440; 390]
- C. [347; 167]
- **D. [485; 315]**

Check: one step gives [490; 310]; a second application of M gives [485; 315]; the total 800 is unchanged.
Rationales: A: this is the prediction after only one step, M times the starting vector; the question asks for two steps, which means applying M a second time. B: this multiplies by the transpose of M, treating rows as the 'from' groups; here each column of M describes where one group goes, so rows and columns were confused. C: this squares each entry of M separately; M² is the matrix product M·M, and squared entries do not even keep the total population constant.

**N-4.14-A-v1.** People in a metro area live in the city (C) or the suburbs (S). Each year 90% of city residents stay and 10% move to the suburbs; 20% of suburban residents move to the city and 80% stay. With state vector [C; S], the yearly update matrix is M = [0.9 0.2; 0.1 0.8] (each column describes where that group's residents go). The population is now 600 thousand in the city and 400 thousand in the suburbs. What is predicted for [C; S] after two years?

- **A. [634; 366]**
- B. [620; 380]
- C. [566; 468]
- D. [502; 262]

Check: one step gives [620; 380]; a second application of M gives [634; 366]; the total 1000 is unchanged.
Rationales: B: this is the prediction after only one step, M times the starting vector; the question asks for two steps, which means applying M a second time. C: this multiplies by the transpose of M, treating rows as the 'from' groups; here each column of M describes where one group goes, so rows and columns were confused. D: this squares each entry of M separately; M² is the matrix product M·M, and squared entries do not even keep the total population constant.

**N-4.14-A-v2.** A bike-share network has stations in the north (N) and south (S). Each day 60% of bikes at N stay there and 40% end the day at S; 50% of bikes at S end at N and 50% stay. With state vector [N; S], the daily update matrix is M = [0.6 0.5; 0.4 0.5] (each column describes where bikes from that station end up). Today there are 200 bikes at N and 100 at S. How many are predicted at [N; S] after two days?

- A. [170; 130]
- **B. [167; 133]**
- C. [156; 155]
- D. [97; 57]

Check: one step gives [170; 130]; a second application of M gives [167; 133]; the total 300 is unchanged.
Rationales: A: this is the prediction after only one step, M times the starting vector; the question asks for two steps, which means applying M a second time. C: this multiplies by the transpose of M, treating rows as the 'from' groups; here each column of M describes where one group goes, so rows and columns were confused. D: this squares each entry of M separately; M² is the matrix product M·M, and squared entries do not even keep the total population constant.

**N-4.14-A-v3.** A town's voters prefer party P or party Q. Each election 70% of P voters stay with P and 30% switch to Q; 40% of Q voters switch to P and 60% stay. With state vector [P; Q], the update matrix is M = [0.7 0.4; 0.3 0.6] (each column describes where that party's voters go). Currently 800 voters prefer P and 200 prefer Q. What is predicted for [P; Q] after two elections?

- A. [640; 360]
- B. [566; 512]
- **C. [592; 408]**
- D. [424; 144]

Check: one step gives [640; 360]; a second application of M gives [592; 408]; the total 1000 is unchanged.
Rationales: A: this is the prediction after only one step, M times the starting vector; the question asks for two steps, which means applying M a second time. B: this multiplies by the transpose of M, treating rows as the 'from' groups; here each column of M describes where one group goes, so rows and columns were confused. D: this squares each entry of M separately; M² is the matrix product M·M, and squared entries do not even keep the total population constant.

