FROM adeliom/php:8.2-caddy-node20

ARG SYLIUS_VERSION=1.12.0
ARG SYMFONY_VERSION=6.4

RUN apk add --update make

RUN mkdir -p /opt/sylius

COPY . /opt/sylius

RUN cd /opt/sylius && \
    make install-docker -e SYLIUS_VERSION=$SYLIUS_VERSION SYMFONY_VERSION=$SYMFONY_VERSION

RUN cp -ra /opt/sylius/install/Application/. /var/www/html && \
    rm -rf /opt/sylius && \
    chown -R www-data:www-data /var/www/html

ENV DOCUMENT_ROOT=/var/www/html/public/

ENV PHP_INI_MEMORY_LIMIT=1G
ENV PHP_INI_OPCACHE_MEMORY_CONSUMPTION=1024
ENV PHP_INI_OPCACHE_INTERNED_STRINGS_BUFFER=256
ENV PHP_INI_OPCACHE_MAX_ACCELERATED_FILES=20000
ENV PHP_INI_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_INI_REALPATH_CACHE_TTL=600


WORKDIR /var/www/html
EXPOSE 80

COPY .docker/Caddyfile /etc/caddy/Caddyfile
COPY .docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
