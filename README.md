# MAG MIXER

MAG image overlay tool for X68000, preserved as original implementation.

---

## Overview

MAG MIXER overlays two 16-color MAG images by treating selected colors\
in the upper image as transparent.

The result is displayed immediately using an external viewer.

---

## Features

* Overlays two MAG images
* Multiple transparent colors can be specified
* Select which palette to use (upper or lower image)
* Uses an external display command via environment variable
* Designed for 16-color mode

---

## Usage

```
MAGMIX /color[p] upper_file lower_file
```

* `upper_file`
  Image to be placed on top

* `lower_file`
  Image to be displayed underneath

* `/color[p]`
  Color codes (`0`–`F`) to be treated as transparent\
  Multiple values can be specified

  * With `p` → use the upper image palette
  * Without `p` → use the lower image palette

---

## Environment Variable

MAG MIXER uses an external command to display images.

Set the command via the `magmix` environment variable:

```
set magmix=magl /r0 /c
```

If not set, the following default is used:

```
magl /r0 /c
```

This allows MAG MIXER to work with different viewers or formats.

---

## Examples

```
magmix sample1.mag sample2.mag /0f
```

Overlay `sample1.mag` onto `sample2.mag`,\
treating colors `0` and `F` as transparent.\
Uses the lower image palette.

```
magmix sample3.mag sample4.mag /8p
```

Overlay `sample3.mag` onto `sample4.mag`,\
treating color `8` as transparent.\
Uses the upper image palette.

---

## Notes

* This tool works in 16-color mode only
* MAG MIXER does not decode image data itself\
  It relies on an external display command
* Designed to work naturally with tools such as MAGL

---

## Status

This repository preserves the original implementation.

The source code and documentation are provided as-is,\
with minimal modification.

---

## License

MIT License
