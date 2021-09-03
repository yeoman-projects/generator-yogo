FROM ubuntu:latest

RUN apt-get -yq update \
  && apt-get -yq upgrade \
  && apt-get -yq install curl sudo gnupg \
  && curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
  && apt-get -yq install nodejs

RUN npm install -g --silent yo

RUN mkdir -p /generator-yogo
COPY . /generator-yogo/

# Add yeoman user
RUN adduser --disabled-password --gecos "" yeoman \
  && echo "yeoman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV HOME /home/yeoman
USER yeoman

RUN cd  \
  && sudo chown -R yeoman:yeoman /generator-yogo \
  && cd /generator-yogo \ 
  && npm install \
  && sudo npm link

WORKDIR /home/yeoman
VOLUME ["/home/yeoman"]

# Expose the port
EXPOSE 9000
CMD ["/bin/bash"]FROM ghcr.io/container-projects/base-docker-images:node-12-npm-yo-git-latest
RUN npm i -g "git://github.com/yeoman-projects/generator-yogo.git#main"
 
RUN \
  # configure the "jhipster" user
  groupadd jhipster && \
  useradd jhipster -s /bin/bash -m -g jhipster -G sudo && \
  echo jhipster:jhipster |chpasswd 
RUN mkdir /home/jhipster/app
USER jhipster
ENV PATH $PATH:/usr/bin
WORKDIR "/home/jhipster/app"
VOLUME ["/home/jhipster/app"]
CMD ["yo"]
