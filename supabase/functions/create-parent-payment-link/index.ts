import { handleCreateCheckoutSession } from "../create-checkout-session/index.ts";

Deno.serve((req) => handleCreateCheckoutSession(req, "parent_share"));
