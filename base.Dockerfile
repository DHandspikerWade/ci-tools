FROM ubuntu:24.04
# Install English locale
RUN apt-get update && apt-get install -y -q --no-install-recommends language-pack-en-base \
# Fixes timezone issue when python is used
&& DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -yq install tzdata \
&& rm -rf /var/lib/apt/lists/* \
&& mkdir -p /data
WORKDIR /data
ENV LC_ALL=en_US.UTF-8

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
    git-lfs \
    build-essential \
    apt-utils \
    software-properties-common \
    libjpeg-dev \
    libpng-dev \
    imagemagick \
    sqlite3 \
    libreadline-dev \
    libssl-dev \
# Debian moved curl libraries causing older PHP builds to fail. (https://bugs.php.net/bug.php?id=74125) 
&& ln -s /usr/include/$(uname -p)-linux-gnu/curl /usr/include/curl \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

RUN apt-get update \
&& curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
# python and node are basically build tools at this point
&& apt-get install -y nodejs python3.12  \
&& npm install yarn -g \
&& npm cache clean --force \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

ARG YQ_VERSION=v4.45.1
RUN wget -nv -O /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_$(dpkg --print-architecture) \
&& chmod +x /usr/bin/yq
