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
    watch:
      dist:
        files: 'lib/zonehandler.coffee'
        tasks: ['coffee:dist']
      example:
        files: 'example/image.coffee'
        tasks: ['coffee:example']

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-karma'

  grunt.registerTask 'default', ['coffee', 'karma']
