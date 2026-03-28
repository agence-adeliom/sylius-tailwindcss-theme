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

## Suivi d'avancement

Dernière mise à jour : 2026-03-28
Total source : 589 templates | Total convertis : ~465 (~79%)

| Dossier        | Source | Thème | Manquants | Statut       |
|----------------|--------|-------|-----------|--------------|
| shared         | 168    | 169   | 0         | terminé ✓    |
| homepage       | 3      | 3     | 0         | terminé ✓    |
| product        | 82     | 82    | 0         | terminé ✓    |
| account        | 166    | 166   | 0         | terminé ✓    |
| checkout       | 64     | 25    | 39        | en cours     |
| order          | 14     | 2     | 12        | en cours     |
| cart           | 30     | 14    | 16        | en cours     |
| contact        | 7      | 4     | 3         | en cours     |
| grid           | 5      | 1     | 4         | en cours     |
| product_review | 35     | 0     | 35        | non démarré  |
| email          | 6      | 0     | 6         | non démarré  |
| errors         | 7      | 0     | 7         | non démarré  |
| form           | 1      | 0     | 1         | non démarré  |
| integrations   | 1      | 0     | 1         | non démarré  |

Priorités : checkout (39) → product_review (35) → cart (16) → order (12) → contact/grid → email/errors/form/integrations

## Commandes de développement

Voir `.claude/commands/dev-commands.md` pour Docker, frontend, tests et qualité de code.
