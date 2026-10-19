#!/usr/bin/env python3
"""Build the card-trial Loops templates (TASK-0077) in the transactional design.

Writes loops/11-*.mjml … loops/20-*.mjml and their manifest.json entries
(status "draft", no transactionalId until published in Loops). The wrapper,
type, colours, header bar, details box, button and footer are copied from
the published templates (loops/04-parent-payment-request.mjml) so every
email reads as one family. Copy follows docs/email/transactional/
TRIAL_TEMPLATES_BRIEF.md and DECISION-0126. Rerun after editing the copy:

    python3 docs/email/transactional/build_trial_templates.py
"""
from __future__ import annotations

import html
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
LOOPS = ROOT / "loops"

SANS = "'Source Sans 3',Arial,Helvetica,sans-serif"
DISPLAY = "'Passion One','Arial Narrow',Arial,sans-serif"
INK, MUTED, RULE, BOX, BOX_RULE = "#16202a", "#5b6b78", "#eceae6", "#f7f6f3", "#dedbd5"


def v(name: str) -> str:
    return "{DATA_VARIABLE:%s}" % name


def esc(text: str) -> str:
    """Escape copy, leaving {DATA_VARIABLE:…} placeholders intact."""
    return html.escape(text, quote=False)


def row(inner: str) -> str:
    return f'<tr><td style="padding:0 0 20px 0;">{inner}</td></tr>'


def eyebrow(text: str) -> str:
    return row(
        f'<div style="font-family:{SANS};font-size:12px;line-height:14px;font-weight:700;'
        f'letter-spacing:1.8px;text-transform:uppercase;color:{MUTED};">{esc(text)}</div>'
    )


def heading(text: str) -> str:
    return row(
        f'<h1 style="margin:0;font-family:{DISPLAY};font-weight:700;font-size:26px;line-height:28px;'
        f'color:{INK};">{esc(text)}</h1>'
    )


def para(text: str) -> str:
    return row(
        f'<p style="margin:0;font-family:{SANS};font-size:16px;line-height:24px;color:{INK};">{esc(text)}</p>'
    )


def small(text: str) -> str:
    return row(
        f'<p style="margin:0;font-family:{SANS};font-size:13px;line-height:18px;color:{MUTED};">{esc(text)}</p>'
    )


def why(text: str) -> str:
    return row(
        f'<p style="margin:0;font-family:{SANS};font-size:14px;line-height:20px;color:{MUTED};">{esc(text)}</p>'
    )


def divider() -> str:
    return row(
        '<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr>'
        f'<td height="1" style="height:1px;line-height:1px;font-size:1px;background-color:{RULE};">&nbsp;</td>'
        "</tr></table>"
    )


def details(items: list[tuple[str, str]], total: tuple[str, str] | None = None) -> str:
    cells = "".join(
        '<tr><td style="padding-bottom:12px;">'
        f'<div style="font-family:{SANS};font-size:14px;line-height:18px;color:{MUTED};padding-bottom:2px;">{esc(label)}</div>'
        f'<div style="font-family:{SANS};font-size:16px;line-height:24px;font-weight:600;color:{INK};">{esc(value)}</div>'
        "</td></tr>"
        for label, value in items
    )
    if total:
        cells += (
            f'<tr><td style="border-top:1px solid {BOX_RULE};padding-top:12px;">'
            f'<div style="font-family:{SANS};font-size:14px;line-height:18px;color:{MUTED};padding-bottom:2px;">{esc(total[0])}</div>'
            f'<div style="font-family:{DISPLAY};font-weight:700;font-size:28px;line-height:30px;color:{INK};">{esc(total[1])}</div>'
            "</td></tr>"
        )
    return row(
        f'<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="{BOX}" '
        f'style="background-color:{BOX};border:1px solid {BOX_RULE};"><tr><td style="padding:16px;">'
        f'<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">{cells}</table>'
        "</td></tr></table>"
    )


def button(label: str, url_var: str) -> str:
    return row(
        '<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"><tr>'
        '<td align="center" bgcolor="#ca3500" style="background-color:#ca3500;">'
        f'<a href="{v(url_var)}" target="_blank" style="display:block;font-family:{SANS};font-size:16px;'
        f'line-height:20px;font-weight:600;text-decoration:none;color:#ffffff;padding:14px 20px;">{esc(label)}</a>'
        "</td></tr></table>"
    )


def link_line(text: str, label: str, url_var: str) -> str:
    return row(
        f'<p style="margin:0;font-family:{SANS};font-size:14px;line-height:20px;color:{MUTED};">{esc(text)} '
        f'<a href="{v(url_var)}" target="_blank" style="color:{INK};text-decoration:underline;">{esc(label)}</a></p>'
    )


