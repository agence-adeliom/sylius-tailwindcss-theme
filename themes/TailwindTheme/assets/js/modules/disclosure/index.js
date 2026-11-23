/**
 * Disclosure widgets: in [data-disclosure], button[aria-expanded][aria-controls] toggles a hidden panel.
 * Escape closes the innermost open panel before its dialog; focus leaving the container closes the panel.
 */
const TOGGLE = 'button[aria-expanded][aria-controls]';

function setOpen(button, open) {
    const panel = document.getElementById(button.getAttribute('aria-controls'));

    if (!panel) {
        return;
    }

    button.setAttribute('aria-expanded', open ? 'true' : 'false');
    panel.hidden = !open;
}

function openToggles(scope) {
    return [...scope.querySelectorAll(`[data-disclosure] ${TOGGLE}[aria-expanded="true"]`)];
}

export function initDisclosures(root = document) {
    // Set when Escape just closed a disclosure, so the native dialog "cancel" does not close the dialog too.
    let escapeHandled = false;

    root.addEventListener('click', (event) => {
        const button = event.target.closest(TOGGLE);

        if (button && button.closest('[data-disclosure]')) {
            const open = button.getAttribute('aria-expanded') !== 'true';

            openToggles(root).forEach((other) => other !== button && setOpen(other, false));
            setOpen(button, open);

            return;
        }

        if (!event.target.closest('[data-disclosure]')) {
            openToggles(root).forEach((other) => setOpen(other, false));
        }
    });

    root.addEventListener('keydown', (event) => {
        if (event.key !== 'Escape') {
            return;
        }

        // Focus may be on <body> (some browsers do not focus a button on click): fall back to the whole scope.
        const container = event.target.closest?.('[data-disclosure]');
        const scope = container ?? event.target.closest?.('dialog') ?? root;
        const buttons = openToggles(scope);

        if (buttons.length === 0) {
            return;
        }

        buttons.forEach((button) => setOpen(button, false));
        buttons[0].focus();
        event.preventDefault();

        escapeHandled = true;
        setTimeout(() => {
            escapeHandled = false;
        }, 0);
    });

    // "cancel" and "close" do not bubble: listen in the capture phase.
    root.addEventListener('cancel', (event) => {
        if (escapeHandled && event.target instanceof HTMLDialogElement) {
            event.preventDefault();
        }
    }, true);

    root.addEventListener('close', (event) => {
        if (event.target instanceof HTMLDialogElement) {
            openToggles(event.target).forEach((button) => setOpen(button, false));
        }
    }, true);

    root.addEventListener('focusout', (event) => {
        const container = event.target.closest?.('[data-disclosure]');

        if (container && event.relatedTarget && !container.contains(event.relatedTarget)) {
            openToggles(container).forEach((button) => setOpen(button, false));
        }
    });
}
