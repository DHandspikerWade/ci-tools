ARG BASE_IMAGE="handspiker2/ci-tools:base"
FROM ${BASE_IMAGE}

RUN \
apt-get update -q \
&& apt-get install -y -qq --no-install-recommends \
    mysql-client \
    libxml2-dev \
    libmcrypt-dev \
    libsqlite3-dev \
    libonig-dev \
    pkg-config \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

ARG PHP_VERSION

# Ubuntu 22.04 switched to libssl3 but older versions of PHP need 1.1.1. It's no longer in repos so must be compiled.
RUN dpkg --compare-versions "$PHP_VERSION" 'gt' '8.1.0' || ( \
  cd /tmp \
  && wget -nv -O openssl-1.1.1u.tar.gz https://www.openssl.org/source/openssl-1.1.1u.tar.gz \
  && tar -xzf openssl-1.1.1u.tar.gz \
  && cd openssl-1.1.1u \
  # "Configure" has a capital letter in 1.1.1
  && ./Configure --prefix=/opt/openssl1.1 -fPIC -shared linux-$(uname -p) \
  && make && make install \
  && cd / \
  && rm -r /tmp/openssl* \
)

RUN cd /tmp/ \
&& wget -nv -O php-${PHP_VERSION}.tar.gz https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz \
&& tar -xzf php-${PHP_VERSION}.tar.gz \
&& cd /tmp/php-${PHP_VERSION} \
&& autoconf \
&& ./configure \
  --prefix=/usr/local \
  --with-config-file-path=/usr/local/etc \
  --with-config-file-scan-dir=/usr/local/etc/php.d \
  --disable-cgi \
  --enable-bcmath \
  --enable-cli \
  --enable-ftp \
  --enable-mbstring \
  --enable-pcntl \
  --enable-phar \
  --enable-shared \
  --enable-zip \
  --with-curl \
  --with-iconv \
  --with-gd \
  --with-mcrypt \
  --with-openssl PKG_CONFIG_PATH=/opt/openssl1.1/lib/pkgconfig \
  --with-openssl-dir=/opt/openssl1.1 \
  --with-pear \
  --with-readline \
  --with-zlib \
&& make clean \
&& make \
&& make install \
&& cd / && rm -rf /tmp/php-${PHP_VERSION}* /tmp/pear \
&& php -r "print('hello world from PHP ' . PHP_VERSION . PHP_EOL);" \
# Update PECL as it's not updated in tarballs
&& pecl channel-update pecl.php.net

ARG COMPOSER_VERSION=2.8.8
ENV COMPOSER_HOME /composer
ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}

# PHPUnit (10 is highest version for all currently supported PHP versions)
ARG PHPUNIT_VERSION=10
RUN wget -nv https://phar.phpunit.de/phpunit-${PHPUNIT_VERSION}.phar\
&& chmod +x phpunit-${PHPUNIT_VERSION}.phar \
&& mv phpunit-${PHPUNIT_VERSION}.phar /usr/local/bin/phpunit \
&& phpunit --version
