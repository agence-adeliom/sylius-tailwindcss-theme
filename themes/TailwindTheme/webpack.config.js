Encore
  .setOutputPath('public/themes/tailwind-theme')
  .setPublicPath('/themes/tailwind-theme')
  .addEntry('app', './themes/TailwindTheme/assets/index.js')
  .copyFiles({
        from: './themes/TailwindTheme/assets/media',
        to: 'media/[path][name].[hash:8].[ext]',
        pattern: /\.(png|jpe?g|gif|svg|webp)$/
  })
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
