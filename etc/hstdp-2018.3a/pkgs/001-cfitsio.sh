#!/bin/bash -e

name=cfitsio
version=3440
url=https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/${name}${version}.tar.gz

sudo yum install -y libcurl-devel
curl -LO "${url}"
tar xf "$(basename ${url})"

pushd "${name}" &>/dev/null
./configure --prefix="${PREFIX}" --enable-reentrant
make shared
make install
popd &>/dev/null
