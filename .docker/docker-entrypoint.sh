#!/bin/sh

su -s /bin/bash -c "mkdir -p var/cache var/log var/sessions public/media" www-data
su -s /bin/bash -c "chmod -R 777 public/media" www-data
su -s /bin/bash -c "php bin/console doctrine:database:drop --force" www-data
su -s /bin/bash -c "php bin/console doctrine:database:create --if-not-exists" www-data
su -s /bin/bash -c "php bin/console doctrine:migrations:migrate -n" www-data
su -s /bin/bash -c "php bin/console sylius:fixtures:load default -n" www-data
su -s /bin/bash -c "php bin/console doctrine:query:sql \"UPDATE sylius_channel SET theme_name = 'agence-adeliom/sylius-tailwindcss-theme'\"" www-data
su -s /bin/bash -c "php bin/console cache:clear" www-data


if [ "${1}" = "-D" ]; then
    # start supervisord and services
    exec /usr/bin/supervisord -n -c /etc/supervisord.conf
else
    exec "$@"
fi
