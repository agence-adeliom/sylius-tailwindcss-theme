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

const SyliusAddToCart = (el) => {
  const element = el;
  const url = element.getAttribute('action');
  const redirectUrl = element.getAttribute('data-redirect');
  const validationElement = element.querySelector('[data-js-add-to-cart="error"]');

  element.addEventListener('submit', (e) => {
    const formData = new FormData(element);
    e.preventDefault();

    (async() => {
      try {
        const response = await fetcher(url, { method: 'POST', body: formData });
        const data = await response.json();

        if (!response.ok) {
          validationElement.classList.remove('hidden');
          let validationMessage = '';
    
          Object.entries(data.errors.errors).forEach(([, message]) => {
            validationMessage += message;
          });
    
          validationElement.innerHTML = validationMessage;
          element.classList.remove('is-loading');
          throw new Error(validationMessage);
        }

        validationElement.classList.add('hidden');
        window.location.href = redirectUrl;
      } catch (error) {
        console.log(error);
      }
    })();
  });
};

export default SyliusAddToCart;
