module.exports = (grunt)->

  grunt.initConfig
    karma:
      options:
        configFile: 'karma.conf.js'
        reporter: ['list']
      assets:
        background: true
    coffee:
      dist:
        files:
          'dist/zonehandler.js': 'lib/zonehandler.coffee'
      example:
        files:
          'example/image.js': 'example/image.coffee'
          'example/crop.js': 'example/crop.coffee'
          'example/resize.js': 'example/resize.coffee'
          'example/canvas/crop_canvas.js': 'example/canvas/crop_canvas.coffee'
          'example/canvas/canvas.js': 'example/canvas/canvas.coffee'
    watch:
      dist:
        files:
          'lib/zonehandler.coffee'
        tasks: ['coffee:dist']
      example:
        files: ['example/image.coffee','example/crop.coffee', 'example/resize.coffee', 'example/canvas/crop_canvas.coffee', 'example/canvas/canvas.coffee']
        tasks: ['coffee:example']

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-karma'

  grunt.registerTask 'default', ['coffee', 'karma']
