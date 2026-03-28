---
name: sylius-bootstrap-to-tailwind
description: Use when converting Sylius ShopBundle Twig templates from Bootstrap to Tailwind CSS and daisyUI — class mapping, interactive components, Sylius-specific constraints
---

# Sylius Bootstrap → Tailwind CSS / daisyUI

Référence complète des correspondances : voir `reference.md` dans ce même dossier.

## Règles fondamentales

- Ne **jamais** modifier la logique métier Twig (blocs, variables, includes, filtres Sylius)
- Conserver intacts les attributs Symfony UX Live : `data-controller`, `data-model`, `data-live-*`
- Conserver `sylius_template_event()` sans modification
- Utiliser **daisyUI** pour les composants interactifs (modal, dropdown, accordéon) → moins de JS custom
- Utiliser la classe **`heading`** pour tous les titres `h1`–`h6` (typographie + SEO)
- Compatibilité cible : **Sylius 2.0**

## Correspondances clés (quick reference)

| Bootstrap | Tailwind / daisyUI |
|-----------|-------------------|
| `d-flex` / `d-none` | `flex` / `hidden` |
| `me-auto` / `ms-auto` | `mr-auto` / `ml-auto` |
| `fw-bold` | `font-bold` |
| `text-body-tertiary` | `text-base-content/60` |
| `visually-hidden` | `sr-only` |
| `bg-white` / `bg-light` | `bg-base-100` / `bg-base-200` |
| `btn btn-link` | `btn btn-ghost` |
| `btn btn-sm btn-danger` | `btn btn-sm btn-error` |
| `alert alert-danger` | `alert alert-error` |
| `card-header` | `<div class="font-bold text-base mb-2">` |
| `input-group` | `join` |
| `table table-striped` | `table table-zebra` |
| `list-group` / `list-group-item` | `menu` / `li` |
| `display-4` | `text-5xl font-bold` |
| `lead` | `text-lg text-base-content/70` |

→ Pour toutes les correspondances (typographie, grille, badges, formulaires, navigation) : voir `reference.md`

## Composants interactifs — Décisions

| Besoin | Solution |
|--------|----------|
| Modal Bootstrap (`data-bs-toggle`) | `<dialog class="modal">` + `showModal()` |
| Accordion Bootstrap | daisyUI `collapse` + `input[type=checkbox]` |
| Dropdown Bootstrap | daisyUI `dropdown` + `menu` |
| Pagination pagerfanta | `join` + `join-item btn btn-sm` |
| Formulaires Sylius (`form_themes`) | Créer un form theme Twig, référencer dans `twig.yaml` |

## Erreurs fréquentes

| Erreur | Correction |
|--------|------------|
| Supprimer `data-controller` d'un Live Component | Ne jamais toucher aux attributs Symfony UX |
| `text-2xl font-bold` pour un titre | Utiliser `class="heading"` |
| Recoder un modal en JS custom | Utiliser `<dialog class="modal">` daisyUI |
| Modifier la logique d'un bloc Twig | Seulement les classes CSS, jamais la logique |
| Oublier `mx-auto` sur `container` | Bootstrap centrait auto, pas Tailwind |
| Modifier `sylius_price` ou `sylius_format_money` | Conserver ces filtres intacts |
