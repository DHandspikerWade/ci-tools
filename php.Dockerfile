FROM handspiker2/ci-tools:base
ARG PHP_VERSION=7.1.28

RUN \
apt-get update \
&& apt-get install -y -qq --no-install-recommends \
    mysql-client \
    libxml2-dev \
    libmcrypt-dev \
    libssl-dev \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/* \
&& cd /tmp/ \
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
  --with-mcrypt \
  --with-openssl \
  --with-pear \
  --with-readline \
  --with-zlib \
&& make clean \
&& make \
&& make install \
&& cd / && rm -rf /tmp/php-${PHP_VERSION} \
&& php -r "print('hello' . PHP_EOL);"

ARG COMPOSER_VERSION=1.8.5
ENV COMPOSER_HOME /composer
ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}

# PHPUnit
RUN \
wget -nv https://phar.phpunit.de/phpunit.phar \
&& chmod +x phpunit.phar \
&& mv phpunit.phar /usr/local/bin/phpunit