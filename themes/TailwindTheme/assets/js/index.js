import { SyliusToggleTheme, SyliusApplyTheme } from './sylius-toggle-theme';
import { focusFormErrorSummary, initFormErrorSummaryLinks } from './form-errors';
import { initDialogs } from './dialog';
import { initFlashes } from './flashes';

document.addEventListener('DOMContentLoaded', () => {
    // Toggle themes
    SyliusToggleTheme();

    // Native dialogs (side panels)
    initDialogs();

    // Flash messages
    initFlashes();

    // Forms sent with errors
    initFormErrorSummaryLinks();
    focusFormErrorSummary();
});

// Apply theme
SyliusApplyTheme();
