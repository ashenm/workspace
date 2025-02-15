FROM ashenm/baseimage:developer

LABEL com.docker.image.source.entrypoint="src/latest/Dockerfile"
LABEL org.opencontainers.image.source="https://github.com/ashenm/workspace.git"

# avoid prompts
ARG ACCEPT_EULA=Y
ARG DEBIAN_FRONTEND=noninteractive

# clinch compiler optimisations
ARG CFLAGS="-march=native -mtune=generic"

# expose tcp ports
EXPOSE 8080 8081 8082

# configure environment
ENV NODE_PATH /usr/lib/node_modules
ENV PYTHONDONTWRITEBYTECODE 1

# set up git-lfs repo
# https://packagecloud.io/github/git-lfs/install#manual
RUN mkdir --parent /etc/apt/keyrings && \
  curl --silent --fail --show-error --location 'https://packagecloud.io/github/git-lfs/gpgkey' | \
    gpg --dearmor --output /etc/apt/keyrings/packagecloud.io.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/packagecloud.io.gpg] https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/github-git-lfs.list && \
  echo "deb-src [signed-by=/etc/apt/keyrings/packagecloud.io.gpg] https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release --short --codename) main" | \
    tee --append /etc/apt/sources.list.d/github-git-lfs.list

# set up google cloud repo
# https://cloud.google.com/sdk/docs/install#deb
RUN mkdir --parent /etc/apt/keyrings && \
  curl --silent --fail --show-error --location 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' | \
    gpg --dearmor --output /etc/apt/keyrings/cloud.google.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee /etc/apt/sources.list.d/google-cloud.list

# set up node 22.x repo
# https://github.com/nodesource/distributions/wiki/Repository-Manual-Installation
RUN mkdir --parent /etc/apt/keyrings && \
  curl --silent --fail --show-error --location 'https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key' | \
    gpg --dearmor --output /etc/apt/keyrings/nodesource.com.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.com.gpg] https://deb.nodesource.com/node_22.x nodistro main" | \
    tee /etc/apt/sources.list.d/nodesource.list

# set up terraform repo
# https://www.terraform.io/docs/cli/install/apt.html
RUN mkdir --parent /etc/apt/keyrings && \
  curl --silent --fail --show-error --location 'https://apt.releases.hashicorp.com/gpg' | \
    gpg --dearmor --output /etc/apt/keyrings/hashicorp.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/terraform.list

# set up microsoft repos
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux
RUN apt-get update && \
    apt-get install --yes apt-transport-https ca-certificates && \
    rm --recursive --force /var/lib/apt/lists/* /var/cache/apt/archives/* && \
  mkdir --parent /etc/apt/keyrings && \
  curl --silent --fail --show-error --location 'https://packages.microsoft.com/keys/microsoft.asc' | \
    gpg --dearmor --output /etc/apt/keyrings/microsoft.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/$(lsb_release --short --release)/prod $(lsb_release --short --codename) main" | \
    tee /etc/apt/sources.list.d/microsoft.list && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release --codename --short) main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

# install packages
# deliberately updating apt cache at the end
# facilitating apt-file usage out-of-the-box
RUN add-apt-repository --yes ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install --yes --no-install-recommends \
    apt-file \
    azure-cli \
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
    google-cloud-cli \
    graphviz \
    httpie \
    hub \
    iputils-ping \
    iputils-tracepath \
    jq \
    libarchive-tools \
    mysql-client \
    ncat \
    nodejs \
    openjdk-21-jdk \
    openjdk-21-jre \
    openssh-client \
    parallel \
    perl \
    php \
    php-cli \
    python3-minimal \
    rename \
    rsync \
    sqlite3 \
    sudo \
    telnet \
    terraform \
    time \
    tree \
    universal-ctags \
    valgrind \
    wget \
    whois && \
  git lfs install --system --skip-repo && \
  apt-get update

# install composer
RUN curl --silent --show-error https://getcomposer.org/installer | \
  sudo -H php -- --install-dir=/usr/local/bin --filename=composer

# install ruby 3.1.x
# http://rubies.travis-ci.org/
RUN curl --silent --fail --show-error \
    --location "https://s3.amazonaws.com/travis-rubies/binaries/ubuntu/$(lsb_release --short --release)/$(uname --machine)/ruby-3.2.5.tar.bz2" | \
  tar --extract --bzip2 --verbose --directory /usr/local --file - --strip-components 1

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
    black \
    blockdiag \
    cairosvg \
    icdiff \
    PyYAML \
    requests \
    termcolor

# install ruby packages
# https://github.com/asciidoctor/asciidoctor-mathematical#ubuntu
RUN apt-get install --yes --no-install-recommends \
    bison \
    cmake \
    flex \
    fonts-lyx \
    libcairo2-dev \
    libffi-dev \
    libgdk-pixbuf2.0-dev \
    libpango1.0-dev \
    libxml2-dev && \
  gem update --system --no-document --no-update-sources && \
  gem install --force --no-document --no-update-sources \
    asciidoctor \
    asciidoctor-diagram \
    asciidoctor-mathematical \
    jekyll \
    mathematical \
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

# configure goenv
RUN git clone --depth 1 https://github.com/go-nv/goenv.git /opt/goenv && \
  chown --recursive 0:1000 /opt/goenv && \
  chmod --recursive g=u /opt/goenv

# configure pyenv
RUN apt-get install --yes --no-install-recommends \
    build-essential \
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    tk-dev \
    xz-utils \
    zlib1g-dev && \
  git clone --depth 1 https://github.com/pyenv/pyenv.git /opt/pyenv && \
  chown --recursive 0:1000 /opt/pyenv && \
  chmod --recursive g=u /opt/pyenv

# configure tfenv
RUN git clone --depth 1 https://github.com/tfutils/tfenv.git /opt/tfenv && \
  mkdir --parent /opt/tfenv/versions/system && \
  echo 'system' | tee /opt/tfenv/version && \
  chown --recursive 0:1000 /opt/tfenv && \
  chmod --recursive g=u /opt/tfenv && \
  ln --symbolic /usr/bin/terraform /opt/tfenv/versions/system/terraform

# configure ssh client
RUN echo '' | tee --append /etc/ssh/ssh_config && \
  echo 'Include /etc/ssh/workspace' | tee --append /etc/ssh/ssh_config && \
  mkdir --parent --mode 770 /opt/ssh && \
  touch /opt/ssh/known_hosts && \
  chown --recursive 0:1000 /opt/ssh && \
  chmod 660 /opt/ssh/known_hosts

# install aws cli
RUN mkdir --parent /tmp/aws-cli && \
  curl --silent --fail --show-error --output "/tmp/aws-cli/awscli.zip" "https://awscli.amazonaws.com/awscli-exe-linux-$(uname --machine).zip" && \
  unzip -d /tmp/aws-cli /tmp/aws-cli/awscli.zip && \
  /tmp/aws-cli/aws/install --install-dir /opt/aws/cli && \
  rm --recursive --force /tmp/aws-cli

# install k8 utilities
RUN curl --silent --fail --show-error --location --output "/usr/local/bin/kubectl" \
    --url "https://dl.k8s.io/release/$(curl --silent --fail --location https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" && \
  curl --silent --fail --show-error --location --output - \
    --url "https://get.helm.sh/helm-$(curl --silent --fail --location https://get.helm.sh/helm-latest-version)-linux-$(dpkg --print-architecture).tar.gz" | \
  tar --extract --gunzip --verbose --wildcards --directory /usr/local/bin --file - --strip-components 1 '**/helm' && \
  chmod 755 /usr/local/bin/kubectl /usr/local/bin/helm

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
