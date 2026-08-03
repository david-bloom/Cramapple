# Lovable Build Prompt - AP Statistics Subject-Aware Onboarding

Update the student onboarding flow so Cramapple supports more than one published subject without adding friction for existing AP Biology-only users.

Goal:
Make the live student onboarding flow subject-aware. If more than one published subject exists for the student's account, show a subject picker before the student continues into the existing practice flow. If only one subject is published, skip the picker entirely so the experience feels unchanged.

Routes:
- Use the current live onboarding entry route.
- Use the current live subject/topic selection route.
- Use the current live practice route.
- Use the current live attempt route.
- Use the current live review route.

Backend calls:
- Read the published subjects/exam packs for the current account before rendering the first subject-specific screen.
- Thread the selected subject through the existing session/flow state only for routing and rendering.
- Read the active exam pack from backend data when rendering subject name, topic list, attempt labels, and review labels.
- Do not hardcode AP Biology anywhere that should vary by subject.

Page behavior:
- Loading: show a light loading state while the published subject list is resolved.
- Single-subject state: if only one subject is published, auto-continue with no selector and no extra click.
- Multi-subject state: show a clear subject picker when AP Biology and AP Statistics are both available.
- The selected subject should drive the next step in the flow, including topic selection and practice rendering.
- Existing AP Biology flow should render exactly as before once AP Biology is selected or auto-selected.
- If a student opens a later subject-specific route without an active subject, redirect them to the subject picker only when multiple subjects are available.
- If only one subject is available, recover by continuing directly into that subject.
- If no published subjects are available, show a simple unavailable state instead of a broken flow.

Copy:
- Selector title: "Choose a subject"
- Helper text: "Pick the subject you want to practice. If only one subject is available, we'll take you straight in."
- Option labels: "AP Biology" and "AP Statistics"
- Single-subject fallback: no selector copy at all
- Empty state: "No published subjects are available yet."

Forbidden behavior:
- Do not make the selector mandatory when only one subject is available.
- Do not hardcode AP Biology into route labels, section headers, placeholders, or empty states.
- Do not infer success locally; always use backend-derived subject availability.
- Do not add new grading UI or new answer widgets.
- Do not write trust fields, entitlement fields, or backend truth directly from the client.

QA expectations:
- Confirm AP Biology-only accounts see no new selector friction.
- Confirm accounts with AP Biology and AP Statistics see the selector once, then continue normally.
- Confirm direct navigation to a later onboarding route still resolves correctly based on the selected subject.
- Confirm existing AP Biology copy and behavior remain unchanged after subject selection.
- Confirm there are no remaining hardcoded "AP Biology" strings in the onboarding flow where the subject should be dynamic.
