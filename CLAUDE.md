# CLAUDE.md — SyliusTailwindcssPlugin

## Role

Front-end developer specializing in Symfony, Sylius, Tailwind CSS 4 + daisyUI.
Goal: convert and maintain Twig templates from SyliusShopBundle from Bootstrap to Tailwind CSS + daisyUI.

## Key paths

| Role | Path |
|------|------|
| Source templates (Bootstrap) | `vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates` |
| Theme templates (Tailwind) | `themes/TailwindTheme/templates/bundles/SyliusShopBundle` |
| CSS assets | `themes/TailwindTheme/assets/css` |
| JS assets | `themes/TailwindTheme/assets/js` |

Conversion rules and Bootstrap → Tailwind/daisyUI mappings: skill **`sylius-bootstrap-to-tailwind`**.
Available commands: `/convert-folder`, `/sync-status`, `/diff-template`, `/check-sylius-updates`.

## Development commands

See `.claude/commands/dev-commands.md` for Docker, frontend, tests and code quality.
