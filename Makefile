.DEFAULT_GOAL := help
SHELL=/bin/bash
COMPOSER_ROOT=composer
TEST_DIRECTORY=install/Application
CONSOLE=cd install/Application && ddev console -e test
COMPOSER=cd install/Application && ddev composer
NPM=cd install/Application && ddev npm
DDEV := ddev

SYLIUS_VERSION=1.12.3
SYMFONY_VERSION=6.4
PLUGIN_NAME=agence-adeliom/sylius-tailwindcss-theme

###
### DEVELOPMENT
### ¯¯¯¯¯¯¯¯¯¯¯

install: sylius ## Install Plugin on Sylius [SYLIUS_VERSION=1.12.13] [SYMFONY_VERSION=6.4]
.PHONY: install

reset: ## Remove dependencies
ifneq ("$(wildcard install/Application/bin/console)","")
	${CONSOLE} doctrine:database:drop --force --if-exists || true
endif
	rm -rf install/Application
.PHONY: reset

phpunit: phpunit-configure phpunit-run ## Run PHPUnit
.PHONY: phpunit

###
### OTHER
### ¯¯¯¯¯¯

sylius: sylius-standard update-dependencies install-plugin install-theme install-sylius
.PHONY: sylius

sylius-standard:
	${COMPOSER_ROOT} create-project sylius/sylius-standard ${TEST_DIRECTORY} "~${SYLIUS_VERSION}" --no-install --no-scripts
	cp -R ./.ddev ./install/Application
	cp .env.dev.local.dist ./install/Application/.env.dev.local
	cd install/Application && $(DDEV) start
	${COMPOSER} config allow-plugins true
	${COMPOSER} require sylius/sylius:"~${SYLIUS_VERSION}"

update-dependencies:
	${COMPOSER} config extra.symfony.require "~${SYMFONY_VERSION}"
	${COMPOSER} update --no-progress -n

install-plugin:
	${COMPOSER} config repositories.plugin '{"type": "path", "url": "../../"}'
	${COMPOSER} config extra.symfony.allow-contrib true
	${COMPOSER} config minimum-stability "dev"
	${COMPOSER} config prefer-stable true
	${COMPOSER} req ${PLUGIN_NAME}:* --prefer-source --no-scripts

install-theme:
ifneq ("$(wildcard install/Application)","")
	cp -r install/Application tests
endif
	mkdir ${TEST_DIRECTORY}/themes/TailwindTheme
	cp -r assets ${TEST_DIRECTORY}/themes/TailwindTheme
	cp -r templates ${TEST_DIRECTORY}/themes/TailwindTheme
	cp composer.json ${TEST_DIRECTORY}/themes/TailwindTheme
	cp webpack.config.js ${TEST_DIRECTORY}/themes/TailwindTheme
	echo "const tailwindTheme = require('./themes/TailwindTheme/webpack.config');" >> ${TEST_DIRECTORY}/webpack.config.js
	echo "module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig, tailwindTheme];" >> ${TEST_DIRECTORY}/webpack.config.js
	echo "            tailwindTheme:" >> ${TEST_DIRECTORY}/config/packages/assets.yaml
	echo "                json_manifest_path: '%kernel.project_dir%/public/themes/tailwind-theme/manifest.json'" >> ${TEST_DIRECTORY}/config/packages/assets.yaml
	echo "        tailwindTheme: '%kernel.project_dir%/public/themes/tailwind-theme'" >> ${TEST_DIRECTORY}/config/packages/webpack_encore.yaml

install-sylius:
	${CONSOLE} doctrine:database:create --if-not-exists
	${CONSOLE} doctrine:migrations:migrate -n
	${CONSOLE} sylius:fixtures:load default -n
	${NPM} install
	${NPM} install tailwindcss
	${NPM} install daisyui
	${NPM} run build
	${CONSOLE} cache:clear

phpunit-configure:
	cp phpunit.xml.dist ${TEST_DIRECTORY}/phpunit.xml

phpunit-run:
	cd ${TEST_DIRECTORY} && ./vendor/bin/phpunit --testdox

help: SHELL=/bin/bash
help: ## Dislay this help
	@IFS=$$'\n'; for line in `grep -h -E '^[a-zA-Z_#-]+:?.*?##.*$$' $(MAKEFILE_LIST)`; do if [ "$${line:0:2}" = "##" ]; then \
	echo $$line | awk 'BEGIN {FS = "## "}; {printf "\033[33m    %s\033[0m\n", $$2}'; else \
	echo $$line | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m%s\n", $$1, $$2}'; fi; \
	done; unset IFS;
.PHONY: help
