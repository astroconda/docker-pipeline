ARG HUB=${HUB:-}
ARG PYTHON_VERSION=${PYTHON_VERSION:-}
FROM "${HUB}/python:${PYTHON_VERSION}"
LABEL maintainer="jhunk@stsci.edu" \
      vendor="Space Telescope Science Institute"

ARG PIPELINE=${PIPELINE:-}

WORKDIR "${TOOLCHAIN_BUILD}"

COPY scripts/ ${TOOLCHAIN_BUILD}/bin
COPY etc/ ${TOOLCHAIN_BUILD}/etc

USER "${USER_ACCT}"

RUN sudo chown -R ${USER_ACCT}: ${TOOLCHAIN_BUILD} \
    && bin/build.sh \
    && sudo rm -rf "${TOOLCHAIN_BUILD}"

WORKDIR "${USER_HOME}"

CMD ["/bin/bash", "-l"]
