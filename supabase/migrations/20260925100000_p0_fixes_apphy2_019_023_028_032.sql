-- Remediation batch 4 of the 34 P0 findings from PR #188.
--
-- apphy2-frq-019: canonical omitted the requested P-V cycle sketch/arrows (part a) and part (c)'s
-- first-law explanation. Described the sketch in words (standard pattern for text-only canonicals) and
-- wrote all three parts.
--
-- apphy2-frq-023: canonical gave correct circuit numbers but omitted the requested junction/loop-rule
-- explanation (part c). Wrote part (c).
--
-- apphy2-frq-028: canonical omitted the required ray diagram / two valid principal rays (part a).
-- Described both principal rays and their intersection point in words.
--
-- apphy2-frq-032: canonical omitted the requested energy-level diagram (part a). Described it in words.

begin;

update app.content_item_versions
set canonical_answer_1 = '(a) The cycle traces a rectangle on the P-V diagram: start at (V₀,P₀), go straight up (constant volume) to (V₀,3P₀), then straight right (constant pressure) to (2V₀,3P₀), then straight down (constant volume) to (2V₀,P₀), then straight left (constant pressure) back to (V₀,P₀) -- with arrows on all four segments pointing in that same clockwise order. Since PV=nRT, temperature is highest wherever the product PV is largest; comparing the four vertices, (2V₀,3P₀) gives the largest PV product, so that corner has the greatest temperature.

(b) The area enclosed by the rectangle equals net work done by the gas: W_net = (ΔP)(ΔV) = (3P₀-P₀)(2V₀-V₀) = (2P₀)(V₀) = 2P₀V₀. Because the cycle is traversed clockwise, the gas does net positive work on its surroundings, so W_net=+2P₀V₀.

(c) Over a complete cycle, the gas returns to its starting state, so its internal energy change is zero: ΔU_cycle=0. By the first law, ΔU=Q-W, so 0=Q_net-W_net, giving Q_net=W_net=2P₀V₀. This is positive, meaning net heat flows into the gas over the cycle -- consistent with the gas doing net positive work while ending with no net change in internal energy.'
where id = '03cb90e0-aa97-453a-95ae-f9c30925f61e';

update app.content_item_versions
set canonical_answer_1 = '(a) Each branch has resistors in series: Branch 1 = 4 Ω + 8 Ω = 12 Ω; Branch 2 = 6 Ω + 6 Ω = 12 Ω. The two 12 Ω branches are in parallel, giving equivalent resistance (12·12)/(12+12) = 6 Ω. Total current from the battery: I=V/R_eq = 12 V/6 Ω = 2 A.

(b) Since both branches have equal resistance (12 Ω each) and see the same 12 V, each branch carries 1 A -- so 1 A flows through the 4 Ω and 8 Ω resistors (in series in Branch 1), and 1 A flows through each 6 Ω resistor (in series in Branch 2). Power: P=I²R gives 4 W in the 4 Ω resistor, 8 W in the 8 Ω resistor, and 6 W in each 6 Ω resistor.

(c) At the junction where the branches meet the battery, the 2 A total current splits into the two branches: 1 A into Branch 1 and 1 A into Branch 2, satisfying the junction rule (current in = current out: 2 A = 1 A + 1 A). For the loop rule, follow each branch from the battery''s + terminal back to its - terminal: in Branch 1, the voltage drops are (1 A)(4 Ω)=4 V and (1 A)(8 Ω)=8 V, summing to 12 V, matching the battery''s 12 V EMF; in Branch 2, the voltage drops are (1 A)(6 Ω)=6 V and (1 A)(6 Ω)=6 V, also summing to 12 V. Each loop''s total voltage drop equals the EMF, satisfying the loop rule.'
where id = 'c1f00b9c-648a-418a-97ef-90fc077b57e9';

update app.content_item_versions
set canonical_answer_1 = '(a) Draw the principal axis as a horizontal line through the mirror''s vertex, with F and C marked on it (F at the focal length, C at twice the focal length from the mirror). The upright object arrow stands on the axis between F and C. Use two principal rays from the tip of the object: Ray 1 travels parallel to the principal axis until it strikes the mirror, then reflects through F. Ray 2 travels through F on its way to the mirror, then reflects back parallel to the principal axis. These two reflected rays are extended until they intersect; because the object sits between F and C, that intersection occurs beyond C, in front of the mirror -- this intersection point locates the tip of the image, with the image arrow pointing downward (opposite the upright object).

(b) Because the reflected rays actually converge at a point in front of the mirror (rather than only appearing to diverge from behind it), the image is real. It is inverted (pointing opposite the object) and enlarged (magnified) relative to the object, consistent with an object placed between F and C on a concave mirror.'
where id = 'fddc7ce8-ac97-4e7c-8e79-2d71d3f82b4f';

update app.content_item_versions
set canonical_answer_1 = '(a) Draw two horizontal energy levels, with the n=2 level below the n=4 level (energy increases, i.e., becomes less negative, with increasing n). Draw a downward-pointing arrow from the n=4 level to the n=2 level, representing the electron''s transition and the photon emitted during that drop.

(b) E₄=-13.6/4²=-0.850 eV; E₂=-13.6/2²=-3.40 eV. Emitted photon energy = E₄-E₂ = -0.850-(-3.40) = 2.55 eV. Frequency: f=E/h=2.55/(4.14×10⁻¹⁵)≈6.16×10¹⁴ Hz. Wavelength: λ=c/f=(3.00×10⁸)/(6.16×10¹⁴)≈4.87×10⁻⁷ m = 487 nm.

(c) The reverse transition (n=2 to n=4) is absorption rather than emission: the atom must absorb a photon of exactly the same energy, 2.55 eV (the same frequency and wavelength as the emitted photon), since the energy difference between the two levels is fixed regardless of direction -- only the direction of energy transfer (photon absorbed versus emitted) differs.'
where id = 'd25d66d0-a39c-4e32-9683-34377e35d708';

commit;
