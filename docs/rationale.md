# Rationale — MAGMIX

## The Gap in the X68000 Ecosystem

While the X68000 supported 256 and 65,536 color modes, the 16-color mode occupied a unique position.

* **65,536 colors**: High-end graphics software already existed, providing layering and editing features.
* **256 colors**: Primarily used for games; less common for static digital art.
* **16 colors**: Widely used in the PC-98 ecosystem (the origin of the MAG format), but lacked dedicated composition tools on the X68000.

## Why 16-color mode?

At the time, MAG images from PC-98 BBS environments were frequently brought into the X68000.

However, once imported, there was no simple way to combine or overlay images in the 16-color environment.

The 16-color mode also played an important role beyond its technical limitations.

While the X68000's primary graphics culture centered around 65,536 colors,\
the 16-color environment became a meeting point between PC-98 users and X68000 users.

In this context, the 16-color mode was not just a constrained display mode,\
but a cultural intersection where different ecosystems met.

## Filling the Gap

MAGMIX was developed to address this limitation.

It introduced simple transparency-based overlaying to the 16-color workflow,\
bringing a form of compositional flexibility that had previously been missing.

---

## Origin

Originally, MAGMIX was created as a small utility during the development of MAGL,\
primarily for debugging purposes.

It was not intended for public release.

However, when someone on a BBS was looking for a tool to overlay images,\
it became clear that such a tool was missing.

This led to its release as a standalone utility.
