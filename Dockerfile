FROM ashenm/workspace:latest

# install packages
RUN sudo -H npm install --global \
  nx \
  typescript \
  ts-node \
  @nestjs/cli
