/**
 * Announces the product price after a variant change. The Live components re-render the price,
 * so the status region sits outside them and is filled only when the displayed price changes.
 * [data-price-announce] holds the price; when empty, the element text is announced (e.g. "Unavailable").
 */
export function initPriceStatus() {
    document.querySelectorAll('[data-price-status-scope]').forEach((scope) => {
        const status = scope.querySelector('[data-price-status]');

        if (!status) {
            return;
        }

        const read = () => {
            const element = scope.querySelector('[data-price-announce]');

            if (!element) {
                return '';
            }

            const price = element.getAttribute('data-price-announce');

            return price
                ? status.dataset.priceStatus.replace('%price%', price)
                : element.textContent.replace(/\s+/g, ' ').trim();
        };

        let last = read();
        let timer = null;

        new MutationObserver(() => {
            clearTimeout(timer);
            timer = setTimeout(() => {
                const current = read();

                if (current && current !== last) {
                    last = current;
                    status.textContent = current;
                }
            }, 150);
        }).observe(scope, { childList: true, subtree: true, characterData: true, attributes: true, attributeFilter: ['data-price-announce'] });
    });
}
