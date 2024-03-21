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

phpunit-ci: phpunit-configure-ci phpunit-run-ci ## Run PHPUnit
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
	echo "    webp:" >> ${TEST_DIRECTORY_CI}/config/packages/liip_imagine.yaml
	echo "        generate: true" >> ${TEST_DIRECTORY_CI}/config/packages/liip_imagine.yaml

install-sylius-ci:
	${CONSOLE_CI} doctrine:database:create --if-not-exists
	${CONSOLE_CI} doctrine:migrations:migrate -n
	${CONSOLE_CI} sylius:fixtures:load default -n
	${CONSOLE_CI} doctrine:query:sql "UPDATE sylius_channel SET theme_name = 'agence-adeliom/sylius-tailwindcss-theme' WHERE id = 1"
	${NPM_CI} install
	${NPM_CI} install tailwindcss @fortawesome/fontawesome-free daisyui
	${NPM_CI} install postcss-loader@^7.0.0 autoprefixer --save-dev
	${NPM_CI} run build:prod
	${CONSOLE_CI} cache:clear

install-sylius-docker:
	${NPM_CI} install
	${NPM_CI} install tailwindcss @fortawesome/fontawesome-free daisyui
	${NPM_CI} install postcss-loader@^7.0.0 autoprefixer --save-dev
	${NPM_CI} run build:prod

phpunit-configure-ci:
	cp phpunit.xml.dist ${TEST_DIRECTORY_CI}/phpunit.xml

phpunit-run-ci:
	cd ${TEST_DIRECTORY_CI} && ./vendor/bin/phpunit --testdox

set-proxies:
	cp .docker/stub/trusted_proxies.yaml ${TEST_DIRECTORY_CI}/config/packages
