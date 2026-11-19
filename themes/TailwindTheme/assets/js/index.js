import { SyliusToggleTheme, SyliusApplyTheme } from './sylius-toggle-theme';
import { focusFormErrorSummary, initFormErrorSummaryLinks } from './form-errors';
import { initDialogs } from './dialog';
import { initDisclosures } from './disclosure';
import { initFlashes } from './flashes';
import { focusFragmentTarget } from './fragment-focus';

document.addEventListener('DOMContentLoaded', () => {
    // Toggle themes
    SyliusToggleTheme();

    // Native dialogs (side panels)
    initDialogs();

    // Disclosure widgets (sub-menus, switchers)
    initDisclosures();

    // Flash messages
    initFlashes();

    // Listing reloaded on its results anchor (sorting, filters, pagination)
    focusFragmentTarget();

    // Forms sent with errors (takes the focus last)
    initFormErrorSummaryLinks();
    focusFormErrorSummary();
});

// Apply theme
SyliusApplyTheme();
