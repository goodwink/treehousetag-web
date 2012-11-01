exports.config =
  # See docs at http://brunch.readthedocs.org/en/latest/config.html.
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/
        'js/vendor.js': /^vendor/
        'test/scenarios.js': /^test(\/|\\)e2e/
      order:
        before: [
          'vendor/scripts/console-helper.js'
          'vendor/scripts/base/jquery-1.8.2.js'
          'vendor/scripts/base/jquery-ui-1.9.0.custom.js'
          'vendor/scripts/angular/angular.js'
          'vendor/scripts/angular/angular-resource.js'
          'vendor/scripts/angular/angular-cookies.js'
        ]

    stylesheets:
      joinTo:
        'css/app.css': /^(app|vendor)/
    templates:
      joinTo: 'js/templates.js'

  # Enable or disable minifying of result js / css files.
  # minify: true
