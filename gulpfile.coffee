gulp = require 'gulp'
gutil = require 'gulp-util'
rename = require 'gulp-rename'
concat = require 'gulp-concat'
streamify = require 'streamify'
browserify = require 'browserify'
watchify = require 'watchify'
source = require 'vinyl-source-stream'
uglify = require 'gulp-uglify'
stylus = require 'gulp-stylus'
extend = require 'extend'
nib = require 'nib'

productionDir = './dist'



gulp.task 'concat-css', ['stylus'], ->
	gulp.src(['./node_modules/hibb-modal/dist/main.css', './dist/main.css'])
		.pipe(concat("main.css"))
		.pipe(gulp.dest("./dist"))

gulp.task 'stylus', ->
	createCSS()

createCSS = ->
	gutil.log('Creating CSS')
	gulp.src('./src/main.styl')
		.pipe(stylus(
			use: [nib()]
			errors: true
		))
		.pipe(gulp.dest(productionDir))

minify = ->
	gulp.src("#{productionDir}/index.js")
		.pipe(uglify())
		.pipe(rename(extname: '.min.js'))
		.pipe(gulp.dest(productionDir))

createBundle = (watch=false) ->
	args =
		entries: './src/main.coffee'
		extensions: ['.coffee', '.jade']

	args = extend args, watchify.args if watch

	bundle = ->
		# Create bundle
		gutil.log('Browserify: bundling')
		bundler.bundle(standalone: 'hibb-login')
			.on('error', ((err) -> gutil.log("Bundling error ::: "+err)))
			.pipe(source("index.js"))
			.pipe(gulp.dest(productionDir))

		minify()

	bundler = browserify args
	if watch
		bundler = watchify(bundler)
		bundler.on 'update', bundle

	bundler.exclude 'jquery'
	bundler.exclude 'backbone'
	bundler.exclude 'underscore'

	bundler.transform 'coffeeify'
	bundler.transform 'jadeify'

	bundle()

gulp.task 'browserify', -> createBundle false
gulp.task 'watchify', -> createBundle true

gulp.task 'browserify-libs', ->
	libs =
		jquery: './node_modules/jquery/dist/jquery'
		backbone: './node_modules/backbone/backbone'
		underscore: './node_modules/underscore/underscore'

	paths = Object.keys(libs).map (key) -> libs[key]

	bundler = browserify paths

	for own id, path of libs
		bundler.require path, expose: id

	gutil.log('Browserify: bundling libs')
	bundler.bundle()
		.pipe(source("libs.js"))
		.pipe(gulp.dest(productionDir))

gulp.task 'watch', ['watchify'], ->
	gulp.watch ['./src/main.styl', './node_modules/hibb-modal/dist/main.css'], ['concat-css']

gulp.task 'default', ['watch']