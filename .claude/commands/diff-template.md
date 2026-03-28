# Comparer un template source avec sa version Tailwind

Affiche les différences entre le template Bootstrap source et sa version Tailwind convertie pour `$ARGUMENTS`.

`$ARGUMENTS` = chemin relatif du template depuis la racine des templates, ex: `checkout/summary/content/main/items.html.twig`

## Étapes

1. Lire le template source : `vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/$ARGUMENTS`
2. Lire le template converti : `themes/TailwindTheme/templates/bundles/SyliusShopBundle/$ARGUMENTS`
3. Analyser les différences :
   - Classes CSS modifiées (Bootstrap → Tailwind)
   - Structure HTML modifiée
   - Logique Twig conservée ou modifiée
4. Signaler si des classes Bootstrap résiduelles sont présentes dans le template converti
5. Suggérer des améliorations si nécessaire
