const path = require('path');
const Encore = require(require.resolve('@symfony/webpack-encore', {
    paths: [path.resolve(__dirname, '../../vendor/sylius/test-application/node_modules')]
}));

Encore
  .setOutputPath('public/themes/tailwind-theme')
  .setPublicPath('/themes/tailwind-theme')
  .addEntry('app', '../../../themes/TailwindTheme/assets/index.js')
  .enableSassLoader()
  .enablePostCssLoader()
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
