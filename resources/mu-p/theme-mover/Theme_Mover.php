<?php

/**
 * Register a directory that contains themes.
 *
 *
 * @since      1.0.0
 * @package    Theme_Mover
 * @author     Charles Strube
 */
class Theme_Mover {

    /**
     * @var string
     * @access protected
     */
    protected $path, $theme;

    /**
     * construtor
     * @param    string  $target     Your directory
     * @access public
     */
    public function __construct($target) {
        $this->theme = $target;
        $this->path = WP_CONTENT_DIR . '/' . $this->theme;
        add_action( 'plugins_loaded', array( $this, 'creat_dir' ) );
    }


    /**
     * creat directory of the theme then init reg_theme method
     * @access public
     * @return bolean
     */
    public function creat_dir() {
        if ( !file_exists( $this->path ) ) {
            mkdir( $this->path, 0755, true );
        }
        $this->reg_theme();
        return true;
    }

    /**
     * creat directory of the theme
     * @access public
     * @return bolean
     */
    public function reg_theme() {
        register_theme_directory( $this->path );
    }
}
