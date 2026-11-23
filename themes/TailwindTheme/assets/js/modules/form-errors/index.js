/**
 * Moves the focus to the error summary of a form sent with errors (RGAA 11.10),
 * so keyboard and screen reader users land on the list of errors.
 * The summary is rendered by form/theme.html.twig (block form_start).
 */
export function focusFormErrorSummary(root = document) {
    const summary = root.querySelector('[data-form-error-summary]');

    if (summary) {
        summary.focus();
    }
}

/**
 * A link of the summary moves the focus to its field, not only the scroll position.
 */
export function initFormErrorSummaryLinks(root = document) {
    root.addEventListener('click', (event) => {
        const link = event.target.closest('[data-form-error-summary] a[href^="#"]');
        const field = link && document.getElementById(link.getAttribute('href').slice(1));

        if (field) {
            event.preventDefault();
            field.focus();
        }
    });
}
