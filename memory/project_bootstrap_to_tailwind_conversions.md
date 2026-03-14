---
name: Conversions Bootstrap → Tailwind/daisyUI
description: Table de correspondance des classes Bootstrap vers Tailwind CSS et daisyUI utilisées dans ce projet
type: project
---

## Classes utilitaires

| Bootstrap | Tailwind/daisyUI |
|-----------|-----------------|
| `text-end` | `text-right` |
| `text-start` | `text-left` |
| `me-auto` | `mr-auto` |
| `ms-auto` | `ml-auto` |
| `me-2` | `mr-2` |
| `ms-2` | `ml-2` |
| `mb-3`, `mb-5` | identiques (Tailwind) |
| `fw-bold` | `font-bold` |
| `fw-medium` | `font-medium` |
| `fw-semibold` | `font-semibold` |
| `text-nowrap` | `whitespace-nowrap` |
| `text-body-tertiary` | `text-base-content/60` |
| `text-decoration-line-through` | `line-through` |
| `d-flex` | `flex` |
| `d-inline-block` | `inline-block` |
| `flex-column` | `flex-col` |
| `align-items-center` | `items-center` |
| `justify-content-center` | `justify-center` |
| `gap-2`, `gap-4` | identiques (Tailwind) |
| `w-75` | `w-3/4` |
| `h-5` | `text-xl font-semibold` (heading) |
| `visually-hidden` | `sr-only` |
| `position-relative z-1` | `relative z-10` |
| `bg-white` | `bg-base-100` |
| `border-bottom` | `border-b` |
| `img-fluid` | `max-w-full h-auto` |
| `container d-flex flex-column align-items-center` | `container flex flex-col items-center` |

## Composants daisyUI

| Bootstrap | daisyUI |
|-----------|---------|
| `badge bg-success-subtle text-success` | `badge badge-success` |
| `badge rounded-pill` | `badge badge-{color}` |
| `alert alert-info/success/danger` | `alert alert-info/success/error` |
| Modal Bootstrap (`data-bs-toggle/target`) | `<dialog class="modal">` + `showModal()` JS |
| Accordion Bootstrap | daisyUI `collapse` avec `input[type=radio/checkbox]` |
| Dropdown Bootstrap | daisyUI `dropdown` + `menu` |
| `card bg-body-tertiary border-0` | `card bg-base-200 border-0` |
| `card-header` | `div.font-bold.text-base.mb-2` (titre de carte) |
| `btn btn-sm btn-outline-danger` | `btn btn-sm btn-outline btn-error` |
| `btn btn-sm btn-danger` | `btn btn-sm btn-error` |

## Pagination (pagerfanta)

Les templates pagerfanta utilisent les classes daisyUI `join-item btn btn-sm` au lieu de `page-item page-link`.
