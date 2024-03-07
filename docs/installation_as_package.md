## Composer installation

It means all files are installed as a composer dependency (into vendor directory).
Then you override templates of your needs by copying files into : `./themes/TailwindTheme/templates/bundles/SyliusShopBundle/...`

Installation as a composer dependency [is documented here for Sylius bootstrapTheme](https://docs.sylius.com/en/1.12/book/themes/bootstrap-theme.html#creating-a-new-theme-based-on-bootstraptheme).
You can follow the same steps, just replace `bootstrap` by `tailwind`

```bash
composer require agence-adeliom/sylius-tailwindcss-theme
```
