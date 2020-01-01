FROM ashenm/workspace:latest

# install cs143 requisit packages
RUN sudo apt update && \
  sudo apt install --yes \
    flex \
    bison \
    build-essential \
    csh \
    openjdk-8-jdk \
    libxaw7-dev

# inject distribution files
RUN sudo mkdir --parents --mode 755 /opt/stanford/cs143 && \
  sudo wget --recursive --no-parent --no-host-directories --cut-dirs 3 --directory-prefix /opt/stanford/cs143 \
    --reject "index.html*" 'https://theory.stanford.edu/~aiken/software/cooldist/' && \
  sudo sed --in-place --regexp-extended 's/^PATH="?([^\"]+)"?$/PATH="\/opt\/stanford\/cs143\/bin\:\1"/' /etc/environment

ENV PATH /opt/stanford/cs143/bin:$PATH
