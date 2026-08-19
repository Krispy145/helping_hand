#!/usr/bin/env bash
# Provision one Firebase project per environment (mobile + Pulse + API Admin).
#
# Run from anywhere; the script always uses the repo root:
#   ./scripts/setup_firebase.sh dev
#   ./scripts/setup_firebase.sh stg
#   ./scripts/setup_firebase.sh prod --yes
#
# Safe to re-run. It skips the project and apps when they already exist, then
# refreshes google-services.json / GoogleService-Info.plist for that flavor.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

log() {
  echo "==> $*" >&2
}

usage() {
  cat <<'EOF'
Usage: ./scripts/setup_firebase.sh <dev|stg|prod> [--yes] [--project-id <id>]

Creates (or updates) the Firebase project for that environment and registers:
  - Android app  (flavor applicationId)
  - iOS app      (flavor bundleId)
  - Web app      (Pulse hosting)

Writes:
  .firebaserc
  firebase.json
  apps/mobile/android/app/src/<flavor>/google-services.json
  apps/mobile/ios/flavors/<flavor>/GoogleService-Info.plist

Does not write API service-account keys. Keep those outside the repo.
EOF
}

YES=0
ENV_ARG=""
PROJECT_ID_OVERRIDE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --yes|-y)
      YES=1
      shift
      ;;
    --project-id)
      if [[ $# -lt 2 ]]; then
        echo "--project-id requires a value" >&2
        exit 1
      fi
      PROJECT_ID_OVERRIDE="$2"
      shift 2
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -n "$ENV_ARG" ]]; then
        echo "Unexpected argument: $1" >&2
        usage >&2
        exit 1
      fi
      ENV_ARG="$1"
      shift
      ;;
  esac
done

if [[ -z "$ENV_ARG" ]]; then
  usage >&2
  exit 1
fi

case "$ENV_ARG" in
  dev)
    ALIAS="dev"
    FLAVOR="dev"
    PROJECT_ID="helping-hand-dev-145"
    DISPLAY_NAME="Helping Hand Dev"
    ANDROID_PACKAGE="com.helping.dev"
    IOS_BUNDLE="com.helping.dev"
    EXTRA_ALIAS=""
    ;;
  stg|staging)
    ALIAS="stg"
    FLAVOR="stg"
    PROJECT_ID="helping-hand-stg-145"
    DISPLAY_NAME="Helping Hand Staging"
    ANDROID_PACKAGE="com.helping.stg"
    IOS_BUNDLE="com.helping.stg"
    EXTRA_ALIAS="staging"
    ;;
  prod|production)
    ALIAS="prod"
    FLAVOR="prod"
    PROJECT_ID="helping-hand-prod-145"
    DISPLAY_NAME="Helping Hand"
    ANDROID_PACKAGE="com.helping.app"
    IOS_BUNDLE="com.helping.app"
    EXTRA_ALIAS="production"
    ;;
  *)
    echo "Invalid environment '$ENV_ARG'. Use dev, stg, or prod." >&2
    exit 1
    ;;
esac

if [[ -n "$PROJECT_ID_OVERRIDE" ]]; then
  PROJECT_ID="$PROJECT_ID_OVERRIDE"
fi

ANDROID_JSON="$ROOT/apps/mobile/android/app/src/${FLAVOR}/google-services.json"
IOS_PLIST="$ROOT/apps/mobile/ios/flavors/${FLAVOR}/GoogleService-Info.plist"
FIREBASERC="$ROOT/.firebaserc"
FIREBASE_JSON="$ROOT/firebase.json"

if [[ "$ALIAS" == "prod" && "$YES" -ne 1 ]]; then
  read -r -p "Create or update the PRODUCTION Firebase project ${PROJECT_ID}? [y/N] " reply
  if [[ ! "$reply" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
  fi
fi

if ! command -v firebase >/dev/null 2>&1; then
  echo "Firebase CLI is not installed. Install it with: npm install -g firebase-tools" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required to parse Firebase CLI JSON." >&2
  exit 1
fi

log "Checking Firebase login"
if ! firebase projects:list --non-interactive >/dev/null; then
  echo "Firebase CLI is not signed in. Run: firebase login" >&2
  exit 1
fi

firebase_json() {
  firebase --non-interactive --json "$@"
}

project_exists() {
  firebase_json projects:list | python3 -c "
import json, sys
wanted = sys.argv[1]
data = json.load(sys.stdin)
result = data.get('result', data)
projects = result.get('projects', result) if isinstance(result, dict) else result
if not isinstance(projects, list):
    sys.exit(1)
for project in projects:
    if project.get('projectId') == wanted:
        sys.exit(0)
sys.exit(1)
" "$PROJECT_ID"
}

ensure_project() {
  if project_exists; then
    log "Firebase project ${PROJECT_ID} already exists"
    return
  fi

  log "Creating Firebase project ${PROJECT_ID}"
  if firebase --non-interactive projects:create "$PROJECT_ID" --display-name "$DISPLAY_NAME"; then
    return
  fi

  echo "Could not create ${PROJECT_ID}." >&2
  echo "Project IDs are globally unique. Re-run with a free id, for example:" >&2
  echo "  ./scripts/setup_firebase.sh ${ALIAS} --project-id helpinghand-${ALIAS}" >&2
  exit 1
}

find_app_id() {
  local platform="$1"
  local identifier="$2"
  firebase_json apps:list "$platform" --project "$PROJECT_ID" | python3 -c "
import json, sys
platform = sys.argv[1].upper()
wanted = sys.argv[2]
data = json.load(sys.stdin)
result = data.get('result', data)
apps = result.get('apps', result) if isinstance(result, dict) else result
if not isinstance(apps, list):
    sys.exit(0)
for app in apps:
    app_platform = str(app.get('platform') or app.get('appPlatform') or '').upper()
    if app_platform and app_platform != platform:
        continue
    candidates = [
        app.get('packageName'),
        app.get('bundleId'),
        app.get('namespace'),
        app.get('displayName'),
        app.get('appId'),
    ]
    matches = [value for value in candidates if value == wanted]
    if matches or (platform == 'WEB' and len(apps) == 1):
        print(app.get('appId', ''))
        break
" "$platform" "$identifier"
}

ensure_app() {
  local platform="$1"
  local display_name="$2"
  shift 2

  local identifier=""
  case "$platform" in
    ANDROID) identifier="$ANDROID_PACKAGE" ;;
    IOS) identifier="$IOS_BUNDLE" ;;
    WEB) identifier="$display_name" ;;
  esac

  local existing
  existing="$(find_app_id "$platform" "$identifier" || true)"
  if [[ -n "${existing:-}" ]]; then
    log "${platform} app already registered (${existing})"
    printf '%s\n' "$existing"
    return
  fi

  log "Creating ${platform} app: ${display_name}"
  local created
  created="$(firebase_json apps:create "$platform" "$display_name" --project "$PROJECT_ID" "$@" | python3 -c "
