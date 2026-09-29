export function addonCustomerOptions(stripeCustomerId: string | null) {
  return stripeCustomerId
    ? { customer: stripeCustomerId }
    : { customer_creation: "always" as const };
}
