// Reddit Conversions API (v3) delivery for day-7 trial charges
// (docs/product/REDDIT_CONVERSIONS_API_DAY7_PLAN_2026_10_25.md).
//
// app.trial_convert queues one row in app.ad_conversion_outbox for a
// converted order whose checkout recorded a Reddit click id. This sends each
// row once as a PURCHASE: the click id, the amount and the order id as the
// deduplication key. Nothing else about the payer or student is sent (David,
// 2026-10-25: click id only).

// deno-lint-ignore no-explicit-any
type Any = any;

export const REDDIT_CONVERSIONS_URL = (pixelId: string) =>
  `https://ads-api.reddit.com/api/v3/pixels/${encodeURIComponent(pixelId)}/conversion_events`;

// Reddit accepts events up to seven days old (two days for deduplication).
const MAX_EVENT_AGE_MS = 7 * 24 * 60 * 60 * 1000;

export type ConversionRow = {
  id: string;
  order_id: string;
  event_type: "PURCHASE";
  click_id: string;
  value_cents: number;
  currency: string;
  event_at: string;
  attempt_count: number;
  lease_id: string | null;
};

export type RedditConversionDeps = {
  service: Any;
  fetch: typeof fetch;
  accessToken: string | null;
  pixelId: string | null;
  // Event Testing id from Reddit Events Manager. Required outside Production,
  // so Development traffic never lands in real reporting.
  testId: string | null;
  isProduction: boolean;
  now: () => Date;
  log: (message: string, detail?: Record<string, unknown>) => void;
};

export function conversionBody(row: ConversionRow, testId: string | null) {
  return {
    data: {
      ...(testId ? { test_id: testId } : {}),
      events: [{
        event_at: new Date(row.event_at).getTime(),
        action_source: "WEBSITE",
        type: { tracking_type: row.event_type },
        click_id: row.click_id,
        metadata: {
          conversion_id: row.order_id,
          currency: row.currency.toUpperCase(),
          value: row.value_cents / 100,
        },
      }],
    },
  };
}

// Back off 5, 15, 45 minutes … capped at 6 hours.
function retryAt(now: Date, attempt: number) {
  const minutes = Math.min(360, 5 * 3 ** Math.max(0, attempt - 1));
  return new Date(now.getTime() + minutes * 60_000).toISOString();
}

export async function deliverRedditConversions(deps: RedditConversionDeps, limit = 10) {
  const summary: { claimed: number; sent: number; failed: number; held: number; skipped?: string } = {
    claimed: 0,
    sent: 0,
    failed: 0,
    held: 0,
  };
  if (!deps.accessToken || !deps.pixelId) return { ...summary, skipped: "not_configured" };
  if (!deps.isProduction && !deps.testId) return { ...summary, skipped: "test_id_required" };

  const app = deps.service.schema("app");
  const { data: rows, error } = await app.rpc("claim_ad_conversions", { p_limit: limit });
  if (error) throw error;
  summary.claimed = (rows ?? []).length;

  for (const row of (rows ?? []) as ConversionRow[]) {
    const now = deps.now();
    const update = (patch: Record<string, unknown>) =>
      app.from("ad_conversion_outbox").update({ leased_until: null, ...patch })
        .eq("id", row.id).eq("lease_id", row.lease_id);

    // Too old for Reddit to accept: keep it for review rather than retry forever.
    if (now.getTime() - new Date(row.event_at).getTime() > MAX_EVENT_AGE_MS) {
      await update({ needs_review: true, last_error: "event_too_old" });
      summary.held++;
      continue;
    }
    try {
      const response = await deps.fetch(REDDIT_CONVERSIONS_URL(deps.pixelId), {
        method: "POST",
        headers: {
          Authorization: `Bearer ${deps.accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(conversionBody(row, deps.isProduction ? null : deps.testId)),
        signal: AbortSignal.timeout(5000),
      });
      if (response.ok) {
        await update({ delivered_at: now.toISOString(), last_error: null });
        summary.sent++;
        continue;
      }
      // Never log the response body: keep the outbox free of provider text.
      const code = `reddit_http_${response.status}`;
      const retryable = response.status === 429 || response.status >= 500;
      await update({
        last_error: code,
        next_attempt_at: retryAt(now, row.attempt_count),
        needs_review: !retryable || row.attempt_count >= 8,
      });
      summary.failed++;
    } catch (e) {
      await update({
        last_error: e instanceof Error ? e.name.slice(0, 60) : "reddit_request_failed",
        next_attempt_at: retryAt(now, row.attempt_count),
        needs_review: row.attempt_count >= 8,
      });
      summary.failed++;
    }
  }
  if (summary.failed) deps.log("reddit_conversions_failed", { failed: summary.failed });
  return summary;
}
