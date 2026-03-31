# Convert a folder of Bootstrap templates → Tailwind

Convert all missing templates from the `$ARGUMENTS` folder of SyliusShopBundle.

## Steps

1. **List source templates** in `vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/$ARGUMENTS`
2. **List existing templates** in `themes/TailwindTheme/templates/bundles/SyliusShopBundle/$ARGUMENTS`
3. **Identify missing ones** (present in source, absent from the theme)
4. **For each missing template**, read the source template and create its Tailwind version following these rules:
   - Replace Bootstrap classes with their Tailwind/daisyUI equivalents (see table in CLAUDE.md)
   - Use daisyUI for interactive components
   - Use the `heading` class for `h1`–`h6` headings
   - Keep Symfony UX Live components intact
   - Do not modify Twig logic (blocks, includes, variables)
5. **Update the progress table** in CLAUDE.md with the new figures
