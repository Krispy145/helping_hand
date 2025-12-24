#!/bin/bash
# Tool to import Master Assets from a Figma Export folder structure.
# Usage: ./tool/import_assets.sh <path_to_figma_export_folder>

INPUT_DIR=$1

if [ -z "$INPUT_DIR" ]; then
  echo "Usage: $0 <path_to_figma_export_folder>"
  exit 1
fi


echo "🔍 Scanning $INPUT_DIR for assets..."

DEST_BASE="apps/mobile/assets/flavors"

# Function to search for an icon in a specific theme (Light/Dark)
find_icon() {
  THEME=$1
  SOURCE_NAME=$2
  
  # Look for the 1024x1024 icon in the iOS structure
  ICON_PATH=$(find "$INPUT_DIR" -path "*/$THEME/ios/Runner/Assets.xcassets/${SOURCE_NAME}AppIcon.appiconset/Icon-App-1024x1024@1x.png" | head -n 1)
  
  # Fallback: fuzzy search
  if [ -z "$ICON_PATH" ]; then
     ICON_PATH=$(find "$INPUT_DIR" -path "*/$THEME/*" -name "Icon-App-1024x1024@1x.png" | grep "${SOURCE_NAME}AppIcon" | head -n 1)
  fi
  
  echo "$ICON_PATH"
}