def document(title: str, preheader: str, blocks: list[str]) -> str:
    body = "\n".join(blocks)
    return f"""<mjml>
  <mj-head>
    <mj-title>{esc(title)}</mj-title>
    <mj-font name="Bungee" href="https://fonts.googleapis.com/css?family=Bungee" />
    <mj-font name="Passion One" href="https://fonts.googleapis.com/css?family=Passion+One:700" />
    <mj-font name="Source Sans 3" href="https://fonts.googleapis.com/css?family=Source+Sans+3:400,600,700" />
    <mj-style>body{{margin:0;padding:0;width:100%!important;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%}}
table{{border-collapse:collapse;mso-table-lspace:0;mso-table-rspace:0}}
img{{border:0;outline:none;text-decoration:none}}
@media (max-width:620px){{.px{{padding-left:20px!important;padding-right:20px!important}}}}</mj-style>
  </mj-head>
  <mj-body background-color="#efedea" width="600px">
    <mj-raw>
<div style="display:none;max-height:0;overflow:hidden;opacity:0;color:transparent;mso-hide:all;">{esc(preheader)}</div>
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#efedea" style="background-color:#efedea;">
<tr><td align="center" style="padding:0;">
<!--[if mso]><table role="presentation" width="600" align="center" cellpadding="0" cellspacing="0" border="0"><tr><td><![endif]-->
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width:600px;width:100%;">
<tr><td class="px" bgcolor="#f54900" style="background-color:#f54900;padding:20px 24px;font-family:'Bungee','Arial Black',Arial,sans-serif;font-size:20px;line-height:24px;color:#ffffff;letter-spacing:0.5px;">cramapple</td></tr>
<tr><td bgcolor="#ca3500" height="3" style="height:3px;line-height:3px;font-size:3px;background-color:#ca3500;">&nbsp;</td></tr>
<tr><td class="px" bgcolor="#ffffff" style="background-color:#ffffff;padding:32px 24px 12px 24px;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
{body}
</table>
</td></tr>
<tr><td class="px" align="center" style="padding:24px;font-family:{SANS};font-size:12px;line-height:16px;color:{MUTED};">
<div style="font-weight:600;">Cramapple &middot; {v("mailingAddress")}</div>
<div style="padding-top:8px;">Questions? Reply to this email.</div>
</td></tr>
</table>
<!--[if mso]></td></tr></table><![endif]-->
</td></tr>
</table>
    </mj-raw>
  </mj-body>
</mjml>
"""


S, A, D, G, R, N = v("subjects"), v("amount"), v("chargeDate"), v("graceEndDate"), v("recoveryDeadline"), v("delayedChargeDate")
CANCEL_NOTE = "Cancelling ends access straight away."
SIGN_IN_NOTE = "Sign in with this email address and we'll email you a code."
PARENT_WHY = "You're getting this because a parent or guardian started a Cramapple free trial for you."

