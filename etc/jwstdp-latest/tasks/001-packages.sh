#!/bin/bash
set -e
set -x

sysconfdir="${TOOLCHAIN_BUILD}/etc/${PIPELINE}"
reqdir=${sysconfdir}/pkgs
blddir=builds


function pre()
{
    if [[ ! -d ${reqdir} ]]; then
        # Nothing there, but maybe that's on purpose.
        exit 0
    fi
    mkdir -p "${blddir}"
    pushd ${blddir} &>/dev/null
}

function build()
{
    pre
    # Iterate over binary package build scripts
    for req in ${reqdir}/*
    do
        chmod +x "${req}"
        "${req}"
    done
    post
}

function post()
{
    popd &>/dev/null
    [[ -d ${blddir} ]] && rm -rf "${blddir}"
}

build
