#!/bin/bash

service mariadb start


# DB_NAME=wordpress
# DB_USER=wp_user
# DB_PASSWORD=db_pw
# DB_PASS_ROOT=rootpw

#create DB and user
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;

CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';

GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
EOF

#restart server to apply changes
sleep 5
service mariadb stop


#restart server with next CMD passed by dockerfile
exec $@