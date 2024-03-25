const Encore = require('@symfony/webpack-encore');

Encore
  .setOutputPath('public/themes/tailwind-theme')
  .setPublicPath('/themes/tailwind-theme')
  .addEntry('app', './themes/TailwindTheme/assets/index.js')
  .enablePostCssLoader()
  .enableSassLoader()
  .disableSingleRuntimeChunk()
  .cleanupOutputBeforeBuild()
  .enableSourceMaps(!Encore.isProduction())
  .enableVersioning(Encore.isProduction());

const config = Encore.getWebpackConfig();
config.name = 'tailwindTheme';

module.exports = config;
