ARG BASEIMAGE=ashenm/workspace:latest

FROM ${BASEIMAGE}

# install cs143 requisit packages
RUN sudo apt update && \
  sudo apt install --yes \
    flex \
    bison \
    build-essential \
    csh \
    openjdk-8-jdk \
    spim \
    libxaw7-dev

# inject distribution files
RUN sudo mkdir --parents --mode 755 /opt/stanford/cs143 && \
  sudo wget --quiet --recursive --show-progress --no-parent --no-host-directories --cut-dirs 3 --directory-prefix /opt/stanford/cs143 \
    --reject "index.html*,spim" 'https://theory.stanford.edu/~aiken/software/cooldist/' 'https://theory.stanford.edu/~aiken/software/cooldist/bin/.i686/' && \
  sudo make --directory /opt/stanford/cs143 install COOL_DIR="/opt/stanford/cs143" BINARIES="aps2c++ coolc xspim" ARCH="echo i686" && \
  sudo find /opt/stanford/cs143/bin -type f -exec chmod 755 {} \; && \
  sudo sed --in-place --regexp-extended 's/^PATH="?([^\"]+)"?$/PATH="\/opt\/stanford\/cs143\/bin\:\1"/' /etc/environment

ENV PATH /opt/stanford/cs143/bin:$PATH
