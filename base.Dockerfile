FROM debian:trixie

RUN apt-get update \
# CI pipelines tend to reinstall packages repeatingly, so add tools to check for a local APT cache
&& apt-get install -y -q auto-apt-proxy \
# Fixes timezone issue when python is used
&& DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y -q install tzdata locales \
# Ensure there's proper locale. Undefined locale causes weird issues later on.
&& export LANG=C.UTF-8 && export LC_ALL=C.UTF-8 \
&& update-locale LANG=C.UTF-8 \
&& rm -rf /var/lib/apt/lists/* \
&& mkdir -p /data
WORKDIR /data
ENV LC_ALL=C.UTF-8

RUN \
mkdir ~/.ssh \
&& apt-get update \
&& apt-get install -y -qq --no-install-recommends \
    gpg-agent \
    autoconf \
    autogen \
    bc \
    wget \
    curl \
    rsync \
    unzip \
    zip \
    tar \
    dnsutils \
    jq \
    pv \
    openssh-client \
    git \
    git-lfs \
    build-essential \
    apt-utils \
    # software-properties-common \ # Removed in Debian Trixie due to bugs. Revist if needed?
    libjpeg-dev \
    libdevmapper-dev \
    libpng-dev \
    libc6-dev \
    libgpgme-dev \
    libselinux1-dev \
    iptables \
    imagemagick \
    sqlite3 \
    libreadline-dev \
    openssl \
    libssl-dev \
    libcurl4-openssl-dev \
# Debian moved curl libraries causing older PHP builds to fail. (https://bugs.php.net/bug.php?id=74125) 
&& ln -s /usr/include/$(uname -p)-linux-gnu/curl /usr/include/curl \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

RUN apt-get update \
&& curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
# python and node are basically build tools at this point
&& apt-get install -y nodejs python3.12 python3-yaml \
&& npm install yarn -g \
&& npm cache clean --force \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

ARG YQ_VERSION=v4.53.6
RUN wget -nv -O /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_$(dpkg --print-architecture) \
&& chmod +x /usr/bin/yq
