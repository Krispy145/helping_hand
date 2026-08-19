#!/bin/sh
# Copy the flavor-specific GoogleService-Info.plist into the built app.
# Xcode configurations are Debug-dev, Release-stg, Profile-prod, etc.

set -e

CONFIGURATION="${CONFIGURATION:-}"
FLAVOR="${CONFIGURATION##*-}"

case "$FLAVOR" in
  dev|stg|prod) ;;
  *)
    echo "warning: Could not derive Firebase flavor from CONFIGURATION='${CONFIGURATION}'"
    exit 0
    ;;
esac

SRC="${PROJECT_DIR}/flavors/${FLAVOR}/GoogleService-Info.plist"
DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

if [ ! -f "$SRC" ]; then
  echo "warning: ${SRC} is missing; iOS FCM will be skipped for flavor ${FLAVOR}"
  exit 0
fi

if [ ! -d "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app" ]; then
  echo "warning: iOS app bundle is not ready yet; skipping GoogleService-Info.plist copy"
  exit 0
fi

cp "$SRC" "$DEST"
echo "Copied GoogleService-Info.plist for ${FLAVOR}"
