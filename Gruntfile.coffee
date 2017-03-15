LIVERELOAD_PORT = 35729
#// lrSnippet is just a function.
#// It's a piece of Connect middleware that injects
#// a script into the static served html.
lrSnippet = require('connect-livereload')({port: LIVERELOAD_PORT})
#// All the middleware necessary to serve static files.
livereloadMiddleware = (connect, options) ->
	[
#// Inject a livereloading script into static files.
		lrSnippet,
#// Serve static files.
		connect.static(options.base),
#// Make empty directories browsable.
		connect.directory(options.base)
	]

module.exports = (grunt) ->
	grunt.config.init
		compass:
			example:
				options:
					sassDir: 'example'
					cssDir: 'example'
					outputStyle: 'compressed'
			src:
				options:
					sassDir: 'src'
					cssDir: 'dist'
					outputStyle: 'compressed'

		concat:
			source:
				files:
					'dist/angular-form-builder.js': ['src/components/*.js']
					'dist/core.js': ['src/core.js']


		coffee:
			options:
				sourceMap: true
			components:
				files:
					'dist/angular-form-builder-components.js': ['src/partials/*.coffee']
#			demo:
#				files:
#					'example/demo.js': 'example/demo.coffee'

		uglify:
			build:
				files:
					'dist/angular-form-builder.min.js': 'dist/angular-form-builder.js'
					'dist/angular-form-builder-components.min.js': 'dist/angular-form-builder-components.js'

		watch:
			compass:
				files: ['src/*.scss', 'index.html']
				tasks: ['compass']
				options:
					spawn: no
					livereload: LIVERELOAD_PORT
#										livereload: true
#										livereload:
#												host: 'localhost',
#												port: 9000,
#                        key: grunt.file.read('path/to/ssl.key'),
#                        cert: grunt.file.read('path/to/ssl.crt')
#    // you can pass in any other options you'd like to the https server, as listed here: http://nodejs.org/api/tls.html#tls_tls_createserver_options_secureconnectionlistener

			concat:
				files: ['src/components/*.js', 'src/core.js']
				tasks: ['concat']
				options:
					sourceMap: true
					spawn: no
					livereload: LIVERELOAD_PORT

			coffee:
				files: ['src/partials/*.coffee']
				tasks: ['coffee']
				options:
					sourceMap: true
					spawn: no
					livereload: LIVERELOAD_PORT
#										livereload: true
#										livereload:
#												host: 'localhost',
#												port: 9000,

		connect:
			server:
				options:
					protocol: 'http'
					hostname: '*'
					port: 8000
					base: '.'
#										livereload: true
#										middleware: livereloadMiddleware
#										livereload: true
				dev:
					options:
						middleware: (connect) ->
							[
								require('connect-livereload')() # < ---here
								checkForDownload
								mountFolder(connect, '.tmp')
								mountFolder(connect, 'app')
							]

		karma:
			min:
				configFile: 'test/karma-min.config.coffee'
			source:
				configFile: 'test/karma.config.coffee'

	# -----------------------------------
	# register task
	# -----------------------------------
	grunt.registerTask 'dev', [
		'compass'
		'concat'
		'coffee'
		'connect'
		'watch'
		'connect:client'
	]
	grunt.registerTask 'build', [
		'compass'
		'concat'
		'coffee'
		'uglify'
	]
	grunt.registerTask 'test', ['karma']

	#		grunt.registerTask 'preview', ['connect:client','watch:client']

	# -----------------------------------
	# Plugins
	# -----------------------------------
	grunt.loadNpmTasks 'grunt-contrib-compass'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-connect'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-karma'
	grunt.loadNpmTasks 'grunt-contrib-uglify'