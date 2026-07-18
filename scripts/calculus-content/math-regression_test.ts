import { assertAlmostEquals, assertEquals } from "jsr:@std/assert@1.0.14";

Deno.test("AB endpoint optimization checks every closed-interval candidate", () => {
  const f = (x: number) => x + 9 / x;
  const candidates = [1, 3, 6].map((x) => ({ x, y: f(x) }));
  assertEquals(candidates.reduce((a, b) => a.y < b.y ? a : b), { x: 3, y: 6 });
  assertEquals(candidates.reduce((a, b) => a.y > b.y ? a : b), { x: 1, y: 10 });
});

Deno.test("AB Euler steps and exact comparison have the correct direction", () => {
  const h = 0.5;
  let x = 0;
  let y = 1;
  for (let step = 0; step < 2; step++) {
    y += h * (x - y);
    x += h;
  }
  assertAlmostEquals(y, 0.5, 1e-12);
  const exact = 2 / Math.E;
  assertEquals(y < exact, true);
});

Deno.test("AB reservoir volume change uses depth endpoints", () => {
  const antiderivative = (h: number) => 30 * h + 2.5 * h * h;
  assertAlmostEquals(antiderivative(2.6) - antiderivative(2), 24.9, 1e-12);
});

Deno.test("BC cardioid polar slope at pi over two is positive one", () => {
  const theta = Math.PI / 2;
  const r = 1 + Math.cos(theta);
  const dr = -Math.sin(theta);
  const dx = dr * Math.cos(theta) - r * Math.sin(theta);
  const dy = dr * Math.sin(theta) + r * Math.cos(theta);
  assertAlmostEquals(dy / dx, 1, 1e-12);
});

Deno.test("Precalculus exponential equation decimal matches exact logarithmic solution", () => {
  const x = -Math.log(21) / (Math.log(3) - 2 * Math.log(7));
  assertAlmostEquals(x, 1.090, 0.001);
  assertAlmostEquals(3 ** (x + 1), 7 ** (2 * x - 1), 1e-10);
});

Deno.test("BC vector speed key is two square root ten", () => {
  const speed = Math.hypot(2, 6);
  assertAlmostEquals(speed, 2 * Math.sqrt(10), 1e-12);
});
