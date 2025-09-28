#!/bin/bash

service mariadb start

DB_PASS_ROOT=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)


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