from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[2]
CHECKER_PATH = ROOT / "scripts" / "ap_statistics_calculation_check" / "checker.py"


def load_checker():
    spec = importlib.util.spec_from_file_location("ap_statistics_calculation_check.checker", CHECKER_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec and spec.loader
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


checker = load_checker()


class CalculationCheckerTest(unittest.TestCase):
    def assert_verdict(self, result, verdict):
        self.assertEqual(result["verdict"], verdict)

    def test_exact_match_z_statistic(self):
        result = checker.check_request(
            {
                "response_id": "z-exact",
                "answer_text": "The test statistic is z = 1.96.",
                "expected_answer_spec": {
                    "calculation_type": "z_statistic",
                    "target": 1.96,
                    "tolerance": 0.0001,
                },
            }
        )
        self.assert_verdict(result, "matches")

    def test_within_tolerance_p_value_inequality(self):
        result = checker.check_request(
            {
                "response_id": "p-within",
                "answer_text": "Since the p-value is < 0.05, the result is significant.",
                "expected_answer_spec": {
                    "calculation_type": "p_value",
                    "target": 0.047,
                    "tolerance": 0.005,
                },
            }
        )
        self.assert_verdict(result, "matches")

    def test_out_of_tolerance_confidence_interval(self):
        result = checker.check_request(
            {
                "response_id": "ci-miss",
                "answer_text": "95% CI is (12.4, 18.9).",
                "expected_answer_spec": {
                    "calculation_type": "confidence_interval",
                    "target": {"lower": 12.4, "upper": 19.4},
                    "tolerance": 0.1,
                },
            }
        )
        self.assert_verdict(result, "does_not_match")

    def test_ambiguous_multiple_confidence_intervals(self):
        result = checker.check_request(
            {
                "response_id": "ci-ambiguous",
                "answer_text": "My first try was (10.0, 15.0), but the corrected 95% CI is (12.4, 18.9).",
                "expected_answer_spec": {
                    "calculation_type": "confidence_interval",
                    "target": {"lower": 12.4, "upper": 18.9},
                    "tolerance": 0.1,
                },
            }
        )
        self.assert_verdict(result, "indeterminate")

    def test_tolerance_edge_matches_with_float_noise(self):
        result = checker.check_request(
            {
                "response_id": "edge-match",
                "answer_text": "t = 2.00",
                "expected_answer_spec": {
                    "calculation_type": "t_statistic",
                    "target": 1.95,
                    "tolerance": 0.05,
                },
            }
        )
        self.assert_verdict(result, "matches")

    def test_no_extractable_number(self):
        result = checker.check_request(
            {
                "response_id": "no-number",
                "answer_text": "I checked the formula again and the statistic should work out.",
                "expected_answer_spec": {
                    "calculation_type": "t_statistic",
                    "target": 2.31,
                    "tolerance": 0.01,
                },
            }
        )
        self.assert_verdict(result, "indeterminate")

    def test_ambiguous_multiple_t_values(self):
        result = checker.check_request(
            {
                "response_id": "ambiguous",
                "answer_text": "t = 2.31 at first, then I corrected it to t = 2.74 after rechecking.",
                "expected_answer_spec": {
                    "calculation_type": "t_statistic",
                    "target": 2.31,
                    "tolerance": 0.01,
                },
            }
        )
        self.assert_verdict(result, "indeterminate")

    def test_confidently_wrong_statistic(self):
        result = checker.check_request(
            {
                "response_id": "wrong",
                "answer_text": "The answer is z = 1.25 because rounding does not matter.",
                "expected_answer_spec": {
                    "calculation_type": "z_statistic",
                    "target": 1.96,
                    "tolerance": 0.01,
                },
            }
        )
        self.assert_verdict(result, "does_not_match")

    def test_cli_jsonl_protocol(self):
        payload = {
            "response_id": "cli-smoke",
            "answer_text": "t = 2.31",
            "expected_answer_spec": {
                "calculation_type": "t_statistic",
                "target": 2.31,
                "tolerance": 0.001,
            },
        }
        proc = subprocess.run(
            [sys.executable, str(CHECKER_PATH)],
            input=json.dumps(payload) + "\n",
            text=True,
            capture_output=True,
            check=True,
        )
        output = json.loads(proc.stdout.strip())
        self.assertEqual(output["response_id"], "cli-smoke")
        self.assertEqual(output["verdict"], "matches")


if __name__ == "__main__":
    unittest.main()
