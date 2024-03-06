## Composer installation

It means all files are installed as a composer dependency (into vendor directory).
Then you override templates of your needs by copying files into : `./themes/TailwindTheme/templates/bundles/SyliusShopBundle/...`

Installation as a composer dependency [is documented here for bootstrapTheme](./docs/COMPOSER_INSTALLATION.md).
You can follow the same steps, just replace `bootstrap` by `tailwind`

```bash
composer require agence-adeliom/sylius-tailwindcss-theme
```
