.DEFAULT_GOAL := help
SHELL=/bin/bash
COMPOSER_ROOT=composer
TEST_DIRECTORY=./install/Application
CONSOLE=cd ./install/Application && ddev console
MYSQL=cd ./install/Application && ddev mysql
CONSOLE_TEST=cd ./install/Application && ddev console -e test
COMPOSER=cd ./install/Application && ddev composer
NPM=cd ./install/Application && ddev npm
DDEV := ddev

SYLIUS_VERSION=1.12.3
SYMFONY_VERSION=6.4
PLUGIN_NAME=agence-adeliom/sylius-tailwindcss-theme

###
### DEVELOPMENT
### ¯¯¯¯¯¯¯¯¯¯¯

install-project: sylius ## Install Plugin on Sylius [SYLIUS_VERSION=1.12.13] [SYMFONY_VERSION=6.4]
.PHONY: install-project

halt:
	cd install/Application && $(DDEV) stop

start:
	cd install/Application && $(DDEV) start

remove-project: ## Remove dependencies
ifneq ("$(wildcard install/Application/bin/console)","")
	${CONSOLE} doctrine:database:drop --force --if-exists || true
endif
	$(DDEV) clean sylius-tailwindcss-theme
	rm -rf install/Application
.PHONY: remove-project

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
	cp .env.local.dist ./install/Application/.env.local
	cd install/Application && $(DDEV) start
	${COMPOSER} config allow-plugins true
	#https://github.com/api-platform/core/issues/6226
	${COMPOSER} req api-platform/core:v2.7.16 --prefer-source --no-scripts --no-install
	${COMPOSER} require sylius/sylius:"~${SYLIUS_VERSION}"

update-dependencies:
	${COMPOSER} config extra.symfony.require "~${SYMFONY_VERSION}"
	${COMPOSER} update --no-progress -n

install-plugin:
	${COMPOSER} config repositories.plugin '{"type": "path", "url": "../../"}'
	${COMPOSER} config repositories.adeliom '{"type":"vcs","url":"git@github.com:agence-adeliom/sylius-tailwindcss-theme.git"}'
	${COMPOSER} config extra.symfony.allow-contrib true
	${COMPOSER} config minimum-stability "dev"
	${COMPOSER} config prefer-stable true
	${COMPOSER} req ${PLUGIN_NAME}:* --prefer-source --no-scripts

install-theme:
ifneq ("$(wildcard install/Application)","")
	cp -r ./tests ./install/Application/tests
endif
	rm -rf ${TEST_DIRECTORY}/themes/TailwindTheme
	mkdir ${TEST_DIRECTORY}/themes/TailwindTheme
	cp -r assets ${TEST_DIRECTORY}/themes/TailwindTheme
	cp -r templates ${TEST_DIRECTORY}/themes/TailwindTheme
	cp composer.json ${TEST_DIRECTORY}/themes/TailwindTheme
	cp tailwind.config.js ${TEST_DIRECTORY}
	cp postcss.config.js ${TEST_DIRECTORY}
	cp webpack.config.js ${TEST_DIRECTORY}/themes/TailwindTheme
	echo "const tailwindTheme = require('./themes/TailwindTheme/webpack.config');" >> ${TEST_DIRECTORY}/webpack.config.js
	echo "module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig, tailwindTheme];" >> ${TEST_DIRECTORY}/webpack.config.js
	echo "            tailwindTheme:" >> ${TEST_DIRECTORY}/config/packages/assets.yaml
	echo "                json_manifest_path: '%kernel.project_dir%/public/themes/tailwind-theme/manifest.json'" >> ${TEST_DIRECTORY}/config/packages/assets.yaml
	echo "        tailwindTheme: '%kernel.project_dir%/public/themes/tailwind-theme'" >> ${TEST_DIRECTORY}/config/packages/webpack_encore.yaml
	echo "    webp:" >> ${TEST_DIRECTORY}/config/packages/liip_imagine.yaml
	echo "    	generate: true" >> ${TEST_DIRECTORY}/config/packages/liip_imagine.yaml

install-sylius:
	${CONSOLE} doctrine:database:create --if-not-exists
	${CONSOLE} doctrine:migrations:migrate -n
	${CONSOLE} sylius:fixtures:load default -n
	${MYSQL} db -e "UPDATE sylius_channel SET theme_name = 'agence-adeliom/sylius-tailwindcss-theme' WHERE id = 1"
	${NPM} install
	${NPM} install tailwindcss @fortawesome/fontawesome-free daisyui
	${NPM} install postcss-loader@^7.0.0 autoprefixer --save-dev
	${NPM} run build
	${CONSOLE} cache:clear
	echo 'Project installation completed successfully.'
	echo 'Navigate here : https://sylius-tailwindcss-theme.ddev.site/'
	echo 'Now go to admin panel to active the new installed theme'

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

get-changes:
	rm -rf ./assets
	rm -rf ./templates
	rm -rf ./tailwind.config.js
	rm -rf ./postcss.config.js
	cp -r ${TEST_DIRECTORY}/themes/TailwindTheme/assets ./
	cp -r ${TEST_DIRECTORY}/themes/TailwindTheme/templates ./
	cp ${TEST_DIRECTORY}/tailwind.config.js ./tailwind.config.js
	cp ${TEST_DIRECTORY}/postcss.config.js ./postcss.config.js


watch:
	${NPM} install
	${NPM} run watch

lint:
	composer install
	vendor/bin/twigcs templates/ --severity error --display blocking --reporter githubAction

###
### CI TEST
### ¯¯¯¯¯¯¯¯¯¯¯
### ¯¯¯¯¯¯¯¯¯¯¯
### ¯¯¯¯¯¯¯¯¯¯¯
### ¯¯¯¯¯¯¯¯¯¯¯
### ¯¯¯¯¯¯¯¯¯¯¯




