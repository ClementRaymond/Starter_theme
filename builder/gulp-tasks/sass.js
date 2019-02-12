var gulp         = require('gulp');
var plumber      = require('gulp-plumber');
var notify       = require('gulp-notify');
var rename       = require('gulp-rename');
var autoprefixer = require('gulp-autoprefixer');
var cleanCSS     = require('gulp-clean-css');
var sass         = require('gulp-sass');
var sourcemaps   = require('gulp-sourcemaps');
var path         = require('./path.js');

module.exports = function (gulp, callback) {
    var onError = function(err) {
        notify.onError({
            title:    "Gulp",
            subtitle: "Failure!",
            message:  "Error: <%= error.message %>"
        })(err);
        this.emit('end');
    };

    gulp.src(path + '/src/scss/copy/*.css')
    .pipe(plumber({
        errorHandler: function (error) {
            console.log(error.message);
            this.emit('end');
        }
    }))
    //.pipe(uglify())
    .pipe(gulp.dest(path + '/dist/styles/'));


    return gulp.src([path + '/src/scss/**/*.scss'])
        .pipe(plumber({
            errorHandler: function (error) {
                console.log(error.message);
                this.emit('end');
            }})
        )
        .pipe(sourcemaps.init())
        .pipe(sass())
        .pipe(autoprefixer({browsers: ['> 1%', 'IE 9', 'Safari 7', 'iOS 7']}))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest(path + '/dist/styles/'))
        .pipe(rename({
            suffix: '.min'
        }))
        .pipe(cleanCSS())
        .pipe(gulp.dest(path + '/dist/styles/'))
        .pipe(notify({
            title: 'Gulp styles',
            subtitle: "Let's Rock",
            message: 'Sass task'
        }));
};

//
// gulp.task('css', function(){
//
//
// });
