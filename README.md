# Dictionary

Dictionary is a small GNUstep/AppKit dictionary browser in the style of classic
NeXT desktop utilities. It looks up words with the local `dict` command, shows
the returned definition, and displays a matching black-and-white illustration
when one is bundled with the app.

If no matching drawing is found, the app generates simple pen-style fallback
line art from the definition text.

## Features

- Native GNUstep desktop application.
- Search box plus `Look Up` action for local dictionary queries.
- Uses `/usr/bin/dict` as the dictionary backend.
- GNUstep Services integration:
  `Services > Look Up in Dictionary` can look up selected text from another
  application.
- Optional bundled drawings under `Resources/Drawings/`.
- Generated fallback illustrations for plant, animal, landscape, and generic
  object definitions.

## Requirements

- GNUstep Make and GNUstep GUI/AppKit development packages.
- A working `dict` client at `/usr/bin/dict`.
- At least one local or network dictionary source configured for `dict`.

On Debian-style systems, the required packages are typically along these lines:

```sh
sudo apt-get install gnustep-make gnustep-gui-runtime libgnustep-gui-dev dict
```

Install a dictionary database as appropriate for your system, for example a
WordNet or Webster dictionary package.

## Build

Source the GNUstep environment first if your shell does not already do it:

```sh
. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
```

Then build the application:

```sh
make
```

The built application is produced by GNUstep Make under the usual application
build directory for your environment.

## Run

From the repository root after building:

```sh
openapp ./Dictionary.app
```

Depending on the GNUstep Make configuration, the app bundle may also be under
`obj/Dictionary.app`.

You can verify the dictionary backend independently with:

```sh
dict example
```

## Services

Dictionary registers itself as a Services provider named `Dictionary`. After the
app is installed or launched in an environment that scans GNUstep services, other
applications can send selected plain text to:

```text
Services > Look Up in Dictionary
```

The service activates Dictionary, opens its window, and looks up the selected
text.

## Drawings

The app checks for bundled drawings before drawing a generated fallback image.
Place drawing files in:

```text
Resources/Drawings/
```

Use lower-case normalized filenames:

```text
Resources/Drawings/apple.tiff
Resources/Drawings/horse.png
Resources/Drawings/test-tube.tiff
```

Supported extensions are:

```text
tiff, tif, png, jpg, jpeg, gif
```

Lookup candidates are generated from the searched word and from cross-reference
terms found in the `dict` output inside braces, such as `{Test tube}` becoming
`test-tube`.

See `Resources/README-Drawings.md` for more detail on naming and sourcing
public-domain line art.

## Source Layout

- `main.m` sets up `NSApplication` and registers the services provider.
- `AppDelegate.m` builds the interface, handles lookups, and manages services.
- `DictionaryClient.m` runs `/usr/bin/dict`, normalizes lookup tokens, and
  derives drawing candidates from definitions.
- `IllustrationView.m` renders bundled images or generated fallback line art.
- `DictionaryInfo.plist` contains application metadata and Services
  registration.
- `GNUmakefile` defines the GNUstep application target.

## Notes

`DictionaryClient.m` currently expects the dictionary executable at
`/usr/bin/dict`. If your platform installs it somewhere else, adjust the
`setLaunchPath:` call or provide a compatible wrapper at that path.
