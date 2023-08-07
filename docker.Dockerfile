FROM handspiker2/ci-tools:base

ARG DOCKER_VERSION=24.0.3
RUN echo "Installing docker CLI" \
&& wget -nv -O /tmp/docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
&& cd /tmp \
&& tar -xzvf docker.tgz \
&& cp docker/* /usr/bin/ \
&& docker -v \
&& echo "Installing credentials store" \ 
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