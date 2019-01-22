FROM ashenm/baseimage

# expose tcp ports
EXPOSE 8080 8081 8082

# add local user
# allow sudo group to su without password
# create workspace
RUN groupadd --gid 1000 ubuntu && useradd --create-home --uid 1000 --gid ubuntu --groups sudo ubuntu && \
  sed -i $(grep -n '^auth' /etc/pam.d/su | tail -1 | sed 's/:.*$//')'a\\n# This allows sudo group to su without passwords\nauth sufficient pam_wheel.so trust group=sudo' /etc/pam.d/su && \
  mkdir /home/ubuntu/workspace && chown ubuntu:ubuntu /home/ubuntu/workspace

# install packages
RUN DEBIAN_FRONTEND=noninteractive && \

  # git-lfs
  curl -sSL https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
  echo "deb https://packagecloud.io/github/git-lfs/ubuntu/ bionic main" | \
    tee /etc/apt/sources.list.d/github_git-lfs.list && \
  echo "deb-src https://packagecloud.io/github/git-lfs/ubuntu/ bionic main" | \
    tee -a /etc/apt/sources.list.d/github_git-lfs.list && \

  # node 10.x
  curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  echo "deb https://deb.nodesource.com/node_10.x bionic main" | \
    tee /etc/apt/sources.list.d/nodesource.list && \
  echo "deb-src https://deb.nodesource.com/node_10.x bionic main" | \
    tee -a /etc/apt/sources.list.d/nodesource.list && \

  apt-get update && \
  apt-get install -y \
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
    ruby-full \
    sqlite3 \
    telnet \
    tree \
    wget && \
  git lfs install && \

  # hub
  # http://stackoverflow.com/a/27869453
  mkdir /tmp/hub-linux-amd64 && \
  curl -s -L https://github.com/github/hub/releases/latest | \
    egrep -o '/github/hub/releases/download/.*/hub-linux-amd64-.*.tgz' | \
    wget --base=http://github.com/ -i - -O - | \
    tar xvz -C /tmp/hub-linux-amd64 --strip-components 1 && \
    /tmp/hub-linux-amd64/install && \
  rm -rf /tmp/hub-linux-amd64 && \

  # node packages
  npm install -g \
    grunt-cli \
    standard && \

  # python packages
  pip3 install \
    awscli && \

  # ruby packages
  gem install \
    bundler && \

  # clear state information
  rm -rf /var/lib/apt/lists/*

# configure system
COPY etc /etc/

# change to non-root user
USER ubuntu

# set working directory
WORKDIR /home/ubuntu/workspace

# default execute login shell
CMD ["bash", "--login"]
