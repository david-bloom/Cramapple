-- Stem/choice cleanup 2026-10-06 -- ROLLBACK. Restores the snapshot stem (prod_snapshot.json) on every row whose
-- current stem equals the cleaned/proposed stem; rows never cleaned are skipped. Same label carry-forward, because
-- restoring the stem changes taxonomy_relevant_hash again. Re-run safe.
do $apply$
declare
  v_approval constant text := 'PENDING';
  v_run      constant text := 'stem-choice-cleanup-rollback-2026-10-06';
  -- target rows: version_id, content_key, md5 of the stem we expect to find, the stem to write, md5 of the choices
  v_targets  constant jsonb := $tj$[
{
"version_id": "d5ce86ce-69e0-4e02-80d6-12b2e47cfb19",
"content_key": "apcalcab-mcq-021",
"from_md5": "5a48ef6d535146e462dbdc013b66086b",
"to_stem": "What is lim(x→2) (x²−4)/(x−2)?\n\nA. 4\nB. 2\nC. 0\nD. The limit does not exist",
"choices_md5": "2e9f06f5e3cc5c17fc410d7a82b5b7b0"
},
{
"version_id": "f187cb9b-ad82-4c0a-bf31-1fe9bc88b111",
"content_key": "apcalcab-mcq-022",
"from_md5": "615d5d378b5a54de3b4870a4ccf8b524",
"to_stem": "Let f(x)=kx+1 for x<2 and f(x)=x²−1 for x≥2. For what value of k is f continuous at x=2?\n\nA. 0\nB. 1\nC. 3/2\nD. 2",
"choices_md5": "974d9e9326ac34f5f2c4c96b9bd74788"
},
{
"version_id": "84b735fd-c0c5-43e9-a061-3c1d49d6faa6",
"content_key": "apcalcab-mcq-023",
"from_md5": "88519f8c555db4bc6a496fd180510eaf",
"to_stem": "A function f is continuous on [1,4], with f(1)=−2 and f(4)=5. Which conclusion is guaranteed?\n\nA. f has an absolute minimum at x=1.\nB. There is a c in (1,4) with f′(c)=7/3.\nC. There is a c in (1,4) with f(c)=0.\nD. f is increasing on [1,4].",
"choices_md5": "890c9d96c8eae5adab319a3668b03251"
},
{
"version_id": "83a5e4bd-4243-45ae-99f3-4dc2b20277d6",
"content_key": "apcalcab-mcq-024",
"from_md5": "29b9597e52bcd82f3de6df778e8aa215",
"to_stem": "What is lim(x→∞) (5x²−x+4)/(2x²+3)?\n\nA. 0.0\nB. 0.4\nC. 2.0\nD. 2.5",
"choices_md5": "d65b8564fb770d5a7de48cdd75232aa8"
},
{
"version_id": "282b516f-24df-4efd-a6b4-4bd707b27ade",
"content_key": "apcalcab-mcq-025",
"from_md5": "fd66be63cd6876d1a1573d279dbd62eb",
"to_stem": "Which expression equals f′(3)?\n\nA. lim(h→0) [f(3+h)−f(3)]/h\nB. lim(h→0) [f(3+h)−f(h)]/3\nC. lim(x→3) [f(x)−f(3)]/3\nD. lim(x→0) [f(3+x)−f(3)]/3",
"choices_md5": "ee91542a00e0bdb6499ae40880646da9"
},
{
"version_id": "b96d3255-5b0b-41d0-acc9-879ff0ce95f4",
"content_key": "apcalcab-mcq-026",
"from_md5": "b82fe7c8a187b4c70b9f2562b0e4a82e",
"to_stem": "If f(x)=x²e^x, what is f′(1)?\n\nA. e\nB. 3e\nC. 2e\nD. 2+e",
"choices_md5": "c053b0503fbe903d211b172701dd8741"
},
{
"version_id": "46c685fa-6f73-4fec-8e6a-65f76f20688b",
"content_key": "apcalcab-mcq-027",
"from_md5": "78fc21b5ac002cae696ce52e2831994c",
"to_stem": "What is d/dx[sec x tan x]?\n\nA. sec x(sec²x+tan x)\nB. sec x(tan²x−sec²x)\nC. sec x(tan²x+sec²x)\nD. tan x(sec²x+tan²x)",
"choices_md5": "a2708819463195919a1e9981c92586eb"
},
{
"version_id": "4f821f8a-e0d2-4335-a0f9-d7f0f45eab31",
"content_key": "apcalcab-mcq-028",
"from_md5": "b1ee7bbdb7cb7b840bb8072c8f8a0546",
"to_stem": "Which statement is always true?\n\nA. Every continuous function is differentiable.\nB. A function with a derivative of 0 at x=a has a local extremum there.\nC. A function can be differentiable where it is discontinuous.\nD. If a function is differentiable at x=a, then it is continuous there.",
"choices_md5": "f362a993850c28d4cb926e6e5c88ffff"
},
{
"version_id": "d78139a9-7f07-47dd-a1d7-2b74588b00f4",
"content_key": "apcalcab-mcq-029",
"from_md5": "06fa8fff87162c024589af74d99f1c7f",
"to_stem": "If f(x)=sin(x²), what is f′(x)?\n\nA. 2x cos(x²)\nB. cos(2x)\nC. 2x sin(x²)\nD. cos(x²)",
"choices_md5": "73ed09b63183318715899bc228e023a4"
},
{
"version_id": "a5a73c42-6cb3-4671-957d-6cd3f8e8498a",
"content_key": "apcalcab-mcq-030",
"from_md5": "ee07295b13b713d9cab03b47a5496e2a",
"to_stem": "For the curve x²+y²=25, what is dy/dx at (3,4)?\n\nA. −4/3\nB. −3/4\nC. 3/4\nD. 4/3",
"choices_md5": "ba5d55849cc489dc741e158273a71fe3"
},
{
"version_id": "33b9f803-7914-45e3-8bcc-ca8997821a45",
"content_key": "apcalcab-mcq-031",
"from_md5": "e371ead8114c1e0460d40b49455c682d",
"to_stem": "A particle has position s(t)=t³−4.7t²+2.1t+6 meters. What is its velocity at t=2.35 seconds, to the nearest hundredth?\n\nA. 7.62 m/s\nB. −2.04 m/s\nC. −3.42 m/s\nD. 2.35 m/s",
"choices_md5": "590d366e3cd1989e257c7db80fd4cddb"
},
{
"version_id": "1a14dfca-2526-4774-86f5-95384856fa6b",
"content_key": "apcalcab-mcq-032",
"from_md5": "614ab42d2ac053cf6eecb06a075ff4f4",
"to_stem": "The radius of a circular stain is increasing at 0.37 centimeter per minute. When the radius is 5.2 centimeters, how fast is its area increasing, to the nearest tenth?\n\nA. 1.9 cm²/min\nB. 3.8 cm²/min\nC. 10.1 cm²/min\nD. 12.1 cm²/min",
"choices_md5": "f541111146a9e977d4f5221ad5a8adc0"
},
{
"version_id": "46ed1137-6d05-41ee-ba4f-33c75138bbfe",
"content_key": "apcalcab-mcq-033",
"from_md5": "c94a71a9e1114415f306709dd961cb8a",
"to_stem": "Using the linearization of f(x)=√x at x=4, which approximation is obtained for √4.1?\n\nA. 2.025\nB. 2.050\nC. 2.100\nD. 2.200",
"choices_md5": "6ac7a87e7432fb62c1c7ac81bc6c48b2"
},
{
"version_id": "a6963891-72c1-4665-912f-948599fcbfa4",
"content_key": "apcalcab-mcq-034",
"from_md5": "c5531a914c9d8520fd5606cfd83dddf8",
"to_stem": "What is lim(x→0) (e^(2x)−1)/x?\n\nA. 0\nB. 2\nC. e²\nD. The limit does not exist",
"choices_md5": "6b8b93ae019bbb715ba446cd7f60bffb"
},
{
"version_id": "4cc3b370-f56b-47ca-a7cf-4e0b32a06595",
"content_key": "apcalcab-mcq-035",
"from_md5": "da28c291491237b8eb698d4e363582dd",
"to_stem": "What are the critical numbers of f(x)=x³−3x?\n\nA. 0 only\nB. 3 only\nC. −1 and 1\nD. −3 and 3",
"choices_md5": "5d231e48fc7ee79429a53ce24d20c444"
},
{
"version_id": "cadbc0c7-61d6-4c34-87df-70fecd83e14c",
"content_key": "apcalcab-mcq-036",
"from_md5": "e79a63f494942dfcd42e80beac2b0e31",
"to_stem": "For f(x)=x² on [1,3], the Mean Value Theorem guarantees a c in (1,3) with f′(c) equal to the average rate of change. What is c?\n\nA. 1\nB. 4\nC. 3\nD. 2",
"choices_md5": "b1ff27192d944a369611ffd8e4e7d276"
},
{
"version_id": "69954758-6a5e-4473-ad33-a5fcef96399f",
"content_key": "apcalcab-mcq-037",
"from_md5": "00f959ecf65fe34760f5af5b21253135",
"to_stem": "A differentiable function has f′(x)=x³−3.2x²−1.1x+2.4 on −2≤x≤4. At which x-value does f have a local maximum, to the nearest thousandth?\n\nA. −0.910\nB. 0.796\nC. 1.000\nD. 3.313",
"choices_md5": "fb52844b2e40930100be768c3fcce6e0"
},
{
"version_id": "4bf6926a-7c55-48f7-b4db-9fc672a14731",
"content_key": "apcalcab-mcq-038",
"from_md5": "f9131d2be35599d42f024e9fa0895d04",
"to_stem": "If f″(x)=6x−12, on which interval is f concave up?\n\nA. x<0\nB. x>2\nC. x<2\nD. 0<x<2",
"choices_md5": "ba7fd45cfd4f2998a3702dd1d42a8599"
},
{
"version_id": "3d5aa0f8-6b75-4490-b338-4d83c9ba3f18",
"content_key": "apcalcab-mcq-039",
"from_md5": "1709c446f16edcd36efc84bc1e03c0ce",
"to_stem": "A rectangle has perimeter 20. What is its greatest possible area?\n\nA. 20\nB. 24\nC. 25\nD. 40",
"choices_md5": "ae15464b8d916138d0e8205e2615d4ac"
},
{
"version_id": "172ee07f-0692-45f6-bcf0-413062e46d4d",
"content_key": "apcalcab-mcq-040",
"from_md5": "3113ddb461433ad6d52bfd07076084ce",
"to_stem": "Values of f are shown: x=0, 0.7, 1.9, 3.0 and f(x)=2.1, 2.8, 1.6, 3.4. What is the right Riemann-sum approximation for ∫₀³ f(x)dx?\n\nA. 6.5\nB. 7.8\nC. 6.59\nD. 7.62",
"choices_md5": "5068f6ad32449d0efbccb02b14c22304"
},
{
"version_id": "4785a80b-e6df-44f8-80b9-0a24c715da30",
"content_key": "apcalcab-mcq-041",
"from_md5": "3e3cd7ff3916db9c6463acea21ebe8a6",
"to_stem": "If F(x)=∫₁^(x²) √(1+t³) dt, what is F′(x)?\n\nA. 2x√(1+x⁶)\nB. √(1+x⁶)\nC. 2x√(1+x³)\nD. x²√(1+x⁶)",
"choices_md5": "ae17c92b14cb036463bf0dded64b62bc"
},
{
"version_id": "8a70d356-3323-498f-bf1c-ed157a9c1d4a",
"content_key": "apcalcab-mcq-042",
"from_md5": "618a7d448eb818b9755ed1c5a6ffaec5",
"to_stem": "If f is odd and integrable on [−3,3], what is ∫₋₃³ f(x)dx?\n\nA. −6\nB. 0\nC. 3\nD. 6",
"choices_md5": "114542f432cefa7f7b6528aea0f42a6d"
},
{
"version_id": "4513a5d9-2989-4839-9009-7cddd4eadfe1",
"content_key": "apcalcab-mcq-043",
"from_md5": "43520a6aba1228317f7d961cc19bb4fd",
"to_stem": "Which is an antiderivative of 2x cos(x²)?\n\nA. 2sin(x²)\nB. x²sin(x²)\nC. sin(x²)\nD. cos(x²)",
"choices_md5": "7c711698f8a7f7cffe48c2f639da9b3d"
},
{
"version_id": "c8d4f7c2-7aec-4ffa-a03f-d301e5d36127",
"content_key": "apcalcab-mcq-044",
"from_md5": "1a420883dba138383bbf44dd6db09da8",
"to_stem": "Let f(x)=e^(−x²). What is the average value of f on [0,1.6], to the nearest thousandth?\n\nA. 0.338\nB. 0.866\nC. 0.676\nD. 0.541",
"choices_md5": "46d3c5bece110abe8af3da95d7fc1e47"
},
{
"version_id": "f5374b3d-e3ff-44b7-91df-5a17e34fe98a",
"content_key": "apcalcab-mcq-047",
"from_md5": "969bb031c1b9771ec4799cab52b81fe6",
"to_stem": "What is the area between y=x and y=x² on 0≤x≤1?\n\nA. 1/3\nB. 1/2\nC. 1/6\nD. 5/6",
"choices_md5": "6ad818adc7356097571035876f0c69d3"
},
{
"version_id": "05bc02e0-3ca9-45f2-9643-e69eddd4161b",
"content_key": "apcalcab-mcq-np2-002",
"from_md5": "fc4949a883ad0072e47a304f0236b1f2",
"to_stem": "Which of the following limits is an indeterminate form (0/0 or infinity/infinity) to which L'Hospital's Rule may be applied directly?\n\nA. the limit as x approaches 0 of (e^x - 1)/x\nB. the limit as x approaches infinity of (x - ln(x))\nC. the limit as x approaches 3 of (x^2-9)/(x+3)\nD. the limit as x approaches 0 of (1/x - 1/x^2)",
"choices_md5": "6d25e86a57b149f082b283593f421eac"
},
{
"version_id": "8801905c-357a-43b7-81b5-0f388c6685bf",
"content_key": "apcalcbc-mcq-021",
"from_md5": "35d36e12e3ea6b23a1ea3017baafe56d",
"to_stem": "What is lim(x→0) (e^(3x)−1)/x?\n\nA. 0\nB. 1\nC. 3\nD. e³",
"choices_md5": "3fcf12b7c380c859d23fc18d2fd7c2e2"
},
{
"version_id": "c8e50471-1357-4455-9e5b-b3365a2eed42",
"content_key": "apcalcbc-mcq-022",
"from_md5": "3a44a67c680b7303a2cb30adc57e1de3",
"to_stem": "What is lim(x→0) ln(1+2x)/sin(3x)?\n\nA. 3/2\nB. 2/3\nC. 1/6\nD. The limit does not exist",
"choices_md5": "c1e848a1f0cf9aa098b89032f1f1e2a4"
},
{
"version_id": "a548a41e-aa7b-462f-8969-fac4def77fd7",
"content_key": "apcalcbc-mcq-023",
"from_md5": "0a42d928092aa86c39f23e63c3bde336",
"to_stem": "If f(x)=x²ln x for x>0, what is f′(1)?\n\nA. 0\nB. 2\nC. 1\nD. e",
"choices_md5": "94fa43a401b842b9ed1e1fe812ab749d"
},
{
"version_id": "22757b29-3af8-40f1-8f88-4d07e2ab1b0c",
"content_key": "apcalcbc-mcq-024",
"from_md5": "eca97e3c1296d28a293051478427bb76",
"to_stem": "Which limit equals f″(2), provided the second derivative exists?\n\nA. lim(h→0)[f(2+h)−f(2)]/h\nB. lim(h→0)[f′(2+h)−f′(h)]/2\nC. lim(x→2)[f′(x)−f′(2)]/2\nD. lim(h→0)[f′(2+h)−f′(2)]/h",
"choices_md5": "d26fc51a3beec83add9196c7ec6cae30"
},
{
"version_id": "fe829169-4d22-44ab-aafa-213cf63cee84",
"content_key": "apcalcbc-mcq-025",
"from_md5": "57532f54783dcbfe43086f3604a81be4",
"to_stem": "What is d/dx[arctan(x²)]?\n\nA. 2x/(1+x⁴)\nB. 2x/(1+x²)\nC. 1/(1+x⁴)\nD. 2/(1+x⁴)",
"choices_md5": "b48bfcb16a49fc44b6fe7511e6961174"
},
{
"version_id": "435c0bbd-475e-41dd-bc25-ee04f09f4754",
"content_key": "apcalcbc-mcq-026",
"from_md5": "8f958f048baa53c0159a8390898e88bd",
"to_stem": "Let g=f⁻¹. If f(2)=5 and f′(2)=−3, what is g′(5)?\n\nA. −3\nB. 1/3\nC. 5\nD. −1/3",
"choices_md5": "e2db659ae79ed9c9c2792a37a824d651"
},
{
"version_id": "fa8b34e0-f9a9-4ebd-a3d2-7a1a077f2034",
"content_key": "apcalcbc-mcq-027",
"from_md5": "f836902e56a05561c87c33f4889e1602",
"to_stem": "The radius of a sphere is increasing at 0.2 centimeter per second. How fast is its volume increasing when the radius is 3 centimeters?\n\nA. 1.8π cm³/s\nB. 3.6π cm³/s\nC. 10.8π cm³/s\nD. 7.2π cm³/s",
"choices_md5": "54d2fd57c1028af93e79f4a9d39e39da"
},
{
"version_id": "b79f95c1-f44e-4bb9-b280-7d3c4ae2a28b",
"content_key": "apcalcbc-mcq-028",
"from_md5": "f4e49b682e2a44ab2959f194fc3f4b03",
"to_stem": "A particle has velocity v(t)=t sin(t²)−0.4. What is its acceleration at t=1.3, to the nearest thousandth?\n\nA. -0.402\nB. 0.993\nC. 0.591\nD. 0.891",
"choices_md5": "64a1a7630c8f4fcdaa85f9eb88008ea0"
},
{
"version_id": "bed2766f-8714-419d-9aaf-d32bb3f69c2e",
"content_key": "apcalcbc-mcq-029",
"from_md5": "89613461312f2ef07a15805ef4388802",
"to_stem": "If f′(x)=(x−1)(x+2), on which intervals is f increasing?\n\nA. (−∞,−2) and (1,∞)\nB. (−2,1) only\nC. (−∞,1) only\nD. (−2,∞) only",
"choices_md5": "f2c42fdedb947cf1160fcecf62acbb2e"
},
{
"version_id": "b601f7db-92e4-4dd6-9b0d-e2864d426b0f",
"content_key": "apcalcbc-mcq-030",
"from_md5": "7dd4220fad29232db5e46413296fe2f9",
"to_stem": "For f(x)=e^x on [0,1], which value of c is guaranteed by the Mean Value Theorem?\n\nA. 1/2\nB. e−1\nC. ln(e−1)\nD. ln 2",
"choices_md5": "b5b8f97610afaf987a376c0e9831a5e1"
},
{
"version_id": "4a47d6f6-0bd0-4ec2-add9-40d40d51b568",
"content_key": "apcalcbc-mcq-031",
"from_md5": "39d58679832e943dce76c6b48af2cad8",
"to_stem": "A differentiable function has f′(x)=x⁴−4x²+0.5 on −2≤x≤2. At which x-values does f have local maxima, to the nearest thousandth?\n\nA. −1.967 and 0.359\nB. −0.359 and 1.967\nC. −1.967 and 1.967\nD. −0.359 and 0.359",
"choices_md5": "900f779d7627c56843c77cab8e63aaf6"
},
{
"version_id": "c7d521ad-bc8a-404c-abd9-0e68350e7afd",
"content_key": "apcalcbc-mcq-032",
"from_md5": "36ee7546bf5f2c15e6ba0a52b6be30d5",
"to_stem": "If f′(x)=x²(x−1)³(x+2)², which statement is true?\n\nA. f has local maxima at x=−2 and x=0, but no extremum at x=1.\nB. f has a local maximum at x=1 and no extrema at x=−2 or x=0.\nC. f has local minima at x=−2 and x=0, but no extremum at x=1.\nD. f has a local minimum at x=1 and no extrema at x=−2 or x=0.",
"choices_md5": "c167cdf5b35579aba49412ad735f6d12"
},
{
"version_id": "1c459529-8016-44ad-be36-dbccc2e0e7fd",
"content_key": "apcalcbc-mcq-033",
"from_md5": "f4b76499956b9b2bdfc4ca14360ee0fa",
"to_stem": "What is the value of the improper integral ∫₁^∞ 1/x² dx?\n\nA. 0\nB. 2\nC. The integral diverges\nD. 1",
"choices_md5": "6cb3c0e8ebca430f7fb8801d37dd3542"
},
{
"version_id": "058cb9f7-37f0-4e0d-af06-97ffa239af39",
"content_key": "apcalcbc-mcq-034",
"from_md5": "ae9f386d2c81e14f5aee4d6f4bd87dd4",
"to_stem": "Which is an antiderivative of xe^x?\n\nA. xe^x−e^x\nB. xe^x+e^x\nC. x²e^x/2\nD. e^x/x",
"choices_md5": "f3672008d6385aa936d7da7e2c626632"
},
{
"version_id": "de0da11c-94be-4ca2-a3e5-edf6836db953",
"content_key": "apcalcbc-mcq-035",
"from_md5": "1fdbe7e1a65040a2ad2a905165fe86bf",
"to_stem": "What is ∫1/(x²−1) dx on an interval not containing ±1?\n\nA. ln|x²−1|+C\nB. ln|(x−1)/(x+1)|+C\nC. (1/2)ln|x²−1|+C\nD. (1/2)ln|(x−1)/(x+1)|+C",
"choices_md5": "6af3059ae0b36a8560b5c757cae0b1ef"
},
{
"version_id": "54c79401-bf15-4533-97d2-1a634ed5ce69",
"content_key": "apcalcbc-mcq-036",
"from_md5": "09860fb28deeedbb02042ca0f240f5c1",
"to_stem": "Let G(x)=∫₀^(x²) cos(t³)dt. What is G′(1.2), to the nearest thousandth?\n\nA. −2.371\nB. −0.988\nC. 0.988\nD. 2.371",
"choices_md5": "7cf2d0bcb2edfa1b1ffcb99e508efcf8"
},
{
"version_id": "f54f258c-060d-4419-b6fc-8382a1b4634b",
"content_key": "apcalcbc-mcq-037",
"from_md5": "2179361a7e03b0e95642533e70f823f1",
"to_stem": "What is ∫₁^∞ (ln x)/x² dx?\n\nA. 1/2\nB. 1\nC. 2\nD. The integral diverges",
"choices_md5": "8180d2d50d4aa87e1b3689358697db57"
},
{
"version_id": "4b886041-044f-4c7a-9907-69d97a19b67f",
"content_key": "apcalcbc-mcq-038",
"from_md5": "3723ceb0b71a123b0ffaca9537a9ba9f",
"to_stem": "Use Euler's method with step size 0.25 to estimate y(0.5) for y′=x²−y and y(0)=1.\n\nA. 0.500\nB. 0.688\nC. 0.750\nD. 0.578",
"choices_md5": "96bbb87acc3da9d2888ad30c5fed1249"
},
{
"version_id": "7ffa3a3c-5e6e-4c35-bdc7-bd6ca6d8e1ff",
"content_key": "apcalcbc-mcq-039",
"from_md5": "3978c9163349cf6fa763cb63e2c31da3",
"to_stem": "A population satisfies dP/dt=0.4P(1−P/1200) and P(0)=300. When does P reach 600, to the nearest thousandth?\n\nA. 1.733\nB. 3.466\nC. 2.747\nD. 3.75",
"choices_md5": "946342125b9de25407f3e1a6c7355113"
},
{
"version_id": "7e90cc29-6b7b-442f-9742-7b099d3745da",
"content_key": "apcalcbc-mcq-040",
"from_md5": "7ff76cabec1fc09361b0f0efde94b55b",
"to_stem": "What is the area between y=√x and y=x on 0≤x≤1?\n\nA. 1/3\nB. 1/4\nC. 1/6\nD. 1/2",
"choices_md5": "22c826b14fa54afd754ec5682e04779a"
},
{
"version_id": "2bcaf641-2acb-418e-93a5-c1fa9ee02d83",
"content_key": "apcalcbc-mcq-041",
"from_md5": "2b75c40458e6652985e9a7d6da259bd0",
"to_stem": "The base of a solid is 0≤x≤1.5 and 0≤y≤e^(−x²). Cross sections perpendicular to the x-axis are semicircles whose diameters lie in the base. What is the volume, to the nearest thousandth?\n\nA. 0.245\nB. 0.491\nC. 0.982\nD. 1.963",
"choices_md5": "a7fe63a26a844ab856d727e960cd1152"
},
{
"version_id": "7fd6e86b-00c8-4167-9cf3-2e9d94c5a0ae",
"content_key": "apcalcbc-mcq-042",
"from_md5": "7f0cce8b29a1736fa58521e8e648a0d5",
"to_stem": "A curve is given by x=t²+1 and y=t³−3t. What is dy/dx at t=1?\n\nA. −1\nB. 0\nC. 1\nD. 2",
"choices_md5": "0ec745da47ca59dd83113a6035bbbf98"
},
{
"version_id": "7945bd22-d0a1-4bba-8420-f193751a8118",
"content_key": "apcalcbc-mcq-043",
"from_md5": "7b26f435bc9a3e8bf091b385efb2d44a",
"to_stem": "A particle has position r(t)=⟨t²−2t,e^(−t)⟩. What is its speed at t=1.4, to the nearest thousandth?\n\nA. 0.247\nB. 0.837\nC. 0.800\nD. 1.047",
"choices_md5": "064f3b54b27e78e4bd1c201ebcdb2507"
},
{
"version_id": "519b75bf-b623-404e-9ad7-da11290053dd",
"content_key": "apcalcbc-mcq-044",
"from_md5": "00e42023b851c93b347920a2bbb5a4ab",
"to_stem": "What is the area of one petal of the polar curve r=2sin(3θ)?\n\nA. π/6\nB. π/3\nC. 2π/3\nD. π",
"choices_md5": "cf2320ba6d8dfd8729d4972a55c3e572"
},
{
"version_id": "f4ea3f50-3a6d-460e-b40a-1be96890e04b",
"content_key": "apcalcbc-mcq-045",
"from_md5": "3f96d53764406637a5f85cc4abb190cc",
"to_stem": "A curve is given by x=t+sin t and y=1−cos t. What is d²y/dx² at t=1, to the nearest thousandth?\n\nA. 0.421\nB. 0.355\nC. 0.649\nD. 0.546",
"choices_md5": "9e329682bdac19824c08e523ad9fb663"
},
{
"version_id": "194278ff-5e81-4785-a965-ce99467e3adc",
"content_key": "apcalcbc-mcq-046",
"from_md5": "3a09ffa603b94b1d02bf466e464206d2",
"to_stem": "What is the sum of Σ[n=1 to ∞] 5(−1/3)^(n−1)?\n\nA. 5/4\nB. 15/4\nC. 5\nD. 15/2",
"choices_md5": "cb2f15426be81c351d537344a77c9b97"
},
{
"version_id": "29374f52-56b5-4d44-8d07-182d10f36644",
"content_key": "apcalcbc-mcq-047",
"from_md5": "9dc0916de63b537d4f93c736d1752187",
"to_stem": "Which statement describes Σ[n=1 to ∞](−1)^(n+1)/√n?\n\nA. It diverges by the nth-term test.\nB. It converges conditionally.\nC. It converges absolutely.\nD. It is geometric and converges.",
"choices_md5": "8c5a7d6302e809bddcdf73e56bd49cde"
},
{
"version_id": "65eb803d-fa43-4292-81fe-dc81a672befc",
"content_key": "apcalcbc-mcq-048",
"from_md5": "3f3efffc55506baf6e815c287e54e836",
"to_stem": "What is the interval of convergence of Σ[n=1 to ∞](x−2)^n/(n3^n)?\n\nA. (−1,5)\nB. [−1,5]\nC. [−1,5)\nD. (−1,5]",
"choices_md5": "d4a8354db5690e28399dfb1c3d50e833"
},
{
"version_id": "4db8a57a-2691-4428-9e8c-2e806f26df40",
"content_key": "apcalcbc-mcq-049",
"from_md5": "89df54e9c31ada60ecf26b9c6760b621",
"to_stem": "The degree-5 Maclaurin polynomial for sin x is used at x=0.7. Which is a valid Lagrange error bound?\n\nA. 0.7⁵/5!\nB. 0.7⁶/6!\nC. 0.7⁶/7!\nD. sin(0.7)/6!",
"choices_md5": "c2ba8402b642198275e340c4e51a4efc"
},
{
"version_id": "6fb0f714-1f8b-47fd-9c84-2caf309ee9f1",
"content_key": "apcalcbc-mcq-050",
"from_md5": "b345388a977522cea9f711c4310bcb9a",
"to_stem": "What is the coefficient of x⁷ in the Maclaurin series for x²e^(−x)?\n\nA. −1/120\nB. 1/120\nC. −1/5040\nD. 1/5040",
"choices_md5": "bffad66e4f4b94898f5c3923eb091511"
},
{
"version_id": "2f26bf80-3101-48fd-960f-526221f2a464",
"content_key": "apcalcbc-mcq-ab-021",
"from_md5": "5a48ef6d535146e462dbdc013b66086b",
"to_stem": "What is lim(x→2) (x²−4)/(x−2)?\n\nA. 4\nB. 2\nC. 0\nD. The limit does not exist",
"choices_md5": "2e9f06f5e3cc5c17fc410d7a82b5b7b0"
},
{
"version_id": "98425cfb-20e4-4325-a0bd-cb5a1a3050a2",
"content_key": "apcalcbc-mcq-ab-022",
"from_md5": "615d5d378b5a54de3b4870a4ccf8b524",
"to_stem": "Let f(x)=kx+1 for x<2 and f(x)=x²−1 for x≥2. For what value of k is f continuous at x=2?\n\nA. 0\nB. 1\nC. 3/2\nD. 2",
"choices_md5": "974d9e9326ac34f5f2c4c96b9bd74788"
},
{
"version_id": "d690b8fc-67ea-4ad9-85d4-2408e38a3cf6",
"content_key": "apcalcbc-mcq-ab-024",
"from_md5": "29b9597e52bcd82f3de6df778e8aa215",
"to_stem": "What is lim(x→∞) (5x²−x+4)/(2x²+3)?\n\nA. 0.0\nB. 0.4\nC. 2.0\nD. 2.5",
"choices_md5": "d65b8564fb770d5a7de48cdd75232aa8"
},
{
"version_id": "98d30b24-d358-4a14-b7ff-11a9251c86b4",
"content_key": "apcalcbc-mcq-ab-025",
"from_md5": "fd66be63cd6876d1a1573d279dbd62eb",
"to_stem": "Which expression equals f′(3)?\n\nA. lim(h→0) [f(3+h)−f(3)]/h\nB. lim(h→0) [f(3+h)−f(h)]/3\nC. lim(x→3) [f(x)−f(3)]/3\nD. lim(x→0) [f(3+x)−f(3)]/3",
"choices_md5": "ee91542a00e0bdb6499ae40880646da9"
},
{
"version_id": "3b0ec592-ec60-4dc7-8aa3-3db8a02c0cb9",
"content_key": "apcalcbc-mcq-ab-026",
"from_md5": "b82fe7c8a187b4c70b9f2562b0e4a82e",
"to_stem": "If f(x)=x²e^x, what is f′(1)?\n\nA. e\nB. 3e\nC. 2e\nD. 2+e",
"choices_md5": "c053b0503fbe903d211b172701dd8741"
},
{
"version_id": "ff2d65f4-eb9b-4a30-907f-42bb3d2e82ea",
"content_key": "apcalcbc-mcq-ab-027",
"from_md5": "78fc21b5ac002cae696ce52e2831994c",
"to_stem": "What is d/dx[sec x tan x]?\n\nA. sec x(sec²x+tan x)\nB. sec x(tan²x−sec²x)\nC. sec x(tan²x+sec²x)\nD. tan x(sec²x+tan²x)",
"choices_md5": "a2708819463195919a1e9981c92586eb"
},
{
"version_id": "30fe73a6-7911-46a5-9c5e-81425aa46ba2",
"content_key": "apcalcbc-mcq-ab-028",
"from_md5": "b1ee7bbdb7cb7b840bb8072c8f8a0546",
"to_stem": "Which statement is always true?\n\nA. Every continuous function is differentiable.\nB. A function with a derivative of 0 at x=a has a local extremum there.\nC. A function can be differentiable where it is discontinuous.\nD. If a function is differentiable at x=a, then it is continuous there.",
"choices_md5": "f362a993850c28d4cb926e6e5c88ffff"
},
{
"version_id": "afefdd33-23f9-45d1-a64b-0a3f5f5b2e94",
"content_key": "apcalcbc-mcq-ab-029",
"from_md5": "06fa8fff87162c024589af74d99f1c7f",
"to_stem": "If f(x)=sin(x²), what is f′(x)?\n\nA. 2x cos(x²)\nB. cos(2x)\nC. 2x sin(x²)\nD. cos(x²)",
"choices_md5": "73ed09b63183318715899bc228e023a4"
},
{
"version_id": "05fb2931-3b7b-4114-ba57-26a1c687ca52",
"content_key": "apcalcbc-mcq-ab-030",
"from_md5": "ee07295b13b713d9cab03b47a5496e2a",
"to_stem": "For the curve x²+y²=25, what is dy/dx at (3,4)?\n\nA. −4/3\nB. −3/4\nC. 3/4\nD. 4/3",
"choices_md5": "ba5d55849cc489dc741e158273a71fe3"
},
{
"version_id": "94bf5ab0-4fc3-4b53-bac9-62ed9de33fe1",
"content_key": "apcalcbc-mcq-mv045",
"from_md5": "6b3dc7823b1d478a2083237eec4bb57d",
"to_stem": "Use Euler's method with step size 0.5 to estimate y(1) for y′=x+y and y(0)=1.\n\nA. 2.5\nB. 2.0\nC. 1.75\nD. 1.5",
"choices_md5": "45d4df2389e7427d62cf0e3659d3e2d0"
},
{
"version_id": "6202f329-6245-4fef-ab40-0a7b8a14c525",
"content_key": "apcalcbc-mcq-mv046",
"from_md5": "482114918b39417c9796331babec4079",
"to_stem": "A population follows dP/dt=0.18P(1−P/900). At what population is the instantaneous growth rate greatest?\n\nA. 225\nB. 450\nC. 720\nD. 900",
"choices_md5": "efbcc042f3c5c8c4e2fa3f9ea3cefef4"
},
{
"version_id": "c431bc9c-5cfe-4059-96f8-98e8589d8410",
"content_key": "apcalcbc-mcq-mv050",
"from_md5": "3a33b9e900e3dc17d42a2346bb76786a",
"to_stem": "What is the length of y=x² from x=0 to x=1.4, to the nearest thousandth?\n\nA. 2.800\nB. 2.520\nC. 1.960\nD. 1.400",
"choices_md5": "a34eb742b6c61325a88964ea96369681"
},
{
"version_id": "d22a425d-8702-43f4-bc38-554f355e04ae",
"content_key": "apchem-mcq-001",
"from_md5": "9349628b129926cf59a40c938760004c",
"to_stem": "A 9.00 g sample of water (18.0 g mol⁻¹) contains how many moles?\n\nA. 0.250 mol\nB. 0.500 mol\nC. 2.00 mol\nD. 162 mol",
"choices_md5": "d24e9edf757cd74f5f20191cbe421094"
},
{
"version_id": "67816f8d-f41f-4c58-a4ae-4966efc7a318",
"content_key": "apchem-mcq-003",
"from_md5": "481c09924a47610b2a8be71997971541",
"to_stem": "Which species has a trigonal planar molecular geometry?\n\nA. NH₃\nB. CO₂\nC. BF₃\nD. CH₄",
"choices_md5": "415f74d11b81dc9498cf7912fe3c2abd"
},
{
"version_id": "c360ba4c-aa2e-4be8-9808-431775a9dae4",
"content_key": "apchem-mcq-004",
"from_md5": "86fa97210922d5461820136876bc10eb",
"to_stem": "Why does solid NaCl not conduct while molten NaCl does?\n\nA. Electrons are created on melting\nB. Ions become mobile on melting\nC. NaCl becomes molecular\nD. Chloride loses its charge",
"choices_md5": "37cf28f62f76a0baf986128f5e746d3e"
},
{
"version_id": "b1befb18-d6df-43af-ab68-ddb88423ed33",
"content_key": "apchem-mcq-005",
"from_md5": "4d39f04fb25d9c2c5085e6c0dc58da30",
"to_stem": "At the same temperature, which gas sample has the greatest average particle speed?\n\nA. Xe\nB. Kr\nC. Ar\nD. He",
"choices_md5": "1ac65376816a9de90615269d7eebfe1e"
},
{
"version_id": "fadd26cc-8d63-4c1d-9d58-9c8550792e36",
"content_key": "apchem-mcq-008",
"from_md5": "4b0eff2662d9e070b10af4c95dbe43bf",
"to_stem": "A gas occupies 2.0 L at 1.0 atm. At constant temperature and fixed amount of gas, its volume at 4.0 atm is\n\nA. 0.50 L\nB. 2.0 L\nC. 4.0 L\nD. 8.0 L",
"choices_md5": "6e2a3f8b46d67708266811baff214385"
},
{
"version_id": "c5b49ad8-9764-4ded-b73b-f6bbf8d612a0",
"content_key": "apchem-mcq-009",
"from_md5": "d5274a449de23dd9be9e48d4381392b6",
"to_stem": "For 2 H₂ + O₂ → 2 H₂O, how many moles of water form from 3.0 mol O₂ with excess H₂?\n\nA. 1.5\nB. 3.0\nC. 6.0\nD. 9.0",
"choices_md5": "ddacfd9502cba88737d91d43db229334"
},
{
"version_id": "d99a02b1-d931-4bfb-babe-69bcd837c5fd",
"content_key": "apchem-mcq-010",
"from_md5": "bc200b5e597d96b48b072f226c2d7ed1",
"to_stem": "Which ions are spectators when AgNO₃(aq) and NaCl(aq) form AgCl(s)?\n\nA. Ag⁺ and Cl⁻\nB. Na⁺ and NO₃⁻\nC. Ag⁺ and NO₃⁻\nD. Na⁺ and Cl⁻",
"choices_md5": "52654bba06e3710ee0e52cdecb860884"
},
{
"version_id": "27ef02be-bead-4584-8fbe-e26f6f7c3b5d",
"content_key": "apchem-mcq-011",
"from_md5": "3e3b2698d61f99edfc0a9df72b56cf48",
"to_stem": "Doubling [A] quadruples the rate while other concentrations remain fixed. The reaction is\n\nA. zero order in A\nB. first order in A\nC. second order in A\nD. fourth order in A",
"choices_md5": "4737a13de1f31bb382ea476e5afaba04"
},
{
"version_id": "2038acfa-ec05-4cc8-b1d3-8d126b2a6461",
"content_key": "apchem-mcq-012",
"from_md5": "f47d87b026c12fc4a6d172362dc4a0f0",
"to_stem": "A catalyst speeds a reaction because it\n\nA. increases ΔG°\nB. raises activation energy\nC. changes equilibrium K\nD. provides an alternative pathway with lower activation energy",
"choices_md5": "6e282afcca07bed6ff5b807a7b032267"
},
{
"version_id": "ec5e88d3-622a-482a-b89d-cefc3cf7afd5",
"content_key": "apchem-mcq-013",
"from_md5": "6d9c9ef783640d1bae0ddef4c7b85005",
"to_stem": "A 100 g metal absorbs 2.50 kJ and warms by 50.0°C. Its specific heat is\n\nA. 0.050 J g⁻¹°C⁻¹\nB. 0.500 J g⁻¹°C⁻¹\nC. 5.00 J g⁻¹°C⁻¹\nD. 50.0 J g⁻¹°C⁻¹",
"choices_md5": "b6cbb289b5db41e2ff05201f4ab81a6e"
},
{
"version_id": "9e7fff7f-3d3c-491a-9b12-4aaba7890769",
"content_key": "apchem-mcq-014",
"from_md5": "444739e2d05805625f7035dd8a2570b1",
"to_stem": "If ΔH is negative for a process at constant pressure, the system\n\nA. absorbs heat\nB. releases heat\nC. must have greater entropy\nD. cannot be spontaneous",
"choices_md5": "ec7eefb4ffae7761f78bd97925a80f7b"
},
{
"version_id": "e47eb90a-bc6a-4f7e-a10c-3b7b4a66a9ef",
"content_key": "apchem-mcq-015",
"from_md5": "3b9a5bf13e3d804bc5fe58aa421f68ed",
"to_stem": "For a reaction with Q<K, the system initially shifts\n\nA. toward reactants\nB. toward products\nC. nowhere because Q=0\nD. only if a catalyst is added",
"choices_md5": "b3a059c829b0c5f37d3127ac74ca6cec"
},
{
"version_id": "1c65cbef-2352-4274-b12e-05f781c3a9e7",
"content_key": "apchem-mcq-016",
"from_md5": "4394de00ed97ea1e3caa88818e773340",
"to_stem": "Adding an inert gas at constant volume and constant temperature does not change an ideal-gas equilibrium because\n\nA. all partial pressures increase\nB. all partial pressures decrease\nC. reactant partial pressures alone increase\nD. the reacting-gas partial pressures do not change",
"choices_md5": "80cf77856d3afe585eb37f3ff49c64a4"
},
{
"version_id": "f79fcfa0-ec2e-4c06-a21b-abe42c8b4f3b",
"content_key": "apchem-mcq-018",
"from_md5": "30f3d07b1131789dbcabfc3ec0d0139c",
"to_stem": "A buffer contains comparable amounts of HA and A⁻. Adding a small amount of H⁺ primarily causes\n\nA. HA to react with H⁺\nB. A⁻ to react with H⁺\nC. most of the added H+ remains free in solution\nD. Ka to increase",
"choices_md5": "6aa4c7f3919b9c648bbb65989f8aaef0"
},
{
"version_id": "cc5c9ef2-1b56-4ec4-902c-5bfa11b61c71",
"content_key": "apchem-mcq-019",
"from_md5": "5745bfe6ba14586bdc5a84bdfe4de0fc",
"to_stem": "At constant temperature and pressure, a process is thermodynamically favorable when\n\nA. ΔG<0\nB. ΔG>0\nC. Delta H < 0\nD. Delta G = 0",
"choices_md5": "9aa2c1db5413184604ea9a14e2d33aa9"
},
{
"version_id": "93e8cec6-75df-4826-b28a-37dbbe6100a0",
"content_key": "apchem-mcq-020",
"from_md5": "d45d92e02b06522ec1ef2c0ae4f56eee",
"to_stem": "For a galvanic cell under standard conditions, E°cell>0 implies\n\nA. ΔG°>0\nB. K<1\nC. ΔG°<0\nD. electrons flow through the salt bridge",
"choices_md5": "1f8dcdc40d496e176362891c01c27a95"
},
{
"version_id": "1ddc5cee-33ed-4b0d-aa0b-185da24a051e",
"content_key": "apchem-mcq-021",
"from_md5": "97b269131c3362e44db8ff87d76ac319",
"to_stem": "A sample of pure glucose (C6H12O6, molar mass = 180.16 g/mol) has a mass of 90.0 g. How many moles of glucose does the sample contain?\n\nA. 0.250 mol\nB. 0.500 mol\nC. 2.00 mol\nD. 1.00 mol",
"choices_md5": "41b677f178b06157ca9286885dd1397a"
},
{
"version_id": "e6ee9d9a-9633-4bf5-8370-ed02fe2fdb46",
"content_key": "apchem-mcq-022",
"from_md5": "8dd7f476f14ff6f53c309559d92ef357",
"to_stem": "What is the ground-state electron configuration of the Fe3+ ion (Fe, Z = 26, ground-state configuration [Ar]3d^6 4s^2)?\n\nA. [Ar]3d^6\nB. [Ar]3d^5\nC. [Ar]4s^1 3d^4\nD. [Ar]3d^3 4s^2",
"choices_md5": "d7108655a2d6271704289538a900e40e"
},
{
"version_id": "99803fab-c449-4a33-8a8e-859eee468990",
"content_key": "apchem-mcq-023",
"from_md5": "57b421126f18f4bf9ad88b059d43e1e3",
"to_stem": "The photoelectron spectrum of a neutral atom of an unknown element shows exactly four peaks. Listed in order of decreasing binding energy, the relative peak areas (relative numbers of electrons) are 2, 2, 6, and 2. Identify the element.\n\nA. Neon\nB. Magnesium\nC. Silicon\nD. Sodium",
"choices_md5": "38b9a8d1d7289f78c3923f5fead2002a"
},
{
"version_id": "89a2d1d9-1c53-45e0-8037-659ccb349392",
"content_key": "apchem-mcq-024",
"from_md5": "267a6f2ca8123bc1ab8cc1aba6c4e691",
"to_stem": "The first ionization energy of magnesium (738 kJ/mol) is greater than that of aluminum (578 kJ/mol), even though aluminum has a higher nuclear charge. Which statement correctly explains this trend?\n\nA. Aluminum has greater nuclear charge, so its valence electron should always be harder to remove.\nB. Magnesium's 3s² subshell is completely filled, giving it extra stability, while aluminum's outermost electron occupies the higher-energy 3p subshell, which is shielded by the filled 3s² subshell and thus more easily removed.\nC. Atomic radius increases from magnesium to aluminum, so aluminum's outer electron is farther from the nucleus and easier to remove.\nD. Aluminum's lower ionization energy is explained by its larger atomic radius from magnesium to aluminum.",
"choices_md5": "e382a2f60450a537af8b39f016be7e3f"
},
{
"version_id": "0c3b7b61-5083-4f8f-aced-2e0d50ea22b5",
"content_key": "apchem-mcq-025",
"from_md5": "78940c66f0b5c8dda6b6a6eec0ef7e97",
"to_stem": "Based on electronegativity differences (using the Pauling scale: Cs = 0.79, C = 2.55, H = 2.20, O = 3.44, F = 3.98, N = 3.04), which pair of atoms would be predicted to form a bond with the greatest ionic character?\n\nA. C–H\nB. O–F\nC. Cs–F\nD. N–O",
"choices_md5": "393ccda3ce4edad9cb3b0102b5845c62"
},
{
"version_id": "0a535dc3-dbc8-456d-a9fd-5e228246be63",
"content_key": "apchem-mcq-026",
"from_md5": "dc5d5e635472276c0036205bd2f432c1",
"to_stem": "Which of the following species requires an expanded (greater than octet) valence shell around its central atom in its best Lewis structure?\n\nA. CO2\nB. ClF3\nC. SiCl4\nD. PF3",
"choices_md5": "c3cf58d68ea97cb0790f3b6f269589a1"
},
{
"version_id": "f68af92a-ea07-43b1-9567-553ad9d4f703",
"content_key": "apchem-mcq-027",
"from_md5": "749bf4bcbf465ed92acc9453080dfee1",
"to_stem": "The nitrite ion, NO2-, is represented by two equivalent resonance contributors in which nitrogen forms one N=O double bond and one N–O single bond (with the negative charge delocalized by resonance). In this Lewis structure, what is the formal charge on the singly-bonded oxygen atom?\n\nA. 0\nB. −1\nC. −2\nD. +1",
"choices_md5": "63a0e6e07d6cb5f1d108c635f5a52e01"
},
{
"version_id": "8c5798af-66dc-4e70-a7a4-522e217784a3",
"content_key": "apchem-mcq-028",
"from_md5": "080df79547a8153987ede5bc9e5e5766",
"to_stem": "What are the electron-domain geometry and molecular (molecular-domain) shape of SF4?\n\nA. Trigonal bipyramidal electron-domain geometry; seesaw molecular shape\nB. Trigonal bipyramidal electron-domain geometry; trigonal pyramidal molecular shape\nC. Octahedral electron-domain geometry; square pyramidal molecular shape\nD. Tetrahedral electron-domain geometry; seesaw molecular shape",
"choices_md5": "72a35296ee4e4be8e096f2e7bda83fdf"
},
{
"version_id": "0d6df8e6-6334-459c-9b1e-a7044546e314",
"content_key": "apchem-mcq-029",
"from_md5": "e8cde8dea2edeeb9e1f3c974c76397ec",
"to_stem": "Which substance is expected to have the highest normal boiling point?\n\nA. CH4\nB. CH3Cl\nC. CH3OH\nD. C2H6",
"choices_md5": "f07b395704ec8b7e646e01367129ff08"
},
{
"version_id": "0a499374-2bed-4302-9eee-5bc170186ca0",
"content_key": "apchem-mcq-030",
"from_md5": "d400e7b6ae1846745eb7f2fdc98430d8",
"to_stem": "CH3F and CH3OH have similar molar masses (34 g/mol and 32 g/mol, respectively), yet CH3OH has a substantially higher boiling point (65C) than CH3F (-78C). What best explains this difference?\n\nA. CH3OH molecules are larger, so they experience much stronger London dispersion forces than CH3F.\nB. Intermolecular attractions are limited to dipole-dipole interactions and London dispersion forces because the molecule has no H bonded to N, O, or F.\nC. CH3F is ionic while CH3OH is molecular, so CH3F should have the lower boiling point regardless of intermolecular forces.\nD. Fluorine's higher electronegativity compared to oxygen means CH3F molecules attract each other more strongly, so CH3F should have the higher boiling point.",
"choices_md5": "125a1d2272a57f9a54b38145f8f20887"
},
{
"version_id": "0baf4908-dc68-4ede-85ef-934d4cec725d",
"content_key": "apchem-mcq-031",
"from_md5": "a2373a7437a78383d8f2b29ce1e242e6",
"to_stem": "A solid sample conducts electricity well in both its solid and molten states, is malleable (can be hammered into sheets without shattering), and has a moderately high melting point. What type of solid is this sample most likely to be?\n\nA. An ionic solid, such as an alkali halide\nB. A metallic solid, such as a transition metal\nC. A covalent network solid, such as silicon dioxide\nD. A molecular solid, such as solid iodine",
"choices_md5": "03730c76ea269cf0b889d2250e873aec"
},
{
"version_id": "c9df7103-b591-4276-844b-e60c9f74654f",
"content_key": "apchem-mcq-032",
"from_md5": "5e59a86322ee7340f9a5c1f26d92ab0a",
"to_stem": "A rigid 2.00 L container holds 0.500 mol of an ideal gas at 27C. What is the pressure of the gas? (R = 0.08206 L*atm/(mol*K))\n\nA. 0.554 atm\nB. 6.15 atm\nC. 12.3 atm\nD. 24.6 atm",
"choices_md5": "bc45d0a6a955722f19b954b134b0250b"
},
{
"version_id": "9e049c05-c49e-4b95-b4b9-a777c60c0d2e",
"content_key": "apchem-mcq-033",
"from_md5": "d0c7abc4c3789e390d87a30b0ec82599",
"to_stem": "Separate rigid containers hold samples of He(g) and O2(g) at the same temperature. According to kinetic molecular theory, which statement correctly compares the two samples?\n\nA. The average kinetic energy is the same in both samples, and the average molecular speed is also the same, since both are at the same temperature.\nB. The average kinetic energy is the same in both samples, but He atoms have a greater average speed than O2 molecules.\nC. O2 molecules have greater average kinetic energy than He atoms because O2 has greater mass, and O2 also has greater average speed.\nD. He atoms have greater average kinetic energy than O2 molecules because He moves faster, and O2 has greater average speed.",
"choices_md5": "c03cd82826a5ebdce6b79ad758ca49b3"
},
{
"version_id": "9c848fdb-a55d-4e02-a30b-9c49cf007b4b",
"content_key": "apchem-mcq-034",
"from_md5": "1f21bbe1ca1572935993f0ea5dc40a98",
"to_stem": "Under which set of conditions would a real gas be expected to deviate most significantly from ideal gas behavior, and why?\n\nA. High temperature and low pressure, because molecules move so quickly that intermolecular attractions and molecular volume become significant.\nB. Low temperature and high pressure, because molecules are forced close together (making their finite volume non-negligible) and move slowly enough for intermolecular attractive forces to noticeably affect their motion.\nC. High temperature and high pressure, because both factors independently increase the frequency of molecular collisions with the container walls.\nD. Low temperature and low pressure, because the gas volume becomes negligible under these conditions.",
"choices_md5": "a68bbf7dbcd6fb6c6d82b311937f22d6"
},
{
"version_id": "abaf2bd3-3b9e-40fd-8737-c11733abbcdd",
"content_key": "apchem-mcq-035",
"from_md5": "ac18bd5bd565a83e351c9bf5eb6b52d7",
"to_stem": "As the temperature of water increases, the solubility of a gas such as O2(g) in the water generally decreases. Which statement best explains this observation?\n\nA. At higher temperatures, gas molecules have greater average kinetic energy, allowing more of them to overcome the weak intermolecular attractions holding them in solution and escape into the gas phase.\nB. At higher temperatures, hydrogen bonds between water molecules strengthen, trapping more gas molecules within the solvent structure.\nC. Temperature breaks O2 molecules apart into atoms, so fewer O2 molecules remain dissolved.\nD. The decrease is caused only by evaporation of water, which makes the remaining dissolved oxygen concentration appear lower.",
"choices_md5": "5b337265f1c178ce816084a116818343"
},
{
"version_id": "33ce2b12-d3ad-4bb2-b893-06e5202f7836",
"content_key": "apchem-mcq-036",
"from_md5": "473056683551d8a4505699e635be1b44",
"to_stem": "A colored solution has a molar absorptivity of 1.50 x 10^3 M^-1 cm^-1 at its wavelength of maximum absorbance. When placed in a cuvette with a 1.00 cm path length, the solution's absorbance is measured as 0.750. What is the molar concentration of the solution?\n\nA. 1.13 x 10^3 M\nB. 5.00 x 10^-4 M\nC. 2.00 x 10^3 M\nD. 7.50 x 10^-1 M",
"choices_md5": "5c587fad5a1e09bcd327b95b7ca15564"
},
{
"version_id": "58bd9254-2451-49bb-bad2-eeac957d595a",
"content_key": "apchem-mcq-037",
"from_md5": "23b9b55978fe15392fa3158f3097d7bd",
"to_stem": "A photon of ultraviolet (UV) light is compared to a photon of infrared (IR) light. Which statement correctly ranks their energies and justifies the ranking?\n\nA. The UV photon has more energy than the IR photon because UV light has a shorter wavelength, which corresponds to a higher frequency, and photon energy is directly proportional to frequency (E = hf).\nB. The IR photon has more energy than the UV photon because IR light has a longer wavelength, and longer wavelengths carry more energy.\nC. The two photons have identical energy because all forms of electromagnetic radiation travel at the same speed in a vacuum.\nD. UV photons have more energy because they have a shorter wavelength, and photon energy is directly proportional to wavelength.",
"choices_md5": "c8a6d591fa5e1e3a1003596cb74f0716"
},
{
"version_id": "a43ad81a-5ac8-4f74-8d40-2b88f7c30f0c",
"content_key": "apchem-mcq-038",
"from_md5": "e7553eac58bede196c3189a449bcb25d",
"to_stem": "A chemist needs to recover acetone (boiling point 56 °C) from a homogeneous mixture of acetone and water (boiling point 100 °C). The two liquids are miscible and do not form an azeotrope. Which technique is most appropriate, and why?\n\nA. Filtration, because it separates the two liquids based on differences in particle size.\nB. Distillation, because heating the mixture selectively vaporizes the lower-boiling acetone, which can then be condensed and collected separately from the higher-boiling water.\nC. Paper chromatography, because it separates substances based on their particle size as they pass through the paper.\nD. Recrystallization, because cooling the mixture causes the higher-boiling liquid to solidify out of solution.",
"choices_md5": "351cbdbf7d10d155d11c0dc80f9d621b"
},
{
"version_id": "e5477db9-0823-45d2-9f56-d031977b10d7",
"content_key": "apchem-mcq-039",
"from_md5": "f4e5ad14e75632da2eb93bff6170fe8e",
"to_stem": "A student dilutes 25.0 mL of a 2.00 M stock solution to a final total volume of 200.0 mL. What is the molarity of the resulting diluted solution?\n\nA. 16.0 M\nB. 0.250 M\nC. 2.00 M\nD. 0.286 M",
"choices_md5": "9c6eabb1d65bd7b71cda58f2d27a4b6f"
},
{
"version_id": "7c443eb4-8aad-493d-a4d3-02190ca66b7f",
"content_key": "apchem-mcq-040",
"from_md5": "b1eb5abd2635e8abbcdb8282c6444800",
"to_stem": "A student reacts 5.4 g of Al (molar mass 27.0 g/mol) with 3.2 g of O2 (molar mass 32.0 g/mol) according to the balanced equation 4Al(s) + 3O2(g) -> 2Al2O3(s) (molar mass Al2O3 = 102.0 g/mol). What mass of Al2O3 is produced, assuming the reaction goes to completion?\n\nA. 6.8 g\nB. 10.2 g\nC. 8.6 g\nD. 15.3 g",
"choices_md5": "b9ab7a3d610cae4095f3824d99465d62"
},
{
"version_id": "257f5379-6555-4286-b85b-7a41fba7842a",
"content_key": "apchem-mcq-041",
"from_md5": "39c9ff8f7c8df967f03de90a4602ae68",
"to_stem": "Aqueous solutions of Pb(NO3)2 and KI are mixed, forming a yellow precipitate: Pb(NO3)2(aq) + 2KI(aq) -> PbI2(s) + 2KNO3(aq). Which equation correctly represents the net ionic equation for this reaction?\n\nA. Pb2+(aq) + 2I-(aq) -> PbI2(s)\nB. Pb(NO3)2(aq) + 2KI(aq) -> PbI2(s) + 2KNO3(aq)\nC. Pb2+(aq) + 2NO3-(aq) + 2K+(aq) + 2I-(aq) -> PbI2(s) + 2K+(aq) + 2NO3-(aq)\nD. K+(aq) + NO3-(aq) -> KNO3(s)",
"choices_md5": "5583dd7cad3c60daf456e2d58ce29570"
},
{
"version_id": "02408752-a11b-40fd-b99f-5d5abc5abf5e",
"content_key": "apchem-mcq-042",
"from_md5": "65bff680ee0de2787c84d9ffe1bccf6d",
"to_stem": "In the reaction Zn(s) + 2AgNO3(aq) -> Zn(NO3)2(aq) + 2Ag(s), which species is the oxidizing agent, and how does its oxidation state change?\n\nA. Ag+ is the oxidizing agent; its oxidation state decreases from +1 to 0 as it is reduced.\nB. Zn is the oxidizing agent; its oxidation state increases from 0 to +2.\nC. NO3- is the oxidizing agent because nitrogen changes oxidation state during the reaction.\nD. H2O is the oxidizing agent because it supplies oxygen atoms to the reaction.",
"choices_md5": "125abfbf3cda6dc90f24d1ebc70ba247"
},
{
"version_id": "99b2b547-b2a8-49a9-bf16-c692589ec7c6",
"content_key": "apchem-mcq-043",
"from_md5": "f6af20c6dfebd91c9d060d7a5cc0b1b5",
"to_stem": "Which type of chemical reaction is represented by CaCO3(s) -> CaO(s) + CO2(g) upon heating?\n\nA. Decomposition reaction, because a single compound breaks down into two or more simpler substances.\nB. Combination (synthesis) reaction, because two products form from the reactants.\nC. Single-replacement reaction, because calcium changes bonding partners.\nD. Combustion, because CO2 is produced during heating.",
"choices_md5": "74758df1b46806294c168059ab7d7823"
},
{
"version_id": "b050e0db-5eb9-45c9-a00a-4d40a08c13cb",
"content_key": "apchem-mcq-044",
"from_md5": "6756bcc3b93646e2f87f7ae811a30a5c",
"to_stem": "A 25.00 mL sample of HCl(aq) is titrated to the equivalence point using 0.100 M NaOH(aq), requiring 32.50 mL of titrant according to HCl(aq) + NaOH(aq) -> NaCl(aq) + H2O(l). What is the concentration of the HCl solution?\n\nA. 0.130 M\nB. 0.100 M\nC. 0.0769 M\nD. 0.0650 M",
"choices_md5": "ceb03c601adfc778e4d8067097d5068d"
},
{
"version_id": "3b490535-520e-4500-98b6-e83034141f46",
"content_key": "apchem-mcq-045",
"from_md5": "401fbb019f70d7f59f760176f797dec0",
"to_stem": "Dinitrogen pentoxide decomposes according to the equation 2 N2O5(g) -> 4 NO2(g) + O2(g). At a certain point during the reaction, O2 is forming at a rate of 0.015 M/s. What is the rate of disappearance of N2O5 at that same instant?\n\nA. 0.0075 M/s\nB. 0.015 M/s\nC. 0.030 M/s\nD. 0.060 M/s",
"choices_md5": "f17369f9e70f65c806bb5d6d1656672a"
},
{
"version_id": "938c2a66-d889-4b80-bfb0-858f425e30d0",
"content_key": "apchem-mcq-046",
"from_md5": "184e5be6b62752cfad8a8adb59ca0984",
"to_stem": "The elementary step 2 X(g) + Y(g) -> products is proposed as part of a reaction mechanism. Which rate law is consistent with this elementary step?\n\nA. rate = k[X][Y]\nB. rate = k[X]^2[Y]\nC. rate = k[X]^2[Y]^2\nD. rate = k[X]^3",
"choices_md5": "d0dc7aa87641d3dc10a1b9f358db2010"
},
{
"version_id": "06cc21e7-d68c-4a8f-a463-a13dcae0d066",
"content_key": "apchem-mcq-047",
"from_md5": "d461effda8f2a14f84e93b1005bebb2b",
"to_stem": "A one-step reaction has an activation energy for the forward reaction, Ea(fwd), of 45 kJ/mol and an overall enthalpy change, deltaH, of -20 kJ/mol. What is the activation energy for the reverse reaction, Ea(rev)?\n\nA. 25 kJ/mol\nB. 45 kJ/mol\nC. 65 kJ/mol\nD. 20 kJ/mol",
"choices_md5": "76f9539fae7ad6ab45fb84ff87add55d"
},
{
"version_id": "4d27c8d2-8521-4043-a254-09a6f5c85998",
"content_key": "apchem-mcq-048",
"from_md5": "0924ba2dadfda9e848fa2e38ce4f1a18",
"to_stem": "Which of the following correctly describes how a catalyst increases the rate of a chemical reaction?\n\nA. It increases the average kinetic energy of the reactant molecules, so more collisions occur per second.\nB. It provides an alternative reaction pathway with a lower activation energy, increasing the fraction of collisions with sufficient energy to react.\nC. It shifts the reaction equilibrium further toward products.\nD. It increases the magnitude of deltaH, making the reaction more exothermic.",
"choices_md5": "692a405e96f2ac377c90f7cc7c7d8da0"
},
{
"version_id": "ad10a23b-bc26-45e7-ab78-47c9cea66001",
"content_key": "apchem-mcq-049",
"from_md5": "c59e6fe326b4e1e355f69e52e2f33c18",
"to_stem": "A student dissolves a sample of solid ammonium nitrate in water inside a coffee-cup calorimeter. As the solid dissolves, the temperature of the solution drops from 25.0 C to 18.5 C. Which statement correctly describes this dissolution process?\n\nA. The process is exothermic because the dissolving solid releases heat directly into the solution, which is why the temperature changed.\nB. The process is endothermic; the dissolving ions absorb heat from the surrounding solution, so the solution's own temperature falls, and deltaH for the process is positive.\nC. The process is endothermic, and therefore deltaH for the dissolution must be negative.\nD. The process is exothermic because the water temperature decreases as heat leaves the solution.",
"choices_md5": "50803c06235bff406950c8b46f8db630"
},
{
"version_id": "7456dabc-c72b-49a3-976f-76cc224fcd83",
"content_key": "apchem-mcq-051",
"from_md5": "fd71f86accadedae3d6466e349bb7a3b",
"to_stem": "Using average bond enthalpies (H-H = 436 kJ/mol, Cl-Cl = 243 kJ/mol, H-Cl = 431 kJ/mol), estimate deltaH for the reaction: H2(g) + Cl2(g) -> 2 HCl(g)\n\nA. -183 kJ/mol\nB. +183 kJ/mol\nC. +248 kJ/mol\nD. +679 kJ/mol",
"choices_md5": "3b88f3038475fd338c639c41fd7d6514"
},
{
"version_id": "389fc6e4-cd85-4680-9722-0932d615c709",
"content_key": "apchem-mcq-052",
"from_md5": "45ff521d696be57fd702a92c66341ded",
"to_stem": "Given standard enthalpies of formation Delta Hf standard: CH4(g) = -74.8 kJ/mol, CO2(g) = -393.5 kJ/mol, H2O(l) = -285.8 kJ/mol, and O2(g) = 0 kJ/mol, calculate Delta H(rxn) for: CH4(g) + 2 O2(g) -> CO2(g) + 2 H2O(l)\n\nA. -890.3 kJ/mol\nB. +890.3 kJ/mol\nC. -965.1 kJ/mol\nD. -1039.9 kJ/mol",
"choices_md5": "dcee3a45203864e1788663da3afd98eb"
},
{
"version_id": "2f157e6c-4421-4989-a060-67b59ed1d9e0",
"content_key": "apchem-mcq-053",
"from_md5": "2a66f54233ae8533dbf0f6f1c6f67d4d",
"to_stem": "Given the following thermochemical equations:\n(1) C(s) + O2(g) -> CO2(g), deltaH1 = -393.5 kJ\n(2) CO(g) + 1/2 O2(g) -> CO2(g), deltaH2 = -283.0 kJ\nUse Hess's Law to find deltaH for: C(s) + 1/2 O2(g) -> CO(g)\n\nA. -110.5 kJ\nB. -676.5 kJ\nC. +110.5 kJ\nD. -283.0 kJ",
"choices_md5": "bfeaf01b1b6ef62bf42be6e6a49b54cf"
},
{
"version_id": "3171c639-e6e3-4775-9961-b83609deec9e",
"content_key": "apchem-mcq-054",
"from_md5": "a92dc8ff661d145be2222df527cead08",
"to_stem": "For the heterogeneous equilibrium CaCO3(s) <-> CaO(s) + CO2(g), which expression correctly represents the equilibrium constant, Kc?\n\nA. Kc = [CaO][CO2] / [CaCO3]\nB. Kc = [CO2]\nC. Kc = [CO2] / [CaCO3]\nD. Kc = [CaO] / [CaCO3]",
"choices_md5": "4793d431804dd91237629519589e46f2"
},
{
"version_id": "187c11be-5220-4b94-9e0a-a5c1b1f7c720",
"content_key": "apchem-mcq-055",
"from_md5": "9a3a3d0e021a4251cddb80c7cb74f895",
"to_stem": "At a given temperature, a reaction has Kc = 4.3 x 10^-9. What does this value indicate about the reaction mixture at equilibrium?\n\nA. At equilibrium, the mixture consists mostly of products.\nB. At equilibrium, the reaction strongly favors reactants.\nC. At equilibrium, reactants and products are present in roughly equal amounts.\nD. The reaction goes essentially to completion, converting all reactants to products.",
"choices_md5": "402c8f93e43da942ba41f2a4cb16b123"
},
{
"version_id": "3ce5264a-7c9e-42b2-a4a0-65227fee2021",
"content_key": "apchem-mcq-056",
"from_md5": "9f51462f4418de87d2669e98dcf80e4b",
"to_stem": "For N2(g) + 3H2(g) <-> 2NH3(g), Kc = 0.50 at a certain temperature. A reaction mixture is sampled and Qc is calculated to be 2.0. Which statement correctly describes how the system will respond?\n\nA. The reaction will proceed in the forward direction, producing more NH3, because Q is greater than K.\nB. The reaction will proceed in the reverse direction, forming more N2 and H2, because Q greater than K indicates an excess of products relative to the equilibrium ratio.\nC. The system is already at equilibrium, so no net reaction will occur.\nD. The reaction will proceed in the forward direction because Kc is less than 1.",
"choices_md5": "a93818be453123671cd7fd3e27b231d6"
},
{
"version_id": "fbbbb532-1691-4ea7-bda7-729e1fb15a1c",
"content_key": "apchem-mcq-058",
"from_md5": "3bd10d8e322bdcc07c6bdcf18e8f0415",
"to_stem": "In the reaction HSO4-(aq) + H2O(l) <-> H3O+(aq) + SO4^2-(aq), which species is the conjugate base of HSO4-?\n\nA. H2O\nB. H3O+\nC. SO4^2-\nD. HSO4-",
"choices_md5": "ae1b276f40a14fbbf100891a0840f6de"
},
{
"version_id": "913eb429-6989-4f9f-ad24-98ee98b55a93",
"content_key": "apchem-mcq-059",
"from_md5": "0f3b02541f84e7fc48c48ec117e7ae59",
"to_stem": "What is the pOH of a 0.0025 M HCl solution at 25 C? (HCl is a strong acid.)\n\nA. 2.60\nB. 11.40\nC. 11.00\nD. 12.40",
"choices_md5": "4ca0fc9e111281be0548f86d4a0534dc"
},
{
"version_id": "b71d2ae6-5884-490e-b44b-3335aa936980",
"content_key": "apchem-mcq-060",
"from_md5": "b37dc9bfe8ea2bf89164e93781d532ab",
"to_stem": "A 0.10 M solution of a weak monoprotic acid HA has Ka = 1.0x10^-5. Assuming the approximation x much less than 0.10 is valid, what is the pH of the solution?\n\nA. 3.00\nB. 5.00\nC. 1.00\nD. 6.00",
"choices_md5": "ad9c78549873c1fb0956597539556188"
},
{
"version_id": "c68402dd-2032-41bc-91fb-84b1c0d9d529",
"content_key": "apchem-mcq-062",
"from_md5": "82186a7f1faa0dabb059c6744c1a180f",
"to_stem": "Which of the following hypohalous acids is the strongest acid, and why?\n\nA. HOI, because iodine is the largest halogen and best stabilizes negative charge through its size alone.\nB. HOCl, because chlorine's high electronegativity withdraws electron density inductively through the O-Cl bond, weakening the O-H bond and stabilizing the conjugate base OCl-.\nC. HOI, because iodine forms the strongest binary acid trend and that trend also applies to HOX acids.\nD. HOBr, because bromine is between chlorine and iodine so it should have the intermediate but strongest balance of effects.",
"choices_md5": "7b0dd30c6f3ea0e4bebe429b19cb6b70"
},
{
"version_id": "aa03ff47-9e9b-4401-83d8-636f6d537918",
"content_key": "apchem-mcq-063",
"from_md5": "379671b5233ff595c6380e83cd72354a",
"to_stem": "During the titration of a weak monoprotic acid with NaOH, the pH at the half-equivalence point is measured to be 4.74. What is the Ka of the acid?\n\nA. 1.8x10^-5\nB. 4.74\nC. 5.5x10^-10\nD. 5.5x10^4",
"choices_md5": "45b6968476f6b3f5f1e7244effac1099"
},
{
"version_id": "a3b6c60a-1b4e-47d7-8c19-93abbcb05e03",
"content_key": "apchem-mcq-064",
"from_md5": "fbcca50e174b39c7082a5fa43f8a6fbf",
"to_stem": "A buffer solution contains 0.30 M sodium acetate (CH3COONa) and 0.15 M acetic acid (CH3COOH), where acetic acid has Ka = 1.8x10^-5 (pKa = 4.74). What is the pH of this buffer?\n\nA. 5.04\nB. 4.44\nC. 4.74\nD. 9.48",
"choices_md5": "6e5531f86b528041a3719d38077d7c6e"
},
{
"version_id": "93314114-a6e2-497a-9b99-0f16cd20c9c2",
"content_key": "apchem-mcq-065",
"from_md5": "22a31cfb28b46483655f734e1212af60",
"to_stem": "Four buffer solutions are prepared using the same conjugate acid-base pair (same pKa). Which combination would provide the greatest buffer capacity?\n\nA. 0.10 M HA and 0.10 M A-\nB. 1.0 M HA and 1.0 M A-\nC. 0.10 M HA and 0.90 M A-\nD. 1.0 M HA and 0.010 M A-",
"choices_md5": "17ebb94eeccac0c42c002605071f7dcc"
},
{
"version_id": "e99c96f2-e0c4-47a6-8a42-993fafcf83a2",
"content_key": "apchem-mcq-067",
"from_md5": "feb4011305f159610f25d0095e0319ba",
"to_stem": "A galvanic cell is built from a Zn electrode in 1.0 M Zn(NO3)2 and a Cu electrode in 1.0 M Cu(NO3)2, connected by a wire and a salt bridge. E standard reduction (Cu2+/Cu) = +0.34 V; E standard reduction (Zn2+/Zn) = -0.76 V. Which statement correctly identifies the cathode and the direction of electron flow?\n\nA. The Cu electrode is the cathode, where Cu2+ is reduced to Cu(s); electrons flow through the external wire from the Zn electrode to the Cu electrode.\nB. The Zn electrode is the cathode because it undergoes oxidation, releasing electrons to the circuit.\nC. Electrons flow from the Zn electrode to the Cu electrode through the salt bridge to complete the circuit.\nD. The Cu electrode is the anode because it has the higher (more positive) standard reduction potential.",
"choices_md5": "6fb0795886269fa09f3645016ed7ceb0"
},
{
"version_id": "c5d5b783-6e2a-49db-9674-9df23e6b1bbe",
"content_key": "apchem-mcq-068",
"from_md5": "ce289f88ea0551cf1ad02077a6183990",
"to_stem": "A galvanic cell has a cathode half-reaction Ag+ + e- -> Ag(s), E = +0.80 V, and an anode half-reaction Pb(s) -> Pb2+ + 2e-, E(Pb2+/Pb) = -0.13 V. The overall balanced reaction transfers n = 2 mol electrons. What is deltaG for the cell reaction, and is it thermodynamically favorable?\n\nA. deltaG approximately -179 kJ/mol; favorable, since Ecell = Ecathode - Eanode = 0.80 - (-0.13) = +0.93 V and deltaG = -nFE with n = 2.\nB. deltaG approximately +179 kJ/mol; nonfavorable, since Ecell = Eanode - Ecathode = -0.93 V.\nC. deltaG approximately -90 kJ/mol; favorable, using deltaG = -FE with E = 0.93 V.\nD. +179 kJ/mol; nonfavorable, using DeltaG = nFE with E = 0.93 V.",
"choices_md5": "d3a2e17e1b70eb172c79fa1d7273a2df"
},
{
"version_id": "6e65dac8-3016-4cca-9461-77cbff9621b4",
"content_key": "apchem-mcq-069",
"from_md5": "a49b5c37b075c0336610ec5453b04e99",
"to_stem": "For the cell Zn(s) | Zn2+(aq) || Cu2+(aq) | Cu(s), E°cell = +1.10 V. If [Cu2+] is decreased to well below 1 M while [Zn2+] remains at 1 M, how does the actual cell potential Ecell compare to E standard cell, and why?\n\nA. Ecell decreases below E standard cell, because Q = [Zn2+]/[Cu2+] increases as [Cu2+] decreases, making the -(RT/nF)lnQ term in the Nernst equation more negative.\nB. Ecell increases above E standard cell, because reducing the concentration of any species always increases the cell potential.\nC. Ecell remains equal to E standard cell, because standard reduction potentials are fixed reference values that do not depend on concentration.\nD. Ecell decreases below E standard cell, because Q = [Zn2+]/[Cu2+] decreases as [Cu2+] decreases, making lnQ negative.",
"choices_md5": "b171cddfb9b49cb50614f835c9ceca82"
},
{
"version_id": "701f1361-022e-4827-820b-60359240f885",
"content_key": "apchem-mcq-070",
"from_md5": "3ec21b6252f7dae903636f74c24fdbf1",
"to_stem": "A constant current of 2.00 A is passed through molten CaCl2 for 3.00 hours, depositing Ca(s) at the cathode via Ca2+ + 2e- -> Ca(s) (molar mass of Ca = 40.08 g/mol). What mass of Ca(s) is deposited?\n\nA. approximately 4.49 g, from moles e- = (2.00 A x 3.00 x 3600 s) / 96485 C/mol = 0.224 mol e-, moles Ca = 0.224/2 = 0.112 mol, mass = 0.112 mol x 40.08 g/mol.\nB. approximately 1.25 x 10^-3 g, from charge = 2.00 A x 3.00 h = 6.00 C.\nC. approximately 8.98 g, from moles e- = 21,600 C / 96485 C/mol = 0.224 mol, treating moles Ca as equal to moles e-.\nD. approximately 2.24 g, from dividing the electron amount by 4 instead of 2.",
"choices_md5": "6dbc9837170225401e76bd1536b31c16"
},
{
"version_id": "80ab716d-cb3c-4226-a9c2-627e21309f9e",
"content_key": "apphy2-mcq-010",
"from_md5": "7690b44d1d4945bf0e701c3678c8b070",
"to_stem": "A particle with charge q moves with speed v in a direction parallel to a uniform magnetic field of magnitude B. The magnetic force on the particle is--\n\nA. qvB\nB. qvB, directed parallel to v\nC. zero\nD. qvB, directed perpendicular to both v and B",
"choices_md5": "1fee493380a7dd0cc5ed7f59bfe814c5"
},
{
"version_id": "f8952991-b8db-4914-89a9-0a537f6ec5ae",
"content_key": "apphy2-mcq-012",
"from_md5": "37805fa99d4daa357d2159b8b4467af2",
"to_stem": "Lenz's law determines the induced current's\n\nA. magnitude only\nB. direction\nC. resistance\nD. charge carrier mass",
"choices_md5": "ab7e7785cd3be4b5ccdeb868f300f9a6"
},
{
"version_id": "6d4fc26b-a60d-4fc0-83e5-9f272a68994c",
"content_key": "apphy2-mcq-013",
"from_md5": "336b8f911d9d1ddc419e579ec88ba95e",
"to_stem": "A beam of monochromatic light travels from air into glass. As the light crosses the boundary, its frequency--\n\nA. increases\nB. decreases\nC. stays the same\nD. changes only if the angle of incidence is nonzero",
"choices_md5": "0d851750eddd115c392bb5cd506194ba"
},
{
"version_id": "d1204237-373b-4ad7-a36c-803c6656cfd9",
"content_key": "apphy2-mcq-014",
"from_md5": "520ae2bdd13b71e5d96c0dd8a68f25f9",
"to_stem": "A converging lens forms a real inverted image when the object is\n\nA. inside the focal length\nB. at the focal point\nC. beyond the focal length\nD. at infinity only",
"choices_md5": "14c1fb9544acc59f8e133ce5b6287d3a"
},
{
"version_id": "9d1fee80-d912-43d6-8746-f2795f09787b",
"content_key": "apphy2-mcq-016",
"from_md5": "40a58ab091341f0761d55f2da24ca925",
"to_stem": "A periodic wave has frequency 5.0 Hz and wavelength 0.60 m. What is its speed?\n\nA. 1.5 m/s\nB. 3.0 m/s\nC. 6.0 m/s\nD. 0.60 m/s",
"choices_md5": "8d4fa6805c3a8fb7631d097c22b983ae"
},
{
"version_id": "0975e43b-f228-403c-8b10-3bb449942a51",
"content_key": "apphy2-mcq-017",
"from_md5": "7321f0e6176095bcc07cb80d6bad5b37",
"to_stem": "Two coherent sources, initially in phase, emit waves of the same wavelength. Constructive interference at a point occurs when the path difference between the waves is\n\nA. an integer multiple of wavelength\nB. a half-integer multiple of wavelength\nC. a quarter-integer multiple of wavelength\nD. any multiple of half a wavelength",
"choices_md5": "d814e348c2bbd469bacceae272bf7b51"
},
{
"version_id": "21247dc8-cf80-4098-b5bc-a84792d7ca10",
"content_key": "apphy2-mcq-019",
"from_md5": "4481aeb91a8d53c30c6fbf2b32192841",
"to_stem": "A photon has energy\n\nA. rest energy m0c²\nB. hf\nC. qV always\nD. p²/2m",
"choices_md5": "fc118c584dafdeeb7649d1e515e9f4e1"
},
{
"version_id": "eeae7b54-8e4a-4a14-bb34-d2c46a628fc0",
"content_key": "apphy2-mcq-020",
"from_md5": "54673b1f734bb6d70ace4b6e8d6245e8",
"to_stem": "In the photoelectric effect, increasing the frequency of light above the threshold frequency primarily increases\n\nA. the maximum kinetic energy of the emitted electrons\nB. the number of electrons emitted per second\nC. the metal's threshold frequency\nD. the average kinetic energy of all emitted electrons",
"choices_md5": "44f26c8cc3c8a06230df4595e6210198"
},
{
"version_id": "904498ef-0e49-49f1-99d5-98c5c53deb7b",
"content_key": "apphy2-mcq-031",
"from_md5": "70f743122117a0826ee169c17b586783",
"to_stem": "A long straight wire carries current upward. At a point directly east of the wire, the magnetic field points\n\nA. north\nB. south\nC. east\nD. west",
"choices_md5": "26e2411117fd8d977cffe9b5b7616c7e"
},
{
"version_id": "9add92ae-19a8-4b53-aaeb-24362f0f4842",
"content_key": "apphy2-mcq-032",
"from_md5": "4ac40bfbb6e9de772fa9716067c55ab1",
"to_stem": "A charged particle moves perpendicular to uniform B. If its speed doubles with q, m, and B fixed, its circular-path radius\n\nA. halves\nB. stays the same\nC. doubles\nD. quadruples",
"choices_md5": "eeaa3a58b4095409a165ef0318377f16"
},
{
"version_id": "5664df1f-203d-47f1-a544-227bbf2bfeb6",
"content_key": "apphy2-mcq-033",
"from_md5": "e3e5856a1e748da5f4b3d8e2612a15c4",
"to_stem": "The magnetic flux into the page through a loop is increasing. The induced current is\n\nA. clockwise\nB. counterclockwise\nC. zero\nD. depends on the loop's resistance",
"choices_md5": "9e343de23582cb6dea9d748700a475eb"
},
{
"version_id": "1124f048-e37b-4337-9cb6-b3305820973b",
"content_key": "apphy2-mcq-034",
"from_md5": "0ee9bdd4e3f8a240998f8bf274bf55ae",
"to_stem": "A ray strikes a plane mirror at 25° measured from the normal. Its reflection angle measured from the normal is\n\nA. 25°\nB. 50°\nC. 65°\nD. 0°",
"choices_md5": "056f731e0a5dd84df0501efc383aeab5"
},
{
"version_id": "baebe382-6429-4f75-a28f-e0e40e964daa",
"content_key": "apphy2-mcq-035",
"from_md5": "c896393ed367caca0d9c9acbd1844587",
"to_stem": "A plane mirror forms an image that is\n\nA. real and inverted\nB. virtual and upright\nC. real and enlarged\nD. virtual and inverted",
"choices_md5": "4fca05b86ac1412cc5ac6e1b1db606cb"
},
{
"version_id": "1ff33c89-a38e-43f1-b83d-88261d6ba0ac",
"content_key": "apphy2-mcq-036",
"from_md5": "fc78965e8a6d80578de7a5ce3dad925d",
"to_stem": "Light enters glass from air at an oblique angle. Because glass has larger refractive index, the ray bends\n\nA. toward the normal\nB. away from the normal\nC. without changing direction\nD. toward the surface",
"choices_md5": "63410fef6f622d3ff1b584133f3451c0"
},
{
"version_id": "f9bd3c8d-0ee2-4783-902f-e721a867b065",
"content_key": "apphy2-mcq-037",
"from_md5": "664f9c746581c3784ba7afc8f6172cc6",
"to_stem": "A periodic wave crosses into a medium where its speed decreases. Its frequency\n\nA. decreases\nB. increases\nC. stays the same\nD. changes to a value determined only by the new medium",
"choices_md5": "723954e520bd97794f6949de88d3be98"
},
{
"version_id": "81d4eb9c-d8b7-4df1-a229-8abd0aab3af3",
"content_key": "apphy2-mcq-038",
"from_md5": "ae134afb9be5a490f3d2bd0c78462d33",
"to_stem": "In an electromagnetic wave in vacuum, electric and magnetic fields are\n\nA. parallel to each other\nB. perpendicular to each other and propagation\nC. both along propagation\nD. unrelated in direction",
"choices_md5": "a2cf160c70e8bb866b7ab2b5f654a6fb"
},
{
"version_id": "d7a58c0f-488b-4eae-946a-2bb6223f4e20",
"content_key": "apphy2-mcq-039",
"from_md5": "e037590494c9d8567144e7d23e442eeb",
"to_stem": "A sound source moves away from a stationary observer. The observed frequency is\n\nA. greater than emitted\nB. less than emitted\nC. equal for every speed\nD. equal unless the source moves faster than sound",
"choices_md5": "3706881860956e794245e795f6345be3"
},
{
"version_id": "c0cf1fa7-2e01-4dca-85e2-6e1dad5bb9b4",
"content_key": "apphy2-mcq-040",
"from_md5": "f4bcbca190a4cb2c58981f909cbf4349",
"to_stem": "A bright atomic emission line is produced when an electron\n\nA. moves to a lower energy level\nB. moves to a higher level without input\nC. remains in one level\nD. is ejected from the atom",
"choices_md5": "19cb92b9b43743ced269bd2c1a307291"
},
{
"version_id": "88061f49-923f-46f4-830c-ad9ef63db3d8",
"content_key": "apphy2-mcq-041",
"from_md5": "d989938f8ac6338c343de4d019a813a3",
"to_stem": "In Compton scattering, an X-ray photon transfers energy and momentum to an electron. The scattered photon's wavelength is generally\n\nA. shorter\nB. longer\nC. unchanged for all angles\nD. longer by exactly the electron Compton wavelength at every angle",
"choices_md5": "a681a699a9b072c4228eb3db362eb729"
},
{
"version_id": "425aa4fb-4a89-4c9a-965f-024d59f67674",
"content_key": "apphy2-mcq-042",
"from_md5": "55e6099973ab1255a95ca3ec10c4b0ef",
"to_stem": "In beta-minus decay, a neutron changes into\n\nA. a proton, electron, and antineutrino\nB. a proton and electron only\nC. a proton, positron, and neutrino\nD. an alpha particle",
"choices_md5": "00e06df410fea1220d1e2098d1c76cc4"
},
{
"version_id": "3d8748d0-fdb6-47fa-bf9a-378ac440435c",
"content_key": "apphycem-mcq-010",
"from_md5": "0df4e58de81885b0cf279dd3d64fc5df",
"to_stem": "For capacitor discharge through R, charge follows\n\nA. Q₀e^{-t/RC}\nB. Q₀e^{t/RC}\nC. Q₀t/RC\nD. Q₀cos(t/RC)",
"choices_md5": "885e231f011856980877a144ac0f77ed"
},
{
"version_id": "ca322b9b-4d53-4c08-bda8-81028cb9bb4f",
"content_key": "apphycem-mcq-011",
"from_md5": "4ddceef254627767c77258c48f6462d4",
"to_stem": "A 2.0 uF capacitor, initially charged to 12 V, discharges through a 500 kOhm resistor. Approximately how long does it take for the charge to fall to 37% of its initial value?\n\nA. 0.25 s\nB. 1.0 s\nC. 2.5 s\nD. 4.0 s",
"choices_md5": "5d96f244176f0ccfed582730013b1182"
},
{
"version_id": "4dbb7d4d-c572-46f3-9947-afcc9b107162",
"content_key": "apphycem-mcq-012",
"from_md5": "e3303af6ea735f7151deb44b70a903ed",
"to_stem": "Kirchhoff's junction rule follows from conservation of\n\nA. energy\nB. charge\nC. angular momentum\nD. mass only",
"choices_md5": "8c1afc63b4a1258ae361bfaae8664a5f"
},
{
"version_id": "af65207c-0029-4d96-811a-492016f25afb",
"content_key": "apphycem-mcq-014",
"from_md5": "335732fbb7db96e4a7e7796bbe7322f8",
"to_stem": "Ampère's law in magnetostatics is useful when symmetry makes\n\nA. B has constant magnitude and is tangent to the selected Amperian loop\nB. E zero everywhere\nC. current vanish\nD. potential discontinuous",
"choices_md5": "526f4a7a5a07a5b32ff3a9e7b164b083"
},
{
"version_id": "cb00852c-7a3d-409a-9ef3-4d8716c7edbf",
"content_key": "apphycem-mcq-015",
"from_md5": "81577fe008b2a39ba52a113259d94cd2",
"to_stem": "The differential magnetic force on a current element is\n\nA. I dl×B\nB. I dl·B\nC. IB/dl\nD. qE",
"choices_md5": "713a866730b03873a83159e1ef77ca15"
},
{
"version_id": "a27c0b98-41a7-45a4-906c-785a810d239f",
"content_key": "apphycem-mcq-016",
"from_md5": "2fd82e3527d6926fd4fd8db5c4d1671e",
"to_stem": "Faraday's law in integral form states that the emf around a closed loop, the line integral of E around the loop, is equal to--\n\nA. dΦ_B/dt\nB. -dΦ_B/dt\nC. -Φ_B/t\nD. -μ₀I_enc",
"choices_md5": "31fdfd7374e5360be96132d4817e27f8"
},
{
"version_id": "ce80e748-3c79-42d0-aead-c1aec5bdd52a",
"content_key": "apphycem-mcq-017",
"from_md5": "2138defee5f7885c589b69f1ede4c333",
"to_stem": "For an LR circuit connected to a DC source, current approaches steady state with time constant\n\nA. L/R\nB. R/L\nC. LR\nD. 1/LR",
"choices_md5": "48b08fd285e4a15db8209137a60259a2"
},
{
"version_id": "9f841d49-4f7e-434f-8497-2f7e17361062",
"content_key": "apphycem-mcq-020",
"from_md5": "77b3732b10572b02194235a148fd0900",
"to_stem": "Induced electric fields from changing magnetic flux are\n\nA. conservative with zero circulation\nB. nonconservative with nonzero circulation\nC. always radial\nD. always zero in vacuum",
"choices_md5": "38c6b85a5aabbe27777e29e6e9839778"
},
{
"version_id": "4e0dadc5-b0d6-45ec-a829-f565a271884e",
"content_key": "apphycem-mcq-031",
"from_md5": "632a80f090dee9e93792787431ba88ac",
"to_stem": "Total current through a surface is\n\nA. ∫J·dA\nB. ∫J·dl\nC. JA always\nD. ∫|J|dA",
"choices_md5": "52b2097e5fe80e69f97f47df61e160f0"
},
{
"version_id": "ce5636a2-ac51-4d6a-bd7a-9525d7c25408",
"content_key": "apphycem-mcq-032",
"from_md5": "374c6bff93bb698cd9cfb18fd6ec8eba",
"to_stem": "In a steady series circuit, current through each element is\n\nA. the same\nB. proportional to resistance\nC. zero after each resistor\nD. largest nearest the battery",
"choices_md5": "d0d3c9521dee65d4ba77cc5201566b06"
},
{
"version_id": "4ccd67cf-6aed-4fb7-851d-edbb005d51d7",
"content_key": "apphycem-mcq-033",
"from_md5": "c9f449c15e8ea9bb6c390658e5593549",
"to_stem": "A wire's length doubles and radius doubles with resistivity unchanged. Its resistance becomes\n\nA. 2R\nB. R\nC. R/2\nD. R/4",
"choices_md5": "2e77823625cd78dfb159e3ef3c406e2f"
},
{
"version_id": "6fe06345-fde5-40eb-b532-04effab6cc25",
"content_key": "apphycem-mcq-035",
"from_md5": "399b9c38257b0065e0aae81c01b6ad51",
"to_stem": "Kirchhoff's loop rule for a steady circuit follows from conservation of\n\nA. charge\nB. energy\nC. momentum\nD. magnetic flux only",
"choices_md5": "9b0ea3a64113295c4dfc905eb9f5a577"
},
{
"version_id": "cd96dd11-e6ad-428b-a95a-f20886b9b911",
"content_key": "apphycem-mcq-036",
"from_md5": "d3ca5877e3655f17a3521ad94232a2fb",
"to_stem": "An uncharged capacitor connects through R to ideal emf ε. Immediately after closing, current is\n\nA. 0\nB. ε/R\nC. ε/(2R)\nD. infinite for any R",
"choices_md5": "bdb0bbd4ba5fd7c64a3fd6be98f985ef"
},
{
"version_id": "e612ebec-2e6a-4b04-9c5c-5d7e7b711977",
"content_key": "apphycem-mcq-037",
"from_md5": "ba50f453303ad79f401bc125e90dfbf6",
"to_stem": "Gauss's law for magnetism states\n\nA. ∮B·dA=0\nB. ∮B·dA=μ₀Q\nC. ∮B·dl=0 always\nD. ∇×B=0 everywhere",
"choices_md5": "e7e6212e7111c02872a30ecbc054d38e"
},
{
"version_id": "330a4588-b35a-4460-a7cb-65ee2ece4661",
"content_key": "apphycem-mcq-038",
"from_md5": "26c4f37ce7986a80158267b0353f64d4",
"to_stem": "A static magnetic field acting alone on a point charge does\n\nA. positive work\nB. negative work\nC. zero work\nD. work depends on the sign of the charge",
"choices_md5": "7abc4552ad352152b5b2cfdb94094a30"
},
{
"version_id": "f643b085-a308-44ca-9625-94eabea78655",
"content_key": "apphycem-mcq-039",
"from_md5": "e925f8da0ba4efef15fd058eaaffa48a",
"to_stem": "For a long ideal solenoid with n turns per length, interior field is\n\nA. μ₀nI\nB. μ₀I/(2πr)\nC. (1/2)μ₀nI\nD. zero",
"choices_md5": "80face9547c99c9296649ff378382d76"
},
{
"version_id": "f0231b54-ad44-4cae-82d7-ff1cfe0b95e7",
"content_key": "apphycem-mcq-040",
"from_md5": "2c5ef2b3f94d63fec82cbe637ca81bc2",
"to_stem": "Uniform B crosses a single loop of area A at angle θ to the area normal. Flux is\n\nA. BA sinθ\nB. BA cosθ\nC. BA\nD. 2BA cosθ",
"choices_md5": "cc4aed348db20fab0e2ec16218ebb3ab"
},
{
"version_id": "24bfd312-4fa1-47cf-aa88-77cacab03038",
"content_key": "apphycem-mcq-041",
"from_md5": "7c68aa4c4025d5c943b619d053e3aeba",
"to_stem": "A conducting plate entering a magnetic-field region experiences a force opposing motion because\n\nA. eddy currents obey Lenz's law\nB. eddy currents reinforce the increasing magnetic flux\nC. magnetic fields do positive work directly\nD. electrical resistance directly exerts a backward mechanical force",
"choices_md5": "0cf1214adbc8007f3e54aee2a38f13b1"
},
{
"version_id": "a3e5e87b-0940-4284-98bc-5b4b0e8f3691",
"content_key": "apphycem-mcq-042",
"from_md5": "20f0b1bde60989cd1664754a464f7d29",
"to_stem": "Energy stored in an ideal inductor carrying current I is\n\nA. LI²\nB. (1/2)LI²\nC. 2LI²\nD. (1/4)LI²",
"choices_md5": "13726414939b172b15b7eabb3b2f5735"
},
{
"version_id": "ad958df1-1534-4cb0-970c-df8e9328985c",
"content_key": "apphycm-mcq-005",
"from_md5": "e6842f3327b666065d8e33b3dd9171a3",
"to_stem": "A particle under F=-kx satisfies\n\nA. x''+(k/m)x=0\nB. x''-kx=0\nC. x'=k/m\nD. x''=constant positive",
"choices_md5": "e1216161ce420bf20516f7ab32268820"
},
{
"version_id": "80dda346-3421-4f59-95fc-e7f973e1e15c",
"content_key": "apphycm-mcq-009",
"from_md5": "4a1f66310d342de9b8af43578f971b24",
"to_stem": "For variable force F(t), impulse from 0 to T is\n\nA. F(T)/T\nB. ∫₀ᵀF(t)dt\nC. dF/dt\nD. ∫F dx",
"choices_md5": "97c4cfc2f729f7428dead8d1d2e2efe6"
},
{
"version_id": "06cab4fb-979c-4ec6-ae24-3e384ef8097a",
"content_key": "apphycm-mcq-010",
"from_md5": "4a5c7668a63c3fcc1c920bfe47708fe8",
"to_stem": "A rocket's changing-mass motion is analyzed by applying momentum conservation to\n\nA. rocket alone without exhaust\nB. rocket plus expelled mass\nC. fuel mass only\nD. Earth only",
"choices_md5": "16ccb05ebb61076f82886e1eec574503"
},
{
"version_id": "7bbc529a-7234-40c3-a573-179ab58d6a13",
"content_key": "apphycm-mcq-011",
"from_md5": "0603ba251baa1a4c845176638710a1fa",
"to_stem": "For angular position θ(t), angular acceleration is\n\nA. dθ/dt\nB. d²θ/dt²\nC. ∫θdt\nD. θ²",
"choices_md5": "582db9211e98474a61daf7e36f8ba543"
},
{
"version_id": "6deeda4a-51fc-4932-a515-dc302ff2e27a",
"content_key": "apphycm-mcq-012",
"from_md5": "22479d381881513283a3d8479852b159",
"to_stem": "Torque from potential energy U(θ), for a system whose potential energy depends only on the angle θ, is\n\nA. dU/dθ\nB. -dU/dθ\nC. -U/θ\nD. +d²U/dθ²",
"choices_md5": "b6ecc0238f6b98c941f0dda09b05cf85"
},
{
"version_id": "928a5a7e-6957-4b74-9802-281e9ce3e96c",
"content_key": "apphycm-mcq-013",
"from_md5": "c5d5d4beb5b95c86e1d544b7c05e8ced",
"to_stem": "For a continuous body, moment of inertia about a chosen rotation axis is (r is the perpendicular distance of each mass element from that axis)\n\nA. ∫r dm\nB. ∫r² dm\nC. ∫dm/r\nD. Mr always",
"choices_md5": "1e9c09fd223cdcfaf2c635b7497b3309"
},
{
"version_id": "2a806254-1a78-4af8-b4dd-689a497ef50e",
"content_key": "apphycm-mcq-014",
"from_md5": "eb667c890643f15556fef62f02f8535d",
"to_stem": "A system experiences zero net external torque. Which of the following is true of dL/dt?\n\nA. zero\nB. I*omega (constant, nonzero)\nC. L/t\nD. proportional to omega^2",
"choices_md5": "4bae70ca8a11ed9979dc9a6e51523a8d"
},
{
"version_id": "f19dc852-061a-4060-ab50-f526132c9b24",
"content_key": "apphycm-mcq-015",
"from_md5": "577e0a029c299ac2cec1dd491f3d0487",
"to_stem": "The small-angle pendulum equation is\n\nA. θ''+(g/L)θ=0\nB. θ''-(g/L)θ=0\nC. θ'=gL\nD. θ''=g",
"choices_md5": "f0a02f391aea19fce3bd368cbff5ce0d"
},
{
"version_id": "f0d61bed-eb70-4a59-a66d-b5a2c8f0c654",
"content_key": "apphycm-mcq-016",
"from_md5": "131a2692e5df5955cfeb3ce521caf273",
"to_stem": "The period for x''+ω²x=0 is\n\nA. ω/2π\nB. 2πω\nC. 2π/ω\nD. 1/ω²",
"choices_md5": "d914ee7f2b0343195f5419dce39bcd74"
},
{
"version_id": "b7f33d69-7a41-42ba-9455-eb46472604f3",
"content_key": "apphycm-mcq-019",
"from_md5": "4291525a2649a0656e8f449a465eff96",
"to_stem": "For τ(t)=τ₀t acting on constant I, change in angular speed from 0 to T is\n\nA. τ₀T/I\nB. τ₀T²/(2I)\nC. Iτ₀T²\nD. τ₀T²/I",
"choices_md5": "904b819910e0d42032d372c0735a9f3d"
},
{
"version_id": "f415f38a-4f86-4254-92a2-51b3687c44d5",
"content_key": "apphycm-mcq-020",
"from_md5": "0da3c24576a409ca59f12a7110f33fe1",
"to_stem": "For a physical pendulum undergoing small-angle oscillation, omega^2 equals which of the following, where d is the distance from the pivot to the center of mass and I is the moment of inertia about the pivot?\n\nA. mgd/I\nB. I/mgd\nC. g/I\nD. mgI/d",
"choices_md5": "d85fe20fd96141ab854796a03218bebf"
},
{
"version_id": "5e75e2b8-cfe6-4f8d-bec9-324d66ccd696",
"content_key": "apphycm-mcq-032",
"from_md5": "82ea3eb3aab7d8799fa9838198408f2a",
"to_stem": "A force F₀e^{-t/τ} acts from t=0 to infinity. Its impulse is\n\nA. F₀τ/e\nB. F₀τ\nC. (1/2)F₀τ\nD. zero",
"choices_md5": "83b30ef5a4fc1ba7cb1f5ac76446be63"
},
{
"version_id": "ba498b18-fcc5-4323-977c-89cd83878f89",
"content_key": "apphycm-mcq-033",
"from_md5": "fddb0552910728ebc966de72161988f4",
"to_stem": "For a system of total mass M, total momentum is\n\nA. M times center-of-mass velocity\nB. sum of speeds\nC. always zero\nD. the sum of the magnitudes of the individual momenta",
"choices_md5": "236f9b92793df9715723e3ee00be1f6c"
},
{
"version_id": "ba6e8551-c83d-4c81-8844-09674b2f42cc",
"content_key": "apphycm-mcq-034",
"from_md5": "56f4c110f73f53da0b43bf1cb7a13aed",
"to_stem": "In an isolated perfectly inelastic collision,\n\nA. momentum and kinetic energy are conserved\nB. momentum is conserved but kinetic energy is not\nC. kinetic energy is conserved but momentum is not\nD. neither total energy nor momentum is conserved",
"choices_md5": "13fbb24e1d602d36c783ddf654724e07"
},
{
"version_id": "c352aa57-dd96-4b56-9dc1-7a95b80e8da2",
"content_key": "apphycm-mcq-035",
"from_md5": "c66da59fb0669a74dabd6fcc1afc383e",
"to_stem": "Torque about an origin is\n\nA. r·F\nB. r×F\nC. F×r\nD. rF",
"choices_md5": "4bafcb964b8bd35f09391a14e1062fb3"
},
{
"version_id": "fe698e65-d37b-4194-81c2-75504cba2deb",
"content_key": "apphycm-mcq-036",
"from_md5": "811db8e7d201fbbf8497580e400c4054",
"to_stem": "For constant rotational inertia I, net torque is\n\nA. Iω\nB. I dω/dt\nC. Iω²\nD. (1/2)I dω/dt",
"choices_md5": "f20421ed9a0b2d9cdc0d1544d981e65f"
},
{
"version_id": "c1f19405-a9cd-45f3-b9d9-55a57b86b180",
"content_key": "apphycm-mcq-037",
"from_md5": "12b51134eaf91d683d42c0b3de76823f",
"to_stem": "A rigid body rotating at angular speed ω has kinetic energy\n\nA. Iω\nB. (1/2)Iω²\nC. Iω²\nD. 2Iω²",
"choices_md5": "bacb1011d0d5e21db942aabf3fba4200"
},
{
"version_id": "6de62c61-d226-478b-88f6-fed67a05f2a8",
"content_key": "apphycm-mcq-038",
"from_md5": "5f45ae7dbd3de0443e61967ec581b464",
"to_stem": "Angular impulse over a time interval equals\n\nA. ∫τdt\nB. ∫τdθ\nC. dL/dt\nD. Iω",
"choices_md5": "4588f99e54504e8d5cabab5f397ff5ac"
},
{
"version_id": "0284f245-d4ce-4c8d-95bf-3022d1cac73d",
"content_key": "apphycm-mcq-039",
"from_md5": "5596cf1d21a384cf86d603a4fa452dff",
"to_stem": "For rolling without slipping, center-of-mass speed is\n\nA. ωR/2\nB. ωR\nC. 2ωR\nD. independent of ω",
"choices_md5": "524a4f35df281669d9238cfae7593011"
},
{
"version_id": "a6ce6f27-2a89-4fdb-bd4f-e462b7c09f73",
"content_key": "apphycm-mcq-040",
"from_md5": "c4de701c7e67cd379405146ec9f712a5",
"to_stem": "For circular orbits about the same mass, doubling radius multiplies period by\n\nA. sqrt2\nB. 2\nC. 2sqrt2\nD. 4",
"choices_md5": "0a2aaf9890014a1ddf7546848ae60584"
},
{
"version_id": "b8e9a3af-7e78-4715-8dab-7b2342d3421f",
"content_key": "apphycm-mcq-041",
"from_md5": "d4d4dd370031191c768c6a603333b1a5",
"to_stem": "For m x''+kx=0, angular frequency is\n\nA. k/m\nB. sqrt(k/m)\nC. sqrt(m/k)\nD. (1/2π)sqrt(k/m)",
"choices_md5": "22bfb88bc3961653501aa447d39b5d9c"
},
{
"version_id": "73234415-efbc-48f4-9d1c-acad9e98b7e1",
"content_key": "apphycm-mcq-042",
"from_md5": "bd3fdaaef2ca218d0021ec38240dec96",
"to_stem": "For amplitude A in ideal SHM with spring constant k, total energy is\n\nA. kA²\nB. (1/2)kA²\nC. (1/2)kA\nD. (1/2)mωA²",
"choices_md5": "402b26d08b3416b059922e178ed80c18"
},
{
"version_id": "71881e36-c4b2-4336-9796-9b4cb4689e61",
"content_key": "apchem-mcq-006",
"from_md5": "a3efdfb8d73296098eeb2690ff7cc396",
"to_stem": "A solution has absorbance 0.60 in a 1.0 cm cell. If concentration is halved, the absorbance is approximately\n\nA. 0.15\nB. 0.30\nC. 0.60\nD. 1.20\n\nAssume the diluted solution is measured at the same wavelength in the same 1.0 cm cell and remains in the linear Beer-Lambert range.",
"choices_md5": "9c5bba84fb47010606cf6d1ba39b7ad4"
},
{
"version_id": "76895682-1bb0-4be4-95d0-4a197edb866f",
"content_key": "apchem-mcq-007",
"from_md5": "87b71b82d4c7283f71bd436c7b567efa",
"to_stem": "Which change most increases the solubility of a nonreactive gas in water?\n\nA. Raise temperature and lower pressure\nB. Raise temperature and raise pressure\nC. Lower temperature and raise pressure\nD. Lower temperature and lower pressure\nAssume pressure refers to the gas partial pressure above the solution.",
"choices_md5": "39c232230f1bd9e8f2ed5e5ceacbde19"
},
{
"version_id": "1a1fb40c-1fb1-4127-bb24-9fd2ee067131",
"content_key": "apchem-mcq-017",
"from_md5": "50fdeb9f9589e2159ac66c17a42c49ec",
"to_stem": "The pH of 1.0×10⁻³ M HCl is approximately\n\nA. 1.00\nB. 3.00\nC. 7.00\nD. 11.00\n\nAssume 25 C.",
"choices_md5": "0582d959fe774d86f384929b3536202b"
},
{
"version_id": "5a6405c0-7c21-4333-8269-1a6ac8792f4d",
"content_key": "apchem-mcq-057",
"from_md5": "25bdbca990ae6ca91aac6b92ab0631a7",
"to_stem": "A saturated aqueous solution of CaF2 is at equilibrium: CaF2(s) <-> Ca2+(aq) + 2F-(aq). A small amount of soluble NaF is added to the solution and stirred until it fully dissolves. What happens to the molar solubility of CaF2?\n\nA. The molar solubility of CaF2 increases because Na+ removes F- from solution.\nB. The molar solubility of CaF2 decreases because the added F- is a common ion that shifts the equilibrium toward the solid, in accordance with Le Chatelier's principle.\nC. The molar solubility of CaF2 stays the same because Ksp is a constant and is unaffected by adding NaF.\nD. The molar solubility increases because Ksp must increase when more ions are added.\nAssume ideal solution behavior and no complex-ion formation.",
"choices_md5": "1f64c92b6625f5fc737bf329c08a1afe"
},
{
"version_id": "758bafd5-9407-4a0c-a4ee-dcd375ab1d29",
"content_key": "apchem-mcq-061",
"from_md5": "a64f2457ce78e87d209f359e58aa28d3",
"to_stem": "50.0 mL of 0.20 M HCl is mixed with 50.0 mL of 0.30 M NaOH. What is the pH of the resulting solution?\n\nA. 12.70\nB. 1.30\nC. 13.00\nD. 1.00\n\nAssume 25 C and additive volumes.",
"choices_md5": "8efd92a0adeaa1e691a849a544532761"
},
{
"version_id": "510c04d3-678d-4bc9-a050-4462d34b933c",
"content_key": "apchem-mcq-066",
"from_md5": "5cf8acb236724b519de94ee50e32c82e",
"to_stem": "A reaction has deltaH = -92 kJ/mol and deltaS = +198 J/(mol*K). Which statement correctly describes the thermodynamic favorability of this reaction?\n\nA. The reaction is nonspontaneous at all temperatures because deltaH is negative.\nB. The reaction is thermodynamically favorable at all temperatures because deltaG = deltaH - TdeltaS is negative for every value of T greater than 0 when deltaH is less than 0 and deltaS is greater than 0.\nC. The reaction is favorable only at low temperatures because the TdeltaS term becomes negligible as T decreases.\nD. The reaction is favorable only at high temperatures because a large positive deltaS requires a large T to overcome an unfavorable deltaH.\n\nAssume Delta H and Delta S remain approximately temperature-independent over the temperature range considered.",
"choices_md5": "0f760e849daed7b697ff001c53582148"
},
{
"version_id": "afe405bd-b6f6-4591-84e9-39b28c97962e",
"content_key": "apphycem-mcq-013",
"from_md5": "00c47d6dbe5c9ea55f4a99f83ed84ab1",
"to_stem": "In the Biot-Savart law, the direction of the differential magnetic field contribution dB from a current element is set by\n\nA. dl×r-hat\nB. r-hat×dl\nC. dl·r-hat\nD. charge velocity only\n\n(Here r-hat is the unit vector pointing from the current element toward the observation point.)",
"choices_md5": "d6b1fd892b77c5b2a6c79d13620424dc"
}
]$tj$::jsonb;
  v_live jsonb; v_prior jsonb;
  n_target int; n_live int; n_upd int; n_lbl int; n_bad int;
