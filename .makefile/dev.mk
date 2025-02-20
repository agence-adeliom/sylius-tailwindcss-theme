.DEFAULT_GOAL := help
shell=/bin/bash
APP_DIR=tests/Application

###
### DEVELOPMENT
### ¯¯¯¯¯¯¯¯¯¯¯

HELP += $(call help,install,			Install the project)
install: application platform sylius ## Install the plugin
.PHONY: install

HELP += $(call help,reset,			Stop docker and remove project)
reset: ## Stop docker and remove dependencies
	${MAKE} platform_down || true
	${MAKE} platform_clean || true
	rm -rf ${APP_DIR}/node_modules ${APP_DIR}/package-lock.json
	rm -rf ${APP_DIR}
	rm -rf vendor composer.lock
.PHONY: rese

HELP += $(call help,stop,				Stop project)
stop:
	${MAKE} platform_down

HELP += $(call help,up,				Start project)
up:
	${MAKE} platform_up

###
### TEST APPLICATION
### ¯¯¯¯¯

application: php.ini .php-version ${APP_DIR} ## Setup the entire Test Application

.php-version: .php-version.dist
	rm -f .php-version
	ln -s .php-version.dist .php-version

php.ini: php.ini.dist
	rm -f php.ini
	ln -s php.ini.dist php.ini

${APP_DIR}:
	(symfony composer create-project --no-interaction --prefer-dist --no-scripts --no-progress --no-install sylius/sylius-standard="${SYLIUS_VERSION}" ${APP_DIR})
	cd ${APP_DIR} && chmod -R 777 public
	echo "COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME}" >> ${APP_DIR}/.env
	echo "NODE_VERSION=${NODE_VERSION}" >> ${APP_DIR}/.env
	${MAKE} apply_dist

apply_dist:
	ROOT_DIR=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))); \
	for i in `cd dist && find . -type f`; do \
		FILE_PATH=`echo $$i | sed 's|./||'`; \
		FOLDER_PATH=`dirname $$FILE_PATH`; \
		echo $$FILE_PATH; \
		(cd ${APP_DIR} && rm -f $$FILE_PATH); \
		(cd ${APP_DIR} && mkdir -p $$FOLDER_PATH); \
    done

###
### SYLIUS
### ¯¯¯¯¯¯¯¯
sylius: sylius_install configure_bundle messenger.setup

sylius_install:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose exec -it -u root php rm -rf public/media/image)
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run php bin/console doctrine:database:drop --if-exists --force)
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php bin/console sylius:install -s default -n)
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm -i php bin/console doctrine:query:sql "UPDATE sylius_channel SET theme_name = 'agence-adeliom/sylius-tailwindcss-theme'")
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm -i php bin/console assets:install --symlink)

configure_bundle:
	${MAKE} bundle_dependencies_install
	echo "navigate to http://localhost:$(DOCKER_PHP_PORT)"

messenger.setup: ## Setup Messenger transports
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run php bin/console messenger:setup-transports)

###
### PLATFORM
### ¯¯¯¯¯¯¯¯

