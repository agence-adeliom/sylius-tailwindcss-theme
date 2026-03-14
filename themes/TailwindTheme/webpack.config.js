const path = require('path');

// @tailwindcss/node uses process.env.NODE_PATH to build its CSS resolver (enhanced-resolve).
// Without this, it can't find 'tailwindcss' because node_modules lives in the test-application
// directory, not in any ancestor of the theme CSS files.
const testAppNodeModules = path.resolve(__dirname, '../../vendor/sylius/test-application/node_modules');
process.env.NODE_PATH = testAppNodeModules;

const Encore = require(require.resolve('@symfony/webpack-encore', {
    paths: [path.resolve(__dirname, '../../vendor/sylius/test-application/node_modules')]
}));

Encore
  .setOutputPath('public/themes/tailwind-theme')
  .setPublicPath('/themes/tailwind-theme')
  .addEntry('app', '../../../themes/TailwindTheme/assets/index.js')
  .enableSassLoader()
  .enablePostCssLoader((options) => {
    options.postcssOptions = {
      config: false,
      plugins: [
        ['@tailwindcss/postcss', {}],
      ],
    };
  })
  .disableSingleRuntimeChunk()
  .cleanupOutputBeforeBuild()
  .enableIntegrityHashes()
  .enableSassLoader()
  .enableSourceMaps(!Encore.isProduction())
  .enableVersioning(Encore.isProduction())
;

const config = Encore.getWebpackConfig();
config.name = 'tailwindTheme';

module.exports = config;
