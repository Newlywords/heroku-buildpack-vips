ARG STACK_VERSION
FROM heroku/heroku:$STACK_VERSION

ENV DEBIAN_FRONTEND noninteractive

# generic build tools  ... libgsf needs intltool
RUN apt-get update \
  && apt-get install -y \
    build-essential \
    libtool \
    wget \
    python3-pip \
    ninja-build \
    intltool \
    pkg-config 

RUN pip3 install meson

# use the heroku platform libraries when we can
#
# see https://devcenter.heroku.com/articles/stack-packages
#
# libgsf needs libxml2
# 
# this should only pull in header files and should not create any extra run
# time dependencies
RUN apt-get install -y \
  glib-2.0-dev \
  libexpat1-dev \
  libpango1.0-dev \
  librsvg2-dev \
  libpng-dev \
  libwebp-dev \
  libjpeg-turbo8-dev \
  libtiff5-dev \
  libexif-dev \
  liblcms2-dev \
  libxml2-dev \
  libfftw3-dev \
  libopenexr-dev \
  libgirepository1.0-dev \
  libmagickcore-dev

WORKDIR /usr/local/src

# build to this prefix 
#  - heroku has /usr/local/lib on the default ld.so.conf search path, so 
#    this is convenient
#  - heroku has a basic dir structure in /usr/local, but no files
ARG PREFIX=/usr/local
ENV PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

# the main libimagequant is now gpl3 and we can't use it ... this is a 
# maintained fork of the old BSD-licensed version
ARG IMAGEQUANT_VERSION=main
ARG IMAGEQUANT_URL=https://github.com/lovell/libimagequant

RUN git clone $IMAGEQUANT_URL \
  && cd libimagequant \
  && git checkout $IMAGEQUANT_VERSION \
  && meson build --prefix=${PREFIX} --libdir=lib \
  && cd build \
  && ninja \
  && ninja install

ARG ORC_VERSION=0.4.32
ARG ORC_URL=https://gstreamer.freedesktop.org/src/orc

RUN wget ${ORC_URL}/orc-$ORC_VERSION.tar.xz \
  && tar xf orc-${ORC_VERSION}.tar.xz \
  && cd orc-${ORC_VERSION} \
  && meson build --prefix=${PREFIX} --libdir=lib \
  && cd build \
  && ninja \
  && ninja install

ARG GSF_VERSION=1.14.48
ARG GSF_URL=http://ftp.gnome.org/pub/GNOME/sources/libgsf

RUN wget ${GSF_URL}/${GSF_VERSION%.*}/libgsf-$GSF_VERSION.tar.xz \
  && tar xf libgsf-${GSF_VERSION}.tar.xz \
  && cd libgsf-${GSF_VERSION} \
  && ./configure --prefix=$PREFIX --disable-gtk-doc \
  && make \
  && make install

# use cgif for GIF write
ARG CGIF_VERSION=0.2.0
ARG CGIF_URL=https://github.com/dloebl/cgif/archive/refs/tags

RUN wget ${CGIF_URL}/V${CGIF_VERSION}.tar.gz \
  && tar xf V${CGIF_VERSION}.tar.gz \
  && cd cgif-${CGIF_VERSION} \
  && meson build --prefix=${PREFIX} --libdir=lib \
  && cd build \
  && ninja \
  && ninja install

# use libspng for PNG load and save
ARG SPNG_VERSION=0.7.2
ARG SPNG_URL=https://github.com/randy408/libspng/archive/refs/tags

RUN wget ${SPNG_URL}/v${SPNG_VERSION}.tar.gz \
  && tar xf v${SPNG_VERSION}.tar.gz \
  && cd libspng-${SPNG_VERSION} \
  && meson build --prefix=${PREFIX} --libdir=lib \
  && cd build \
  && ninja \
  && ninja install

