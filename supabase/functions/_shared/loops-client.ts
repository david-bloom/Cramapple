// Thin Loops API client for lifecycle-email triggers. Loops owns journey
// content, timing, and scheduling entirely in its own dashboard -- this
// module's only job is to reliably tell Loops "this happened, for this
// contact." Never throws: a failed Loops call must never break the
// entitlement/purchase flow that triggered it.

const LOOPS_API_BASE = "https://app.loops.so/api/v1";

export async function sendLoopsEvent(input: {
  email: string;
  eventName: string;
  eventProperties?: Record<string, string | number | boolean>;
  contactProperties?: Record<string, string | number | boolean>;
}): Promise<void> {
  const apiKey = Deno.env.get("LOOPS_SECRET_KEY");
  if (!apiKey) return;

  try {
    const response = await fetch(`${LOOPS_API_BASE}/events/send`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        email: input.email,
        eventName: input.eventName,
        eventProperties: input.eventProperties ?? {},
        contactProperties: input.contactProperties ?? {},
      }),
    });
    if (!response.ok) {
      console.error(
        "loops_event_failed",
        input.eventName,
        response.status,
        await response.text().catch(() => ""),
      );
    }
  } catch (error) {
    console.error("loops_event_failed", input.eventName, error);
  }
}
