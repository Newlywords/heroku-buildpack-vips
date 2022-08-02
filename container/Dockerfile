ARG STACK_VERSION
FROM heroku/heroku:$STACK_VERSION

ENV DEBIAN_FRONTEND noninteractive

# useful build tools ... we need gtk-doc to build orc, since they don't ship
# pre-baked tarballs
RUN apt-get update && apt-get install -y \
  build-essential \
  autoconf \
  automake \
  cmake \
  libtool \
  intltool \
  gtk-doc-tools \
  meson \
  unzip \
  wget \
  git \
  pkg-config

# heroku buildpacks include some libraries, like tiff and jpeg, as part of the
# run-time platform, and we want to use those libs if we can
#
# see https://devcenter.heroku.com/articles/stack-packages
#
# libgsf needs libxml2
RUN apt-get update && apt-get install -y \
  glib-2.0-dev \
  libexpat-dev \
  librsvg2-dev \
  libpng-dev \
  libjpeg-dev \
  libtiff5-dev \
  libexif-dev \
  liblcms2-dev \
  libxml2-dev \
  libfftw3-dev \
  libpoppler-glib-dev \
  libwebp-dev \
  libmagickcore-dev \
  libpango1.0-dev \
  python-gi-dev \
  libgirepository1.0-dev

# Used by the libvips test suite
RUN apt-get update && apt-get install -y \
  bc

# build our stack to this prefix
ARG VIPS_PREFIX=/usr/local/vips

# ld and pkg-config need to pick up packages from this area
ENV LD_LIBRARY_PATH=$VIPS_PREFIX/lib
ENV PKG_CONFIG_PATH=$VIPS_PREFIX/lib/pkgconfig

# build area
WORKDIR /usr/local/src

ARG GIFLIB_VERSION=5.1.4
ARG GIFLIB_URL=http://downloads.sourceforge.net/project/giflib

RUN wget ${GIFLIB_URL}/giflib-$GIFLIB_VERSION.tar.bz2 \
  && tar xf giflib-${GIFLIB_VERSION}.tar.bz2 \
  && cd giflib-${GIFLIB_VERSION} \
  && ./configure --prefix=$VIPS_PREFIX \
  && make V=0 \
  && make install

ARG ORC_VERSION=0.4.28
ARG ORC_URL=https://gstreamer.freedesktop.org/src/orc

RUN wget ${ORC_URL}/orc-$ORC_VERSION.tar.xz \
  && tar xf orc-${ORC_VERSION}.tar.xz \
  && cd orc-${ORC_VERSION} \
  && ./autogen.sh \
  && ./configure --prefix=$VIPS_PREFIX --disable-gtk-doc \
  && make V=0 \
  && make install

ARG GSF_VERSION=1.14.42
ARG GSF_URL=http://ftp.gnome.org/pub/GNOME/sources/libgsf

RUN wget ${GSF_URL}/${GSF_VERSION%.*}/libgsf-$GSF_VERSION.tar.xz \
  && tar xf libgsf-${GSF_VERSION}.tar.xz \
  && cd libgsf-${GSF_VERSION} \
  && ./configure --prefix=$VIPS_PREFIX --disable-gtk-doc \
  && make V=0 \
  && make install

ARG DE265_VERSION=1.0.8
ARG DE265_URL=https://github.com/strukturag/libde265/releases/download

RUN wget ${DE265_URL}/v${DE265_VERSION}/libde265-${DE265_VERSION}.tar.gz \
  && tar xf libde265-${DE265_VERSION}.tar.gz \
  && cd libde265-${DE265_VERSION} \
  && ./autogen.sh \
  && ./configure --prefix=$VIPS_PREFIX \
  && make V=0 \
  && make install

ARG HEIF_VERSION=1.10.0
ARG HEIF_URL=https://github.com/strukturag/libheif/releases/download

RUN wget ${HEIF_URL}/v${HEIF_VERSION}/libheif-${HEIF_VERSION}.tar.gz \
  && tar xf libheif-${HEIF_VERSION}.tar.gz \
  && cd libheif-${HEIF_VERSION} \
  && ./configure --prefix=$VIPS_PREFIX \
  && make V=0 \
  && make install

ARG VIPS_VERSION=8.13.0
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
  && tar xzf vips-${VIPS_VERSION}.tar.gz \
  && cd vips-${VIPS_VERSION} \
  && meson setup build-dir --buildtype=release --prefix=$VIPS_PREFIX \
  && cd build-dir \
  && meson compile \
  && meson test \
  && meson install

# clean the build area ready for packaging
RUN cd $VIPS_PREFIX \
  && rm bin/gif* bin/orc* bin/gsf* bin/batch_* bin/vips-* \
  && rm bin/vipsprofile bin/light_correct bin/shrink_width \
  && strip lib/*.a lib/lib*.so* \
  && rm -rf share/gtk-doc \
  && rm -rf share/man \
  && rm -rf share/thumbnailers

ARG STACK_VERSION
RUN cd $VIPS_PREFIX \
  && rm -rf build \
  && mkdir build \
  && tar czf "build/heroku-${STACK_VERSION}.tar.gz" bin include lib

# Store configuration for easy viewing in the repo
ARG STACK_VERSION
RUN cd $VIPS_PREFIX \
  && echo "$ vips --vips-version" > "build/heroku-${STACK_VERSION}.config.log" \
  && ./bin/vips --vips-version >> "build/heroku-${STACK_VERSION}.config.log" \
  && echo "" >> "build/heroku-${STACK_VERSION}.config.log" \
  && echo "$ vips --vips-config" >> "build/heroku-${STACK_VERSION}.config.log" \
  && ./bin/vips --vips-config >> "build/heroku-${STACK_VERSION}.config.log"
