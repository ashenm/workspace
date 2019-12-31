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
  curl --silent --location --fail --output - --url 'https://s3-us-west-1.amazonaws.com/prod-edx/Compilers/Misc/student-dist.tar.gz' | \
    sudo tar --gzip --extract --file - --directory /opt/stanford/cs143 && \
  sudo sed --in-place --regexp-extended 's/^PATH="?([^\"]+)"?$/PATH="\/opt\/stanford\/cs143\/bin\:\1"/' /etc/environment

ENV PATH /opt/stanford/cs143/bin:$PATH