import json, sys
data = json.load(sys.stdin)
result = data.get('result', data)
if isinstance(result, dict):
    print(result.get('appId') or result.get('app', {}).get('appId') or '')
")"
  if [[ -z "${created:-}" ]]; then
    created="$(find_app_id "$platform" "$identifier" || true)"
  fi
  if [[ -z "${created:-}" ]]; then
    echo "Failed to create or look up the ${platform} app." >&2
    exit 1
  fi
  printf '%s\n' "$created"
}

download_sdkconfig() {
  local platform="$1"
  local app_id="$2"
  local dest="$3"
  local attempt

  mkdir -p "$(dirname "$dest")"
  for attempt in 1 2 3 4 5; do
    if firebase --non-interactive apps:sdkconfig "$platform" "$app_id" --project "$PROJECT_ID" -o "$dest"; then
      log "Wrote ${dest}"
      return
    fi
    log "Waiting for ${platform} config (attempt ${attempt})"
    sleep 3
  done
  echo "Could not download ${platform} SDK config for ${app_id}." >&2
  exit 1
}

write_firebase_json() {
  if [[ -f "$FIREBASE_JSON" ]]; then
    log "firebase.json already present"
    return
  fi

  cat > "$FIREBASE_JSON" <<'EOF'
{
  "hosting": {
    "public": "apps/web_pulse/build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
EOF
  log "Wrote firebase.json (Pulse hosting)"
}

write_firebaserc() {
  python3 - "$FIREBASERC" "$ALIAS" "$PROJECT_ID" "$EXTRA_ALIAS" <<'PY'
import json, os, sys

path, alias, project_id = sys.argv[1], sys.argv[2], sys.argv[3]
extra_alias = sys.argv[4] if len(sys.argv) > 4 else ""
data = {"projects": {}}
if os.path.exists(path):
    with open(path, encoding="utf-8") as handle:
        loaded = json.load(handle)
    if isinstance(loaded, dict):
        data = loaded
    data.setdefault("projects", {})

projects = data["projects"]
projects[alias] = project_id
if extra_alias:
    projects[extra_alias] = project_id
if "default" not in projects:
    projects["default"] = project_id

with open(path, "w", encoding="utf-8") as handle:
    json.dump(data, handle, indent=2)
    handle.write("\n")
PY
  log "Updated .firebaserc alias '${ALIAS}' -> ${PROJECT_ID}"
}

ensure_project
write_firebaserc
write_firebase_json
firebase --non-interactive use "$PROJECT_ID" >/dev/null

ANDROID_APP_ID="$(ensure_app ANDROID "${DISPLAY_NAME} Android" --package-name "$ANDROID_PACKAGE")"
IOS_APP_ID="$(ensure_app IOS "${DISPLAY_NAME} iOS" --bundle-id "$IOS_BUNDLE")"
WEB_APP_ID="$(ensure_app WEB "${DISPLAY_NAME} Pulse")"

download_sdkconfig ANDROID "$ANDROID_APP_ID" "$ANDROID_JSON"
download_sdkconfig IOS "$IOS_APP_ID" "$IOS_PLIST"

cat <<EOF

Done. ${DISPLAY_NAME} is ready as ${PROJECT_ID}.

Registered apps
  Android  ${ANDROID_PACKAGE}  ${ANDROID_APP_ID}
  iOS      ${IOS_BUNDLE}       ${IOS_APP_ID}
  Web      Pulse               ${WEB_APP_ID}

Still manual (once per project)
  1. API Admin: Firebase console → Project settings → Service accounts → Generate key.
     Save it outside the repo and export GOOGLE_APPLICATION_CREDENTIALS to that file.
  2. iOS: upload an APNs auth key under Project settings → Cloud Messaging.
  3. Android (optional for FCM): add the debug SHA-1/SHA-256 from
     apps/mobile/android ./gradlew :app:signingReport

Later environments
  ./scripts/setup_firebase.sh stg
  ./scripts/setup_firebase.sh prod --yes
EOF
