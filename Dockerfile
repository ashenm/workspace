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
RUN curl --silent --fail --show-error --location 'https://packagecloud.io/github/git-lfs/gpgkey' | apt-key add - && \
  echo "deb https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/github_git-lfs.list && \
  echo "deb-src https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release --short --codename) main" | \
    tee --append /etc/apt/sources.list.d/github_git-lfs.list

# set up node 12.x repo
# https://github.com/nodesource/distributions#debmanual
RUN curl --silent --fail --show-error --location 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | apt-key add - && \
  echo "deb https://deb.nodesource.com/node_12.x $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/nodesource.list && \
  echo "deb-src https://deb.nodesource.com/node_12.x $(lsb_release --short --codename) main" | \
    tee --append /etc/apt/sources.list.d/nodesource.list

# install packages
# deliberately updating apt cache at the end
# facilitating apt-file usage out-of-the-box
RUN apt-get update && \
  apt-get install --yes --no-install-recommends \
    apt-file \
    bash-completion \
    bc \
    bison \
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
    libarchive-tools \
    mysql-client \
    nodejs \
    openssh-client \
    perl \
    php \
    php-cli \
    python2-minimal \
    python3-minimal \
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

# install composer
RUN curl --silent --show-error https://getcomposer.org/installer | \
  sudo -H php -- --install-dir=/usr/local/bin --filename=composer

# install python 2.7.x
RUN curl --silent --fail --show-error \
    --location "https://s3.amazonaws.com/travis-python-archives/binaries/ubuntu/$(lsb_release --short --release)/$(uname --machine)/python-2.7.18.tar.bz2" | \
  bsdtar --extract --directory / --file - opt/
ENV PATH /opt/python/2.7/bin:$PATH

# install python 3.8.x
RUN curl --silent --fail --show-error \
    --location "https://s3.amazonaws.com/travis-python-archives/binaries/ubuntu/$(lsb_release --short --release)/$(uname --machine)/python-3.8.5.tar.bz2" | \
  bsdtar --extract --directory / --file - opt/
ENV PATH /opt/python/3.8/bin:$PATH

# install ruby 2.7.x
# http://rubies.travis-ci.org/
RUN curl --silent --fail --show-error \
    --location "https://s3.amazonaws.com/travis-rubies/binaries/ubuntu/$(lsb_release --short --release)/$(uname --machine)/ruby-2.7.1.tar.bz2" | \
  tar --bzip --extract --file - --strip-components 1 --directory /usr/local

# install openjdk
# https://openjdk.java.net/install/
RUN mkdir --parent /opt/openjdk && \
  curl --silent --show-error --location 'https://jdk.java.net/15/' | \
    egrep --only-matching --max-count 1 '/java/GA/.*/openjdk-.*_linux-x64_bin.tar.gz' | \
    wget --quiet --base=https://download.java.net/ --input-file - --output-document - | \
    tar --gzip --extract --strip-components 1 --file - --directory /opt/openjdk
ENV PATH /opt/openjdk/bin:$PATH

# install hub
# http://stackoverflow.com/a/27869453
RUN mkdir /tmp/hub-linux-amd64 && \
  curl --silent --show-error --location 'https://github.com/github/hub/releases/latest' | \
    egrep --only-matching --max-count=1 '/github/hub/releases/download/.*/hub-linux-amd64-.*.tgz' | \
    wget --quiet --base=https://github.com/ --input-file - --output-document - | \
    tar --gzip --extract --strip-components 1 --file - --directory /tmp/hub-linux-amd64 && \
    /tmp/hub-linux-amd64/install && \
  rm --recursive --force /tmp/hub-linux-amd64

# install java packages
RUN mkdir --parents /usr/local/share/java && \
  curl --silent --fail --show-error --location 'https://sourceforge.net/projects/ditaa/files/latest/download' | \
    bsdtar -xf - -s '/ditaa.*\.jar/ditaa.jar/' --directory /usr/local/share/java '*.jar' && \
  curl --silent --fail --show-error --location --output /usr/local/share/java/plantuml.jar 'http://sourceforge.net/projects/plantuml/files/plantuml.jar/download' && \
  curl --silent --fail --show-error --location --output - 'https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.9/SaxonHE9-9-1-6J.zip' | \
    bsdtar -xf - -s '/saxon.*\.jar/saxon.jar/' --directory /usr/local/share/java 'saxon9he.jar'
ENV CLASSPATH /usr/local/share/java/plantuml.jar:/usr/local/share/java/saxon.jar

# install python packages
RUN python3 -m pip install --upgrade --no-cache-dir \
    pip \
    setuptools \
    wheel && \
  python3 -m pip install --upgrade --no-cache-dir --ignore-installed \
    awscli \
    cairosvg \
    blockdiag \
    icdiff \
    PyYAML \
    requests \
    termcolor

# install ruby packages
# https://github.com/asciidoctor/asciidoctor-mathematical#ubuntu
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
    jekyll \
    pygments.rb \
    travis && \
  gem install --pre --no-document --no-update-sources \
    asciidoctor-pdf

# install node packages
RUN npm install --global \
    eslint \
    eslint-plugin-html \
    heroku \
    nodemon && \
  npm install --global --unsafe-perm \
    ngrok && \
  rm --recursive --force $HOME/.ngrok && \
  npm cache clean --force

# configure ssh client
RUN echo '' | tee --append /etc/ssh/ssh_config && \
  echo 'Include /etc/ssh/workspace' | tee --append /etc/ssh/ssh_config && \
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
