# Changes by date

References to "John" are referring to [John Cupitt](https://github.com/jcupitt), author and maintainer of the libvips
library.

## September 18, 2023

- Fixed [broken libheif build](https://github.com/brandoncc/heroku-buildpack-vips/issues/41) that was introduced by
  https://github.com/brandoncc/heroku-buildpack-vips/pull/38
  - Fixed by https://github.com/brandoncc/heroku-buildpack-vips/commit/fc62dfeaaa6abf9c4a8e4a09470e50834ba60271
- Build files for heroku-20 and heroku-22 are now separated, because heroku-22 has more dependencies baked-in than
  heroku-20. We don't have to build those dependencies from source. Eventually, hopefully we don't need to build
  anything from source.
  - https://github.com/brandoncc/heroku-buildpack-vips/commit/c010f987d704a5bc49b65221f8417893dacc760e
- After using PDFium for a month, the buildpack has switched back to poppler due to an issue found by John
  - reference: https://github.com/brandoncc/heroku-buildpack-vips/issues/41#issuecomment-1722462354
  - https://github.com/brandoncc/heroku-buildpack-vips/commit/c010f987d704a5bc49b65221f8417893dacc760e
- Misc modifications recommended to John
  - https://github.com/brandoncc/heroku-buildpack-vips/commit/3af8c48b1b1935087c3775940247663123fae459
  - https://github.com/brandoncc/heroku-buildpack-vips/commit/5dbbdcfc8f89cd8a7470e770376c053a2edc8fab
- [Update to 8.14.5](https://github.com/brandoncc/heroku-buildpack-vips/commit/ce6d1b661fc8be15d4810af7fa02939f2796c57f)
