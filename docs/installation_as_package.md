## Composer installation

It means all files are installed as a composer dependency (into vendor directory).
Then you override templates of your needs by copying files into : `./themes/TailwindTheme/templates/bundles/SyliusShopBundle/...`

Installation as a composer dependency [is documented here for Sylius bootstrapTheme](https://docs.sylius.com/en/1.12/book/themes/bootstrap-theme.html#creating-a-new-theme-based-on-bootstraptheme).
You can follow the same steps, just replace `bootstrap` by `tailwind`

1. Install package :

```bash
composer require agence-adeliom/sylius-tailwindcss-theme ^2.0.0
```

2. Copy all templates files into your project theme folder

```bash
mkdir -p themes/TailwindTheme
cp -R vendor/agence-adeliom/sylius-tailwindcss-theme/themes/TailwindTheme ./themes/TailwindTheme/
```

3. Configure assets and webpack

- In the `config/packages/assets.yaml` add:
```yaml
framework:
    assets:
        packages:
            tailwindTheme:
              json_manifest_path: '%kernel.project_dir%/public/themes/tailwind-theme/manifest.json'
```

- In the `config/packages/webpack_encore.yaml` add:
```yaml
webpack_encore:
    output_path: '%kernel.project_dir%/public/build/default'
    builds:
        tailwindTheme: '%kernel.project_dir%/public/themes/tailwind-theme'
```


4. Compile Webpack Encore

- Add following code into `webpack.config.js`

```js
// TailwindTheme
Encore.reset();
const tailwindThemeConfig = require('../../../themes/TailwindTheme/webpack.config.js');
tailwindThemeConfig.resolve.modules = nodeModulesPath;

module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig, tailwindThemeConfig];
```

- Run :

```bash
$ npm install
$ yarn install
```
```bash
$ npm install -D tailwindcss@4 postcss postcss-loader autoprefixer @fortawesome/fontawesome-free daisyui@5 @tailwindcss/postcss
$ yarn add -D tailwindcss@4 postcss postcss-loader autoprefixer @fortawesome/fontawesome-free daisyui@5 @tailwindcss/postcss 
```
```bash
$ npm run build:prod
$ yarn run build:prod
```

5. Change channel configuration

Now you can go to the channel settings in the admin panel and select the created theme as default.

