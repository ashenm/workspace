ARG BASEIMAGE=ashenm/workspace:latest

FROM ${BASEIMAGE}

LABEL com.docker.image.source.entrypoint="src/railsbank/Dockerfile"
LABEL org.opencontainers.image.source="https://github.com/ashenm/workspace.git"

# avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# expose tcp ports
EXPOSE 3333

# extend system-wide npmrc
RUN printf '; Railsbank NPM Package Registry\n\
@railsbank-tech:registry=https://gitlab.com/api/v4/packages/npm/\n\n' | \
sudo tee --append /etc/npmrc 1> /dev/null

# install node packages
RUN sudo --set-home npm install --global \
    nx \
    @nestjs/cli && \
  sudo --set-home npm cache clean --force

# configure git hooks
RUN printf '[include]\n\
    path = /etc/git/railsbank.gitconfig\n\n' | \
sudo tee --append /etc/gitconfig

# configure system
COPY filesystem /
