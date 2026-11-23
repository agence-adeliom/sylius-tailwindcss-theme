/**
 * After a page load on a URL fragment (e.g. listing sorted or paginated, URL ending with #products),
 * moves the focus to the target when it carries [data-focus-on-load], so screen readers start there.
 * The browser has already scrolled to the target: the focus does not scroll again.
 */
export function focusFragmentTarget() {
    const id = decodeURIComponent(window.location.hash.slice(1));
    const target = id ? document.getElementById(id) : null;

    if (target && target.hasAttribute('data-focus-on-load')) {
        target.focus({ preventScroll: true });
    }
}
