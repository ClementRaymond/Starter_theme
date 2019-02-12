var gulp    = require('gulp');
var plumber = require('gulp-plumber');
var path    = require('./path.js');

// gulp.task('copy', function () {
//
// 	//favicon
// 	gulp.src([path + '/src/favicon/**/*'])
// 		.pipe(gulp.dest(path + '/dist/favicon/'));
//
// 	//fonts
// 	gulp.src([path + '/src/fonts/**/*'])
// 		.pipe(gulp.dest(path + '/dist/fonts/'));
//
// });


module.exports = function (gulp, callback) {
    //favicon
	gulp.src([path + '/src/favicon/**/*'])
		.pipe(gulp.dest(path + '/dist/favicon/'));

	//fonts
	gulp.src([path + '/src/fonts/**/*'])
		.pipe(gulp.dest(path + '/dist/fonts/'));
};
