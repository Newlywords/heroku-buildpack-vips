# Changes by date

References to "John" are referring to [John Cupitt](https://github.com/jcupitt), author and maintainer of the libvips
library.

## September 19, 2023

A [long-time bug](https://github.com/brandoncc/heroku-buildpack-vips/issues/3) in the `bin/compile` script was
[resolved](https://github.com/brandoncc/heroku-buildpack-vips/commit/80abfc0f5072f1104d5587b7f59ad90686a6b413).

Here is the "before" list of an application's `$PATH`:

- `/app/bin`
- `/app/vendor/vips/bin`
- `/app/bin`
- `/app/vendor/bundle/bin`
- `/app/vendor/bundle/ruby/3.2.0/bin`
- `/app/vendor/ruby-3.2.2/bin`
- `/tmp/codon/tmp/buildpacks/50d5eddf222a9b7326028041d4e6509f915ccf2c/vendor/ruby/heroku-22/bin/`
- `/usr/local/bin`
- `/usr/bin`
- `/bin`
- `/usr/local/bin`
- `/usr/bin`
- `/bin`
- `/app/bin`
- `/app/vendor/bundle/bin`
- `/app/vendor/bundle/ruby/3.2.0/bin`
- `/usr/local/bin`
- `/usr/bin`
- `/bin`

and here is the "after":

- `/app/bin`
- `/app/vendor/vips/bin`
- `/app/bin`
- `/app/vendor/bundle/bin`
- `/app/vendor/bundle/ruby/3.2.0/bin`
- `/usr/local/bin`
- `/usr/bin`
- `/bin`

The full list of affected environment variables is:

- PATH
- LD_LIBRARY_PATH
- LIBRARY_PATH
- PKG_CONFIG_PATH
- CPPPATH
- CPATH

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
