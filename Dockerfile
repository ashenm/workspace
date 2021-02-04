FROM ashenm/workspace:latest

# expose tcp ports
EXPOSE 3333

# extend system-wide npmrc
RUN printf '\
; Railsbank NPM Package Registry\n\
@railsbank-tech:registry=https://gitlab.com/api/v4/packages/npm/\n' | \
sudo tee --append /etc/npmrc 1> /dev/null

# install packages
RUN sudo -H npm install --global \
  jest \
  nx \
  prettier \
  typescript \
  ts-node \
  @nestjs/cli
