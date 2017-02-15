#!/bin/bash

# Set vips version
export VIPS_VERSION=8.4.5
export WEBP_VERSION=0.6.0
export GIF_VERSION=5.1.4

export BUILD_PATH=/tmp
export OUT_PATH=$OUT_DIR/app/vendor/vips
export PKG_CONFIG_PATH=$OUT_PATH/lib/pkgconfig:$PKG_CONFIG_PATH
export PATH=$OUT_PATH/bin:$PATH

# Based on https://gist.github.com/chrismdp/6c6b6c825b07f680e710
function putS3 {
  file=$1
  aws_path=$2
  aws_id=$3
  aws_token=$4
  aws_bucket=$5
  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:public-read"
  content_type='application/x-compressed-tar'
  string="PUT\n\n$content_type\n$date\n$acl\n/$aws_bucket$aws_path$file"
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${aws_token}" -binary | base64)
  curl -X PUT -T "$file" \
    -H "Host: $aws_bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${aws_id}:$signature" \
    "https://$aws_bucket.s3.amazonaws.com$aws_path$file"
  echo "Uploaded to https://$aws_bucket.s3.amazonaws.com$aws_path$file"
}

# These should be set from the outside. A git version and heroku/travis respectively
if [ -z "$VERSION" ]
then
    VERSION="unknown"
fi
if [ -z "$TARGET" ]
then
    TARGET="unknown"
fi

# Remove out path if already exists
rm -Rf $OUT_PATH

# Build path
cd $BUILD_PATH

###############
#     WebP    #
###############
function build_webp {
    # Download webp dependency
    curl https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-$WEBP_VERSION.tar.gz -o libwebp.tar.gz
    # Unzip
    tar -xf libwebp.tar.gz
    # Get into webp folder
    cd libwebp-$WEBP_VERSION
    # Configure build
    ./configure --prefix $OUT_PATH
    # Make libwebp
    make
    # Install webp
    make install
}

###############
#   CFITSIO   #
###############
function build_cftsio {
    # Download CFITSIO dependency
    curl -L ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3370.tar.gz -o cfitsio.tar.gz
    # Unzip
    tar -xf cfitsio.tar.gz
    # Get into CFITSIO folder
    cd cfitsio
    # Configure build
    ./configure --prefix $OUT_PATH
    # Make cfitsio
    make
    # Install cfitsio
    make install
}

###############
#     GIF     #
###############
function build_gif {
  curl -L http://downloads.sourceforge.net/project/giflib/giflib-${GIF_VERSION}.tar.gz -o giflib.tar.gz
  tar -xf giflib.tar.gz
  cd giflib-$GIF_VERSION
  ./configure --prefix $OUT_PATH --enable-shared --disable-static \
  --disable-dependency-tracking
  make
  make install
}

###############
#     VIPS    #
###############
function build_vips {
    # Download vips runtime
    curl http://www.vips.ecs.soton.ac.uk/supported/current/vips-$VIPS_VERSION.tar.gz -o vips.tar.gz
    # Unzip
    tar -xf vips.tar.gz
    # Get into vips folder
    cd vips-$VIPS_VERSION
    # Configure build and output everything in /tmp/vips
    ./configure --prefix $OUT_PATH --enable-shared --disable-static --disable-dependency-tracking \
  --disable-debug --disable-introspection --without-python --without-fftw \
  --without-magick --without-pangoft2 --without-ppm --without-analyze --without-radiance \
  --with-giflib-includes=$OUT_PATH/include \
  --with-giflib-libraries=$OUT_PATH/lib
    # Make
    make
    # install vips
    make install
}

### Build
cd $BUILD_PATH
build_webp
cd $BUILD_PATH
build_cftsio
cd $BUILD_PATH
build_gif
cd $BUILD_PATH
build_vips

###############
#    Output   #
###############

# Get into output path
cd $OUT_PATH
# Clean useless files
rm -rf $OUT_PATH/share/{doc,gtk-doc}
# Create dist package
tar -cvzf libvips-${VERSION}-${TARGET}.tgz *

###############
#     S3      #
###############
if [ -z "$AMAZON_API_TOKEN" ];
then
    echo "Amazon API Token not provided, skipping upload";
else
    putS3 "libvips-${VERSION}-${TARGET}.tgz" "/bundles/" $AMAZON_API_ID $AMAZON_API_TOKEN $AMAZON_API_BUCKET
fi

