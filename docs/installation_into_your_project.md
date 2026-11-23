## Installation into your project

#### 1. Create a folder `./themes/TailwindTheme` and copy the following files from the repository :

-   `themes/TailwindTheme/assets`
-   `themes/TailwindTheme/templates`
-   `themes/TailwindTheme/translations`
-   `themes/TailwindTheme/webpack.config.js`

The theme's `translations` folder holds the texts used by its templates, under the `sylius_tailwindcss.ui.*` keys. It ships `fr` and `en`: for another locale, add a `messages.<locale>.yaml` file with all the keys, or the templates display raw keys. When a key exists in both the theme and your project's `./translations`, the theme's value wins: to change a theme text, edit it in `themes/TailwindTheme/translations`.

The templates also rely on the theme's scripts (`assets/js`) and styles (`assets/css/main.css`): without them, the side cart, the menus and the dropdowns do not open. To update an existing project, see [Upgrading the theme](./upgrading.md).

#### 2. Install dependencies

```bash
$ npm install -D tailwindcss@4 postcss postcss-loader autoprefixer daisyui@5 @tailwindcss/postcss
$ yarn add -D tailwindcss@4 postcss postcss-loader autoprefixer daisyui@5 @tailwindcss/postcss
```

#### 3. Import `tailwind-theme` config in your `./webpack.config.js`

```diff
* Encore.reset();
+ const tailwindTheme = require('./themes/TailwindTheme/webpack.config');
+ Encore.reset();

// ...

- module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig];
+ module.exports = [shopConfig, adminConfig, appShopConfig, appAdminConfig, tailwindTheme];
```

#### 4. Edit project configuration

```diff
# ./config/packages/assets.yaml

framework:
    assets:
        packages:
+            tailwindTheme:
+                json_manifest_path: '%kernel.project_dir%/public/themes/tailwind-theme/manifest.json'
```

```diff
# ./config/packages/webpack_encore.yaml

webpack_encore:
    output_path: '%kernel.project_dir%/public/build'
    builds:
+        tailwindTheme: '%kernel.project_dir%/public/themes/tailwind-theme'
```

#### 5. Build assets

```bash
# compile assets once
npm|yarn run build

# recompile assets automatically when files change
npm|yarn run watch

# create a production build
npm|yarn run build:prod
```

#### 6. Create a composer.json file in the theme folder

This step is necessary to make the theme appear in the admin panel and be selectable for channels.

```json
{
    "name": "your-vendor-name/sylius-tailwind-theme",
    "description": "A Sylius front-end alternative based on Tailwindcss 4 and daisyUI 5.",
    "extra": {
        "sylius-theme": {
          "title": "Tailwind theme"
        }
    }
}
```

#### 7. Change theme in the admin panel

1. Go to `Configuration > Channels`
2. Edit desired channel from the list
3. Go to `Look & feel > Theme` section
4. Change theme to `Sylius Tailwind Theme`

#### 8. Link your accessibility statement

The footer of every page, checkout included, shows the accessibility mention required by the RGAA. Set the URL of your statement page and your compliance level in your project's translations (`./translations/messages.<locale>.yaml`), for each locale:

```yaml
sylius_tailwindcss:
    ui:
        a11y:
            accessibility_statement:
                url: /en_US/accessibility-statement
                label: "Accessibility: partially compliant"
```

Without `url`, the mention is shown without a link. Without `label`, it reads "Accessibility: not compliant" (`default_label` in the theme). Keep these two keys in `./translations`, out of `themes/TailwindTheme/translations`, so that updating the theme files never overwrites them.
