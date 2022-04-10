heroku-buildpack-vips
=====================

A VIPS buildpack for the modern Heroku stacks. This stack supports the following
stacks:

- heroku-16
- heroku-18
- heroku-20

If you have problems on any of these stacks, or if a new stack comes out that is
unsupported, please file an issue.

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

## Build configuration (heroku-16)

```
~ $ vips --vips-version
vips-8.12.2-Tue Jan 25 09:34:32 UTC 2022

~ $ vips --vips-config
enable debug: no
enable deprecated library components: yes
enable modules: no
use fftw3 for FFT: yes
accelerate loops with orc: yes
ICC profile support with lcms: yes (lcms2)
zlib: yes
text rendering with pangocairo: no
font file support with fontconfig:
RAD load/save: yes
Analyze7 load/save: yes
PPM load/save: yes
GIF load:  yes
GIF save with cgif: no
EXIF metadata support with libexif: yes
JPEG load/save with libjpeg: yes (pkg-config)
JXL load/save with libjxl: no (dynamic module: no)
JPEG2000 load/save with libopenjp2: no
PNG load with libspng: no
PNG load/save with libpng: yes (pkg-config libpng >= 1.2.9)
quantisation to 8 bit: no
TIFF load/save with libtiff: yes (pkg-config libtiff-4)
image pyramid save: yes
HEIC/AVIF load/save with libheif: yes (dynamic module: no)
WebP load/save with libwebp: no
PDF load with PDFium:  no
PDF load with poppler-glib: yes (dynamic module: no)
SVG load with librsvg-2.0: yes
EXR load with OpenEXR: yes
OpenSlide load: no (dynamic module: no)
Matlab load with matio: no
NIfTI load/save with niftiio: no
FITS load/save with cfitsio: no
Magick package: MagickCore (dynamic module: no)
Magick API version: magick6
load with libMagickCore: yes
save with libMagickCore: yes
```

## Build configuration (heroku-18)

```
~ $ vips --vips-version
vips-8.12.2-Tue Jan 25 09:34:32 UTC 2022

~ $ vips --vips-config
enable debug: no
enable deprecated library components: yes
enable modules: no
use fftw3 for FFT: yes
accelerate loops with orc: yes
ICC profile support with lcms: yes (lcms2)
zlib: yes
text rendering with pangocairo: no
font file support with fontconfig:
RAD load/save: yes
Analyze7 load/save: yes
PPM load/save: yes
GIF load:  yes
GIF save with cgif: no
EXIF metadata support with libexif: yes
JPEG load/save with libjpeg: yes (pkg-config)
JXL load/save with libjxl: no (dynamic module: no)
JPEG2000 load/save with libopenjp2: no
PNG load with libspng: no
PNG load/save with libpng: yes (pkg-config libpng >= 1.2.9)
quantisation to 8 bit: no
TIFF load/save with libtiff: yes (pkg-config libtiff-4)
image pyramid save: yes
HEIC/AVIF load/save with libheif: yes (dynamic module: no)
WebP load/save with libwebp: yes
PDF load with PDFium:  no
PDF load with poppler-glib: yes (dynamic module: no)
SVG load with librsvg-2.0: yes
EXR load with OpenEXR: yes
OpenSlide load: no (dynamic module: no)
Matlab load with matio: no
NIfTI load/save with niftiio: no
FITS load/save with cfitsio: no
Magick package: MagickCore (dynamic module: no)
Magick API version: magick6
load with libMagickCore: yes
save with libMagickCore: yes
```

## Build configuration (heroku-20)

```
~ $ vips --vips-version
vips-8.12.2-Tue Jan 25 09:34:32 UTC 2022

~ $ vips --vips-config
enable debug: no
enable deprecated library components: yes
enable modules: no
use fftw3 for FFT: yes
accelerate loops with orc: yes
ICC profile support with lcms: yes (lcms2)
zlib: yes
text rendering with pangocairo: no
font file support with fontconfig:
RAD load/save: yes
Analyze7 load/save: yes
PPM load/save: yes
GIF load:  yes
GIF save with cgif: no
EXIF metadata support with libexif: yes
JPEG load/save with libjpeg: yes (pkg-config)
JXL load/save with libjxl: no (dynamic module: no)
JPEG2000 load/save with libopenjp2: no
PNG load with libspng: no
PNG load/save with libpng: yes (pkg-config libpng >= 1.2.9)
quantisation to 8 bit: no
TIFF load/save with libtiff: yes (pkg-config libtiff-4)
image pyramid save: yes
HEIC/AVIF load/save with libheif: yes (dynamic module: no)
WebP load/save with libwebp: yes
PDF load with PDFium:  no
PDF load with poppler-glib: yes (dynamic module: no)
SVG load with librsvg-2.0: yes
EXR load with OpenEXR: yes
OpenSlide load: no (dynamic module: no)
Matlab load with matio: no
NIfTI load/save with niftiio: no
FITS load/save with cfitsio: no
Magick package: MagickCore (dynamic module: no)
Magick API version: magick6
load with libMagickCore: yes
save with libMagickCore: yes
```
