#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env.local"
TEMPLATE_FILE="$PROJECT_ROOT/scripts/handler.applescript.template"
GENERATED_SCRIPT="$PROJECT_ROOT/scripts/generated-handler.applescript"
APP_PATH="$PROJECT_ROOT/IllustratorUrlHandler.app"
PLIST_PATH="$APP_PATH/Contents/Info.plist"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing .env.local. Copy .env.example and fill values."
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

: "${ILLUSTRATOR_APP_NAME:?ILLUSTRATOR_APP_NAME must be set}"
: "${ILLUSTRATOR_ALLOWED_BASE_PATH:?ILLUSTRATOR_ALLOWED_BASE_PATH must be set}"
: "${ILLUSTRATOR_URL_SCHEME:?ILLUSTRATOR_URL_SCHEME must be set}"

python3 - "$TEMPLATE_FILE" "$GENERATED_SCRIPT" <<'PY'
from pathlib import Path
import os
import sys

template_path = Path(sys.argv[1])
output_path = Path(sys.argv[2])

template = template_path.read_text(encoding="utf-8")

replacements = {
    "__ILLUSTRATOR_APP_NAME__": os.environ["ILLUSTRATOR_APP_NAME"],
    "__ILLUSTRATOR_ALLOWED_BASE_PATH__": os.environ["ILLUSTRATOR_ALLOWED_BASE_PATH"],
}

for key, value in replacements.items():
    template = template.replace(key, value)

output_path.write_text(template, encoding="utf-8")
PY

rm -rf "$APP_PATH"
osacompile -o "$APP_PATH" "$GENERATED_SCRIPT"

/usr/libexec/PlistBuddy -c "Delete :LSUIElement" "$PLIST_PATH" >/dev/null 2>&1 || true
/usr/libexec/PlistBuddy -c "Add :LSUIElement bool true" "$PLIST_PATH"

/usr/libexec/PlistBuddy -c "Delete :CFBundleURLTypes" "$PLIST_PATH" >/dev/null 2>&1 || true
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes array" "$PLIST_PATH"
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0 dict" "$PLIST_PATH"
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLName string com.d-es-ign.illustrator-url-handler" "$PLIST_PATH"
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes array" "$PLIST_PATH"
/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string $ILLUSTRATOR_URL_SCHEME" "$PLIST_PATH"

"/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister" -f "$APP_PATH"

echo "Built and registered: $APP_PATH"
