# Compare a source template with its Tailwind version

Shows the differences between the Bootstrap source template and its converted Tailwind version for `$ARGUMENTS`.

`$ARGUMENTS` = relative path of the template from the templates root, e.g. `checkout/summary/content/main/items.html.twig`

## Steps

1. Read the source template: `vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/$ARGUMENTS`
2. Read the converted template: `themes/TailwindTheme/templates/bundles/SyliusShopBundle/$ARGUMENTS`
3. Analyze the differences:
   - Modified CSS classes (Bootstrap → Tailwind)
   - Modified HTML structure
   - Twig logic preserved or modified
4. Report any residual Bootstrap classes present in the converted template
5. Suggest improvements if necessary
