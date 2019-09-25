FROM handspiker2/ci-tools:base

ENV ANSIBLE_INVENTORY="/etc/ansible/hosts,/data/hosts"
ENV ANSIBLE_LOCAL_TEMP=/tmp

RUN apt-get update \
&& apt-get install -y -qq --no-install-recommends software-properties-common \
&& apt-add-repository --yes --update ppa:ansible/ansible \
&& apt-get install -y -qq --no-install-recommends ansible \
&& ansible --version \
# prevent warning about invalid host file
&& touch /data/hosts \
&& ansible localhost -m ping \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*