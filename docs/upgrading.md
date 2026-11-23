## Upgrading the theme in your project

Copy the new version of `themes/TailwindTheme/templates`, then the files listed for your upgrade below. Templates depend on them: copying the templates alone breaks the pages.

### Upgrading from 2.0.x

The accessibility release makes the templates depend on scripts, styles and translations of the theme. With the templates alone, the side cart, the mobile menu, the sub-menus, the sorting and limit selectors, the locale and currency switchers and the address deletion do not open, and labels show raw translation keys.

Copy or merge these files:

| File | Used by |
|---|---|
| `themes/TailwindTheme/assets/js/index.js` | Starts the modules used on every page: dialogs, disclosures, theme switcher, flash messages and form error summary |
| `themes/TailwindTheme/assets/js/modules/` | One folder per component. `dialog`: side cart, mobile menu and address deletion (native dialogs). `disclosure`: sub-menus, sorting, limit, locale, currency, theme and mobile account menus. `theme-switcher`: replaces `assets/js/sylius-toggle-theme.js`. `flashes`: close button of the flash messages. `form-errors`: focus on the error summary of a form sent with errors. `price-status`: price announced after a variant change. `fragment-focus`: focus on the product list after sorting, filtering or paging |
| `themes/TailwindTheme/assets/js/entries/` | `price-status` and `fragment-focus` entries, loaded only by `product/show.html.twig` and `product/index.html.twig` |
| `themes/TailwindTheme/assets/js/utils/dom-ready.js` | Runs the start-up code once the page is parsed, whether the script sits at the end of `body` or in `head` with `defer` |
| `themes/TailwindTheme/webpack.config.js` | Declares the `price-status` and `fragment-focus` entries next to `app` |
| `themes/TailwindTheme/assets/css/main.css` | `modal` in the daisyUI `include` list, the `:focus-visible` rule and the `.badge` rule |
| `themes/TailwindTheme/translations/messages.en.yaml`, `messages.fr.yaml` | `sylius_tailwindcss.ui.*` keys used by the templates |

Then:

-   Delete `themes/TailwindTheme/assets/js/sylius-toggle-theme.js`.
-   If you override `product/show.html.twig` or `product/index.html.twig`, keep their `javascripts` block: it loads the `price-status` or `fragment-focus` entry. If you import the theme scripts from your own entry point, declare these 2 entries in your Webpack config and load them in the same blocks.
-   Set `--focus-ring-color` on `:root` to a colour with a 3:1 contrast against your backgrounds. The default is `currentColor`.
-   If you override `confirmation_modal.html.twig` or `delete_modal.html.twig`, remove their `onclick` attributes: the trigger opens the dialog with `data-dialog-open` and the cancel button closes it with `data-dialog-close`. The dialog title goes in the `title` block, an optional text in the `description` block.
-   If a page renders the sorting, limit, locale or currency control twice, pass a `variant` in the hook context of the second one, for instance `variant: 'mobile'`. Its panel id then gets the suffix (`sorting-panel-mobile`).
-   Forms say which fields are required: one sentence above the form, and asterisks only when some entry fields are optional. The theme picks the mode from the fields; to force it on a form, pass `required_mode` to `form_start`: `{{ form_start(form, {required_mode: 'none'}) }}` (`none`, `all` or `marked`). If you override `required_marker`, keep its classes: the asterisk is shown by CSS from the `data-required-mode` attribute of the form tag.
-   The product name link covers the whole product card. If you add a button or a link to the card (wishlist, add to cart), give it `relative z-10`: otherwise the card link sits above it and takes its clicks.
-   Add an accessibility statement page to your project: see step 8 of [the installation](./installation_into_your_project.md).
-   If your project already has translation files in `themes/TailwindTheme/translations`, merge the keys instead of replacing the files.
-   If you moved the theme templates out of `themes/TailwindTheme` (for instance into `./templates`), put the keys in `./translations` and import the scripts from your own entry point.
