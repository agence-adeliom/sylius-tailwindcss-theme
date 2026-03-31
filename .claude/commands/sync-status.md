# Sync template progress status

Recalculate the actual progress table by comparing the source and theme folders.

## Steps

1. For each folder in the CLAUDE.md table, count:
   - `.html.twig` files in `vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/{folder}` (recursive)
   - `.html.twig` files in `themes/TailwindTheme/templates/bundles/SyliusShopBundle/{folder}` (recursive)
2. Calculate missing = source - theme (if positive)
3. Update the table in CLAUDE.md with the actual figures
4. Recalculate the total and coverage percentage
5. Update the "Last updated" date
