# firstPixel boilerplate
-	Dependendices:
    -   WP-CLI
    -   composer
    -   npm
    -   gulp
    -   git
-	Version: 0.5.1
-	Requires at least: 2.9.0
-	Tested up to: 4.7.3
-	License: GPLv2 or later
-	License URI: http://www.gnu.org/licenses/gpl-2.0.html

## Install
Installation du projet via shell
```shell
$ npm run-script setup
```

## Work
Pour lancer le gulp
```shell
$ gulp run
$ gulp
```
Si gulp non installé en global
```shell
$ npm start
```

## Configuration
Configurations du theme éventuelles
wp-config.php
```php
/** production of not (final website) */
define('PRODUCTION', false);

/** Define if the website is https or not. */
define('FP_SSL', true);
```

## Code


### HTML
functionnalité html sous form de className

#### downarr
fleche de scroll vers un element
```html
<button class="downarr styled" data-scrollto="#section-first"></button>
<a name="section-first" id="section-first"></a>
```

#### fullscreen
Ajout de la className fullscreen pour rendre fullscreen la div
```html
<div class="fullscreen"></div>
```

### SCSS
Documentation de [Foundation](http://foundation.zurb.com/sites/docs/)
Customisation de foundation : `resources/t/firstPixel/src/scss/partials/_foundation-settings.scss`

#### function custom
##### px-to-rem
function qui transform les px en rem
```scss
top: px-to-rem( 12px );
// ou
top: px-to-rem( 12 );
```

#### mixin custom
##### fp_transform
mixin qui apporte le support pour ie9
```scss
@include fp_transform( translateX(100%) rotate(90deg) );
```

##### font-size
mixin qui gere toutes les unités de taille de font
```scss
@include font-size( 12px );
```

##### align
mixin pour aligner l'element en absolute (le parent doit etre en position relatif)
```scss
@include align; // vertical et horizontal
@include align(v); // vertical
@include align(h); // horizontal
```

### JS
#### Browserify
Browserify est utiliser pour importer et exporter des scripts
```js
var monExport = function () {
    console.log('Hello World');
};
module.exports = monExport;
```
```js
var monImport = require('./maFunction.js');
var obj = new monImport();
```

#### Core
##### Animation

animate with requestAnimationFrame

```Js
require('./core/animation/Animate.js');

var initial = 0;    // initial value
var target  = 100;  // target value

var myAnimation = new Animate();

myAnimation
    .request(function () {
        var progression = myAnimation.interpolation(initial, target);
        console.log(progression); // animation
    }, function () {
        console.log(target); // callback
        console.log('done'); // callback
    });
```

```Js
require('./core/animation/Animate.js');

var initial  = Window.scrollY;  // initial value
var target   = 2400;            // target value
var easing   = 'bounce';        // easing style
var fps      = 60;              // frames per second
var duration = 500;             // duration in ms


var myAnimation = new Animate();

myAnimation
    .setDuration(duration)  // 500 ms (optionnal)
    .setEase(easing)        // easing style (optionnal)
    .setFps(fps)            // frames per second (optionnal)
    .request(function () {
        window.scrollTo(0, myAnimation.interpolation(initial, target)); // animation
    }, function () {
        window.scrollTo(0, scrollTargetY); // callback
    });
```

##### scrollToY
Function to scroll to with ease
```js
var scrollToY = require('./core/scroll/scrollToY.js');
var target    = 1000; // pixels
var speed     = 1000; // second
var ease      = 'swingTo'; //easing
scrollToY(target, speed, ease);
```

### php
#### Date converter
```php
<?php
$oldDate   = '20170921'
$oldFormat = 'Ymd'
$newDate   = new DateConverter( $oldFormat, $oldDate);

$newFormat = 'd/m/Y'
echo $newDate->getDate($newFormat); // 21/09/2017


$newFormat = 'D d F Y'
echo $newDate->getDate($newFormat); // Lundi 21 septembre 2017
```
