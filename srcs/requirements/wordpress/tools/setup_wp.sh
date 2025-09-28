#!/bin/bash

host="$DB_HOST"
user="$DB_USER"
pass="$DB_PASSWORD"

until mariadb -h "$host" -u "$user" -p"$pass" -e "SELECT 1;" > /dev/null 2>&1; do
  echo "Waiting for MariaDB at $host..."
  sleep 2
done

echo "MariaDB is up, starting WordPress..."

#TODO as env later
# WP_URL=lgottsch.42.fr
# WP_TITLE=InceptionLGOTTSCH
# WP_ADMIN_USER=theroot
# WP_ADMIN_PASSWORD=rootpw
# WP_ADMIN_EMAIL=theroot@123.com
# WP_USER=wp_user
# WP_PASSWORD=db_pw
# WP_EMAIL=theuser@123.com
# WP_ROLE=editor

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