import_flavor() {
  FLAVOR=$1
  SEARCH_TERM=$2
  FALLBACK_SOURCE=$3 # Optional: Name of flavor to use as fallback if not found
  
  echo "📦 Processing Flavor: $FLAVOR (Searching for: $SEARCH_TERM)..."
  
  # === 1. App Icons (Opaque) ===
  # Helper to find icon in "Theme" folder
  find_variant() {
      THEME=$1
      SEARCH=$2
      # Try exact match first
      # Validated: Do NOT use PATH variable name
      ASSET_PATH=$(find "$INPUT_DIR" -path "*/$THEME/ios/Runner/Assets.xcassets/${SEARCH}AppIcon.appiconset/Icon-App-1024x1024@1x.png" | head -n 1)
      if [ -z "$ASSET_PATH" ]; then
         # Try fuzzy match
         ASSET_PATH=$(find "$INPUT_DIR" -path "*/$THEME/*" -name "Icon-App-1024x1024@1x.png" | grep "${SEARCH}AppIcon" | head -n 1)
      fi
      echo "$ASSET_PATH"
  }

  echo "   [Icons]"
  # Light Opaque -> icon.png
  LIGHT_ICON=$(find_variant "Light" "$SEARCH_TERM")
  if [ -z "$LIGHT_ICON" ] && [ "$FLAVOR" == "stg" ]; then LIGHT_ICON=$(find_variant "Light" "staging"); fi

  if [ -f "$LIGHT_ICON" ]; then
    echo "   ✅ Found Light Opaque: $LIGHT_ICON"
    cp "$LIGHT_ICON" "$DEST_BASE/$FLAVOR/icon.png"
  else
    echo "   ⚠️  Missing Light Opaque Icon for $FLAVOR"
    if [ -n "$FALLBACK_SOURCE" ] && [ -f "$DEST_BASE/$FALLBACK_SOURCE/icon.png" ]; then
        echo "   ↪️  Using $FALLBACK_SOURCE fallback."
        cp "$DEST_BASE/$FALLBACK_SOURCE/icon.png" "$DEST_BASE/$FLAVOR/icon.png"
    fi
  fi

  # Dark Opaque -> icon_dark.png
  DARK_ICON=$(find_variant "Dark" "$SEARCH_TERM")
  if [ -z "$DARK_ICON" ] && [ "$FLAVOR" == "stg" ]; then DARK_ICON=$(find_variant "Dark" "staging"); fi

  if [ -f "$DARK_ICON" ]; then
    echo "   ✅ Found Dark Opaque: $DARK_ICON"
    cp "$DARK_ICON" "$DEST_BASE/$FLAVOR/icon_dark.png"
  else
    echo "   ⚠️  Missing Dark Opaque Icon for $FLAVOR"
    if [ -n "$FALLBACK_SOURCE" ] && [ -f "$DEST_BASE/$FALLBACK_SOURCE/icon_dark.png" ]; then
        echo "   ↪️  Using $FALLBACK_SOURCE fallback."
        cp "$DEST_BASE/$FALLBACK_SOURCE/icon_dark.png" "$DEST_BASE/$FLAVOR/icon_dark.png"
    fi
  fi


  # === 2. Splash Images (Transparent) ===
  # Helper to find icon in "Theme-Transparent" folder as requested by user
  find_splash() {
      THEME_KEY=$1 # e.g. "Light" or "Dark"
      SEARCH=$2
      
      # The user explicitly requested "Light-Transparent" and "Dark-Transparent" folder names.
      # We construct the folder name dynamically: e.g. "Light-Transparent"
      local FOLDER_NAME="${THEME_KEY}-Transparent"
      
      # Search for the asset in that specific folder structure
      ASSET_PATH=$(find "$INPUT_DIR" -path "*/$FOLDER_NAME/ios/Runner/Assets.xcassets/${SEARCH}AppIcon.appiconset/Icon-App-1024x1024@1x.png" | head -n 1)
      
      echo "$ASSET_PATH"
  }

  echo "   [Splash]"
  # Light Transparent -> splash_light.png
  SPLASH_LIGHT=$(find_splash "Light" "$SEARCH_TERM")
  if [ -z "$SPLASH_LIGHT" ] && [ "$FLAVOR" == "stg" ]; then SPLASH_LIGHT=$(find_splash "Light" "staging"); fi
  
  if [ -f "$SPLASH_LIGHT" ]; then
    echo "   ✅ Found Light Splash (Transparent): $SPLASH_LIGHT"
    cp "$SPLASH_LIGHT" "$DEST_BASE/$FLAVOR/splash_light.png"
  else
    echo "   ⚠️  Missing Light Splash (Light-Transparent) for $FLAVOR"
    echo "       (Will default to using the Opaque icon if available, but splash may have background box)"
    if [ -f "$DEST_BASE/$FLAVOR/icon.png" ]; then
       cp "$DEST_BASE/$FLAVOR/icon.png" "$DEST_BASE/$FLAVOR/splash_light.png"
    fi
  fi

  # Dark Transparent -> splash_dark.png
  SPLASH_DARK=$(find_splash "Dark" "$SEARCH_TERM")
  if [ -z "$SPLASH_DARK" ] && [ "$FLAVOR" == "stg" ]; then SPLASH_DARK=$(find_splash "Dark" "staging"); fi
  
  if [ -f "$SPLASH_DARK" ]; then
    echo "   ✅ Found Dark Splash (Transparent): $SPLASH_DARK"
    cp "$SPLASH_DARK" "$DEST_BASE/$FLAVOR/splash_dark.png"
  else
    echo "   ⚠️  Missing Dark Splash (Dark-Transparent) for $FLAVOR"
    if [ -f "$DEST_BASE/$FLAVOR/icon_dark.png" ]; then
       cp "$DEST_BASE/$FLAVOR/icon_dark.png" "$DEST_BASE/$FLAVOR/splash_dark.png"
    fi
  fi

}

import_flavor "dev" "dev"
import_flavor "stg" "qa" "dev" # Staging is named "qa" in Figma export
import_flavor "prod" "prod" "dev"

echo "----------------------------------------------------------------"
echo "🎉 Import complete!"
echo "   - Icons copied to apps/mobile/assets/flavors/{env}/icon.png"
echo "   - Splash images (using icons) copied to apps/mobile/assets/flavors/{env}/splash_{light,dark}.png"
echo ""
echo "Now run:"
echo "   cd apps/mobile"
echo "   flutter pub run flutter_flavorizr"
echo "   dart run flutter_native_splash:create --flavor dev"
echo "   dart run flutter_native_splash:create --flavor stg"
echo "   dart run flutter_native_splash:create --flavor prod"
