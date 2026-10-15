# Two follow-up question visuals

Built for the owner's request to complete and certify the Calculus AB/Chemistry Units 1–3 audit. **Prepared, not uploaded or attached.** The four earlier attachments remain live.

`specs.json` recovers only supplied question givens. `manifest.json` pins the two exact Production versions, source MD5s, audit digest, SVG/PNG SHA-256, accessible descriptions, immutable private paths and renderer hashes. `render.py` reuses the graph renderer from `../question-visuals-pilot/render.py`; both files are hash-pinned. Matplotlib 3.9.4 and NumPy 1.26.4 reproduce the assets. No model runs or generated artwork.

* `apcalcab-mcq-060`: the supplied line, downward parabola, open `(3,4)` and filled `(3,6)`. No limit value, answer arrow or choice is annotated.
* `apchem-frq-u13g-3-8`: equal-volume models with P's six Na⁺/six Cl⁻ and Q's four Ca²⁺/eight Cl⁻. Charges are printed, so color is redundant. All ions are separate. Q's concentration and the requested water orientations are omitted. The complete source table is preserved.

Compact artwork is 340 CSS pixels wide, served as 2× PNG. At the minimum 272px width, meaningful labels are 17.6px. The tall Chemistry image stacks panels instead of shrinking ion labels. Circle sizes are schematic and carry no relative ionic-radius claim. Axes, charges and counts are taken from the source; no invented concentration or geometry.

Run `MPLCONFIGDIR=/tmp/cramapple-cert-mpl arch -x86_64 python3 render.py`, then `verify.py` in the same environment. Four checks pass: exact graph equations/markers, exact ion counts/equal box sizes, labels inside the canvas without overlap, and byte-identical rebuild/hash/glyph-floor checks. Both PNGs were visually inspected by the implementer. This is not an independent reader verdict.

`attach_production.sql` is an exact-version/hash/status guarded atomic attachment, with approved metadata/requirements and question/scoring/taxonomy invariance checks. It expects the two immutable objects to exist and neither target to have metadata/decisions. `rehearse_production.sql` performs the same work but rolls back. `rollback_production.sql` recovers original null paths and removes this batch's rows while retaining immutable bytes. All are **unexecuted**. Before release, independently review all six images, upload/verify private bytes, rehearse, commit, verify signed reads and actual student delivery. Do not redeploy the drifted backend function from repository main.

Independent QA found two release-script weaknesses before execution: only stem/stimulus were guarded against pre-existing drift, and recovery did not fence later metadata/decision edits. The prepared attachment now compares the complete frozen audit digest (including choices, authored parts and full prompt/package), locks current choice rows and verifies choice-row invariance. Recovery locks versions/metadata/decisions and requires full release-owned row hashes captured after commit; its NOT_RELEASED placeholders deliberately fail until the release record exists. These scripts remain unexecuted.