COMPOSER_CI_ROOT=composer
TEST_DIRECTORY_CI=./install/Application
CONSOLE_CI=cd ./install/Application && php bin/console -e test
COMPOSER_CI=cd ./install/Application && composer
NPM_CI=cd ./install/Application && npm


install-ci: sylius-ci ## Install Plugin on Sylius [SYLIUS_VERSION=1.12.13] [SYMFONY_VERSION=6.4]
install-docker: sylius-docker ## Install Plugin on Sylius [SYLIUS_VERSION=1.12.13] [SYMFONY_VERSION=6.4]
.PHONY: install

reset-ci: ## Remove dependencies
ifneq ("$(wildcard install/Application/bin/console)","")
	${CONSOLE_CI} doctrine:database:drop --force --if-exists || true
endif
	rm -rf install/Application
.PHONY: reset-ci

phpunit-ci: phpunit-configure phpunit-run ## Run PHPUnit
.PHONY: phpunit

###
### OTHER
### ¯¯¯¯¯¯

sylius-ci: sylius-standard-ci update-dependencies-ci install-plugin-ci install-theme-ci install-sylius-ci
sylius-docker: sylius-standard-ci update-dependencies-ci install-plugin-ci install-theme-ci install-sylius-docker set-proxies
.PHONY: sylius-ci

sylius-standard-ci:
	${COMPOSER_CI_ROOT} create-project sylius/sylius-standard ${TEST_DIRECTORY_CI} "~${SYLIUS_VERSION}" --no-install --no-scripts
	${COMPOSER_CI} config allow-plugins true
	#https://github.com/api-platform/core/issues/6226
	${COMPOSER_CI} req api-platform/core:v2.7.16 --prefer-source --no-scripts --no-install
	${COMPOSER_CI} require sylius/sylius:"~${SYLIUS_VERSION}"

update-dependencies-ci:
	${COMPOSER_CI} config extra.symfony.require "~${SYMFONY_VERSION}"
	${COMPOSER_CI} update --no-progress -n

install-plugin-ci:
	${COMPOSER_CI} config repositories.plugin '{"type": "path", "url": "../../"}'
	${COMPOSER_CI} config repositories.adeliom '{"type":"vcs","url":"git@github.com:agence-adeliom/sylius-tailwindcss-theme.git"}'
	${COMPOSER_CI} config extra.symfony.allow-contrib true
	${COMPOSER_CI} config minimum-stability "dev"
	${COMPOSER_CI} config prefer-stable true
	${COMPOSER_CI} req ${PLUGIN_NAME}:* --prefer-source --no-scripts

install-theme-ci:
ifneq ("$(wildcard install/Application)","")
	cp -r install/Application tests
endif
	mkdir ${TEST_DIRECTORY_CI}/themes/TailwindTheme
	cp -r assets ${TEST_DIRECTORY_CI}/themes/TailwindTheme
	cp -r templates ${TEST_DIRECTORY_CI}/themes/TailwindTheme
	cp composer.json ${TEST_DIRECTORY_CI}/themes/TailwindTheme
	cp webpack.config.js ${TEST_DIRECTORY_CI}/themes/TailwindTheme
	cp tailwind.config.js ${TEST_DIRECTORY_CI}
	cp postcss.config.js ${TEST_DIRECTORY_CI}
	echo "const tailwindTheme = require('./themes/TailwindTheme/webpack.config');" >> ${TEST_DIRECTORY_CI}/webpack.config.js
	echo "module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig, tailwindTheme];" >> ${TEST_DIRECTORY_CI}/webpack.config.js
	echo "            tailwindTheme:" >> ${TEST_DIRECTORY_CI}/config/packages/assets.yaml
	echo "                json_manifest_path: '%kernel.project_dir%/public/themes/tailwind-theme/manifest.json'" >> ${TEST_DIRECTORY_CI}/config/packages/assets.yaml
	echo "        tailwindTheme: '%kernel.project_dir%/public/themes/tailwind-theme'" >> ${TEST_DIRECTORY_CI}/config/packages/webpack_encore.yaml
	echo "    webp:" >> ${TEST_DIRECTORY}/config/packages/liip_imagine.yaml
	echo "    	generate: true" >> ${TEST_DIRECTORY}/config/packages/liip_imagine.yaml

install-sylius-ci:
	${CONSOLE_CI} doctrine:database:create --if-not-exists
	${CONSOLE_CI} doctrine:migrations:migrate -n
	${CONSOLE_CI} sylius:fixtures:load default -n
	${CONSOLE_CI} doctrine:query:sql "UPDATE sylius_channel SET theme_name = 'agence-adeliom/sylius-tailwindcss-theme' WHERE id = 1"
	${NPM_CI} install
	${NPM_CI} install tailwindcss @fortawesome/fontawesome-free daisyui
	${NPM_CI} install postcss-loader@^7.0.0 autoprefixer --save-dev
	${NPM_CI} run build
	${CONSOLE_CI} cache:clear

install-sylius-docker:
	${NPM_CI} install
	${NPM_CI} install tailwindcss @fortawesome/fontawesome-free daisyui
	${NPM_CI} install postcss-loader@^7.0.0 autoprefixer --save-dev
	${NPM_CI} run build

phpunit-configure-ci:
	cp phpunit.xml.dist ${TEST_DIRECTORY_CI}/phpunit.xml

phpunit-run-ci:
	cd ${TEST_DIRECTORY_CI} && ./vendor/bin/phpunit --testdox

set-proxies:
	cp .docker/stub/trusted_proxies.yaml ${TEST_DIRECTORY_CI}/config/packages
