---
name: sylius-bootstrap-to-tailwind
description: Use when converting Sylius ShopBundle Twig templates from Bootstrap to Tailwind CSS and daisyUI — class mapping, interactive components, Sylius-specific constraints
---

# Sylius Bootstrap → Tailwind CSS / daisyUI

Full mapping reference: see `reference.md` in this same folder.

## Fundamental rules

- **Never** modify Twig business logic (blocks, variables, includes, Sylius filters)
- Keep Symfony UX Live attributes intact: `data-controller`, `data-model`, `data-live-*`
- Keep `sylius_template_event()` unmodified
- Use **daisyUI** for interactive components (modal, dropdown, accordion) → less custom JS
- Use the **`heading`** class for all `h1`–`h6` headings (typography + SEO)
- Target compatibility: **Sylius 2.0**

## Key mappings (quick reference)

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

→ For all mappings (typography, grid, badges, forms, navigation): see `reference.md`

## Interactive components — Decisions

| Need | Solution |
|------|----------|
| Bootstrap modal (`data-bs-toggle`) | `<dialog class="modal">` + `showModal()` |
| Bootstrap accordion | daisyUI `collapse` + `input[type=checkbox]` |
| Bootstrap dropdown | daisyUI `dropdown` + `menu` |
| Pagerfanta pagination | `join` + `join-item btn btn-sm` |
| Sylius forms (`form_themes`) | Create a Twig form theme, reference in `twig.yaml` |

## Common mistakes

| Mistake | Correction |
|---------|------------|
| Removing `data-controller` from a Live Component | Never touch Symfony UX attributes |
| Using `text-2xl font-bold` for a heading | Use `class="heading"` |
| Recoding a modal in custom JS | Use daisyUI `<dialog class="modal">` |
| Modifying Twig block logic | Only CSS classes, never the logic |
| Forgetting `mx-auto` on `container` | Bootstrap auto-centered, Tailwind does not |
| Modifying `sylius_price` or `sylius_format_money` | Keep these filters intact |