# (file, subject, preheader, blocks)
TEMPLATES: list[tuple[str, str, str, list[str]]] = [
    ("11-trial-started-payer.mjml", "Your 7-day free trial has started",
     f"You won't be charged until {D}.",
     [eyebrow("Free trial started"), heading("Your 7-day free trial has started"),
      para(f"You won't be charged until {D}. If you don't cancel before then, we'll charge {A} to the card ending {v('cardLast4')}."),
      details([("Subjects", S), ("Trial ends", D), ("Card", f"Ending {v('cardLast4')}")], ("Then", A)),
      button("Cancel the free trial", "cancelUrl"),
      small(f"{CANCEL_NOTE} You agreed to these terms when you started the trial."),
      divider(), link_line("Read the terms:", "Terms and Conditions", "termsUrl")]),
    # A student who started and pays for their own trial. No invite email is
    # sent at activation, so this is how they learn to sign in.
    ("11-trial-started-learner.mjml", "Your 7-day free trial has started",
     f"You won't be charged until {D}.",
     [eyebrow("Free trial started"), heading("Your 7-day free trial has started"),
      para(f"You won't be charged until {D}. If you don't cancel before then, we'll charge {A} to the card ending {v('cardLast4')}."),
      details([("Subjects", S), ("Trial ends", D), ("Card", f"Ending {v('cardLast4')}")], ("Then", A)),
      button("Start studying", "accountUrl"),
      small(SIGN_IN_NOTE),
      link_line("Changed your mind?", "Cancel the free trial", "cancelUrl"),
      small(f"{CANCEL_NOTE} You agreed to these terms when you started the trial."),
      divider(), link_line("Read the terms:", "Terms and Conditions", "termsUrl")]),
    ("11-trial-started-student.mjml", "Your free trial has started",
     f"Your 7-day free trial of {S} runs until {D}.",
     [eyebrow("Free trial started"), heading("Your free trial has started"),
      para(f"Your parent started a 7-day free trial of {S} for you. It runs until {D}."),
      button("See your trial", "accountUrl"),
      small(SIGN_IN_NOTE),
      small("You can cancel the trial from your account. Cancelling ends access straight away."),
      divider(), why(PARENT_WHY)]),

    ("12-trial-reminder-payer.mjml", "Your free trial ends in 2 days",
     f"On {D} we'll charge {A} unless you cancel.",
     [eyebrow("Trial reminder"), heading("Your free trial ends in 2 days"),
      para(f"On {D}, we'll charge {A} for {S}. To avoid the charge, cancel before then."),
      details([("Subjects", S), ("Charge date", D)], ("Amount", A)),
      button("Cancel the free trial", "cancelUrl"),
      small(f"Nothing to do if you want to keep studying. {CANCEL_NOTE}")]),
    ("12-trial-reminder-student.mjml", "Your free trial ends in 2 days",
     f"Your parent's card will be charged on {D} unless the trial is cancelled.",
     [eyebrow("Trial reminder"), heading("Your free trial ends in 2 days"),
      para(f"On {D}, your parent's card will be charged {A} for {S} unless the trial is cancelled."),
      button("See your trial", "accountUrl"), divider(), why(PARENT_WHY)]),

    ("13-trial-payment-failed-payer.mjml", "We couldn't take your payment",
     f"Your access continues until {G}.",
     [eyebrow("Payment problem"), heading("We couldn't take your payment"),
      para(f"The {A} charge for {S} didn't go through. Your access continues until {G}. Update your payment to keep it."),
      button("Update payment", "recoveryUrl"),
      small("Your bank may have declined the charge. You can use the same card or a different one.")]),
    ("13-trial-payment-failed-student.mjml", "There was a problem with the payment",
     f"Your access continues until {G}.",
     [eyebrow("Payment problem"), heading("There was a problem with the payment"),
      para(f"Your parent's payment for {S} didn't go through. Your access continues until {G}. We've emailed your parent a link to fix it."),
      divider(), why(PARENT_WHY)]),

    ("14-trial-requires-action-payer.mjml", "Confirm your payment",
     f"Your bank needs you to confirm the {A} payment.",
     [eyebrow("Action needed"), heading("Confirm your payment"),
      para(f"Your bank needs you to confirm the {A} payment for {S}. Your access continues until {G}."),
      button("Confirm payment", "recoveryUrl")]),
    ("14-trial-requires-action-student.mjml", "There was a problem with the payment",
     f"Your access continues until {G}.",
     [eyebrow("Payment problem"), heading("There was a problem with the payment"),
      para(f"Your parent's bank needs them to confirm the payment for {S}. Your access continues until {G}. We've emailed your parent a link."),
      divider(), why(PARENT_WHY)]),

    ("15-trial-grace-ended-payer.mjml", "Your access is paused",
     f"You can still pay until {R}.",
     [eyebrow("Access paused"), heading("Your access is paused"),
      para(f"We still couldn't take the {A} payment for {S}, so access is paused. You can pay until {R} to pick up where you left off."),
      button("Pay now", "recoveryUrl")]),
    ("15-trial-grace-ended-student.mjml", "Your access is paused",
     f"Access to {S} is paused until the payment is completed.",
     [eyebrow("Access paused"), heading("Your access is paused"),
      para(f"Access to {S} is paused until the payment is completed. Your parent has a link to pay until {R}."),
      divider(), why(PARENT_WHY)]),

    ("16-trial-delayed-charge-payer.mjml", "Your charge has been delayed",
     f"We'll now charge {A} on {N} unless you cancel.",
     [eyebrow("Charge delayed"), heading("Your charge has been delayed"),
      para(f"We couldn't process your charge on {D} because of a problem on our side. We'll now charge {A} on {N} unless you cancel. Your access continues until then."),
      button("Cancel the free trial", "cancelUrl"), small(CANCEL_NOTE)]),
    ("16-trial-delayed-charge-student.mjml", "Your trial access continues",
     f"The charge moved to {N}.",
     [eyebrow("Charge delayed"), heading("Your trial access continues"),
      para(f"Because of a problem on our side, the charge for {S} moved to {N}. Your access continues until then."),
      divider(), why(PARENT_WHY)]),

    ("17-trial-canceled-payer.mjml", "Your free trial is cancelled",
     v("cancelOutcomeText"),
     [eyebrow("Trial cancelled"), heading("Your free trial is cancelled"),
      para(v("cancelOutcomeText")),
      para(f"Access to {S} has ended. If you'd like to come back, buying again is a regular purchase.")]),
    ("17-trial-canceled-student.mjml", "Your free trial was cancelled",
     f"Your access to {S} has ended.",
     [eyebrow("Trial cancelled"), heading("Your free trial was cancelled"),
      para(f"Your trial of {S} has been cancelled and your access has ended."),
      divider(), why(PARENT_WHY)]),

    ("18-trial-converted-payer.mjml", "Thanks for your payment",
     f"{A} paid for {S}.",
     [eyebrow("Payment received"), heading("Thanks for your payment"),
      para(f"Your free trial has ended and {A} has been paid for {S}. Your access continues with no end date."),
      details([("Subjects", S)], ("Paid", A)),
      button("Open Cramapple", "accountUrl"),
      small("Refunds are available within 7 days of this payment. Reply to this email to ask.")]),
    ("18-trial-converted-student.mjml", "Your parent paid for your subjects",
     f"Your access to {S} continues.",
     [eyebrow("Access confirmed"), heading("Your parent paid for your subjects"),
      para(f"Your free trial has ended and your parent paid for {S}. Your access continues with no end date."),
      button("Keep studying", "accountUrl"), divider(), why(PARENT_WHY)]),

    ("19-trial-refunded-payer.mjml", "Your payment was refunded",
     f"The {A} payment for {S} has been refunded.",
     [eyebrow("Refund"), heading("Your payment was refunded"),
      para(f"The {A} payment for {S} has been refunded in full. It usually appears within 5 to 10 business days. Access to {S} has ended.")]),
    ("19-trial-refunded-student.mjml", "Your access has ended",
     f"The payment for {S} was refunded.",
     [eyebrow("Access ended"), heading("Your access has ended"),
      para(f"The payment for {S} was refunded, so your access has ended."),
      divider(), why(PARENT_WHY)]),

    ("20-parent-trial-request.mjml", f"{v('studentName')} asked you to start a free trial",
     f"{v('studentName')} picked AP subjects on Cramapple and asked you to start a 7-day free trial.",
     [eyebrow("Free trial request"), heading(f"{v('studentName')} asked you to start a free trial"),
      para(f"Cramapple is an AP exam practice app. {v('studentName')} picked the subjects below and asked you to start a {v('trialDays')}-day free trial."),
      details([("Student", v("studentName")), ("Subjects", S)], ("After the trial", A)),
      button("Start the free trial", "paymentUrl"),
      small(f"Nothing is charged today. If you don't cancel within {v('trialDays')} days, we'll charge {A}. Secure checkout by Stripe. This link works until {v('expiresOn')}."),
      divider(),
      why(f"Why you're getting this: {v('studentName')} entered {v('parentEmail')} to request a free trial. Not expecting it? Ignore this email. Nothing is charged unless you start the trial.")]),
]

