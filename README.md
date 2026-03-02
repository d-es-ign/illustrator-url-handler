# Illustrator URL Handler

Small macOS helper that registers a custom URL scheme and opens SVG files in Adobe Illustrator.

## What It Does

- Registers `illustrator-open://` URL scheme.
- Accepts URLs in the form:
  - `illustrator-open://open?path=/absolute/path/to/file.svg`
- Opens the SVG in Illustrator and brings Illustrator to the foreground.

## Security Guards

- Only paths ending in `.svg` are accepted.
- Only paths under your configured base directory are accepted.

## Setup

1. Copy env template:

```bash
cp .env.example .env.local
```

2. Edit `.env.local`:

- `ILLUSTRATOR_APP_NAME` - usually `Adobe Illustrator`
- `ILLUSTRATOR_ALLOWED_BASE_PATH` - absolute allowlisted folder for SVGs
- `ILLUSTRATOR_URL_SCHEME` - default `illustrator-open`

## Build and Register

Run:

```bash
./scripts/build-handler.sh
```

This will:

- Generate AppleScript from template + env values
- Compile `IllustratorUrlHandler.app`
- Register URL scheme with LaunchServices

## Example Page

Open:

```bash
open example/index.html
```

Then click the icon. It triggers the URL handler and opens the SVG in Illustrator.

## Notes

- Source-of-truth handler logic is in:
  - `scripts/handler.applescript.template`
