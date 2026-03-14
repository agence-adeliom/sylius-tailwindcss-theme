import { SyliusToggleTheme, SyliusApplyTheme } from './sylius-toggle-theme';
import '@fortawesome/fontawesome-free/css/solid.css';
import '@fortawesome/fontawesome-free/scss/brands.scss';
import '@fortawesome/fontawesome-free/scss/fontawesome.scss';

document.addEventListener('DOMContentLoaded', () => {
    // Toggle themes
    SyliusToggleTheme();
});

// Apply theme
SyliusApplyTheme();
