FROM ubuntu:18.04
# Install English locale
RUN apt-get update && apt-get install -y -q --no-install-recommends language-pack-en-base && rm -rf /var/lib/apt/lists/*
ENV LC_ALL en_US.UTF-8

ARG YQ_VERSION=2.4.0

RUN \
mkdir ~/.ssh \
apt-get update \
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
    libpng-dev \
    imagemagick \
    libssl-dev \
    openssl \
    libreadline-dev \
    libssl-dev \
    libcurl4-openssl-dev \

&& wget -nv -O /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_386 \
&& chmod +x /usr/bin/yq \
&& curl -sL https://deb.nodesource.com/setup_10.x | bash - \

# python and node are basically build tools at this point
&& apt-get install -y nodejs python3.6  \
&& npm install yarn -g \
&& npm cache clean --force\
&& rm -rf /var/lib/apt/lists/*

