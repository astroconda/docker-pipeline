#!/bin/bash
PROJECT=astroconda/pipeline
PIPELINE="${1}"
if [[ -z ${PIPELINE} ]]; then
    echo "No pipeline specified. [e.g. hst-TREE, jwst-TREE, ...]"
    exit 1
fi

docker build -t ${PROJECT}:${PIPELINE} --build-arg PIPELINE=${PIPELINE} .
