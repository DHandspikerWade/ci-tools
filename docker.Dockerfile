ARG BASE_IMAGE="handspiker2/ci-tools:base"
FROM ${BASE_IMAGE}

RUN echo "Installing credentials store" \ 
&& apt-get update \
&& apt-get install -y -qq --no-install-recommends pass \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

RUN echo "Installing buildah and skopeo" \
&& apt-get update \
&& apt-get -y install --no-install-recommends uidmap buildah skopeo \
&& buildah version \
&& skopeo -v \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

RUN echo "Installing kubectl" \
&& curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl \
&& chmod +x ./kubectl \
&& mv ./kubectl /usr/local/bin/kubectl \
&& kubectl --help

ARG DOCKER_VERSION=28.0.1
RUN echo "Installing docker CLI" \
&& wget -nv -O /tmp/docker.tgz https://download.docker.com/linux/static/stable/$(uname -m)/docker-${DOCKER_VERSION}.tgz \
&& cd /tmp \
&& tar -xzvf docker.tgz \
&& cp docker/* /usr/bin/ \
&& docker -v 
