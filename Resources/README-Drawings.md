# Dictionary Drawings

The app looks for bundled black-and-white drawings before trying to fetch a
Wikipedia thumbnail and convert it to a monochrome drawing.

Place image files in:

```text
Resources/Drawings/
```

Use lower-case normalized names, for example:

```text
Resources/Drawings/apple.tiff
Resources/Drawings/horse.png
Resources/Drawings/test-tube.tiff
```

Lookup order:

1. The searched word normalized to lower-case alphanumeric words joined by
   hyphens.
2. Cross-reference terms found in the `dict` output inside braces, such as
   `{Test tube}` becoming `test-tube`.
3. A Wikipedia thumbnail converted to monochrome line art if no bundled drawing
   exists.

If no bundled or Wikipedia illustration is found, the app does not draw an
illustration.

Good drawing sources are public-domain dictionary and encyclopedia scans,
especially Webster-era plate art from Internet Archive, Wikimedia Commons
public-domain engravings, and Project Gutenberg illustration sets. Convert
individual illustrations to monochrome TIFF or PNG, name them with the scheme
above, and add them to `Resources/Drawings`.
