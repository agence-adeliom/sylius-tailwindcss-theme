/**
 * Close button of the flash messages (shared/flashes.html.twig).
 * The message is removed and the focus moves on, so it is not lost on <body> (RGAA 12.8):
 * to the close button of the next message, or of the previous one, or else to the main content.
 */
export function initFlashes(root = document) {
    root.addEventListener('click', (event) => {
        const button = event.target.closest('[data-flash-close]');

        if (!button) {
            return;
        }

        const flash = button.closest('[data-test-sylius-flash-message]');
        const buttons = [...document.querySelectorAll('[data-flash-close]')];
        const index = buttons.indexOf(button);
        const next = buttons[index + 1] ?? buttons[index - 1] ?? document.getElementById('main');

        flash?.remove();
        next?.focus();
    });
}
