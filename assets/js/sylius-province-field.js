/*
 * This file is part of the Sylius package.
 *
 * (c) Paweł Jędrzejewski
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

/* eslint-env browser */

import axios from 'axios';

const getProvinceInputValue = function getProvinceInputValue(valueSelector) {
  const val = valueSelector ? valueSelector.value : null;
  return !val || val == undefined ? '' : `value="${val}"`;
};


const SyliusProvinceField = function SyliusProvinceField() {
  const countrySelect = document.querySelectorAll('select[name$="[countryCode]"]');
  const changeEvent = new Event('change');

  countrySelect.forEach((countrySelectItem) => {
    countrySelectItem.addEventListener('change', (event) => {
      const select = event.currentTarget;
      const provinceContainer = document.querySelector('[data-parent="' + select.id + '"]');

      const provinceSelectFieldName = select.getAttribute('name').replace('country', 'province');
      const provinceInputFieldName = select.getAttribute('name').replace('countryCode', 'provinceName');

      const provinceSelectFieldId = select.getAttribute('id').replace('country', 'province');
      const provinceInputFieldId = select.getAttribute('id').replace('countryCode', 'provinceName');

      if (select.value === '' || select.value == undefined) {
        provinceContainer.innerHTML = '';
        return;
      }

      provinceContainer.setAttribute('data-loading', '');

      axios.get(provinceContainer.getAttribute('data-url'), { params: { countryCode: select.value } })
        .then((response) => {
          if (!response.data.content) {
            provinceContainer.removeAttribute('data-loading');
            provinceContainer.innerHTML = '';
          } else if (response.data.content.indexOf('select') !== -1) {
            const provinceSelectValue = getProvinceInputValue((
              provinceContainer.querySelector('select > option[selected$="selected"]')
            ));

            provinceContainer.innerHTML = response.data.content
              .replace('<label', '<label class="label"')
              .replace('name="sylius_address_province"', `name="${provinceSelectFieldName}"${provinceSelectValue}`)
              .replace('id="sylius_address_province"', `id="${provinceSelectFieldId}"`)
              .replace('option value="" selected="selected"', 'option value=""')
              .replace(`option ${provinceSelectValue}`, `option ${provinceSelectValue}" selected="selected"`);

            provinceContainer.querySelector('select').classList.add('select');
            provinceContainer.querySelector('select').classList.add('select-bordered');
            provinceContainer.querySelector('select').classList.add('w-full');
            provinceContainer.removeAttribute('data-loading');
          } else {
            const provinceInputValue = getProvinceInputValue(provinceContainer.querySelector('input'));

            provinceContainer.innerHTML =
              response.data.content
              .replace('</label>', '</label><div class="input input-bordered flex items-center gap-2">')
              .replace('<label', '<label class="label"')
              .replace('name="sylius_address_province"', `name="${provinceInputFieldName}"${provinceInputValue}`)
              .replace('id="sylius_address_province"', `id="${provinceInputFieldId}"`)
              + '</div>';

            provinceContainer.querySelector('input').classList.add('grow');
            provinceContainer.querySelector('input').classList.add('w-full');
            provinceContainer.removeAttribute('data-loading');
          }
        });
    });

    if (countrySelectItem.value !== '') {
      countrySelectItem.dispatchEvent(changeEvent);
    }
  });
};

export default SyliusProvinceField;
