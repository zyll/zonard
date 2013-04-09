module.exports = (grunt)->

  grunt.initConfig
    karma:
      options:
        configFile: 'karma.conf.js'
        reporter: ['list']
      assets:
        background: true
    watch:
      libs:
        files: ['**/*.coffee', 'libs/**/*.coffee']
        tasks: ['karma:assets:run']

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-karma'

  grunt.registerTask 'default', ['jshint', 'karma']
