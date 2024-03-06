module.exports = {
    root: true,
    env: {
        browser: true,
        es2024: true,
    },
    extends: [
        "eslint:recommended",
    ],
    parserOptions: {
        sourceType: "module"
    },
    globals: {
        Translator: 'readonly',
    },
};
