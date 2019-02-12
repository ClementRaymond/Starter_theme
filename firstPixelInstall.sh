#!/bin/bash

reset="\033[0m"
teal="\033[0;36m"
white="\033[1;37m"
red="\033[1;31m"
green="\033[0;32m"
Blue="\[\033[0;34m\]"

echo "Welcome to the ${white}starter theme ${reset}installation"

# create wp config
echo "${red}What php version are you using ?${white}"
current=7.2.1
read -p "Leave blank for 7.2.1: " version
version=${version:-${current}}
echo "$version\n"

# Pour faire marcher mysql sur mac.
export PATH=/Applications/MAMP/bin/php/php${version}/bin:$PATH
export PATH=$PATH:/Applications/MAMP/Library/bin/

#ask project name
echo "${red}What's the name of your project?${white}"
read project


echo "${reset}\n\n${teal}  __ _          _   ____  _          _"
echo "${reset}${teal} / _(_)_ __ ___| |_|  _ \(_)_  _____| |"
echo "${reset}${teal}| |_| |  __/ __| __| |_) | \ \/ / _ \ |"
echo "${reset}${teal}|  _| | |  \__ \ |_|  __/| |>  <  __/ |"
echo "${reset}${teal}|_| |_|_|  |___/\__|_|   |_/_/\_\___|_|\n\n${reset}"


# wordpress install
echo "${teal}Downloading WordPress${reset}"
wp core download --locale=fr_FR --path=app
echo "${green}Done\n${reset}"

##-----------moi-----------##

# create wp config
echo "${red}prefix for data base${white}"
random=$(openssl rand -hex 5)
read -p "Leave blank for auto generated prefix: " prefix
prefix=${prefix:-${random}wp_}
echo "$prefix\n"

echo "${red}Database host${white}"
echo "${green}Sur certains ordinateurs, utiliser 127.0.0.1 au lieu de localhost ${white}"
read -p "Leave blank for localhost: " db_host
db_host=${db_host:-localhost}
echo "$db_host\n"

echo "${red}Name for database${white}"
read -p "Leave blank for "$project" database name: " db_name
db_name=${db_name:-${project}}
echo "$db_name\n"

echo "${red}User for database${white}"
read -p "Leave blank for root: " db_user
db_user=${db_user:-root}
echo "$db_user\n"

echo "${red}Password for database${white}"
read -s -p "Leave blank for root: " db_pass
db_pass=${db_pass:-root}
echo "$db_pass\n"


echo "${red}Environnement of production${white}"
read -p "Leave blank for false: " environment
environment=${environment:-"false"}
echo "$environment"


echo '\n' >>.env
echo 'DB_HOST='${db_host} >> .env
echo 'DB_NAME='${db_name} >> .env
echo 'DB_USER='${db_user} >> .env
echo 'DB_PASSWORD='${db_pass} >> .env
echo 'DB_PREFIX='${prefix} >> .env
echo 'WP_ENVIRONMENT='${environment} >> .env

echo "\n"
wp core config --dbhost=${db_host} --dbname=${db_name} --dbuser=${db_user} --dbpass=${db_pass} --dbprefix=${prefix}

# Create database
wp db create

#launch instalation
echo "\n\n${teal}installation setting ${reset}\n\n"

echo "${red}url du serveur${white}"
read -p "Leave blank for http://localhost : " url_serveur
url_serveur=${url_serveur:-"http://localhost"}
echo "$url_serveur\n"

# Add WP_PATH to dotenv file
echo 'WP_PATH='${url_serveur} >> .env

echo "${red}admin user${white}"
random=$(openssl rand -hex 12)
read -p "Leave blank for starterTheme admin user: " admin_user
admin_user=${admin_user:-"clementRmd"}
echo "$admin_user\n"

echo "${red}admin mail${white}"
read -p "Leave blank for clement.rmd@yahoo.com: " admin_mail
admin_mail=${admin_mail:-"clement.rmd@yahoo.com"}
echo "$admin_mail\n"

