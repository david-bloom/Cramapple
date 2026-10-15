"""Semantic and rendered-layout checks for the four exact question stimuli."""
import hashlib
import json
import math
from pathlib import Path
import unittest
import xml.etree.ElementTree as ET

import render as R

HERE = Path(__file__).resolve().parent
SPECS = {v["visual_id"]: v for v in json.loads((HERE / "specs.json").read_text())["visuals"]}


class QuestionVisuals(unittest.TestCase):
    def test_rebuild_is_byte_identical(self):
        before = (HERE / "manifest.json").read_bytes()
        R.build()
        self.assertEqual(before, (HERE / "manifest.json").read_bytes())

    def test_first_graph_exact_segments(self):
        s = SPECS["calc-ab-u13-002-graph"]
        segments = s["segments"]
        expected = [[(-4, -2), (-1, 4)], [(-1, 1), (2, 1)], [(2, 3), (4, -1)]]
        for segment, ends in zip(segments, expected):
            for x, y in ends:
                self.assertAlmostEqual(R.value(segment, x), y)
        self.assertEqual({(p["x"], p["y"], p["included"]) for p in s["points"]},
                         {(-4, -2, True), (-1, 4, False), (-1, 1, True),
                          (2, 1, False), (2, 3, True), (4, -1, True)})

    def test_second_graph_endpoint_and_pole_contract(self):
        s = SPECS["calc-ab-u13g-1-3-graph"]
        a, b, left, right = s["segments"]
        self.assertEqual([(R.value(a, x)) for x in [-4, -1]], [0, 3])
        self.assertEqual([(R.value(b, x)) for x in [-1, 2]], [-2, 4])
        self.assertAlmostEqual(R.value(left, 2), 4)
        self.assertAlmostEqual(R.value(right, 6), 1)
        self.assertGreater(R.value(left, 3.999), 1000)
        self.assertGreater(R.value(right, 4.001), 1000)
        xs = [2.01, 2.2, 2.8, 3.2, 3.9]
        self.assertEqual(sorted(R.value(left, x) for x in xs), [R.value(left, x) for x in xs])
        xs = [4.01, 4.2, 4.8, 5.2, 6]
        self.assertEqual(sorted((R.value(right, x) for x in xs), reverse=True), [R.value(right, x) for x in xs])
        self.assertEqual(s["asymptotes"], [4])
        self.assertTrue(all(p["x"] != 4 for p in s["points"]))
        self.assertEqual({(p["x"], p["y"], p["included"]) for p in s["points"]},
                         {(-4, 0, True), (-1, 3, False), (-1, 1, True),
                          (-1, -2, False), (2, 4, False), (2, 0, True), (6, 1, True)})

    def test_teaching_graph_equations_and_markers(self):
        s = SPECS["calc-ab-oht-1-3-graph"]
        a, b = s["segments"]
        for x in [-1, 0, 1, 2, 3]:
            self.assertEqual(R.value(a, x), x + 2)
        for x in [3, 3.5, 4]:
            self.assertEqual(R.value(b, x), x*x - 7)
        self.assertEqual(s["points"], [{"x": 3, "y": 5, "included": True},
                                       {"x": 3, "y": 2, "included": False}])

    def test_particle_counts_positions_and_unambiguous_volumes(self):
        s = SPECS["chem-oht-3-8-particles"]
        self.assertEqual([p["volume_ml"] for p in s["panels"]], [100, 200])
        self.assertEqual([len(p["particles"]) for p in s["panels"]], [8, 16])
        for panel, height in zip(s["panels"], [2, 4]):
            dots = panel["particles"]
            for i, (x, y) in enumerate(dots):
                self.assertTrue(.1 < x < 3.9 and .1 < y < height - .1)
                for xx, yy in dots[i + 1:]:
                    self.assertGreater(math.hypot(x - xx, y - yy), .2)

    def test_every_layout_has_correct_particles_and_readable_labels(self):
        s = SPECS["chem-oht-3-8-particles"]
        for name, layout in R.LAYOUTS.items():
            fig = R.particles(s, layout)
            fig.canvas.draw()
            self.assertEqual([sum(isinstance(p, R.Circle) for p in ax.patches) for ax in fig.axes], [8, 16])
            # Same physical scale, radius, and two-to-one box area at every layout.
            a, b = fig.axes
            wa, ha = a.get_window_extent().size
            wb, hb = b.get_window_extent().size
            self.assertAlmostEqual(wa, wb)
            self.assertAlmostEqual(hb / ha, 2)
            R.plt.close(fig)

    def test_rendered_text_is_inside_canvas_and_nonoverlapping(self):
        for spec in SPECS.values():
            for layout in R.LAYOUTS.values():
                fig = R.particles(spec, layout) if spec["kind"] == "particles" else R.graph(spec, layout)
                fig.canvas.draw()
                renderer = fig.canvas.get_renderer()
                labels = [t for t in fig.findobj(R.matplotlib.text.Text)
                          if (t.get_gid() or "").startswith("meaningful-")]
                bounds = []
                for label in labels:
                    box = label.get_window_extent(renderer)
                    self.assertTrue(0 <= box.x0 and 0 <= box.y0 and box.x1 <= fig.bbox.width and box.y1 <= fig.bbox.height,
                                    f'{spec["visual_id"]} {label.get_gid()} off canvas: {box}')
                    for prior in bounds:
                        self.assertFalse(box.overlaps(prior), f'{spec["visual_id"]} overlapping meaningful labels')
                    bounds.append(box)
                R.plt.close(fig)

    def test_assets_have_accessibility_hashes_and_minimum_size(self):
        manifest = json.loads((HERE / "manifest.json").read_text())
        self.assertEqual(len(manifest["visuals"]), 4)
        ns = "{http://www.w3.org/2000/svg}"
        for visual in manifest["visuals"]:
            self.assertGreater(len(visual["alt"]), 80)
            for layout in visual["layouts"].values():
                for ext in ["svg", "png"]:
                    p = HERE / layout[ext]
                    self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(), layout["sha256"][ext])
                self.assertGreaterEqual(layout["min_meaningful_glyph_css_px"], 16)
                root = ET.parse(HERE / layout["svg"]).getroot()
                self.assertIsNotNone(root.find(ns + "title"))
                self.assertIsNotNone(root.find(ns + "desc"))
                self.assertFalse(any(e.tag.endswith("script") for e in root.iter()))


if __name__ == "__main__":
    unittest.main(verbosity=2)
