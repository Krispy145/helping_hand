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
- [x] **Mobile Auth:** Secure Storage, Riverpod State, Login/Register UI.
- [x] **API Docs:** Swagger UI (`/api`).

---

## 🚧 Current Phase: Request & Safety Core (v0.3.0)

### **Next Steps**
1.  **Request Feature (Mobile & API)**
    - [x] User can create a Help Request (Title, Type, Location, Urgency).
    - [x] Database Schema update (`Request` model).
2.  **Automated Vetting (Backend)**
    - [x] Integration of "Vetting Guard" to filter unsafe content.
    - [x] Status transitions (`pending_vetting` -> `approved` / `rejected`).
3.  **Discovery (Mobile)**
    - [x] "Helpers Nearby" feed (Geo-queries).

## Phase 2: Refinement & Testing (v0.x.x)
- [ ] **Code Quality**:
    - [ ] Resolved all Lint Warnings (BE/FE).
    - [ ] `flutter analyze` passing.
- [ ] **Testing Strategy**:
    - [ ] Unit Tests for Auto-Vetting (Done).
    - [ ] Integration Tests for Auth & Requests.
    - [ ] Widget Tests for Core Screens.

---

## 🔮 Future Phases

### **Phase 4: Real-time Connection (v0.4.0)**
- [ ] WebSocket Gateway (NestJS).
- [ ] Real-time Chat (Flutter).
- [ ] Session Management (Accept/Decline flow).

### **Phase 5: Safety & Reporting (v0.5.0)**
- [ ] "Emergency" & "Report" buttons.
- [ ] Privacy Controls (Location masking).

### **Phase 6: Polish & Beta (v1.0.0)**
- [ ] Push Notifications (FCM).
- [ ] Shorebird OTA Setup.
- [ ] App Store / Play Store Prep.
