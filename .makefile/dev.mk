.DEFAULT_GOAL := help
SHELL=/bin/bash
APP_DIR=tests/Application
SYMFONY=cd ${APP_DIR} && symfony
COMPOSER=symfony composer
CONSOLE=${SYMFONY} console
COMPOSE=docker-compose
YARN=yarn
NPM=npm

###
### DEVELOPMENT
### ¯¯¯¯¯¯¯¯¯¯¯

HELP += $(call help,install,			Install the project and the theme)
install: application platform sylius theme ## Install the plugin
.PHONY: install

up: docker.up server.start ## Up the project (start docker, start symfony server)
stop: server.stop docker.stop ## Stop the project (stop docker, stop symfony server)
down: server.stop docker.down ## Down the project (removes docker containers, stop symfony server)

HELP += $(call help,reset,			Stop docker and remove dependencies)
reset: ## Stop docker and remove dependencies
	${MAKE} docker.down || true
	rm -rf ${APP_DIR}/node_modules ${APP_DIR}/package-lock.json
	rm -rf ${APP_DIR}
	rm -rf vendor composer.lock
.PHONY: reset

dependencies: composer.lock node_modules ## Setup the dependencies
.PHONY: dependencies

.php-version: .php-version.dist
	rm -f .php-version
	ln -s .php-version.dist .php-version

php.ini: php.ini.dist
	rm -f php.ini
	ln -s php.ini.dist php.ini

composer.lock: composer.json
	${COMPOSER} install --no-scripts --no-plugins

yarn.install: ${APP_DIR}/yarn.lock
npm.install: ${APP_DIR}/package-lock.json

${APP_DIR}/yarn.lock:
	ln -sf ${APP_DIR}/node_modules node_modules
	cd ${APP_DIR} && ${YARN} install && ${YARN} build
	${YARN} install
	${YARN} encore prod

${APP_DIR}/package-lock.json:
	ln -sf ${APP_DIR}/node_modules node_modules
	cd ${APP_DIR} && ${NPM} install
	cd ${APP_DIR} && ${NPM} install tailwindcss @fortawesome/fontawesome-free daisyui
	cd ${APP_DIR} && ${NPM} install postcss-loader@^7.0.0 autoprefixer --save-dev
	cd ${APP_DIR} && ${NPM} run build:prod

node_modules: ${APP_DIR}/node_modules ## Install the Node dependencies using npm

${APP_DIR}/node_modules: npm.install

###
### TEST APPLICATION
### ¯¯¯¯¯

application: .php-version php.ini ${APP_DIR} setup_application ${APP_DIR}/docker-compose.yaml ## Setup the entire Test Application

${APP_DIR}:
	(${COMPOSER} create-project --no-interaction --prefer-dist --no-scripts --no-progress --no-install sylius/sylius-standard="~${SYLIUS_VERSION}" ${APP_DIR})

setup_application:
	rm -f ${APP_DIR}/yarn.lock
	rm -f ${APP_DIR}/package-lock.json
	(cd ${APP_DIR} && ${COMPOSER} config repositories.plugin '{"type": "path", "url": "../../"}')
	(cd ${APP_DIR} && ${COMPOSER} config repositories.adeliom '{"type":"vcs","url":"git@github.com:agence-adeliom/sylius-tailwindcss-theme.git"}')
	(cd ${APP_DIR} && ${COMPOSER} config extra.symfony.allow-contrib true)
	(cd ${APP_DIR} && ${COMPOSER} config minimum-stability dev)
	(cd ${APP_DIR} && ${COMPOSER} config --no-plugins allow-plugins true)
	(cd ${APP_DIR} && ${COMPOSER} config extra.symfony.require "~${SYMFONY_VERSION}")
	(cd ${APP_DIR} && ${COMPOSER} require --no-install --no-scripts --no-progress sylius/sylius="~${SYLIUS_VERSION}") # Make sure to install the required version of sylius because the sylius-standard has a soft constraint
	$(MAKE) ${APP_DIR}/.php-version
	$(MAKE) ${APP_DIR}/php.ini
	(cd ${APP_DIR} && ${COMPOSER} install --no-interaction)
	$(MAKE) apply_dist
	(cd ${APP_DIR} && ${COMPOSER} require --no-progress ${PLUGIN_NAME}="*@dev")
	rm -rf ${APP_DIR}/var/cache


