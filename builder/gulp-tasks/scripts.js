//js
var gulp       = require('gulp');
var plumber    = require('gulp-plumber');
var notify     = require('gulp-notify');
var uglify     = require('gulp-uglify');
var browserify = require('browserify'); // use 'gulp-browserify' if using old js handler
var babelify   = require('babelify');
var concat     = require('gulp-concat');
var path       = require('./path.js');
var rename     = require('gulp-rename');
var env        = require('babel-preset-env');
var sourcemaps = require('gulp-sourcemaps');
var source     = require('vinyl-source-stream');
var buffer     = require('vinyl-buffer');


module.exports = function (gulp, callback) {

    var onError = function(err) {
        notify.onError({
            title:    "Gulp",
            subtitle: "Failure!",
            message:  "Error: <%= error.message %>"//,
            //sound:    "Beep"
        })(err);
        this.emit('end');
    };
    gulp.src(path + '/src/js/copy/*.js')
		.pipe(plumber({
			errorHandler: function (error) {
				console.log(error.message);
				this.emit('end');
			}
		}))
		//.pipe(uglify())
        .pipe(gulp.dest(path + '/dist/scripts/'));

    // Browserify + Babel
    return Promise.all([
        new Promise(function (resolve, reject) {
            browserify({
                entries     : path + '/src/js/app.js',
                debug       : true,
            })
                .transform('babelify', {presets: [env]})
                .bundle()
                .on('error', notify.onError({title: 'Gulp: scripts'}))
                .pipe(source('bundle.js'))
                .pipe(buffer())
                .pipe(sourcemaps.init({loadMaps: true }))
                .pipe(sourcemaps.write('./'))
                .pipe(gulp.dest(path + '/dist/scripts/'))
                .on('end', resolve);
        })
    ]).then(function () {
        return gulp.src(path + '/dist/scripts/bundle.js')
            .pipe(rename({suffix: '.min'}))
            .pipe(uglify())
            .pipe(gulp.dest(path + '/dist/scripts/'))
            .pipe(notify({
                title: 'Gulp Scripts',
                subtitle: 'Fuck Yeah !',
                message: 'JS task'
            }));
    });

    /**
     * Old js handler:
     */

    /* return gulp.src(path + '/src/js/app.js')
        .pipe(plumber({
            errorHandler: function (error) {
                console.log(error.message);
                this.emit('end');
            }
        }))
		.pipe(browserify())
        .pipe(concat('bundle.js'))
        .pipe(gulp.dest(path + '/dist/scripts/'))
        .pipe(rename({suffix: '.min'}))
        .pipe(uglify())
        .pipe(gulp.dest(path + '/dist/scripts/'))
    	.pipe(notify({
    		title: 'Gulp Scripts',
    		subtitle: 'Fuck Yeah !',
    		message: 'JS task'
    	})); */

};
