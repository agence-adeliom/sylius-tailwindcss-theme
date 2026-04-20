1. Install Dependencies with Composer

```bash
composer install
```

2. Create the Test Database

```bash
vendor/bin/console doctrine:database:create
```
This command creates the database for the Test Application using Doctrine. It reads the DATABASE_URL from the .env file in tests/TestApplication/.
If the database already exists, this command won’t do anything.

3. Run Migrations to Build the Database Schema


```bash
vendor/bin/console doctrine:migrations:migrate -n
```
This applies all available Doctrine migrations, including those from Sylius core and your plugin (if any).
The -n flag skips confirmation prompts, which is especially useful in CI environments.

4. Load Sylius Fixtures


```bash
vendor/bin/console sylius:fixtures:load -n
```
Fixtures are predefined data (like products, channels, and users) that populate your test database.
This command loads these sample records, so your test application is ready to use.
You can add custom fixtures if your plugin needs specific data (such as custom entities or product types).

5. Install Frontend Dependencies (JavaScript & CSS)

```bash
(cd vendor/sylius/test-application && yarn install)
```

This installs JavaScript dependencies defined in package.json inside the Test Application.
The command changes into the vendor/sylius/test-application directory and runs yarn install, which installs the necessary packages into node_modules.

If your plugin adds additional JS dependencies, they will be merged automatically.

6. Modify test application webpack configuration

Modify the `webpack.config.js` file in `vendor/sylius/test-application` to include plugin's assets:

Change this part:
```js
Encore.reset();

module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig];
```

With this:
```js
Encore.reset();

const tailwindThemeConfig = require('../../../themes/TailwindTheme/webpack-test-application.config.js');
tailwindThemeConfig.resolve.modules = nodeModulesPath;
Encore.reset();

module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig, tailwindThemeConfig];

```

7. Build Frontend Assets (Admin & Shop)


```bash
(cd vendor/sylius/test-application && yarn build)
```

This command builds the frontend assets, including JavaScript and CSS.
Once the build process completes, the assets will be ready to be installed into the public/ directory.

8. Install Assets into the Public Directory


```bash
vendor/bin/console assets:install
```

This command copies the built frontend assets (JS, CSS) into the public/ directory of your Test Application.
Without this step, your app may load without styles or JavaScript features on both the admin and shop sides.

9. Start the Local Web Server


```bash
symfony server:start -d
```

This command starts a local development server using the Symfony CLI.
Your Test Application will be accessible at http://127.0.0.1:8000 by default.

10. Composer script for convenience


```bash
# If you want to reset the database and reload fixtures, you can use the following composer script:
composer run database-reset
```

```bash
# Rebuild frontend assets
composer run frontend-clear
```