platform:
	@if [ ! -e ${APP_DIR}/compose.override.yml ]; then \
		(cd ${APP_DIR} && cp compose.override.dist.yml compose.override.yml); \
		(cd ${APP_DIR} && sed -i'' -e 's|3306:3306|${DOCKER_MYSQL_PORT}:3306|g' compose.override.yml); \
		(cd ${APP_DIR} && sed -i'' -e 's|          - public-media:/srv/sylius/public/media:rw|          - public-media:/srv/sylius/public/media:rw\n          - ../../:/srv/sylius/${PLUGIN_DIR}:rw|g' compose.override.yml); \
		(cd ${APP_DIR} && sed -i'' -e 's|            - ./public:/srv/sylius/public:rw,delegated|            - ./public:/srv/sylius/public:rw,delegated\n            - ../../:/srv/sylius/${PLUGIN_DIR}:rw|g' compose.override.yml); \
		(cd ${APP_DIR} && sed -i'' -e 's|APP_DEBUG: 0|APP_DEBUG: 1|g' compose.override.yml); \
		(cd ${APP_DIR} && sed -i'' -e 's|- "80:80"|- "$(DOCKER_PHP_PORT):80"\n        depends_on:\n            - php|g' compose.override.yml); \
		(cd ${APP_DIR} && sed -i'' -e 's|            - public-media:/srv/sylius/public/media:ro,nocopy|            - public-media:/srv/sylius/public/media:ro,nocopy\n            - ../../:/srv/sylius/${PLUGIN_DIR}:rw|g' compose.override.yml); \
		(cd ${APP_DIR} && sed -i'' -e 's|plugin-proposal-object-rest-spread|plugin-transform-object-rest-spread|g' .babelrc); \
		(cd ${APP_DIR} && rm -rf compose.override.yml-e); \
		(cd ${APP_DIR} && rm -rf composer.json-e); \
		(cd ${APP_DIR} && rm -rf .babelrc-e); \
		(cd ${APP_DIR} && echo "const tailwindTheme = require('./themes/TailwindTheme/webpack.config');" >> ./webpack.config.js); \
		(cd ${APP_DIR} && echo "module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig, tailwindTheme];" >> ./webpack.config.js); \
		(cd ${APP_DIR} && echo "            tailwindTheme:" >> ./config/packages/assets.yaml); \
		(cd ${APP_DIR} && echo "                json_manifest_path: '%kernel.project_dir%/public/themes/tailwind-theme/manifest.json'" >> ./config/packages/assets.yaml); \
		(cd ${APP_DIR} && echo "        tailwindTheme: '%kernel.project_dir%/public/themes/tailwind-theme'" >> ./config/packages/webpack_encore.yaml); \
		(cd ${APP_DIR} && echo "    webp:" >> ./config/packages/liip_imagine.yaml); \
		(cd ${APP_DIR} && echo "        generate: true" >> ./config/packages/liip_imagine.yaml); \
		(cp tailwind.config.js ${APP_DIR}/tailwind.config.js); \
		(cp postcss.config.mjs ${APP_DIR}/postcss.config.mjs); \
	fi

	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer config github-oauth.github.com ${GITHUB_TOKEN})
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer config minimum-stability dev)
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer config extra.symfony.allow-contrib true)
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer config repositories.plugin '{"type": "path", "url": "../../"}')
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer config extra.symfony.require "~${SYMFONY_VERSION}")
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer require --no-install --no-scripts --no-progress sylius/sylius="~${SYLIUS_VERSION}")
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer require --no-install --no-scripts --dev friendsoftwig/twigcs)
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer global config allow-plugins.${PLUGIN_NAME} true)
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer dump-autoload)
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer install --no-interaction --no-scripts --prefer-dist)
	${MAKE} platform_up
	${MAKE} platform_assets

platform_assets:
	rm -rf ${APP_DIR}/node_modules
	mkdir ${APP_DIR}/node_modules
	rm -rf ${APP_DIR}/package-lock.json
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm -i nodejs "npm install -D postcss postcss-loader postcss-cli tailwindcss @tailwindcss/postcss daisyui@beta @fortawesome/fontawesome-free")
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm nodejs)

platform_debug:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose -f compose.yml -f compose.override.yml -f compose.debug.yml up -d)

platform_up:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose up -d --force-recreate)

platform_down:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose down)

platform_clean:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose down -v)

HELP += $(call help,php-shell,			Go into docker php shell)
php-shell:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose exec php sh)

HELP += $(call help,node-shell,			Go into docker node shell)
node-shell:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm -i nodejs sh)

HELP += $(call help,node-watch,			Run assets build as watch)
node-watch:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm -i nodejs "npm run watch")

HELP += $(call help,node-watch,			Run assets build as watch)
node-build:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm -i nodejs "npm run build:prod")

HELP += $(call help,bundle_dependencies_install,			Install bundles assets npm dependencies)
bundle_dependencies_install:
	cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm -i nodejs "npm install --prefix ./${PLUGIN_DIR}")
	#cd ${APP_DIR} && (ENV=$(ENV) docker compose run --rm php composer install --no-interaction --no-scripts --working-dir=${PLUGIN_DIR})
	${MAKE} symfony_assets_install

HELP += $(call help,symfony_assets_install,			Install bundles assets npm dependencies)
symfony_assets_install:
	cd ${APP_DIR}/${PLUGIN_DIR} && (ENV=$(ENV) docker compose run --rm php bin/console assets:install --symlink)
