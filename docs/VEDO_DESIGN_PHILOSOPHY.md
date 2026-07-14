# VEDO Design Philosophy (Frozen)

## Core Principle
Speed and simplicity over feature count. Every screen/workflow decision is evaluated first against: number of clicks, number of windows, number of seconds — and whether it can be reduced further.

## Target Benchmarks
- New patient registration: < 30 seconds
- Book appointment: < 10 seconds
- Start visit: 1 click from Appointments or Patient screen
- Finish visit → invoice: automatic, no extra steps
- Minimal windows/navigations; one screen completes a task where possible
- Keyboard-first over mouse-first

## Standing Feature Requirements
- **Global smart search**: name, partial name, phone, file number, recent patients — one search box
- **Keyboard shortcuts**: Ctrl+N (new patient), Ctrl+F (search), Ctrl+S (save), Ctrl+Enter (finish current action), Esc (close), F2 (edit), F4 (add appointment)
- **One-click visit workflow**: Start Visit → Encounter → Save → Prescription → Invoice → back to Appointments, no backtracking between screens
- **Templates**: for diagnoses, prescriptions, notes, treatment, physical exam, chief complaint
- **Smart defaults**: today's date, current doctor, current branch, default payment method, appointment time — all pre-filled
- **Patient Timeline**: single view combining visits, prescriptions, invoices, labs, radiology, notes
- **Dashboard**: doctor sees today's patients, upcoming appointments, late patients, revenue, waiting patients — with zero clicks on open
- **Minimal UI**: any screen with too many elements must be redesigned; priority order is clarity → speed → fewer clicks, not more information

## Marketable Differentiators (near-term, not far future)
- **Speed Mode** for high-volume doctors: name, complaint, diagnosis, treatment, finish — nothing else
- **Finish Visit** single action: saves encounter + creates prescription + creates invoice + updates appointment + opens next patient
- **Global search** across patients/appointments/invoices/prescriptions/phone/file number
- **Favorite/Recent patients** for fast re-access
- **Smart templates**: typing a short trigger (e.g., a common diagnosis name) auto-fills diagnosis/treatment/instructions
- **Voice dictation** (future, not immediate)
- **One-click print**: Ctrl+P prints directly, no save→open→print chain
- **Full keyboard operability** for extended mouse-free sessions
- **Self-measuring performance**: average time to register a patient, book an appointment, finish an encounter, clicks per operation — rising numbers signal a design that needs improvement

## Evaluation Rule
Before proposing any new screen or workflow: count clicks, windows, and seconds, and ask whether one more can be removed. Prefer removing a step/window/click even at higher implementation cost.