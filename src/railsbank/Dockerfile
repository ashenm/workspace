FROM ashenm/workspace:latest

# avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# expose tcp ports
EXPOSE 3333

# set up terraform repo
# https://www.terraform.io/docs/cli/install/apt.html
RUN curl --silent --fail --show-error --location 'https://apt.releases.hashicorp.com/gpg' | sudo --set-home apt-key add - && \
  echo "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release --short --codename) main" | \
    sudo --set-home tee /etc/apt/sources.list.d/terraform.list

# extend system-wide npmrc
RUN printf '; Railsbank NPM Package Registry\n\
@railsbank-tech:registry=https://gitlab.com/api/v4/packages/npm/\n\n' | \
sudo tee --append /etc/npmrc 1> /dev/null

# install packages
RUN sudo --set-home apt-get update && \
  sudo --set-home apt-get install --yes --no-install-recommends \
    terraform

# install node packages
RUN sudo --set-home npm install --global \
    jest \
    nx \
    prettier \
    typescript \
    ts-node \
    @nestjs/cli && \
  sudo --set-home npm cache clean --force

# configure git hooks
RUN printf '[include]\n\
    path = /etc/git/railsbank.gitconfig\n\n' | \
sudo tee --append /etc/gitconfig

# configure system
COPY filesystem /
