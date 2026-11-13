(() => {
  'use strict';
  const normalize = (text) => text.normalize('NFD').replace(/\p{M}/gu, '').toLocaleLowerCase('es').trim();

  for (const catalog of document.querySelectorAll('[data-catalog]')) {
    const controls = catalog.querySelector('[data-controls]');
    const field = controls.querySelector('[data-search]');
    const filters = [...controls.querySelectorAll('[data-filter]')];
    const empty = catalog.querySelector('[data-no-results]');
    const status = catalog.querySelector('[data-status]');
    const entries = [...catalog.querySelectorAll('[data-entry]')].map((entry) => ({
      entry,
      kinds: [].concat(JSON.parse(entry.dataset.kind) ?? []).map(normalize),
      text: normalize(entry.textContent)
    }));
    let category = '';

    const refresh = () => {
      const terms = normalize(field.value).split(/\s+/).filter(Boolean);
      let visible = 0;
      for (const { entry, kinds, text } of entries) {
        const haystack = text + ' ' + kinds.join(' ');
        entry.hidden = (category !== '' && !kinds.includes(category)) ||
          !terms.every((term) => haystack.includes(term));
        if (!entry.hidden) visible += 1;
      }
      if (empty) empty.hidden = visible !== 0;
      status.textContent = visible === 1 ? '1 resultado' : visible + ' resultados';
    };

    controls.hidden = false;
    field.addEventListener('input', refresh);
    filters.forEach((button) => button.addEventListener('click', () => {
      category = normalize(button.dataset.filter);
      for (const option of filters) option.setAttribute('aria-pressed', String(option === button));
      refresh();
    }));
  }
})();
