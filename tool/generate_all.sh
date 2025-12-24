#!/bin/bash
# Master generation script for Flavor & Splash assets.
# This script runs the standard generation tools AND applies necessary fixes for iOS Storyboard paths.
# Run this instead of running the tools manually.

set -e

APP_DIR="apps/mobile"

echo "🚀 Starting Asset Generation..."

if [ ! -d "$APP_DIR" ]; then
  echo "❌ Error: Could not find $APP_DIR. Please run from the project root."
  exit 1
fi

cd "$APP_DIR"

echo "----------------------------------------------------------------"
echo "🏗️  Running Flutter Flavorizr..."
# Using -f (force) to ensure it runs without interactive verify prompts, relying on our safe config
flutter pub run flutter_flavorizr -f

echo "----------------------------------------------------------------"
echo "🔧 Applying iOS Storyboard Fix..."
# Flavorizr generates 'Base.lproj/LaunchScreen{Flavor}.storyboard' 
# but links 'Runner/{flavor}LaunchScreen.storyboard' in Xcode.
# We move them to match the Xcode reference.

fix_storyboard() {
  SRC="ios/Runner/Base.lproj/LaunchScreen$1.storyboard"
  DEST="ios/Runner/$2LaunchScreen.storyboard"
  
  if [ -f "$SRC" ]; then
    echo "   Moving $SRC -> $DEST"
    mv "$SRC" "$DEST"
  else
    echo "   Note: $SRC not found (might already be moved)"
  fi
}

fix_storyboard "Dev" "dev"
fix_storyboard "Stg" "stg"
fix_storyboard "Prod" "prod"

echo "----------------------------------------------------------------"
echo "💦 Generating Native Splash Screens..."
dart run flutter_native_splash:create --flavor dev
dart run flutter_native_splash:create --flavor stg
dart run flutter_native_splash:create --flavor prod

echo "----------------------------------------------------------------"
echo "🌗 Applying iOS 18 Dark Icon Support..."
dart tool/ios_dark_icon_support.dart ios/Runner/Assets.xcassets

echo "----------------------------------------------------------------"
echo "✅ Generation Complete!"
