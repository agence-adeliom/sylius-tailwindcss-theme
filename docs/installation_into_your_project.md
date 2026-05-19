## Installation into your project

#### 1. Create a folder `./themes/TailwindTheme` and copy the following files from the repository :

-   `themes/TailwindTheme/assets`
-   `themes/TailwindTheme/templates`
-   `themes/TailwindTheme/webpack.config.js`

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
