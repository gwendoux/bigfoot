module.exports = (grunt) ->
  baseStyles = [
    'src/less/foundation/bigfoot-variables.less'
    'src/less/foundation/bigfoot-mixins.less'
    'src/less/base/bigfoot-button.less'
    'src/less/base/bigfoot-popover.less'
  ]
  variants = [
    'bottom'
    'number'
  ]

  concatSet =
    options:
      stripBanners: true
      banner: "// <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today('yyyy.mm.dd') %>\n\n\n"
      separator: "\n\n\n// -----\n\n\n"

    main:
      src: baseStyles
      dest: 'dist/bigfoot-default.less'

  lessSet = 'dist/bigfoot-default.css': 'dist/bigfoot-default.less'
  autoprefixSet = 'dist/bigfoot-default.css': 'dist/bigfoot-default.css'
  cssMinSet = 'dist/bigfoot-default.min.css': 'dist/bigfoot-default.css'

  variants.forEach (variant) ->
    css = "dist/bigfoot-#{variant}.css"
    less = css.replace('.css', '.less')
    src = less.replace('dist/', 'src/less/variants/')
    conc = baseStyles.slice(0)
    conc.push src
    concatSet[variant] =
      src: conc
      dest: less

    lessSet[css] = less
    autoprefixSet[css] = css


  # 1. CONFIG
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    uglify:
      build:
        src: 'dist/bigfoot.js'
        dest: 'dist/bigfoot.min.js'

    concat: concatSet

    coffee:
      dist:
        src: 'src/coffee/bigfoot.coffee'
        dest: 'dist/bigfoot.js'

    less:
      dist:
        files: lessSet

    autoprefixer:
      dist:
        files: autoprefixSet

    watch:
      options:
        livereload: false

      coffee:
        files: ['src/coffee/bigfoot.coffee']
        tasks: ['coffee', 'uglify']
        options:
          spawn: false

      less:
        files: ['src/**/*.less']
        tasks: [
          'concat'
          'less'
          'autoprefixer'
        ]
        options:
          spawn: false


  # 2. TASKS
  require('load-grunt-tasks') grunt

  # 3. PERFORM
  grunt.registerTask 'default', [
    'coffee'
    'uglify'
    'concat'
    'less'
    'autoprefixer'
  ]

  grunt.registerTask 'styles', [
    'concat'
    'less'
    'autoprefixer'
  ]

  grunt.registerTask 'scripts', [
    'coffee'
    'uglify'
  ]
