const SyliusToggleTheme = () => {
  const themeToggleInputs = document.querySelectorAll('.theme-controller');
  if (!themeToggleInputs) {
    return;
  }
  themeToggleInputs.forEach((themeToggleInput) => {
    themeToggleInput.addEventListener('click', function(event) {
      const theme = event.target.value;
      localStorage.setItem('color-theme', theme);
    });
  });
}

const SyliusApplyTheme = () => {

  if (
    localStorage.getItem('color-theme')
  ) {
    document.documentElement.setAttribute('data-theme', localStorage.getItem('color-theme'));
  } else if (!('color-theme' in localStorage) &&
    window.matchMedia('(prefers-color-scheme: dark)').matches) {
    document.documentElement.setAttribute('data-theme', 'dark');
  }
}

export { SyliusToggleTheme, SyliusApplyTheme };
