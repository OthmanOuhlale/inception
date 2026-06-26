#!/bin/bash 

until mysqladmin ping -h mariadb -u root -p${MYSQL_ROOT_PASSWORD} --silent; do
    echo "wait MariaDB"
    sleep 2
done

cd /var/www/html

if [ ! -f wp-config.php]; then

    wp core download --allow-root

    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --url=https://${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root

    wp user create \
        ${WP_USER} \
        ${WP_USER_EMAIL} \
        --user_role=author \
        --user_passwors=${$WP_USER_PASSWORD} \
        --allow-root
    
fi

sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' \
    /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php

exec php-fpm7.4 -F