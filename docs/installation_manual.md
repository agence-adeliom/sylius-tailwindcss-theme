## Manual installation

#### 1. Create a folder `./themes/TailwindTheme` and copy the following files from the repository :

-   `assets`
-   `templates`
-   `webpack.config.js`
-   `composer.json`

#### 2. Install node dependencies

```bash
$ npm install -D tailwindcss@4 postcss postcss-loader autoprefixer @fortawesome/fontawesome-free daisyui@5 @tailwindcss/postcss
$ yarn add -D tailwindcss@4 postcss postcss-loader autoprefixer @fortawesome/fontawesome-free daisyui@5 @tailwindcss/postcss
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

#### 4. Create `postcss.config.mjs` file in your project root directory

```bash
export default {
  plugins: {
    "@tailwindcss/postcss": {},
  }
}
````

#### 5. Edit project configuration

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

#### 6. Build assets

```bash
# compile assets once
npm|yarn run build

# recompile assets automatically when files change
npm|yarn run watch

# create a production build
npm|yarn run build:prod
```

#### 7. Change theme in the admin panel

1. Go to `Configuration > Channels`
2. Edit desired channel from the list
3. Go to `Look & feel > Theme` section
4. Change theme to `Sylius Tailwind Theme`
