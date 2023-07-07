FROM ubuntu:22.04
# Install English locale
RUN apt-get update && apt-get install -y -q --no-install-recommends language-pack-en-base \
&& rm -rf /var/lib/apt/lists/* \
&& mkdir -p /data
WORKDIR /data
ENV LC_ALL en_US.UTF-8

ARG YQ_VERSION=v4.34.1

RUN \
mkdir ~/.ssh \
&& apt-get update \
&& apt-get install -y -qq --no-install-recommends \
    gpg-agent \
    autoconf \
    autogen \
    wget \
    curl \
    rsync \
    unzip \
    zip \ 
    tar \
    dnsutils \
    unrar \
    jq \
    pv \
    openssh-client \
    git \
    build-essential \
    apt-utils \
    software-properties-common \
    libjpeg-dev \
    libdevmapper-dev \
    libpng-dev \
    libc6-dev \
    libgpgme-dev \
    libselinux1-dev \
    iptables \
    imagemagick \
    libssl-dev \
    openssl \
    libreadline-dev \
    libssl-dev \
    libcurl4-openssl-dev \
# Debian moved curl libraries causing older PHP builds to fail. (https://bugs.php.net/bug.php?id=74125) 
&& ln -s /usr/include/x86_64-linux-gnu/curl /usr/include/curl \
&& wget -nv -O /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_386 \
&& chmod +x /usr/bin/yq \
&& curl -sL https://deb.nodesource.com/setup_10.x | bash - \
# python and node are basically build tools at this point
&& apt-get install -y nodejs python3.11  \
&& npm install yarn -g \
&& npm cache clean --force \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

