import { onDomReady } from './utils/dom-ready';
import { SyliusToggleTheme, SyliusApplyTheme } from './modules/theme-switcher';
import { hideOrphanDialogOpeners, initDialogs } from './modules/dialog';
import { initDisclosures } from './modules/disclosure';
import { initFlashes } from './modules/flashes';
import { focusFormErrorSummary, initFormErrorSummaryLinks } from './modules/form-errors';

SyliusApplyTheme();

// Delegated listeners on document: they do not need the DOM to be parsed and survive Live re-renders.
initDialogs();
initDisclosures();
initFlashes();
initFormErrorSummaryLinks();

onDomReady(() => {
    hideOrphanDialogOpeners();
    SyliusToggleTheme();
    focusFormErrorSummary();
});
