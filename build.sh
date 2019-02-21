#!/bin/bash
HUB=${3:-astroconda}
PROJECT=${HUB}/pipeline
PROJECT_VERSION="${1}"
PYTHON_VERSION="${2}"
TAGS=()
SUFFIX=
image_tag="${PROJECT_VERSION}"

if [[ -z ${PROJECT_VERSION} ]]; then
    echo "Pipeline version required [e.g. hstdp-2018.3]"
    exit 1
fi

if [[ -z ${PYTHON_VERSION} ]]; then
    echo "Python version required [e.g. latest, 3.7.2]"
    exit 1
fi

if [[ ${PYTHON_VERSION} != latest ]]; then
    SUFFIX=${PYTHON_VERSION//\./}
    if [[ -z ${SUFFIX} ]]; then
        echo "Unable to determine tag suffix from python version."
        exit 1
    fi

    image_tag="${image_tag}_py${SUFFIX}"
fi

case "${HUB}" in
    *amazonaws\.com)
        if ! type -p aws; then
            echo "awscli client not installed"
            exit 1
        fi
        REGION="$(awk -F'.' '{print $(NF-2)}' <<< ${HUB})"
        $(aws ecr get-login --no-include-email --region ${REGION})
        unset REGION
        ;;
    *)
        # Assume default index
        docker login
        ;;
esac
set -x

TAGS+=( "-t ${PROJECT}:${image_tag}" )
PIPELINE="${PROJECT_VERSION}"
docker build ${TAGS[@]} \
    --build-arg HUB="${HUB}" \
    --build-arg PYTHON_VERSION="${PYTHON_VERSION}" \
    --build-arg PIPELINE="${PROJECT_VERSION}" \
    .

rv=$?
if (( rv > 0 )); then
    echo "Failed... Image not published"
    exit ${rv}
fi


max_retry=4
retry=0
set +e
while (( retry != max_retry ))
do
    echo "Push attempt #$(( retry + 1 ))"
    docker push "${PROJECT}:${image_tag}"
    rv=$?
    if [[ ${rv} == 0 ]]; then
        break
    fi
    (( retry++ ))
done

exit ${rv}
