/*
 * This file is part of the Sylius package.
 *
 * (c) Paweł Jędrzejewski
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

/* eslint-env browser */

import SyliusRating from './sylius-rating';
import SyliusToggle from './sylius-toggle';
import SyliusAddToCart from './sylius-add-to-cart';
import SyliusRemoveFromCart from './sylius-remove-from-cart';
import SyliusApiToggle from './sylius-api-toggle';
import SyliusApiLogin from './sylius-api-login';
import SyliusVariantsPrices from './sylius-variants-prices';
import SyliusVariantImages from './sylius-variant-images';
import SyliusProvinceField from './sylius-province-field';
import SyliusAddressBook from './sylius-address-book';
import SyliusLoadableForms from './sylius-loadable-forms';
import { SyliusToggleTheme, SyliusApplyTheme } from './sylius-toggle-theme';
import '@fortawesome/fontawesome-free/scss/solid.scss';
import '@fortawesome/fontawesome-free/scss/brands.scss';
import '@fortawesome/fontawesome-free/scss/fontawesome.scss';

document.addEventListener('DOMContentLoaded', () => {

  // Add to cart
  document.querySelectorAll('[data-js-add-to-cart="form"]')
    .forEach(el => SyliusAddToCart(el));

  // Remove from cart
  document.querySelectorAll('[data-js-remove-from-cart-button]')
    .forEach(el => SyliusRemoveFromCart(el));

  // Province field
  SyliusProvinceField();

  // Address book
  const syliusShippingAddress = document.querySelector('[data-js-address-book="sylius-shipping-address"]');
  if (syliusShippingAddress && syliusShippingAddress.querySelector('.select-book-address')) {
    SyliusAddressBook(syliusShippingAddress);
  }
  const syliusBillingAddress = document.querySelector('[data-js-address-book="sylius-billing-address"]');
  if (syliusBillingAddress && syliusBillingAddress.querySelector('.select-book-address')) {
    SyliusAddressBook(syliusBillingAddress);
  }

  // Variant prices
  SyliusVariantsPrices();

  // Star rating
  document.querySelectorAll('[data-js-rating]').forEach((elem) => {
    new SyliusRating(elem, {
      onRate(value) {
        document.querySelector(`#sylius_product_review_rating_${value - 1}`).checked = true;
      },
    });
  });

  // Toggle and login from checkout
  if (document.querySelector('[data-js-login]')) {
    SyliusApiToggle(document.querySelector('[data-js-login="email"]'));
    SyliusApiLogin(document.querySelector('[data-js-login]'));
  }

  // Toggle billing address on the checkout page
  document.querySelectorAll('[data-js-toggle]').forEach(elem => new SyliusToggle(elem));

  // Product images for variants
  if (document.querySelector('[data-variant-options], [data-variant-code]')) { new SyliusVariantImages(); }

  // Loadable forms
  SyliusLoadableForms();

  // Toggle themes
  SyliusToggleTheme();
});

// Apply theme
SyliusApplyTheme();
