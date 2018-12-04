#!/bin/bash -e
name=hstcal
version=2.2.0
url="https://github.com/spacetelescope/${name}"

git clone "${url}"
pushd "${name}" &>/dev/null
    # Grab a version of WAF that isn't broken
    curl -o waf https://waf.io/waf-2.0.12
    chmod +x waf

    # Build / Install
    ./waf configure --prefix=${PREFIX} --release-with-symbols --with-cfitsio=${PREFIX}
    ./waf build
    ./waf install
popd &>/dev/null
