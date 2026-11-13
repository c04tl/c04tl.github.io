(() => {
  'use strict';
  const root = document.documentElement;
  try {
    if (localStorage.getItem('c04tl-theme') === 'light') root.dataset.theme = 'light';
  } catch {}
  document.addEventListener('DOMContentLoaded', () => {
    const menu = document.getElementById('menu-toggle');
    const nav = document.getElementById('main-nav');
    const smallScreen = matchMedia('(max-width: 690px)');
    const updateMenu = (open) => {
      menu.hidden = !smallScreen.matches;
      menu.setAttribute('aria-expanded', String(open));
      nav.hidden = smallScreen.matches && !open;
    };
    updateMenu(false);
    smallScreen.addEventListener('change', () => updateMenu(false));
    menu.addEventListener('click', () => updateMenu(menu.getAttribute('aria-expanded') !== 'true'));
    nav.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && smallScreen.matches) { updateMenu(false); menu.focus(); }
    });
    const toggle = document.getElementById('theme-toggle');
    const sync = () => toggle.setAttribute('aria-pressed', String(root.dataset.theme === 'light'));
    toggle.hidden = false;
    sync();
    toggle.addEventListener('click', () => {
      root.dataset.theme = root.dataset.theme === 'light' ? 'dark' : 'light';
      try { localStorage.setItem('c04tl-theme', root.dataset.theme); } catch {}
      sync();
    });
  });
})();
