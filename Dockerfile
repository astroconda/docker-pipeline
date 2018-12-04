FROM astroconda/python:3.7.1
LABEL maintainer="jhunk@stsci.edu" \
      vendor="Space Telescope Science Institute"

ARG USER_ACCT=${USER_ACCT:-developer}
ARG USER_HOME=/home/${USER_ACCT}
ARG PIPELINE=${PIPELINE:-}

WORKDIR "${TOOLCHAIN_BUILD}"

COPY scripts/ ${TOOLCHAIN_BUILD}/bin
COPY etc/ ${TOOLCHAIN_BUILD}/etc

USER "${USER_ACCT}"

RUN sudo chown -R ${USER_ACCT}: ${TOOLCHAIN_BUILD} \
    && whoami \
    && bin/build.sh \
    && sudo rm -rf "${TOOLCHAIN_BUILD}"

WORKDIR "${USER_HOME}"

CMD ["/bin/bash", "-l"]
