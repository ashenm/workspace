FROM ashenm/baseimage

# expose tcp ports
EXPOSE 8080 8081 8082

# revert exclusion of man pages
RUN DEBIAN_FRONTEND=noninteractive && \
  echo '# override man page and documentation page exclusion' | \
    tee -a /etc/dpkg/dpkg.cfg.d/includes && \
  echo 'path-include=/usr/share/doc/*' | \
    tee -a /etc/dpkg/dpkg.cfg.d/includes && \
  echo 'path-include=/usr/share/man/*' | \
    tee -a /etc/dpkg/dpkg.cfg.d/includes && \
  apt-get update && dpkg -l | grep ^ii | cut -d' ' -f3 | \
    xargs apt-get install --yes --no-install-recommends --reinstall && \
  rm -rf /var/lib/apt/lists/*

# install packages
RUN DEBIAN_FRONTEND=noninteractive && \

  # git-lfs
  curl -sSL https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
  echo 'deb https://packagecloud.io/github/git-lfs/ubuntu/ bionic main' | \
    tee /etc/apt/sources.list.d/github_git-lfs.list && \
  echo 'deb-src https://packagecloud.io/github/git-lfs/ubuntu/ bionic main' | \
    tee -a /etc/apt/sources.list.d/github_git-lfs.list && \

  # node 10.x
  curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  echo 'deb https://deb.nodesource.com/node_10.x bionic main' | \
    tee /etc/apt/sources.list.d/nodesource.list && \
  echo 'deb-src https://deb.nodesource.com/node_10.x bionic main' | \
    tee -a /etc/apt/sources.list.d/nodesource.list && \

  apt-get update && \
  apt-get install --yes --no-install-recommends \
    bash-completion \
    bc \
    bsdtar \
    cmake \
    dnsutils \
    dos2unix \
    exiftool \
    gdb \
    git-lfs \
    man \
    mysql-client \
    nodejs \
    perl \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    ruby-full \
    sqlite3 \
    sudo \
    telnet \
    tree \
    wget && \
  git lfs install && \

  # hub
  # http://stackoverflow.com/a/27869453
  mkdir /tmp/hub-linux-amd64 && \
  curl -sSL https://github.com/github/hub/releases/latest | \
    egrep -o '/github/hub/releases/download/.*/hub-linux-amd64-.*.tgz' | \
    wget --base=http://github.com/ -q -i - -O - | \
    tar xz -C /tmp/hub-linux-amd64 --strip-components 1 && \
    /tmp/hub-linux-amd64/install && \
  rm -rf /tmp/hub-linux-amd64 && \

  # python packages
  pip3 install --no-cache-dir \
    awscli && \

  # ruby packages
  gem install --no-update-sources \
    bundler && \

  # node packages
  npm install -g \
    grunt-cli \
    standard && \
  npm cache clean --force && \

  # clear state information
  rm -rf /var/lib/apt/lists/*

# add local user
# create workspace
RUN groupadd --gid 1000 ubuntu && useradd --create-home --uid 1000 --gid ubuntu --groups sudo ubuntu && \
  mkdir /home/ubuntu/workspace && chown ubuntu:ubuntu /home/ubuntu/workspace

# configure system
COPY etc /etc/

# change to non-root user
USER ubuntu

# set working directory
WORKDIR /home/ubuntu/workspace

# default execute login shell
CMD ["bash", "--login"]

