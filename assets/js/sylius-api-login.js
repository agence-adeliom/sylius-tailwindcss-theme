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

const SyliusApiLogin = (el) => {
  const element = el;
  const signInButton = element.querySelector('.btn');
  const validationField = element.querySelector('.alert');
  const url = signInButton.getAttribute('data-js-login-url');
  const emailField = element.querySelector('input[type="email"]');
  const passwordField = element.querySelector('input[type="password"]');
  const csrfTokenField = element.querySelector('input[type="hidden"]');
  const csrfTokenName = csrfTokenField.getAttribute('name');

  signInButton.addEventListener('click', (e) => {
    e.preventDefault();

    const params = new URLSearchParams();
    params.append('_username', emailField.value);
    params.append('_password', passwordField.value);
    params.append([csrfTokenName], csrfTokenField.value);

    (async() => {
      try {
        const response = await fetcher(url, { method: 'POST', body: params });
        const data = await response.json();
        if (data.success) {
          window.location.reload();
        } else {
          validationField.classList.remove('hidden');
          validationField.innerHTML = data.message;
        }
      } catch (error) {
        console.log(error);
      }
    })();
  });
};

export default SyliusApiLogin;
