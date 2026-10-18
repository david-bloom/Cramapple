# Card-trial email templates — brief for Claude Design (TASK-0077)

Eighteen Loops transactional templates for the seven-day free trial (`DECISION-0126`). Build them on **the same base template as
templates 01–10 in this folder**: same layout, header, footer, type and voice (second person, present tense, no exclamation
marks, no emoji). Each template is listed in `manifest.json` when it exists, with its variables and published `transactionalId`;
the id then goes into the matching Edge Function secret.

**Every template receives the same variables.** The code sends all of them; a template uses the ones it needs. All are strings.

| Variable | Example | Notes |
|---|---|---|
| `subjects` | `AP Biology, AP Statistics` | |
| `amount` | `$19.99` | The locked price, promo included |
| `chargeDate` | `Sunday, October 25, 2026 (Eastern)` | Day-7 charge date; always Eastern (item 29) |
| `graceEndDate` | `Monday, October 26, 2026 (Eastern)` | Failed charge: when access pauses |
| `recoveryDeadline` | `Wednesday, November 25, 2026 (Eastern)` | Last day to pay after grace |
| `delayedChargeDate` | `Tuesday, October 27, 2026 (Eastern)` | New charge date after a delay on our side |
| `studentFirstName` | `Sam` | Parent-pay only; may be empty |
| `paidByParent` | `yes` / `no` | |
| `cancelOutcome` | `no_charge` / `refunded` | Cancellation email only |
| `cardLast4` | `4242` | Payer copy of "trial started" only; empty elsewhere |
| `cancelUrl` | link | Payer (parent): one-click cancel link. Student: their Account page |
| `recoveryUrl` | link | Payer only, failure emails only; empty in student copies |
| `accountUrl` | link | Account page in the app |
| `termsUrl` | `https://cramapple.com/terms` | |
| `mailingAddress` | footer address | Same footer as every transactional email |

**Two copies of each email.** "Payer" goes to whoever pays: the student on their own checkout, the parent on parent-pay. "Student"
goes to the student **only on parent-pay**. Student copies never contain payment links or card details (`recoveryUrl` and
`cardLast4` are empty for them).

## The nine emails

File names continue the existing numbering. The secret for each is `LOOPS_TRIAL_<KIND>_<PAYER|STUDENT>_TRANSACTIONAL_ID`.

| # | Kind | Payer copy | Student copy (parent-pay) |
|---|---|---|---|
| 11 | `TRIAL_STARTED` | Your 7-day free trial of {subjects} has started. On {chargeDate} we'll charge {amount} to the card ending {cardLast4} unless you cancel. Cancel button ({cancelUrl}). Link to Terms. This is the written record of the agreement to the future charge, so the amount, date, card and how to cancel must all be on it. | Your parent started your 7-day free trial of {subjects}. Start studying ({accountUrl}). It ends on {chargeDate}. You can cancel it from your Account. |
| 12 | `REMINDER` (day 5, 48 h before) | Your trial ends on {chargeDate}. We'll charge {amount} unless you cancel before then. Cancel button. | Your trial ends on {chargeDate}; your parent's card will be charged {amount} then unless the trial is cancelled. |
| 13 | `PAYMENT_FAILED` | We couldn't charge {amount} for {subjects}. Your access continues until {graceEndDate}. Update your payment button ({recoveryUrl}). | There was a problem with your parent's payment. Your access continues until {graceEndDate}. No link. |
| 14 | `REQUIRES_ACTION` | Your bank needs you to confirm the {amount} payment. Confirm button ({recoveryUrl}). Access continues until {graceEndDate}. | Same as 13's student copy. |
| 15 | `GRACE_ENDED` | Your access to {subjects} is paused. You can still pay {amount} until {recoveryDeadline} to pick up where you left off. Pay button ({recoveryUrl}). | Your access is paused until the payment is completed. |
| 16 | `DELAYED_CHARGE` | We couldn't process your charge on {chargeDate} because of a problem on our side. We'll charge {amount} on {delayedChargeDate} unless you cancel. Your access continues until then. Cancel button. | Same facts, without payment details. |
| 17 | `CANCELED` | `cancelOutcome = no_charge`: Your trial is cancelled. You won't be charged. `refunded`: Your trial is cancelled and the {amount} charge has been refunded in full. Either way: access to {subjects} has ended; buying again later is a regular purchase. | Your trial of {subjects} has been cancelled and your access has ended. |
| 18 | `CONVERTED` | Receipt: thanks, {amount} paid for {subjects}; access continues with no end date. | "Your parent paid for {subjects}." (May reuse the existing parent-paid template's look.) |
| 19 | `REFUNDED` | Your {amount} payment for {subjects} has been refunded in full; access has ended. | Your access to {subjects} has ended. |

**Wording rules from the decisions:**
- Name the exact amount and date wherever a charge is mentioned (state free-trial rules; `DECISION-0126` items 8, 27).
- Never write "you won't be charged" unless `cancelOutcome` is `no_charge` (item 19).
- Dates come pre-formatted with "(Eastern)"; don't reformat them.
- New trial wording should go to the lawyer if it wasn't part of their review (item 27).
