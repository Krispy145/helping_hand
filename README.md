# Helping Hand

**Helping Hand** is a community-driven platform connecting people who need assistance with those willing to help. This repository is a monorepo containing the mobile application, web portal, and backend services.

## Repository Structure

-   **`apps/`**: Application entry points.
    -   `mobile`: Flutter Mobile App (Android/iOS).
    -   `web_pulse`: Flutter Web Admin/Portal.
    -   `api`: NestJS Backend API.
-   **`packages/`**: Shared libraries.
    -   `models`: Shared Dart/Flutter Data Transfer Objects.
    -   `ui`: Shared Flutter UI components and theme.
-   **`docs/`**: Project documentation.
-   **`scripts/`**: Utility scripts (e.g., deployment).

## Documentation

### 🚀 Getting Started
-   [Developer Setup Guide](docs/guides/DEVELOPER_SETUP.md): How to build and run the project locally.
-   [Authentication Guide](docs/guides/AUTHENTICATION.md): Understanding the auth flow.
-   [CI/CD Manual](docs/guides/CI_CD_MANUAL.md): Deployment pipelines and release strategy.

### 📅 Planning & Roadmap
-   [MVP Plan](docs/planning/01_MVP_PLAN.md)
-   [Technical Foundation](docs/planning/02_TECHNICAL_FOUNDATION.md)
-   [Testing Strategy](docs/planning/03_TESTING_RELEASE.md)
-   [CI/CD Setup Plan](docs/planning/04_CI_CD_SETUP.md)

### 💡 Core Concepts (Ideation)
-   [Vision](docs/ideation/01_VISION.md)
-   [Architecture](docs/ideation/08_ARCHITECTURE.md)
-   [Data Model](docs/ideation/09_DATA_MODEL.md)
-   [Threat Model & Safety](docs/ideation/13_THREAT_MODEL.md)
-   [API Contracts](docs/ideation/10_API_CONTRACTS.md)
