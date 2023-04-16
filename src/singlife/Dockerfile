ARG BASEIMAGE=ashenm/workspace:latest

FROM ${BASEIMAGE}

# avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# install qldb shell
# https://github.com/awslabs/amazon-qldb-shell/releases
RUN curl --silent --fail --show-error --location 'https://api.github.com/repos/awslabs/amazon-qldb-shell/releases/latest' | \
    egrep --only-matching --max-count 1 'https://.*/releases/download/.*/qldb-.*-linux.tar.gz' | wget --input-file - --output-document - | \
    sudo --set-home tar --gzip --extract --wildcards --strip-components 1 --file - --directory /usr/local/bin 'qldb-*/qldb'
