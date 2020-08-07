FROM ashenm/baseimage:developer

# avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# clinch compiler optimisations
ARG CFLAGS="-march=x86-64 -mtune=x86-64"

# expose tcp ports
EXPOSE 8080 8081 8082

# configure environment
ENV NODE_PATH /usr/lib/node_modules

# set up git-lfs repo
# https://packagecloud.io/github/git-lfs/install#manual
RUN curl -sSL https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
  echo "deb https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/github_git-lfs.list && \
  echo "deb-src https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release --short --codename) main" | \
    tee -a /etc/apt/sources.list.d/github_git-lfs.list

# set up node 12.x repo
# https://github.com/nodesource/distributions#debmanual
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  echo "deb https://deb.nodesource.com/node_12.x $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/nodesource.list && \
  echo "deb-src https://deb.nodesource.com/node_12.x $(lsb_release --short --codename) main" | \
    tee -a /etc/apt/sources.list.d/nodesource.list

# set up ruby 2.7.x
# http://rubies.travis-ci.org/
RUN apt-get update && \
  apt-get install --yes --no-install-recommends \
    libyaml-0-2 && \
  curl -sSL https://s3.amazonaws.com/travis-rubies/binaries/ubuntu/18.04/x86_64/ruby-2.7.0.tar.bz2 | \
    tar --bzip --extract --file - --strip-components 1 --directory /usr/local && \
  rm -rf /var/lib/apt/lists/*

# install packages
# deliberately updating apt cache at the end
# facilitating apt-file usage out-of-the-box
RUN apt-get update && \
  apt-get install --yes --no-install-recommends \
    apt-file \
    bash-completion \
    bc \
    bison \
    bsdtar \
    cmake \
    dnsutils \
    dos2unix \
    exiftool \
    file \
    flex \
    gdb \
    git-lfs \
    golang-go \
    graphviz \
    iputils-ping \
    iputils-tracepath \
    jq \
    mysql-client \
    nodejs \
    openssh-client \
    perl \
    python \
    python-pip \
    python-setuptools \
    python-wheel \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    rename \
    rsync \
    sqlite3 \
    sudo \
    telnet \
    time \
    tree \
    valgrind \
    wget \
    whois && \
  git lfs install --system --skip-repo && \
  apt update

# install openjdk
# https://openjdk.java.net/install/
RUN mkdir --parent /opt/openjdk && \
  curl --silent --fail --output - https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz | \
    tar --gzip --extract --strip-components 1 --file - --directory /opt/openjdk
ENV PATH /opt/openjdk/bin:$PATH

# install hub
# http://stackoverflow.com/a/27869453
RUN mkdir /tmp/hub-linux-amd64 && \
  curl -sSL https://github.com/github/hub/releases/latest | \
    egrep -o '/github/hub/releases/download/.*/hub-linux-amd64-.*.tgz' | \
    wget --base=http://github.com/ -q -i - -O - | \
    tar xz -C /tmp/hub-linux-amd64 --strip-components 1 && \
    /tmp/hub-linux-amd64/install && \
  rm -rf /tmp/hub-linux-amd64

# install java packages
RUN mkdir --parents /usr/local/share/java && \
  curl --fail --location https://sourceforge.net/projects/ditaa/files/latest/download | \
    bsdtar -xf - -s '/ditaa.*\.jar/ditaa.jar/' -C /usr/local/share/java '*.jar' && \
  curl --fail --location --output /usr/local/share/java/plantuml.jar http://sourceforge.net/projects/plantuml/files/plantuml.jar/download && \
  curl --fail --location --output - https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.9/SaxonHE9-9-1-6J.zip | \
    bsdtar -xf - -s '/saxon.*\.jar/saxon.jar/' -C /usr/local/share/java 'saxon9he.jar'
ENV CLASSPATH /usr/local/share/java/plantuml.jar:/usr/local/share/java/saxon.jar

# install python packages
RUN pip3 install --no-cache-dir \
    awscli \
    cairosvg \
    blockdiag \
    icdiff

# install ruby packages
RUN apt-get install --yes --no-install-recommends \
    fonts-lyx \
    libcairo2-dev \
    libffi-dev \
    libgdk-pixbuf2.0-dev \
    libpango1.0-dev \
    libxml2-dev && \
  gem install --force --no-document --no-update-sources \
    asciidoctor \
    asciidoctor-diagram \
    asciidoctor-mathematical \
    bundler \
    jekyll \
    pygments.rb \
    travis && \
  gem install --pre --no-document --no-update-sources \
    asciidoctor-pdf

# install node packages
RUN npm install --global \
    eslint \
    eslint-plugin-html \
    nodemon && \
  npm cache clean --force

# configure ssh client
RUN echo '' | tee -a /etc/ssh/ssh_config && \
  echo 'Include /etc/ssh/workspace' | tee -a /etc/ssh/ssh_config && \
  mkdir --parent --mode 770 /opt/ssh && \
  touch /opt/ssh/known_hosts && \
  chown --recursive 0:1000 /opt/ssh && \
  chmod 660 /opt/ssh/known_hosts

# configure system
COPY filesystem /

# configure workspace
RUN groupadd --gid 1000 ubuntu && useradd --create-home --uid 1000 --gid ubuntu --groups sudo ubuntu --shell /bin/bash && \
  mkdir --mode 700 /home/ubuntu/workspace && chown ubuntu:ubuntu /home/ubuntu/workspace

# change to non-root user
USER ubuntu

# set working directory
WORKDIR /home/ubuntu/workspace

# default execute login shell
CMD ["/usr/local/sbin/workspace"]
