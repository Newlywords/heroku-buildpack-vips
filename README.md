heroku-buildpack-vips (heroku-18 version -- heroku-20 version [available here](https://github.com/brandoncc/heroku-buildpack-vips-h20)
=====================

A VIPS buildpack for the heroku-18 stack.

Important notes:

This buildpack started out as one of the many that are out there, and ended up
being completely different. The build script uses docker and also includes pdf
support via poppler. In order to use this buildpack, you must install these packages in your heroku application:

- libglib2.0-0
- libglib2.0-dev
- libpoppler-glib8

The easiest way to do this is using the heroku apt buildpack.

This buildpack was put together with the help of John Cupitt, the creator of
libvips. He was invaluable in my efforts to get a working libvips installation
with pdf support on heroku. Thank you John!

---

Heroku buildpack with [libvips](https://github.com/jcupitt/libvips) installed.


## Usage

Add this buildpack to your app:

```
https://github.com/brandoncc/heroku-buildpack-vips
```

## Build script

[This](./build.sh) is the script used to build vips using docker.

```sh
VIPS_VERSION=x.y.z ./build.sh
```

After building a tar file, it will be copied to the `build` directory. Then you should commit this changes to git.

## Build configuration

```
~ $ vips --vips-config
native win32: no
native OS X: no
open files in binary mode: no
enable debug: no
enable deprecated library components: yes
enable docs with gtkdoc: no
gobject introspection: no
enable radiance support: yes
enable analyze support: yes
enable PPM support: yes
use fftw3 for FFT: yes
Magick package: none
Magick API version: none
load with libMagick: no
save with libMagick: no
accelerate loops with orc: yes
ICC profile support with lcms: yes (lcms2)
file import with niftiio: no
file import with libheif: yes
file import with OpenEXR: no
file import with OpenSlide: no
file import with matio: no
PDF import with PDFium: no
PDF import with poppler-glib: yes
SVG import with librsvg-2.0: yes
zlib: yes
file import with cfitsio: no
file import/export with libwebp: yes
text rendering with pangoft2: no
file import/export with libspng: no
file import/export with libpng: yes (pkg-config libpng >= 1.2.9)
support 8bpp PNG quantisation: no
file import/export with libtiff: yes (pkg-config libtiff-4)
file import/export with giflib: yes (found by search)
file import/export with libjpeg: yes (pkg-config)
image pyramid export: yes
use libexif to load/save JPEG metadata: yes
```
