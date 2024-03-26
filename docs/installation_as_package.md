## Composer installation

It means all files are installed as a composer dependency (into vendor directory).
Then you override templates of your needs by copying files into : `./themes/TailwindTheme/templates/bundles/SyliusShopBundle/...`

Installation as a composer dependency [is documented here for Sylius bootstrapTheme](https://docs.sylius.com/en/1.12/book/themes/bootstrap-theme.html#creating-a-new-theme-based-on-bootstraptheme).
You can follow the same steps, just replace `bootstrap` by `tailwind`

1. Install package :

```bash
composer require agence-adeliom/sylius-tailwindcss-theme
```

2. In the `config/packages/_sylius.yaml` file, add the path to the installed package

```yaml
sylius_theme:
    sources:
        filesystem:
            directories:
                - "%kernel.project_dir%/vendor/agence-adeliom/sylius-tailwindcss-theme"
                - "%kernel.project_dir%/themes"
```

3. Create your custom child theme directory and composer file : `themes/TailwindChildTheme/composer.json`

```json
{
    "name": "acme/sylius-tailwindcss-child-theme",
    "description": "Tailwind child theme",
    "license": "MIT",
    "authors": [
        {
            "name": "James Potter",
            "email": "prongs@example.com"
        }
    ],
    "extra": {
        "sylius-theme": {
            "title": "Tailwind child theme",
            "parents": [ "agence-adeliom/sylius-tailwindcss-theme" ]
        }
    }
}
```

4. Compile Webpack Encore

- Add following code into `webpack.config.js`

```js
// TailwindTheme
Encore.reset();

Encore
    .setOutputPath('public/themes/tailwind-theme')
    .setPublicPath('/themes/tailwind-theme')
    .addEntry('app', './themes/TailwindChildTheme/assets/index.js')
    .enablePostCssLoader()
    .enableSassLoader()
    .disableSingleRuntimeChunk()
    .cleanupOutputBeforeBuild()
    .enableSourceMaps(!Encore.isProduction())
    .enableVersioning(Encore.isProduction());

const tailwindTheme = Encore.getWebpackConfig();
tailwindTheme.name = 'tailwindTheme';

module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig, tailwindTheme];
```

- Create a `tailwind.config.js` file and add content from `vendor/agence-adeliom/sylius-tailwindcss-theme/tailwind.config.js`

You can run:
```bash
$ cp vendor/agence-adeliom/sylius-tailwindcss-theme/tailwind.config.js ./
```

Then white list content path :
```js
{
    content: [
        './vendor/agence-adeliom/sylius-tailwindcss-theme/assets/**/*.js',
        './vendor/agence-adeliom/sylius-tailwindcss-theme/themes/**/assets/**/*.js',
        './vendor/agence-adeliom/sylius-tailwindcss-theme/templates/**/*.html.twig',
        './vendor/agence-adeliom/sylius-tailwindcss-theme/themes/**/*.html.twig',
        './vendor/agence-adeliom/sylius-tailwindcss-theme/themes/**/*.html.twig',
      ]
}
```

- Create index asset into `themes/TailwindChildTheme/assets/index.js` and add:

```js
import '../../../vendor/agence-adeliom/sylius-tailwindcss-theme/assets/index';
```


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

- Run :

```bash
$ npm install
$ npm install -D tailwindcss postcss postcss-loader autoprefixer @fortawesome/fontawesome-free daisyui
$ npm run build:prod
```

5. Change channel configuration

Now you can go to the channel settings in the admin panel and select the created theme as default.

