export const PERCEPTION_CONTRACT_VERSION = "handwriting-perception-v1";

export type TranscriptionLine = {
  line_id: string;
  text: string;
  confidence: number;
  ambiguous_spans: string[];
  learner_confirmed: boolean;
};

export function assessTranscriptionReadiness(input: {
  captureQuality: "pass" | "retry" | "unreadable";
  lines: TranscriptionLine[];
}) {
  if (input.captureQuality !== "pass") {
    return {
      contract_version: PERCEPTION_CONTRACT_VERSION,
      status: "capture_retry" as const,
      gradable: false,
      reason: "The image must be recaptured before transcription or grading.",
    };
  }
  if (input.lines.length === 0 || input.lines.some((line) =>
    !line.learner_confirmed || line.ambiguous_spans.length > 0 ||
    !Number.isFinite(line.confidence) || line.confidence < 0 || line.confidence > 1
  )) {
    return {
      contract_version: PERCEPTION_CONTRACT_VERSION,
      status: "needs_confirmation" as const,
      gradable: false,
      reason: "Confirm every line and resolve every ambiguous span before grading.",
    };
  }
  return {
    contract_version: PERCEPTION_CONTRACT_VERSION,
    status: "confirmed" as const,
    gradable: true,
    reason: null,
  };
}

export function canReuseConfirmedTranscription(previous: {
  imageHash: string;
  preprocessingVersion: string;
  transcriptionVersion: string;
  confirmed: boolean;
}, current: {
  imageHash: string;
  preprocessingVersion: string;
  transcriptionVersion: string;
}) {
  return previous.confirmed && previous.imageHash === current.imageHash &&
    previous.preprocessingVersion === current.preprocessingVersion &&
    previous.transcriptionVersion === current.transcriptionVersion;
}