# the version number is was correct in feb 2022 ... it just needs to be >4200
# for libvips
ARG PDFIUM_URL=https://github.com/bblanchon/pdfium-binaries/releases/latest/download
ARG PDFIUM_VERSION=4901

RUN wget $PDFIUM_URL/pdfium-linux-x64.tgz \
  && mkdir pdfium \
  && cd pdfium \
  && tar xf ../pdfium-linux-x64.tgz \
  && cp lib/* $PREFIX/lib \
  && cp -r include/* $PREFIX/include

# make a pdfium.pc file libvips can use
RUN mkdir -p $PREFIX/lib/pkgconfig \
  && cd $PREFIX/lib/pkgconfig \
  && echo "prefix=$PREFIX" >> pdfium.pc \
  && echo "exec_prefix=\${prefix}" >> pdfium.pc \
  && echo "libdir=\${exec_prefix}/lib" >> pdfium.pc \
  && echo "includedir=\${prefix}/include" >> pdfium.pc \
  && echo "Name: pdfium" >> pdfium.pc \
  && echo "Description: pdfium" >> pdfium.pc \
  && echo "Version: $PDFIUM_VERSION" >> pdfium.pc \
  && echo "Requires: " >> pdfium.pc \
  && echo "Libs: -L\${libdir} -lpdfium" >> pdfium.pc \
  && echo "Cflags: -I\${includedir}" >> pdfium.pc

ARG DE265_VERSION=1.0.12
ARG DE265_URL=https://github.com/strukturag/libde265/releases/download

RUN wget ${DE265_URL}/v${DE265_VERSION}/libde265-${DE265_VERSION}.tar.gz \
  && tar xf libde265-${DE265_VERSION}.tar.gz \
  && cd libde265-${DE265_VERSION} \
  && ./autogen.sh \
  && ./configure --prefix=$PREFIX \
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

ARG VIPS_VERSION=8.14.3
ARG VIPS_URL=https://github.com/libvips/libvips/archive/refs/tags

RUN wget ${VIPS_URL}/v${VIPS_VERSION}/v${VIPS_VERSION}.tar.gz \
  && tar xzf v${VIPS_VERSION}.tar.gz \
  && cd libvips-${VIPS_VERSION} \
  && meson setup build --buildtype=release --prefix=$PREFIX --libdir=lib \
  && cd build \
  && meson compile \
  && meson test \
  && meson install

# clean and package
ARG STACK_VERSION
RUN cd $PREFIX \
  && rm -rf bin/gif* bin/orc* bin/gsf* bin/batch_* bin/vips-* \
  && rm -rf bin/vipsprofile bin/light_correct bin/shrink_width \
  && rm -rf lib/*.a lib/*.la lib/python* \
  && strip lib/lib*.so* \
  && rm -rf build \
  && mkdir -p build \
  && tar czf "build/heroku-${STACK_VERSION}.tar.gz" bin include lib \
  && ls -l build/heroku-${STACK_VERSION}.tar.gz \
  && echo built heroku-${STACK_VERSION}.tar.gz

# Update ldconfig cache
RUN ldconfig

# Store configuration for easy viewing in the repo
ARG STACK_VERSION
RUN cd $PREFIX \
  && echo "$ vips --vips-version" > "build/heroku-$STACK_VERSION.config.log" \
  && vips --vips-version >> "build/heroku-$STACK_VERSION.config.log" \
  && echo "" >> "build/heroku-$STACK_VERSION.config.log" \
  && echo "$ vips --vips-config" >> "build/heroku-$STACK_VERSION.config.log" \
  && vips --vips-config >> "build/heroku-$STACK_VERSION.config.log"

# install and test ruby-vips to confirm we can pick up the libraries
# correctly 
# we need ruby-dev to install ruby-ffi
RUN apt-get install -y ruby-dev
RUN gem install ruby-vips
RUN ruby -e 'require "vips"; puts "ruby-vips: libvips #{Vips::LIBRARY_VERSION}"'
