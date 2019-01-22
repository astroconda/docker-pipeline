#!/bin/bash
PROJECT=astroconda/pipeline
PIPELINE="${1}"
if [[ -z ${PIPELINE} ]]; then
    echo "No pipeline specified. [e.g. hst-TREE, jwst-TREE, ...]"
    exit 1
fi

PYTHON_VERSION="${2}"
if [[ -z ${PIPELINE} ]]; then
    echo "Need a fully qualified python version [e.g. 3.7.1]"
    exit 1
fi

SUFFIX=${PYTHON_VERSION//\./}
if [[ -z ${SUFFIX} ]]; then
    echo "Unable to determine tag suffix from python version."
    exit 1
fi

TAG="${PROJECT}:${PIPELINE}_py${SUFFIX}"
docker build -t ${TAG} --build-arg PIPELINE=${PIPELINE} --build-arg PYTHON_VERSION=${PYTHON_VERSION} .
