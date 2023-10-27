FROM ashenm/baseimage:developer

# avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# clinch compiler optimisations
ARG CFLAGS="-march=native -mtune=generic"

# expose tcp ports
EXPOSE 8080 8081 8082

# configure environment
ENV NODE_PATH /usr/lib/node_modules

# set up git-lfs repo
# https://packagecloud.io/github/git-lfs/install#manual
RUN curl --silent --fail --show-error --location 'https://packagecloud.io/github/git-lfs/gpgkey' | \
    apt-key --keyring /usr/share/keyrings/packagecloud.io.gpg add - && \
  echo "deb [signed-by=/usr/share/keyrings/packagecloud.io.gpg] https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/github-git-lfs.list && \
  echo "deb-src [signed-by=/usr/share/keyrings/packagecloud.io.gpg] https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release --short --codename) main" | \
    tee --append /etc/apt/sources.list.d/github-git-lfs.list

# set up google cloud repo
# https://cloud.google.com/sdk/docs/install#deb
RUN curl --silent --fail --show-error --location 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee /etc/apt/sources.list.d/google-cloud.list

# set up node 16.x repo
# https://github.com/nodesource/distributions#debmanual
RUN curl --silent --fail --show-error --location 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | \
    apt-key --keyring /usr/share/keyrings/nodesource.com.gpg add - && \
  echo "deb [signed-by=/usr/share/keyrings/nodesource.com.gpg] https://deb.nodesource.com/node_18.x $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/nodesource.list && \
  echo "deb-src [signed-by=/usr/share/keyrings/nodesource.com.gpg] https://deb.nodesource.com/node_18.x $(lsb_release --short --codename) main" | \
    tee --append /etc/apt/sources.list.d/nodesource.list

# set up terraform repo
# https://www.terraform.io/docs/cli/install/apt.html
RUN curl --silent --fail --show-error --location 'https://apt.releases.hashicorp.com/gpg' | apt-key add - && \
  echo "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/terraform.list

# set up azure cli repo
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux
RUN curl --silent --fail --show-error --location 'https://packages.microsoft.com/keys/microsoft.asc' | \
    gpg --dearmor | apt-key --keyring /usr/share/keyrings/microsoft.gpg add - && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release --codename --short) main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

# set up liquibase repo
RUN curl --silent --fail --show-error --location 'https://repo.liquibase.com/liquibase.asc' | \
    gpg --dearmor | apt-key --keyring /usr/share/keyrings/liquibase.gpg add - && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/liquibase.gpg] https://repo.liquibase.com stable main" | \
    tee /etc/apt/sources.list.d/liquibase.list

# install packages
# deliberately updating apt cache at the end
# facilitating apt-file usage out-of-the-box
RUN apt-get update && \
  apt-get install --yes --no-install-recommends \
    apt-file \
    azure-cli \
    bash-completion \
    bc \
    bison \
    cmake \
    ctags \
    dnsutils \
    dos2unix \
    exiftool \
    file \
    flex \
    gdb \
    git-lfs \
    golang-go \
    google-cloud-cli \
    graphviz \
    httpie \
    hub \
    iputils-ping \
    iputils-tracepath \
    jq \
    libarchive-tools \
    liquibase \
    mysql-client \
    nodejs \
    netcat \
    openssh-client \
    parallel \
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
    terraform \
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

# install python 3.11.x
RUN curl --silent --fail --show-error \
    --location "https://s3.amazonaws.com/travis-python-archives/binaries/ubuntu/$(lsb_release --short --release)/$(uname --machine)/python-3.11.0.tar.bz2" | \
  bsdtar --extract --directory / --file - opt/
ENV PATH /opt/python/3.11/bin:$PATH

# install ruby 3.1.x
# http://rubies.travis-ci.org/
RUN curl --silent --fail --show-error \
    --location "https://s3.amazonaws.com/travis-rubies/binaries/ubuntu/$(lsb_release --short --release)/$(uname --machine)/ruby-3.1.2.tar.bz2" | \
  tar --bzip --extract --file - --strip-components 1 --directory /usr/local

# install openjdk
# https://openjdk.java.net/install/
RUN mkdir --parent /opt/openjdk && \
  curl --silent --show-error --location "https://jdk.java.net/21/" | \
    egrep --only-matching --max-count 1 "/java/GA/.*/openjdk-.*_linux-$(uname --machine | sed 's/86_//')_bin.tar.gz" | \
    wget --quiet --base=https://download.java.net/ --input-file - --output-document - | \
    tar --gzip --extract --strip-components 1 --file - --directory /opt/openjdk
ENV PATH /opt/openjdk/bin:$PATH

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
    black \
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
  gem update --system --no-document --no-update-sources && \
  gem install --force --no-document --no-update-sources \
    mathematical:1.6.14 # https://github.com/asciidoctor/asciidoctor-mathematical/issues/122 && \
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
    artillery \
    eslint \
    eslint-plugin-html \
    heroku \
    jest \
    nodemon \
    prettier \
    ts-node \
    typescript && \
  npm install --global --unsafe-perm \
    ngrok && \
  rm --recursive --force $HOME/.ngrok && \
  npm cache clean --force

# configure nvm
RUN mkdir --parent --mode 0700 /etc/skel/.nvm && \
  curl --silent --fail --show-error \
    --output "/etc/skel/.nvm/nvm-exec" \
    --location "https://raw.githubusercontent.com/nvm-sh/nvm/master/nvm-exec" && \
  curl --silent --fail --show-error \
    --output "/etc/skel/.nvm/nvm.sh" \
    --location "https://raw.githubusercontent.com/nvm-sh/nvm/master/nvm.sh" && \
  chmod 0700 /etc/skel/.nvm/nvm-exec /etc/skel/.nvm/nvm.sh && \
  cp --recursive --force /etc/skel/.nvm /root && \
  printf '\nsource $HOME/.nvm/nvm.sh\n' | \
    tee --append /etc/skel/.bashrc /root/.bashrc

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
