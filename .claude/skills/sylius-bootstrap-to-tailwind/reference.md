# Référence complète Bootstrap → Tailwind CSS / daisyUI

## Classes utilitaires

| Bootstrap | Tailwind |
|-----------|----------|
| `text-end` / `text-start` | `text-right` / `text-left` |
| `me-{n}` / `ms-{n}` | `mr-{n}` / `ml-{n}` |
| `me-auto` / `ms-auto` | `mr-auto` / `ml-auto` |
| `mb-3`, `mb-5`, `gap-2`, `gap-4`, `p-0`, `m-0` | identiques (Tailwind) |
| `fw-bold` / `fw-medium` / `fw-semibold` | `font-bold` / `font-medium` / `font-semibold` |
| `text-nowrap` | `whitespace-nowrap` |
| `text-body-tertiary` | `text-base-content/60` |
| `text-decoration-line-through` | `line-through` |
| `d-flex` / `d-inline-block` / `d-block` / `d-none` | `flex` / `inline-block` / `block` / `hidden` |
| `flex-column` | `flex-col` |
| `align-items-center` / `align-items-start` / `align-items-end` | `items-center` / `items-start` / `items-end` |
| `justify-content-center` / `justify-content-between` / `justify-content-end` | `justify-center` / `justify-between` / `justify-end` |
| `w-100` / `w-75` | `w-full` / `w-3/4` |
| `visually-hidden` | `sr-only` |
| `position-relative` / `position-absolute` | `relative` / `absolute` |
| `position-relative z-1` | `relative z-10` |
| `bg-white` / `bg-light` | `bg-base-100` / `bg-base-200` |
| `border-bottom` / `border-top` | `border-b` / `border-t` |
| `rounded` | `rounded` (identique) |
| `rounded-pill` | `rounded-full` |
| `img-fluid` | `max-w-full h-auto` |
| `container` | `container mx-auto` |
| `container d-flex flex-column align-items-center` | `container mx-auto flex flex-col items-center` |

## Typographie

| Bootstrap | Tailwind |
|-----------|----------|
| `h1`–`h6`, `class="h5"` etc. | `<hN class="heading">` |
| `display-4` | `text-5xl font-bold` |
| `lead` | `text-lg text-base-content/70` |
| `small` / `<small>` | `text-sm` |

## Grille

| Bootstrap | Tailwind |
|-----------|----------|
| `row` | `grid` ou `flex flex-wrap` (selon contexte) |
| `col-*` | `col-span-*` ou `w-*` (flex) |
| `col-12` | `w-full` |
| `col-md-6` | `md:col-span-6` ou `md:w-1/2` |
| `g-3` | `gap-3` |

## Badges & Alertes

| Bootstrap | daisyUI |
|-----------|---------|
| `badge bg-success-subtle text-success` | `badge badge-success` |
| `badge bg-danger-subtle text-danger` | `badge badge-error` |
| `badge bg-warning-subtle text-warning` | `badge badge-warning` |
| `badge rounded-pill` | `badge badge-{color}` |
| `alert alert-info` | `alert alert-info` |
| `alert alert-success` | `alert alert-success` |
| `alert alert-danger` | `alert alert-error` |
| `alert alert-warning` | `alert alert-warning` |

## Cards

| Bootstrap | daisyUI |
|-----------|---------|
| `card` | `card` |
| `card bg-body-tertiary border-0` | `card bg-base-200 border-0` |
| `card-body` | `card-body` |
| `card-title` | `card-title` |
| `card-header` | `<div class="font-bold text-base mb-2">` |

## Boutons

| Bootstrap | daisyUI |
|-----------|---------|
| `btn btn-primary` | `btn btn-primary` |
| `btn btn-secondary` | `btn btn-secondary` |
| `btn btn-link` | `btn btn-ghost` |
| `btn btn-sm btn-danger` | `btn btn-sm btn-error` |
| `btn btn-sm btn-outline-danger` | `btn btn-sm btn-outline btn-error` |

## Formulaires

| Bootstrap | daisyUI |
|-----------|---------|
| `form-control` | `input input-bordered` ou `textarea textarea-bordered` |
| `form-select` | `select select-bordered` |
| `form-check-input` (checkbox) | `checkbox` |
| `form-check-input` (radio) | `radio` |
| `form-label` | `label` > `<span class="label-text">` |
| `input-group` | `join` |

### Formulaires Sylius (form_themes)

Les formulaires Sylius utilisent des classes Bootstrap via `form_themes`. Pour les overrider avec Tailwind :
1. Créer un form theme Twig dans `themes/TailwindTheme/templates/form/`
2. Le référencer dans `config/packages/twig.yaml` sous `form_themes`

## Tableaux

| Bootstrap | daisyUI |
|-----------|---------|
| `table table-striped` | `table table-zebra` |
| `table table-hover` | `table` (hover natif daisyUI) |

## Navigation

| Bootstrap | daisyUI |
|-----------|---------|
| `nav nav-tabs` | `tabs` |
| `nav-link active` | `tab tab-active` |
| `list-group` | `menu` ou `ul` avec classes Tailwind |
| `list-group-item` | `li` (dans `menu`) |

## Composants interactifs

### Modal

Bootstrap : `data-bs-toggle="modal"` + `data-bs-target`
daisyUI : `<dialog class="modal">` + `showModal()` JS

```twig
<button onclick="document.getElementById('confirm_modal').showModal()" class="btn btn-sm btn-error">
  Supprimer
</button>

<dialog id="confirm_modal" class="modal">
  <div class="modal-box">
    <h3 class="heading font-bold text-lg">Confirmation</h3>
    <p>Êtes-vous sûr ?</p>
    <div class="modal-action">
      <form method="dialog">
        <button class="btn">Annuler</button>
      </form>
      <button class="btn btn-error">Confirmer</button>
    </div>
  </div>
  <form method="dialog" class="modal-backdrop"><button>Fermer</button></form>
</dialog>
```

### Accordéon

```twig
<div class="collapse collapse-arrow bg-base-200">
  <input type="checkbox" />
  <div class="collapse-title font-medium">Titre</div>
  <div class="collapse-content">Contenu</div>
</div>
```

### Dropdown

```twig
<div class="dropdown">
  <div tabindex="0" role="button" class="btn">Ouvrir</div>
  <ul tabindex="0" class="dropdown-content menu bg-base-100 rounded-box z-1 w-52 p-2 shadow">
    <li><a>Option</a></li>
  </ul>
</div>
```

### Pagination (pagerfanta)

```twig
<div class="join">
  {# items     : class="join-item btn btn-sm" #}
  {# page active : class="join-item btn btn-sm btn-active" #}
</div>
```

## Notes spécifiques Sylius

- **Twig hooks** : conserver `sylius_template_event()` — ne pas modifier
- **Live Components** : conserver `data-controller`, `data-model`, `data-live-*` — ne pas modifier
- **Flash messages** : utiliser `alert alert-{info|success|error|warning}` daisyUI
- **Prix / montants** : conserver les filtres Twig `sylius_price`, `sylius_format_money` sans les modifier
