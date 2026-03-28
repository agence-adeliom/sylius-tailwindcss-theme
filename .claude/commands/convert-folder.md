# Convertir un dossier de templates Bootstrap → Tailwind

Convertis tous les templates manquants du dossier `$ARGUMENTS` du SyliusShopBundle.

## Étapes

1. **Lister les templates source** dans `vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/$ARGUMENTS`
2. **Lister les templates existants** dans `themes/TailwindTheme/templates/bundles/SyliusShopBundle/$ARGUMENTS`
3. **Identifier les manquants** (présents en source, absents dans le thème)
4. **Pour chaque template manquant**, lire le template source et créer sa version Tailwind en respectant :
   - Remplacer les classes Bootstrap par leurs équivalents Tailwind/daisyUI (voir table dans CLAUDE.md)
   - Utiliser daisyUI pour les composants interactifs
   - Utiliser la classe `heading` pour les titres `h1`–`h6`
   - Conserver intacts les composants Symfony UX Live
   - Ne pas modifier la logique Twig (blocs, includes, variables)
5. **Mettre à jour le tableau d'avancement** dans CLAUDE.md avec les nouveaux chiffres
