# Helping Hand - Roadmap 🚀

This document tracks the high-level progress of the Helping Hand project.

## ✅ Completed Milestones

### **Phase 1: Technical Foundation (v0.1.0)**
- [x] **Monorepo Setup:** NestJS (Backend) + Flutter (Mobile) + Flutter Web + Shared Packages.
- [x] **Infrastructure:** Docker Compose (Postgres + Redis).
- [x] **DevOps:** Flutter Flavors (Dev/Stg/Prod) & Environment Configuration.
- [x] **Shared Architecture:**
    - `packages/models`: Shared DTOs with `dart_mappable`.
    - `packages/ui`: Shared Design System & Localization (`slang`).

### **Phase 2: Authentication (v0.2.0)**
- [x] **Backend Auth:** JWT Strategy, Passport, Bcrypt.
- [x] **Mobile Auth:** Secure Storage, Riverpod, Login/Register UI.
- [x] **Persistence:** Token Storage, Auto-Restore Session, `/auth/me` Endpoint.
- [x] **API Docs:** Swagger UI (`/api`).

---

## 🚧 Current Phase: UI/UX & Web Dashboard (v0.3.0)

### **1. UI/UX Refinement (Mobile)**
*Goal: Align with "Calm, Dignified, Human" design principles.*
- [ ] **Theme Update:** Soft color palette, premium typography (Google Fonts).
- [ ] **Interaction Design:** Smooth transitions, "deep breath" pacing.
- [ ] **Component Polish:** "Dignified" cards for Requests, minimalist inputs.

### **2. Web Pulse Dashboard (MVP)**
*Goal: A calm monitoring interface for admins.*
- [ ] **Setup:** Web-optimized Navigation & Layout.
- [ ] **Auth:** Web Persistence & Login Screen.
- [ ] **Vetting Queue:** Interface to approve/reject requests.

### **3. Map Feature (Home View) 🗺️**
*Goal: Visual discovery of helpers using OpenStreetMap.*
- [ ] **Map Package:** Create `packages/map` with Riverpod Clean Arch.
- [ ] **Integration:** Replace Home Screen list with Map View.

### **4. Auth & Onboarding 👤**
*Goal: Smooth, private, and helpful entry.*
- [ ] **Auth Polish:** Device email autofill, "Calm" UI.
- [ ] **Profile:** Optional local avatar, privacy-focused.
- [ ] **Onboarding:** "First Launch" experience & Permissions flow.
- [ ] **Settings:** Profile & Permission management.

### **5. Polishing the Core ✨**
- [ ] **Chat UI:** Apply "Calm Joy" theme to chat.
- [ ] **Quality:** Resolve all lints, optimize AppLifecycle.

## Phase 4: Refinement & Testing (v0.4.0)
- [ ] **Code Quality**: Resolve Lint Warnings.
- [ ] **Testing**: Integration Tests for Auth & Requests.

---

## 🔮 Future Phases

### **Phase 5: Real-time Connection**
- [x] WebSocket Gateway.
- [ ] Real-time Chat UI Polish.
- [ ] Session Management Polish.

### **Phase 6: Polish & Beta (v1.0.0)**
- [ ] Push Notifications.
- [ ] Shorebird OTA.

