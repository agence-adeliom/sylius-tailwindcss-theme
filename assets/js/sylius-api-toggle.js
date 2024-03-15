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

const SyliusApiToggle = (el) => {
  const element = el;
  const url = element.getAttribute('data-js-login-check-email-url');
  const toggleableElement = document.querySelector('[data-js-login="form"]');

  const debounce = (callback, duration) => {  
    // eslint-disable-next-line
    let timeout = null;

    return (...args) => {
      timeout = setTimeout(() => {
        callback.apply(this, args);
        timeout = null;
      }, duration);
    }
  }

  element.addEventListener('input', debounce((e) => {
    toggleableElement.classList.add('hidden');

    if (e.target.value.length > 3) {
      (async() => {
        try {
          const response = await fetcher(url + "?" + new URLSearchParams({ email: e.target.value }), { method: 'GET' } );
          response.ok ? toggleableElement.classList.remove('hidden') : toggleableElement.classList.add('hidden');
        } catch (error) {
          console.log(error)
        }
      })();
    }
  }, 1500));
};

export default SyliusApiToggle;
