## Manual installation

#### 1. Copy files from the repository to `./themes/TailwindTheme`

Files/folders to copy:
* `assets`
* `templates`
* `tailwind.config.js`
* `webpack.config.js`

#### 2. Install node dependencies

```bash
npm install
npm i -D tailwindcss
npm i -D daisyui@latest
```

#### 3. Import `tailwind-theme` config in your `./webpack.config.js`

```diff
+ const tailwindTheme = require('./themes/TailwindTheme/webpack.config');

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
npm run build

# recompile assets automatically when files change
npm run watch

# create a production build
npm run build:prod
```

#### 6. Change theme in the admin panel

1. Go to `Configuration > Channels`
2. Edit desired channel from the list
3. Go to `Look & feel > Theme` section
4. Change theme to `Sylius Tailwind Theme`
