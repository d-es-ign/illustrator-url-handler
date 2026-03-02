# Open Illustrator From Browser (macOS)

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![AppleScript](https://img.shields.io/badge/AppleScript-999999?style=for-the-badge&logo=apple&logoColor=white)
![Adobe Illustrator](https://img.shields.io/badge/Adobe_Illustrator-330000?style=for-the-badge&logo=adobeillustrator&logoColor=FF9A00)
![SVG](https://img.shields.io/badge/SVG-FFB13B?style=for-the-badge&logo=svg&logoColor=white)
![Browser Integration](https://img.shields.io/badge/Browser_Integration-1E293B?style=for-the-badge)
![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

Small macOS helper that lets you open Adobe Illustrator from browser links via a custom URL protocol.

## Open Illustrator From Browser

Use links like:

`illustrator-open://open?path=/absolute/path/to/file.ai`

to open local Illustrator-supported files directly in Adobe Illustrator.

## What It Does

- Registers `illustrator-open://` URL scheme.
- Accepts URLs in the form:
  - `illustrator-open://open?path=/absolute/path/to/file.ai`
- Opens the file in Illustrator and brings Illustrator to the foreground.

## Security Guards

- Only paths ending in `.svg`, `.pdf`, `.ai`, or `.eps` are accepted.
- Only paths under your configured base directory are accepted.

## Setup

1. Copy env template:

```bash
cp .env.example .env.local
```

2. Edit `.env.local`:

- `ILLUSTRATOR_APP_NAME` - usually `Adobe Illustrator`
- `ILLUSTRATOR_ALLOWED_BASE_PATH` - absolute allowlisted folder for your artwork files
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

Then click the icon. It triggers the URL handler and opens the file in Illustrator.

Source-of-truth handler logic is in `scripts/handler.applescript.template`.

## License

MIT.