${APP_DIR}/docker-compose.yaml:
	rm -f ${APP_DIR}/docker-compose.yml
	rm -f ${APP_DIR}/docker-compose.yaml
	ln -s ../../docker-compose.yaml.dist ${APP_DIR}/docker-compose.yaml
.PHONY: ${APP_DIR}/docker-compose.yaml

${APP_DIR}/.php-version: .php-version
	(cd ${APP_DIR} && ln -sf ../../.php-version)

${APP_DIR}/php.ini: php.ini
	(cd ${APP_DIR} && ln -sf ../../php.ini)

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
### TESTS
### ¯¯¯¯¯

test.all: test.composer test.phpstan test.phpmd test.phpunit test.phpspec test.phpcs test.yaml test.schema test.twig test.container ## Run all tests in once

test.composer: ## Validate composer.json
	${COMPOSER} validate --strict

test.phpstan: ## Run PHPStan
	${COMPOSER} phpstan

test.phpmd: ## Run PHPMD
	${COMPOSER} phpmd || true

test.phpunit: ## Run PHPUnit
	${COMPOSER} phpunit

test.phpspec: ## Run PHPSpec
	${COMPOSER} phpspec

test.phpcs: ## Run PHP CS Fixer in dry-run
	${COMPOSER} run -- phpcs --dry-run -v

test.phpcs.fix: ## Run PHP CS Fixer and fix issues if possible
	${COMPOSER} run -- phpcs -v

test.container: ## Lint the symfony container
	${CONSOLE} lint:container

test.yaml: ## Lint the symfony Yaml files
	${CONSOLE} lint:yaml ../../recipes ../../src/Resources/config

test.schema: ## Validate MySQL Schema
	${CONSOLE} doctrine:schema:validate

HELP += $(call help,test.twig,			Test twig files)
test.twig: ## Validate Twig templates
	#${CONSOLE} lint:twig --no-debug templates/ ../../src/Resources/views/
	composer install
	vendor/bin/twigcs templates/ --severity error --display blocking --reporter githubAction

###
### SYLIUS
### ¯¯¯¯¯¯

sylius: dependencies sylius.database sylius.fixtures sylius.assets messenger.setup ## Install Sylius
.PHONY: sylius

sylius.database: ## Setup the database
	${CONSOLE} doctrine:database:drop --if-exists --force
	${CONSOLE} doctrine:database:create --if-not-exists
	${CONSOLE} doctrine:migration:migrate -n

sylius.fixtures: ## Run the fixtures
	${CONSOLE} sylius:fixtures:load -n default
	${CONSOLE} doctrine:query:sql "UPDATE sylius_channel SET theme_name = 'agence-adeliom/sylius-tailwindcss-theme'"

sylius.assets: ## Install all assets with symlinks
	${CONSOLE} assets:install --symlink
	${CONSOLE} sylius:install:assets
	${CONSOLE} sylius:theme:assets:install --symlink

messenger.setup: ## Setup Messenger transports
	${CONSOLE} messenger:setup-transports

###
### PLATFORM
### ¯¯¯¯¯¯¯¯

platform: .php-version up ## Setup the platform tools
.PHONY: platform

docker.pull: ## Pull the docker images
	cd ${APP_DIR} && ${COMPOSE} pull

docker.up: ## Start the docker containers
	cd ${APP_DIR} && ${COMPOSE} up -d
.PHONY: docker.up

docker.stop: ## Stop the docker containers
	cd ${APP_DIR} && ${COMPOSE} stop
