/** @type {import('tailwindcss').Config} */
const plugin = require('tailwindcss/plugin');
module.exports = {
  darkMode: ['selector', '[data-theme="dark"]'],
  content: [
    './assets/**/*.js',
    './themes/**/assets/**/*.js',
    './templates/**/*.html.twig',
    './themes/**/*.html.twig',
  ],
  safelist: [
    'alert-success',
    'alert-warning',
    'alert-info',
    'alert-error',
    'textarea',
  ],
  theme: {
    fontFamily: {
      body: ['"Inter", sans-serif'],
    },
    container: {
      center: true,
      padding: {
        DEFAULT: "1rem",
        sm: "2.5rem",
        md: "2.25rem",
        lg: "2.75rem",
        xl: "2.5rem",
        "2xl": "3rem",
      },
    },
  },
  daisyui: {
    darkTheme: "dark",
    themes: [
      {
        light: {
          "primary": "#177c68",
          "primary-content": "#FFFFFF",
          "secondary": "#48485C",
          "secondary-content": "#FFFFFF",
          "accent": "#B7B1AD",
          "neutral": "#eee",
          "neutral-content": "#000000",
          "base-100": "#FFFFFF",
          "base-content": "#222327",
          "success": "#177c68",
          "success-content": "#FFFFFF",
          "warning": "#FBAB24",
          "warning-cotent": "#FFFFFF",
          "info": "#48485C",
          "info-content": "#FFFFFF",
          "error": "#F87171",
          "error-content": "#FFFFFF",
          'light-content': "#FFFFFF",
        },
        dark: {
          "primary": "#198A73",
          "primary-content": "#FFFFFF",
          "secondary": "#162434",
          "secondary-content": "#FFFFFF",
          "accent": "#99938F",
          "neutral": "#1E2E3E",
          "neutral-content": "#FFFFFF",
          "base-100": "#0D141C",
          "base-content": "#e9f3f1",
          "success": "#177c68",
          "success-content": "#FFFFFF",
          "warning": "#D98B06",
          "warning-cotent": "#FFFFFF",
          "error": "#DC2626",
          "error-content": "#FFFFFF",
          "info-content": "#FFFFFF",
          "light-content": "#FFFFFF",
        },
        adeliom: {
          "primary": "#8c46ff",
          "primary-content": "#FFFFFF",
          "secondary": "#ec2e69",
          "secondary-content": "#FFFFFF",
          "accent": "#fcb900",
          "accent-content": "#fff",
          "neutral": "#eee",
          "neutral-content": "#0a0a0a",
          "base-100": "#FFFFFF",
          "base-content": "#0a0a0a",
          "success": "#8c46ff",
          "success-content": "#FFFFFF",
          "warning": "#FBAB24",
          "warning-cotent": "#FFFFFF",
          "info": "#48485C",
          "info-content": "#FFFFFF",
          "error": "#ec2e69",
          "error-content": "#FFFFFF",
          'light-content': "#FFFFFF",
        },
      },
    ],
  },
  plugins: [
    // Ajout de variants custom
    plugin(function ({ addVariant }) {
      addVariant('is-loading', ['&.is-loading', '.is-loading &']);
      addVariant('keyboard', '.tab-ative &');
    }),
    require("daisyui")
  ],
};
