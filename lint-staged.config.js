module.exports = {
    'templates/**/*.twig': [
      'vendor/bin/twigcs templates/ --severity error --display blocking',
    ],
    'assets/**/*.js': [
      'eslint --fix'
    ],
    'assets/**/*.css': [
      'stylelint --fix --no-cache'
    ]
};
