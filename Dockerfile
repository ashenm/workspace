FROM ashenm/baseimage:developer

# avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# expose tcp ports
EXPOSE 8080 8081 8082

# set up git-lfs repo
# https://packagecloud.io/github/git-lfs/install#manual
RUN curl -sSL https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
  echo 'deb https://packagecloud.io/github/git-lfs/ubuntu/ bionic main' | \
    tee /etc/apt/sources.list.d/github_git-lfs.list && \
  echo 'deb-src https://packagecloud.io/github/git-lfs/ubuntu/ bionic main' | \
    tee -a /etc/apt/sources.list.d/github_git-lfs.list

# set up node 10.x repo
# https://github.com/nodesource/distributions#debmanual
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  echo 'deb https://deb.nodesource.com/node_10.x bionic main' | \
    tee /etc/apt/sources.list.d/nodesource.list && \
  echo 'deb-src https://deb.nodesource.com/node_10.x bionic main' | \
    tee -a /etc/apt/sources.list.d/nodesource.list

# install packages
RUN apt-get update && \
  apt-get install --yes --no-install-recommends \
    apt-file \
    bash-completion \
    bc \
    bsdtar \
    cmake \
    dnsutils \
    dos2unix \
    exiftool \
    gdb \
    git-lfs \
    iputils-ping \
    iputils-tracepath \
    jq \
    mysql-client \
    nodejs \
    openssh-client \
    perl \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    ruby-full \
    sqlite3 \
    sudo \
    telnet \
    time \
    tree \
    wget \
    whois && \ 
  git lfs install && \
  rm -rf /var/lib/apt/lists/*

# install hub
# http://stackoverflow.com/a/27869453
RUN mkdir /tmp/hub-linux-amd64 && \
  curl -sSL https://github.com/github/hub/releases/latest | \
    egrep -o '/github/hub/releases/download/.*/hub-linux-amd64-.*.tgz' | \
    wget --base=http://github.com/ -q -i - -O - | \
    tar xz -C /tmp/hub-linux-amd64 --strip-components 1 && \
    /tmp/hub-linux-amd64/install && \
  rm -rf /tmp/hub-linux-amd64

# install python packages
RUN pip3 install --no-cache-dir \
    awscli \
    icdiff

# install ruby packages
RUN gem install --no-update-sources --no-rdoc --no-ri \
    bundler \
    jekyll \
    travis

# install node packages
RUN npm install -g \
    eslint  \
    grunt-cli && \
  npm cache clean --force

# add local user
# create workspace
RUN groupadd --gid 1000 ubuntu && \
  useradd --create-home --uid 1000 --gid ubuntu --groups sudo ubuntu --shell /bin/bash && \
  mkdir /home/ubuntu/workspace && \
  chown ubuntu:ubuntu /home/ubuntu/workspace

# configure ssh client
RUN echo '' | tee -a /etc/ssh/ssh_config && \
  echo 'Include /etc/ssh/workspace' | tee -a /etc/ssh/ssh_config

# configure user utilities
ADD --chown=1000:1000 https://gist.githubusercontent.com/ashenm/537a91f9c864d6ef6180790d9076047d/raw/eslintrc.json /home/ubuntu/.eslintrc.json

# configure system
COPY etc /etc/

# change to non-root user
USER ubuntu

# set working directory
WORKDIR /home/ubuntu/workspace

# default execute login shell
CMD ["bash", "--login"]
