FROM ubuntu:20.04

WORKDIR /tmp

# install basic tools
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/Berlin"
RUN \
  apt-get update && \
  apt-get install --yes git wget xz-utils && \
  apt-get clean

# install docker cli
ENV DOCKER_VERSION="20.10.2"
RUN \
  wget -q https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz && \
  sha1sum docker-$DOCKER_VERSION.tgz && \
  echo "75713453622aafcd9baf5ca17ae3c3c8c126c700  docker-$DOCKER_VERSION.tgz" | sha1sum -c - && \
  tar xf docker-$DOCKER_VERSION.tgz && \
  mv docker /opt/docker && \
  ln -s /opt/docker/docker /usr/bin/docker && \
  rm docker-$DOCKER_VERSION.tgz

# install git-describe-semver
ENV GIT_DESCRIBE_SEMVER_VERSION="0.2.4"
RUN \
  wget -q https://github.com/choffmeister/git-describe-semver/releases/download/v$GIT_DESCRIBE_SEMVER_VERSION/git-describe-semver-linux-amd64 && \
  sha1sum git-describe-semver-linux-amd64 && \
  echo "a1056bc9b410ba22c926a17ab14795cac4389588  git-describe-semver-linux-amd64" | sha1sum -c - && \
  mkdir /opt/git-describe-semver && \
  mv git-describe-semver-linux-amd64 /opt/git-describe-semver && \
  chmod +x /opt/git-describe-semver/git-describe-semver-linux-amd64 && \
  ln -s /opt/git-describe-semver/git-describe-semver-linux-amd64 /usr/bin/git-describe-semver

# install openjdk, scala, sbt
ENV SCALA_VERSION="2.13.4"
ENV SBT_VERSION="1.4.6"
RUN \
  apt-get update && \
  apt-get install --yes openjdk-8-jdk && \
  apt-get clean
RUN \
  wget -q http://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
  sha1sum scala-$SCALA_VERSION.tgz && \
  echo "28e3c52d9a02345db0764dff26e941a1aaeae67d  scala-$SCALA_VERSION.tgz" | sha1sum -c - && \
  tar xf scala-$SCALA_VERSION.tgz && \
  mv scala-$SCALA_VERSION /opt/scala && \
  rm scala-$SCALA_VERSION.tgz
ENV PATH="/opt/scala/bin:$PATH"
RUN \
  wget -q https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz && \
  sha1sum sbt-$SBT_VERSION.tgz && \
  echo "1a15ce3922854f64fd5d5828e753d8f57b32f9c9  sbt-$SBT_VERSION.tgz" | sha1sum -c - && \
  tar xf sbt-$SBT_VERSION.tgz && \
  mv sbt /opt/sbt && \
  rm sbt-$SBT_VERSION.tgz
ENV PATH="/opt/sbt/bin:$PATH"
RUN \
  mkdir project && \
  echo "sbt.version=$SBT_VERSION" > project/build.properties && sbt sbtVersion && \
  rm -rf project

# install nodejs, npm, yarn
ENV NODE_VERSION="14.15.4"
RUN \
  wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz && \
  sha1sum node-v$NODE_VERSION-linux-x64.tar.xz && \
  echo "5fbdfbfdac4454e458c9ab005b6c693794116143  node-v$NODE_VERSION-linux-x64.tar.xz" | sha1sum -c - && \
  tar xf node-v$NODE_VERSION-linux-x64.tar.xz && \
  mv node-v$NODE_VERSION-linux-x64 /opt/node && \
  rm node-v$NODE_VERSION-linux-x64.tar.xz
ENV PATH="/opt/node/bin:$PATH"
RUN \
  npm install -g yarn

WORKDIR /workspace
