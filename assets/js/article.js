(() => {
  'use strict';

  const outline = document.querySelector('.toc details');
  if (outline) {
    const wideScreen = matchMedia('(min-width: 72rem)');
    const updateOutline = () => { outline.open = wideScreen.matches; };
    updateOutline();
    wideScreen.addEventListener('change', updateOutline);
    outline.addEventListener('click', (event) => {
      const link = event.target.closest('a');
      if (!link || wideScreen.matches) return;
      outline.open = false;
      outline.querySelector('summary').focus({ preventScroll: true });
    });
  }

  for (const block of document.querySelectorAll('.post-content pre')) {
    const wrapper = document.createElement('div');
    wrapper.className = 'code-block';
    const toolbar = document.createElement('div');
    toolbar.className = 'code-toolbar';
    const status = document.createElement('span');
    status.setAttribute('role', 'status');
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'code-copy';
    button.textContent = 'Copiar';
    button.setAttribute('aria-label', 'Copiar bloque de código');
    toolbar.append(status, button);
    block.before(wrapper);
    wrapper.append(toolbar, block);

    button.addEventListener('click', async () => {
      status.textContent = '';
      try {
        const code = block.querySelector('code') || block;
        await navigator.clipboard.writeText(code.textContent);
        status.textContent = 'Copiado';
      } catch {
        status.textContent = 'Selecciona el código para copiarlo manualmente.';
      }
    });
  }
})();