KIND_ENV = {
    "trial-started": "TRIAL_STARTED", "trial-reminder": "REMINDER", "trial-payment-failed": "PAYMENT_FAILED",
    "trial-requires-action": "REQUIRES_ACTION", "trial-grace-ended": "GRACE_ENDED",
    "trial-delayed-charge": "DELAYED_CHARGE", "trial-canceled": "CANCELED", "trial-converted": "CONVERTED",
    "trial-refunded": "REFUNDED",
}


def secret_name(file: str) -> str:
    if file.startswith("20-"):
        return "LOOPS_PARENT_TRIAL_REQUEST_TRANSACTIONAL_ID"
    stem = re.sub(r"^\d{2}-", "", file[:-5])
    kind, role = stem.rsplit("-", 1)
    return f"LOOPS_TRIAL_{KIND_ENV[kind]}_{role.upper()}_TRANSACTIONAL_ID"


def main() -> None:
    manifest_path = ROOT / "manifest.json"
    manifest = json.loads(manifest_path.read_text())
    keep = [m for m in manifest if not re.match(r"^(1[1-9]|20)-", m["file"])]
    entries = []
    for file, subject, preheader, blocks in TEMPLATES:
        if not re.match(r"^\d{2}-[a-z-]+\.mjml$", file):
            raise SystemExit(f"bad filename {file}")
        doc = document(subject, preheader, blocks)
        (LOOPS / file).write_text(doc)
        variables = sorted(set(re.findall(r"\{DATA_VARIABLE:([A-Za-z0-9]+)\}", doc)))
        old = next((m for m in manifest if m["file"] == file), {})
        entries.append({
            "file": file,
            "subject": subject.replace(v("studentName"), "Your student"),
            "variables": variables,
            "status": old.get("status", "draft"),
            "transactionalId": old.get("transactionalId"),
            "secret": secret_name(file),
        })
    manifest_path.write_text(json.dumps(keep + entries, indent=2) + "\n")
    print(f"wrote {len(entries)} trial templates; manifest has {len(keep) + len(entries)} entries")


if __name__ == "__main__":
    main()