echo "${red}admin pass${white}"
read -p "Password (Leave blank for auto generated password): " admin_pass
random=$(openssl rand -hex 12)
echo "$random\n"
admin_pass=${admin_pass:-${random}}

wp core install --url="${url_serveur}/${project}" --title="${project}" --admin_user="${admin_user}" --admin_email="${admin_mail}" --admin_password="${admin_pass}"
echo 'url_serveur='${url_serveur} >> .secret
echo 'admin_mail='${admin_mail} >> .secret
echo 'admin_user='${admin_user} >> .secret
echo 'admin_pass='${admin_pass} >> .secret

#swap default config
echo "${teal}language import ${reset}"
mkdir resources/languages
mv app/wp-content/languages resources/languages
rm -rf resources/languages/themes
echo "${green}Done\n${reset}"


echo "${teal}Change Wordpress core path${reset}"
#Change site url
wp option update siteurl ${url_serveur}'/'${project}'/app' --autoload='yes'
#change wp-config.php path
mv app/wp-config.php wp-config.php


# remove wp content folder
echo "${teal}Removing wp-content${reset}"
rm -rf app/wp-content
echo "${green}Done\n${reset}"

# plugin install
echo "${teal}Plugins installation${reset}"
cd builder/
composer install
cd ../
echo "${green}Done\n${reset}"

# writting .htaccess
echo "${teal}writting .htaccess${reset}"
echo "\n\n# Protect .env
<Files .env>
Order Allow,Deny
Deny from all
</Files>
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /${project}/
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /${project}/index.php [L]
</IfModule>
# END WordPress" >> .htaccess
echo "${green}Done\n${reset}"
# get the theme on git

#install custom theme
echo "${teal}Get the theme from git${reset}"
cd resources/t/
git clone git@github.com:ClementRaymond/my_theme.git
git flow init
cd ../../

# swap default config
echo "${teal}wp-config-sample swap${reset}"
mv configFirstPixel.php wp-config.php
echo "${green}Done\n${reset}"


echo "${teal}List of theme${reset}"
wp theme list
wp theme activate my_theme


echo "${teal}\nClean and init the theme${reset}"

#create page
wp post create --post_type=page --post_title='Accueil' --post_status=publish
wp post create --post_type=page --post_title='Mentions Légales' --post_status=publish

#change home page
wp option update show_on_front page
wp option update page_on_front 3


# clean
wp post delete 1 --force # Article exemple - no trash. Comment is also deleted
wp post delete 2 --force # page exemple

#export starter table
wp db export --add-drop-table

# rename folder
echo "${teal}Renaming folder${reset}"
DIR="${PWD##*/}"
echo "$DIR"
PWD
cd ../
mv "$DIR" "$project"
cd "$project"
echo "${green}Done\n${reset}"

# remove all git
echo "${teal}Removing old git${reset}"
find . -type d | grep .git | xargs rm -rf
find . -type d | grep .gitignore | xargs rm -rf
echo "${green}Done\n${reset}"


# git init
echo "${teal}Initialising git${reset}"
git init
git commit -m "initial commit"
echo "${green}Done\n${reset}"

# npm installation
cd builder
echo "${teal}Initialising npm${reset}"
yarn install || npm install
echo "${green}Done\n${reset}"
cd ..

# Writable right on upload directories
echo "${teal}Writable right on upload directories${reset}"
chmod -R 664 resources/files; chmod 775 resources/files
echo "${green}Done\n${reset}"

# post Setup
echo "${teal}Post setup${reset}"
yarn post-setup

# gulp
cd builder
echo "${teal}Setup gulp${reset}"
gulp run
echo "${green}Done\n${reset}"
cd ..

echo "${green}\nRemove firstPixelInstall.sh"
rm -rf firstPixelInstall.sh

#Installing Dploy
echo "\n"
dploy install

echo "${teal}Done, you can go to your new folder project with ${green}cd ../$project${reset}"
echo "${teal}Or go to your new website ${green} ${url_serveur}"/"${project}${reset}"
