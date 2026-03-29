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
  const savedTheme = localStorage.getItem('color-theme');
  if (savedTheme) {
    document.documentElement.setAttribute('data-theme', savedTheme);
    const activeInput = document.querySelector(`.theme-controller[value="${savedTheme}"]`);
    if (activeInput) {
      activeInput.checked = true;
    }
  } else if (!('color-theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    //document.documentElement.setAttribute('data-theme', 'dark');
  }
}

export { SyliusToggleTheme, SyliusApplyTheme };
