/*
 * This file is part of the Sylius package.
 *
 * (c) Paweł Jędrzejewski
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

/* eslint-env browser */

import { fetcher } from './utils'

const SyliusRemoveFromCart = (el) => {
  const element = el;
  const redirectUrl = element.getAttribute('data-js-remove-from-cart-redirect-url');
  const csrfToken = element.getAttribute('data-js-remove-from-cart-csrf-token');
  const url = element.getAttribute('data-js-remove-from-cart-api-url');

  element.addEventListener('click', (e) => {
    e.preventDefault();

    (async() => {
      try {
        const response = await fetcher(url, { 
          method: 'DELETE', 
          body: JSON.stringify({ _csrf_token: csrfToken}), 
          headers: { 
            'Content-Type': 'application/json',  
            'Accept': 'application/json, text/javascript, */*; q=0.01',
            'X-Requested-With': 'XMLHttpRequest'
          } 
        } );

        if (response.ok) {
          window.location.replace(redirectUrl);
        } else {
          throw new Error('Failed to remove from cart');
        }
      } catch (error) {
        console.log(error)
      }
    })();
  });
};

export default SyliusRemoveFromCart;
