/**
 * Native <dialog> panels (side_dialog.html.twig), wired by event delegation so they survive Live Component re-renders.
 *
 * - button[data-dialog-open="<id>"] opens the dialog with showModal() and sets aria-expanded="true";
 * - [data-dialog-close] (close button, backdrop) closes it; Escape is handled natively;
 * - openers whose dialog is missing from the page are hidden;
 * - on close, the focus goes back to the opener and aria-expanded returns to "false" (RGAA 7.1, 12.8).
 */
const openers = new WeakMap();

export function openDialog(dialog, opener = null) {
    if (!dialog || dialog.open) {
        return;
    }

    openers.set(dialog, opener ?? document.activeElement);
    opener?.setAttribute('aria-expanded', 'true');
    dialog.showModal();
}

// The navigation dialog is absent when the menu has no taxon: hide its burger rather than leave a dangling aria-controls.
export function hideOrphanDialogOpeners(root = document) {
    root.querySelectorAll('[data-dialog-open]').forEach((button) => {
        button.hidden = !document.getElementById(button.dataset.dialogOpen);
    });
}

export function initDialogs(root = document) {
    root.addEventListener('click', (event) => {
        const opener = event.target.closest('[data-dialog-open]');

        if (opener) {
            openDialog(document.getElementById(opener.dataset.dialogOpen), opener);

            return;
        }

        const closer = event.target.closest('[data-dialog-close]');

        if (closer) {
            closer.closest('dialog')?.close();
        }
    });

    // "close" does not bubble: listen in the capture phase.
    root.addEventListener('close', (event) => {
        const dialog = event.target;

        if (!(dialog instanceof HTMLDialogElement)) {
            return;
        }

        const opener = openers.get(dialog);

        document.querySelectorAll(`[data-dialog-open="${dialog.id}"]`).forEach((button) => {
            button.setAttribute('aria-expanded', 'false');
        });

        if (opener && opener.isConnected) {
            opener.focus();
        }

        openers.delete(dialog);
    }, true);
}
