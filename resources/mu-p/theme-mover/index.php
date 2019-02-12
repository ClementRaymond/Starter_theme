<?php
/*
Plugin Name: Theme Mover
Description: Provides an additional location for themes. You don't need the creat the directory.
Version: 1.0.0
Author: Charles Strube
Author URI: http://www.charlesstrube.com
*/


require_once( dirname(__FILE__) . '/Theme_Mover.php' );

// change the name of your directory here
$myFolder = 't';

new Theme_Mover($myFolder);
