heroku-buildpack-vips
=====================

Heroku buildpack with [libvips](https://github.com/jcupitt/libvips) installed.

Current vips version is 8.0.0 with webp 0.4.0, libtiff 4.0.3, orc 0.4.18, fftw 3.3.4, libgsf 1.14.30, imagemagick 6.9.0 and lcms 2.6

## About libtiff use

We removed `libtiff.*` from the vips bundle because it's version (5.0) was conflicting with opencv (4.0). Removing `libtiff.*` made it use the user default's libtiff (5.0). Symbol names on the original vips bundle `libtiff.so` are wrong, they have versions appended, which causes the conflict.

The new bundle is available [here](https://s3-us-west-2.amazonaws.com/cdn.thegrid.io/caliper/libvips/libvips-build-0.0.2.tar.gz) and is currently used by us.

## Usage

Point the `BUILDPACK_URL` config or add to your `.buildpacks` this:

```
https://github.com/automata/heroku-buildpack-vips.git
```

## Build script

[This](./build.sh) is the script used to build vips on `heroku run bash`.
