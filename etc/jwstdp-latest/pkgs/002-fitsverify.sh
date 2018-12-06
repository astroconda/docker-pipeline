#!/bin/bash -e

name=fitsverify
version=4.19
url=https://heasarc.gsfc.nasa.gov/docs/software/ftools/${name}/${name}-${version}.tar.gz

curl -LO "${url}"
tar xf "$(basename ${url})"

pushd "${name}" &>/dev/null
gcc -o ${name} ftverify.c fvrf_data.c fvrf_file.c fvrf_head.c \
       fvrf_key.c fvrf_misc.c -DSTANDALONE -I${TOOLCHAIN_INCLUDE} \
       -L${TOOLCHAIN_LIB} -Wl,-rpath=${TOOLCHAIN_LIB} -lcfitsio -lm -lnsl

install -m 755 -t "${TOOLCHAIN_BIN}" ${name}
popd &>/dev/null
