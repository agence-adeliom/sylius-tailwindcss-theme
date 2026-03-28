# Synchroniser le statut d'avancement des templates

Recalcule le tableau d'avancement réel en comparant les dossiers source et thème.

## Étapes

1. Pour chaque dossier du tableau dans CLAUDE.md, compter :
   - Fichiers `.html.twig` dans `vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/{dossier}` (récursif)
   - Fichiers `.html.twig` dans `themes/TailwindTheme/templates/bundles/SyliusShopBundle/{dossier}` (récursif)
2. Calculer les manquants = source - thème (si positif)
3. Mettre à jour le tableau dans CLAUDE.md avec les vrais chiffres
4. Recalculer le total et le pourcentage de couverture
5. Mettre à jour la date "Dernière mise à jour"
