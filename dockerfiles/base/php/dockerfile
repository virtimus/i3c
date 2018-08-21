FROM php:7.1-fpm-alpine

RUN apk add --update \
		autoconf \
		g++ \
		libtool \
		make \

	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install opcache \

	&& apk add --update icu-dev \
	&& docker-php-ext-install intl \

	&& apk add --update postgresql-dev \
	&& docker-php-ext-install pgsql \
	&& apk del \
		postgresql-libs \
		libsasl \
		db \

	&& docker-php-ext-install sockets \

	&& touch /usr/local/etc/php/bogus.ini \
	&& pear config-set php_ini /usr/local/etc/php/bogus.ini \
	&& pecl config-set php_ini /usr/local/etc/php/bogus.ini \
	&& apk add --update \
		libevent-dev \
		openssl-dev \
	&& pecl install event \
	&& docker-php-ext-enable event \
	&& mv /usr/local/etc/php/conf.d/docker-php-ext-event.ini \
		/usr/local/etc/php/conf.d/docker-php-ext-zz-event.ini \
	&& rm /usr/local/etc/php/bogus.ini \

	&& apk del \
		autoconf \
		bash \
		binutils \
		binutils-libs \
		db \
		expat \
		file \
		g++ \
		gcc \
		gdbm \
		gmp \
		isl \
		libatomic \
		libbz2 \
		libc-dev \
		libffi \
		libgcc \
		libgomp \
		libldap \
		libltdl \
		libmagic \
		libsasl \
		libstdc++ \
		libtool \
		m4 \
		make \
		mpc1 \
		mpfr3 \
		musl-dev \
		perl \
		pkgconf \
		pkgconfig \
		python \
		re2c \
		readline \
		sqlite-libs \
		zlib-dev \
	&& rm -rf /tmp/* /var/cache/apk/*

# Those packages are not removed, because extensions are dynamically linked against them:
# - icu-libs
# - libpq
# - openssl-dev
# - postgresql-libs
# - libevent
# - postgresql-dev
# - libevent-dev
# - icu-dev