ARG BASEIMAGE=ashenm/workspace:latest

FROM ${BASEIMAGE}

# avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# install python packages
RUN sudo --set-home python3 -m pip install --no-cache-dir --ignore-installed \
    aws-sam-cli \
    qldbshell