.PHONY: docker.stop

docker.down: ## Stop and remove the docker containers
	cd ${APP_DIR} && ${COMPOSE} down
.PHONY: docker.down

docker.logs: ## Logs the docker containers
	cd ${APP_DIR} && ${COMPOSE} logs -f
.PHONY: docker.logs

docker.dc: ARGS=ps
docker.dc: ## Run docker-compose command. Use ARGS="" to pass parameters to docker-compose.
	cd ${APP_DIR} && ${COMPOSE} ${ARGS}
.PHONY: docker.dc

server.start: ## Run the local webserver using Symfony
	${SYMFONY} local:server:start -d

server.stop: ## Stop the local webserver
	${SYMFONY} local:server:stop

###
### THEME
### ¯¯¯¯¯¯

theme: install-theme build-theme ## Install Theme
.PHONY: theme

install-theme:
ifneq ("$(wildcard install/Application)","")
	cp -r ./tests ${APP_DIR}/tests
endif
	rm -rf ${APP_DIR}/themes/TailwindTheme
	mkdir ${APP_DIR}/themes/TailwindTheme
	cp -r assets ${APP_DIR}/themes/TailwindTheme
	cp -r templates ${APP_DIR}/themes/TailwindTheme
	cp composer.json ${APP_DIR}/themes/TailwindTheme
	cp tailwind.config.js ${APP_DIR}
	cp postcss.config.js ${APP_DIR}
	cp webpack.config.js ${APP_DIR}/themes/TailwindTheme
	echo "const tailwindTheme = require('./themes/TailwindTheme/webpack.config');" >> ${APP_DIR}/webpack.config.js
	echo "module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig, tailwindTheme];" >> ${APP_DIR}/webpack.config.js
	echo "            tailwindTheme:" >> ${APP_DIR}/config/packages/assets.yaml
	echo "                json_manifest_path: '%kernel.project_dir%/public/themes/tailwind-theme/manifest.json'" >> ${APP_DIR}/config/packages/assets.yaml
	echo "        tailwindTheme: '%kernel.project_dir%/public/themes/tailwind-theme'" >> ${APP_DIR}/config/packages/webpack_encore.yaml
	echo "    webp:" >> ${APP_DIR}/config/packages/liip_imagine.yaml
	echo "        generate: true" >> ${APP_DIR}/config/packages/liip_imagine.yaml

HELP += $(call help,build-theme,			Build theme)
build-theme:
	cd ${APP_DIR} && ${NPM} run build:prod

HELP += $(call help,watch-theme,			Build & watch theme)
watch-theme:
	cd ${APP_DIR} && ${NPM} run watch

HELP += $(call apply-theme,			Update APP_DIR theme files with root theme files)
apply-theme:
	rm -rf ${APP_DIR}/themes/TailwindTheme/assets
	rm -rf ${APP_DIR}/themes/TailwindTheme/templates
	rm -rf ${APP_DIR}/themes/TailwindTheme/tailwind.config.js
	rm -rf ${APP_DIR}/themes/TailwindTheme/postcss.config.js
	cp -r ./assets ${APP_DIR}/themes/TailwindTheme
	cp -r ./templates ${APP_DIR}/themes/TailwindTheme
	cp ./tailwind.config.js ${APP_DIR}/themes/TailwindTheme
	cp ./postcss.config.js ${APP_DIR}/themes/TailwindTheme


HELP += $(call help,reset-theme,			Update root theme files with APP_DIR theme files)
reset-theme:
	rm -rf ./assets
	rm -rf ./templates
	rm -rf ./tailwind.config.js
	rm -rf ./postcss.config.js
	cp -r ${APP_DIR}/themes/TailwindTheme/assets ./
	cp -r ${APP_DIR}/themes/TailwindTheme/templates ./
	cp ${APP_DIR}/tailwind.config.js ./tailwind.config.js
	cp ${APP_DIR}/postcss.config.js ./postcss.config.js
