begin
  if v_approval is null or v_approval = 'PENDING' then
    raise exception 'stem-choice-cleanup-rollback-2026-10-06: label carry-forward needs a Product Owner approval reference (set v_approval)';
  end if;
  perform pg_advisory_xact_lock(hashtext('cramapple-' || v_run));
  n_target := jsonb_array_length(v_targets);
  if n_target <> 198 then raise exception '%: expected 198 target rows, got %', v_run, n_target; end if;

  -- idempotence: only rows whose stem is still byte-identical to the expected one, still the current published
  -- MCQ version, with choices unchanged since the snapshot
  select coalesce(jsonb_agg(jsonb_build_object('version_id', t.version_id, 'from_md5', t.from_md5, 'to_stem', t.to_stem,
           'choices_md5', t.choices_md5, 'content_item_id', civ.content_item_id,
           'old_taxo_hash', app.taxonomy_relevant_hash(civ.id))), '[]'::jsonb)
    into v_live
  from jsonb_to_recordset(v_targets) as t(version_id uuid, content_key text, from_md5 text, to_stem text, choices_md5 text)
  join app.content_item_versions civ on civ.id = t.version_id
  join app.content_items ci on ci.id = civ.content_item_id and ci.content_key = t.content_key
  where md5(civ.stem) = t.from_md5
    and civ.status = 'published' and ci.item_type = 'mcq'
    and not exists (select 1 from app.content_item_versions later
                    where later.content_item_id = civ.content_item_id and later.version_num > civ.version_num)
    and (select md5(string_agg(mc.choice_key || '|' || mc.choice_text || '|' || mc.is_correct::text, chr(10) order by mc.choice_key))
         from app.mcq_choices mc where mc.content_item_version_id = civ.id) = t.choices_md5;
  n_live := jsonb_array_length(v_live);
  raise notice '%: % of % target rows still match and will be updated', v_run, n_live, n_target;
  if n_live = 0 then
    return;  -- already applied (or every row drifted): nothing to do
  end if;

  -- capture every current label the stale trigger can touch (validated / provisional_model), BEFORE the write:
  -- the derive trigger nulls validated_by/at/decision when the status flips to stale. 'held' labels are not touched
  -- by the trigger but carry the same hash; re-point them too so a later hold release is not blocked by this edit.
  select coalesce(jsonb_agg(jsonb_build_object('content_taxonomy_label_id', l.content_taxonomy_label_id,
           'version_id', lv.version_id, 'label_status', l.label_status, 'validated_by', l.validated_by,
           'validated_at', l.validated_at, 'validation_decision_id', l.validation_decision_id,
           'validated_against_version_id', l.validated_against_version_id,
           'was_fresh', (l.validated_against_taxo_hash is not distinct from lv.old_taxo_hash))), '[]'::jsonb)
    into v_prior
  from jsonb_to_recordset(v_live) as lv(version_id uuid, content_item_id uuid, old_taxo_hash text)
  join app.content_taxonomy_labels l on l.content_item_id = lv.content_item_id
  where l.superseded_by is null and l.label_status in ('validated', 'provisional_model', 'held');

  update app.content_item_versions civ
  set stem = lv.to_stem
  from jsonb_to_recordset(v_live) as lv(version_id uuid, from_md5 text, to_stem text)
  where civ.id = lv.version_id and md5(civ.stem) = lv.from_md5;
  get diagnostics n_upd = row_count;
  if n_upd <> n_live then raise exception '%: updated % rows, expected %', v_run, n_upd, n_live; end if;

  -- carry labels forward: restore the exact prior status/validation; re-point the hash only where it was fresh
  update app.content_taxonomy_labels l
  set label_status = p.label_status,
      validated_by = p.validated_by,
      validated_at = p.validated_at,
      validation_decision_id = p.validation_decision_id,
      validated_against_version_id = p.validated_against_version_id,
      validated_against_taxo_hash = case when p.was_fresh then app.taxonomy_relevant_hash(p.version_id)
                                         else l.validated_against_taxo_hash end,
      source_payload = l.source_payload || jsonb_build_object('carried_forward_' || replace(v_run, '-', '_'), jsonb_build_object(
        'version_id', p.version_id,
        'reason', 'rollback of stem/choice cleanup: snapshot stem restored; choices, units and topics unchanged',
        'approval_ref', v_approval, 'run', v_run))
  from jsonb_to_recordset(v_prior) as p(content_taxonomy_label_id uuid, version_id uuid, label_status text,
       validated_by uuid, validated_at timestamptz, validation_decision_id uuid, validated_against_version_id uuid, was_fresh boolean)
  where l.content_taxonomy_label_id = p.content_taxonomy_label_id;
  get diagnostics n_lbl = row_count;

  -- postconditions
  select count(*) into n_bad
  from jsonb_to_recordset(v_live) as lv(version_id uuid, to_stem text, choices_md5 text)
  join app.content_item_versions civ on civ.id = lv.version_id
  where civ.stem is distinct from lv.to_stem or civ.status <> 'published'
     or cardinality(app.mcq_stem_choice_desync(civ.id, civ.stem)) > 0
     or (select md5(string_agg(mc.choice_key || '|' || mc.choice_text || '|' || mc.is_correct::text, chr(10) order by mc.choice_key))
         from app.mcq_choices mc where mc.content_item_version_id = civ.id) is distinct from lv.choices_md5;
  if n_bad > 0 then raise exception '%: % rows fail stem/status/choices/desync postconditions', v_run, n_bad; end if;
  select count(*) into n_bad
  from jsonb_to_recordset(v_prior) as p(content_taxonomy_label_id uuid, version_id uuid, label_status text, was_fresh boolean)
  join app.content_taxonomy_labels l on l.content_taxonomy_label_id = p.content_taxonomy_label_id
  where l.label_status <> p.label_status
     or (p.was_fresh and l.validated_against_taxo_hash is distinct from app.taxonomy_relevant_hash(p.version_id));
  if n_bad > 0 then raise exception '%: % labels not carried forward', v_run, n_bad; end if;
  select count(*) into n_bad
  from jsonb_to_recordset(v_live) as lv(content_item_id uuid)
  join app.content_taxonomy_labels l on l.content_item_id = lv.content_item_id
  where l.superseded_by is null and l.label_status = 'stale';
  if n_bad > 0 then raise exception '%: % target labels left stale', v_run, n_bad; end if;

  raise notice '%: stems updated %, labels carried forward %', v_run, n_upd, n_lbl;
end
$apply$;
