#!/bin/bash

#read secrets
WP_ADMIN_PASSWORD=$(cat /run/secrets/db_root_password)
WP_PASSWORD=$(cat /run/secrets/db_password)


#change ownership of wp files to www-data user
chown -R www-data:www-data /var/www/inception/

#move wp-config.php file to wp folder if not there yet
if [ ! -f /var/www/inception/wp-config.php ]; then
	mv /tmp/wp-config.php /var/www/inception/
fi

#download wordpress
sleep 10
wp --allow-root --path="/var/www/inception/" core download || true

#if wp not there yet, install wp, else skip
if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
    wp  --allow-root --path="/var/www/inception/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
fi;


#create non-admin user and set its role
if ! wp --allow-root --path="/var/www/inception/" user get $WP_USER;
then
    wp  --allow-root --path="/var/www/inception/" user create \
        $WP_USER \
        $WP_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=$WP_ROLE
fi;


#start php server 
exec $@