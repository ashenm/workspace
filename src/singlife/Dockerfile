ARG BASEIMAGE=ashenm/workspace:latest

FROM ${BASEIMAGE}

LABEL com.docker.image.source.entrypoint="src/singlife/Dockerfile"
LABEL org.opencontainers.image.source="https://github.com/ashenm/workspace.git"

# avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# install python packages
RUN sudo --set-home python3 -m pip install --no-cache-dir --ignore-installed \
    aws-sam-cli \
    qldbshell
