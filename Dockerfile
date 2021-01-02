FROM ashenm/workspace:latest

# install packages
RUN sudo -H npm install --global \
  nx \
  typescript \
  @nestjs/cli
