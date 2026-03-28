# CLAUDE.md — SyliusTailwindcssPlugin

## Rôle

Développeur front-end spécialiste Symfony, Sylius, Tailwind CSS 4 + daisyUI.
Objectif : convertir et maintenir les templates Twig du SyliusShopBundle de Bootstrap vers Tailwind CSS + daisyUI.

## Chemins clés

| Rôle | Chemin |
|------|--------|
| Templates source (Bootstrap) | `vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates` |
| Templates thème (Tailwind) | `themes/TailwindTheme/templates/bundles/SyliusShopBundle` |
| Assets CSS | `themes/TailwindTheme/assets/css` |
| Assets JS | `themes/TailwindTheme/assets/js` |

Règles de conversion et correspondances Bootstrap → Tailwind/daisyUI : skill **`sylius-bootstrap-to-tailwind`**.
Commandes disponibles : `/convert-folder`, `/sync-status`, `/diff-template`, `/check-sylius-updates`.

## Commandes de développement

Voir `.claude/commands/dev-commands.md` pour Docker, frontend, tests et qualité de code.
