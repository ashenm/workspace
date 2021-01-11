FROM ashenm/workspace:latest

# install packages
RUN sudo -H npm install --global \
  jest \
  nx \
  typescript \
  ts-node \
  @nestjs/cli
