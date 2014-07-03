heroku-buildpack-vips
=====================

Heroku buildpack with [libvips](https://github.com/jcupitt/libvips) installed.

Current vips version is 7.40.3 with webp 0.4.0, orc 0.4.18 and fftw 3.3.4

## Usage

Point the BUILDPACK_URL config or add to your .buildpacks this:

```
https://github.com/alex88/heroku-buildpack-vips.git
```

or, if you want to stick with a version:

```
https://github.com/alex88/heroku-buildpack-vips.git#7.38.4.0
```

PS: You can even use the `ruby-vips` gem ;)

## Version

Buildpack is tagged with the vips version it uses with the scheme of `vips-mayor`.`vips-minor`.`vips-pl`.`buildpack-pl`

## Contribute

Open a damn issue or pull request (way appreciated) ;)

## Build script

This is the script used to build vips on `heroku run bash`

```bash
#!/bin/bash

# Set vips version
export VIPS_VERSION=7.40.3
export WEBP_VERSION=0.4.0
export ORC_VERSION=0.4.18
export FFTW_VERSION=3.3.4
export BUILD_PATH=/tmp
export OUT_PATH=/app/vendor/vips
export PKG_CONFIG_PATH=$OUT_PATH/lib/pkgconfig:$PKG_CONFIG_PATH

# Remove out path if already exists
rm -Rf $OUT_PATH

# Build path
cd $BUILD_PATH

###############
#     Orc     #
###############

# Download orc dependency
curl http://cgit.freedesktop.org/gstreamer/orc/snapshot/orc-$ORC_VERSION.tar.gz -o orc.tar.gz
# Unzip
tar -xvf orc.tar.gz
# Get into orc folder
cd orc-$ORC_VERSION
# Configure
./autogen.sh
# Configure build
./configure --prefix $OUT_PATH
# Make orc
make
# Install orc
make install

cd $BUILD_PATH

###############
#     WebP    #
###############

# Download webp dependency
curl https://webp.googlecode.com/files/libwebp-$WEBP_VERSION.tar.gz -o libwebp.tar.gz
# Unzip
tar -xvf libwebp.tar.gz
# Get into webp folder
cd libwebp-$WEBP_VERSION
# Configure build
./configure --prefix $OUT_PATH
# Make libwebp
make
# Install webp
make install

# Build path
cd $BUILD_PATH

###############
#    FFTW     #
###############

# Download fftw dependency
curl http://www.fftw.org/fftw-$FFTW_VERSION.tar.gz -o fftw.tar.gz
# Unzip
tar -xvf fftw.tar.gz
# Get into fftw folder
cd fftw-$FFTW_VERSION
# Configure build
./configure --enable-shared --prefix $OUT_PATH
# Make fftw
make
# Install fftw
make install

# Build path
cd $BUILD_PATH

###############
#     VIPS    #
###############

# Download vips runtime
curl http://www.vips.ecs.soton.ac.uk/supported/current/vips-$VIPS_VERSION.tar.gz -o vips.tar.gz
# Unzip
tar -xvf vips.tar.gz
# Get into vips folder
cd vips-$VIPS_VERSION
# Configure build and output everything in /tmp/vips
./configure --prefix $OUT_PATH
# Make
make
# install vips
make install


###############
#    Output   #
###############

# Get into output path
cd $OUT_PATH
# Create dist package
tar -cvzf output.tar.gz *

###############
#     FTP     #
###############

curl -T output.tar.gz -u username:password ftp://yourftpsitehere/
```