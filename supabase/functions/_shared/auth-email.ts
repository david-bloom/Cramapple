import { Webhook } from "https://esm.sh/standardwebhooks@1.0.0";
import {
  emailFirstName,
  emailFooter,
  emailText,
  emailUrl,
} from "./email-template-data.ts";
import {
  requireEmailConfig,
  sendLoopsTransactional,
} from "./loops-transactional.ts";

const TEMPLATE_ENV: Record<string, string> = {
  signup: "LOOPS_SIGNUP_TRANSACTIONAL_ID",
  invite: "LOOPS_INVITE_TRANSACTIONAL_ID",
  magiclink: "LOOPS_MAGICLINK_TRANSACTIONAL_ID",
};

export function buildAuthEmail(payload: unknown) {
  const { user, email_data: data } = payload as {
    user?: { email?: string; user_metadata?: { first_name?: unknown } };
    email_data?: { email_action_type?: string; token?: string };
  };
  const action = data?.email_action_type ?? "";
  const templateEnv = Object.hasOwn(TEMPLATE_ENV, action)
    ? TEMPLATE_ENV[action]
    : undefined;
  if (!templateEnv) throw new Error("unsupported_auth_email_action");
  if (!user?.email || !data?.token || !/^\d{6}$/.test(data.token)) {
    throw new Error("invalid_auth_email_payload");
  }
  return {
    transactionalId: requireEmailConfig(templateEnv),
    email: user.email,
    dataVariables: {
      token: data.token,
      welcomeUrl: emailUrl(requireEmailConfig("AUTH_EMAIL_WELCOME_URL")),
      emailAddress: emailText(user.email),
      expiryText: "Use this code soon. Request a new code if it expires.",
      ...emailFooter(),
      ...(action === "invite"
        ? {
          // Personalization only: metadata must never imply payment or access.
          firstName: emailFirstName(user.user_metadata?.first_name),
        }
        : {}),
    },
  };
}

export async function handleAuthEmail(req: Request): Promise<Response> {
  const respond = (body: unknown, status = 200) =>
    new Response(JSON.stringify(body), {
      status,
      headers: { "Content-Type": "application/json" },
    });
  if (req.method !== "POST") {
    return respond(
      { error: { http_code: 405, message: "Method not allowed" } },
      405,
    );
  }
  let webhook: Webhook;
  try {
    webhook = new Webhook(
      requireEmailConfig("SEND_EMAIL_HOOK_SECRET").replace(/^v1,whsec_/, ""),
    );
  } catch {
    return respond({
      error: { http_code: 503, message: "Email hook unavailable" },
    }, 503);
  }
  let payload: unknown;
  try {
    payload = webhook.verify(await req.text(), Object.fromEntries(req.headers));
  } catch {
    return respond(
      { error: { http_code: 401, message: "Invalid signature" } },
      401,
    );
  }
  try {
    const id = req.headers.get("webhook-id");
    if (!id) throw new Error("missing_webhook_id");
    await sendLoopsTransactional(buildAuthEmail(payload), `auth:${id}`);
    return respond({});
  } catch {
    return respond({
      error: {
        http_code: 503,
        message: "Authentication email delivery failed",
      },
    }, 503);
  }
}
