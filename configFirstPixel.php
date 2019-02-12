<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

define('WP_CACHE', true);
define('WP_MEMORY_LIMIT', '256M');
define( 'GF_LICENSE_KEY', '0e5b4a8ea227d1df35df6fe27381c67d' );


// ======================= FIRSTPIXEL ======================== //
require_once(__DIR__ . '/builder/vendor/autoload.php');
(new \Dotenv\Dotenv(__DIR__.'/'))->load();

/** production of not (final website) */
if(getenv('WP_ENVIRONMENT')=="false")
{ define('PRODUCTION', false);}
else{{ define('PRODUCTION', true);}}
/** Define if the website is https or not. */
define('FP_SSL', false);
// =========================================================== //

// ** MySQL settings - You can get this info from your web host ** //
/** Nom de la base de données de WordPress. */
define('DB_NAME', getenv('DB_NAME'));

/** Utilisateur de la base de données MySQL. */
define('DB_USER', getenv('DB_USER'));

/** Mot de passe de la base de données MySQL. */
define('DB_PASSWORD', getenv('DB_PASSWORD'));

/** Adresse de l’hébergement MySQL. */
define('DB_HOST', getenv('DB_HOST'));

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');



/** configuration... don't touch */
if ( FP_SSL == true ) {
    define('FORCE_SSL_ADMIN', true);
    if ( strpos( $_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
        $_SERVER['HTTPS'] = 'on';
}


/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = getenv('DB_PREFIX');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
if(!PRODUCTION){
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
}
else
{
define('WP_DEBUG', false);
define('WP_DEBUG_LOG', false);
}

/** force download without FTP */
define('FS_METHOD','direct');

/**
 * server folder (change when you're going live)
 */
// $folder_serveur = PRODUCTION ? '' : '/' . basename(__DIR__);
$folder_serveur = PRODUCTION ? '/'  : getenv('WP_PATH');

/**
 * wp-content folder
 */


$folder_content = 'resources';

$url = FP_SSL ? "https" : "http";

define( 'WP_CONTENT_DIR',   dirname(__FILE__) . '/' . $folder_content ); // Do not remove. Removing this line could break your site. Added by Security > Settings > Change Content Directory.
define( 'WP_CONTENT_URL',   $url . '://' . $_SERVER['HTTP_HOST'] . $folder_serveur . '/' . $folder_content ); // Do not remove. Removing this line could break your site. Added by Security > Settings > Change Content Directory.
define( 'WP_PLUGIN_DIR',    WP_CONTENT_DIR . '/' . 'p' );
define( 'WP_PLUGIN_URL',    WP_CONTENT_URL . '/' . 'p');
define( 'PLUGINDIR',        WP_CONTENT_DIR . '/' . 'p' );
define( 'WPMU_PLUGIN_DIR',  WP_CONTENT_DIR . '/' . 'mu-p' );
define( 'WPMU_PLUGIN_URL',  WP_CONTENT_URL . '/' . 'mu-p');
define( 'UPLOADS',         '../'.$folder_content . '/' . 'files' );

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
