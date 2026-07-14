# Next Task

Patients Module — Complete (Full CRUD)

Completed
- Patients List (Search)
- Add Patient
- Patient Details
- Edit Patient
- Delete Patient (Soft Delete)
- Backend: PatientsController (GET by id, GET search, POST, PUT, DELETE)
- API Contract Frozen

Next
Appointments Module
- Appointment Entity + Backend Endpoint (check Backend first)
- Appointments Calendar/List Screen
- Book Appointment
- Cancel/Reschedule Appointment

# Next Task

Appointments Module — MVP Complete

Completed
- Backend: AppointmentsController (GetById, Search by date, Create with conflict check, Cancel)
- Appointments List Screen (by date, navigation, date picker)
- Add Appointment Screen (patient dropdown, date/time pickers)
- API Contract Frozen

Next
- Cancel Appointment UI (backend endpoint ready)
- Doctors/Staff Module (needed for real doctor selection instead of hardcoded id)
- Medical Encounters Module (clinical visit documentation)

# Next Task

Appointments Module — Complete

Completed
- Backend: AppointmentsController (GetById, Search, Create, Cancel)
- Appointments List (by date, navigation)
- Add Appointment (patient/date/time selection)
- Cancel Appointment (with confirmation)
- API Contract Frozen

Next
Medical Encounters Module (Clinical Visit Documentation)
- Check Backend for Encounter Entity/DTO first
- Vital Signs, Diagnosis, Prescription base structure

# Next Task

Medical Encounters Module — MVP Complete

Completed
- Backend: EncountersController (GetById, GetByPatient, Create, Update, Close)
- Encounter Screen (HPI, Physical Exam, Clinical Notes, Treatment Plan)
- Linked from Patient Details ("بدء كشف طبي")
- API Contract Frozen

Next
Prescriptions Module (ePrescription)
- Check Backend for Prescription Entity/DTO first
- Drug database structure needed
- Link to Encounter

# Next Task

Prescriptions Module — MVP Complete

Completed
- Backend: PrescriptionsController (GetById, GetByPatient, Create with multiple items)
- Prescription Form embedded in Encounter Screen (add/remove drug rows)
- API Contract Frozen

Next
Billing/Invoices Module
- Check Backend for Invoice/Payment Entities first
- Auto-generate invoice on Encounter close
- Payment recording

# Next Task

Billing/Invoices Module — Complete

Completed
- Backend: InvoicesController (GetById, GetByPatient, Create, RecordPayment)
- Invoice Form embedded in Encounter Screen (create + payment recording)
- API Contract Frozen

Core Clinical Workflow Now Complete:
Patient → Appointment → Encounter → Prescription + Invoice → Payment

Next
- Reports Module (daily revenue, patient statistics)
OR
- Staff/Doctors Module (replace hardcoded doctorId across system)
- Decision needed on priority