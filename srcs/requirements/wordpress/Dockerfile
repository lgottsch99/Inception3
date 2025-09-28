FROM debian:12

RUN apt update -y && apt upgrade -y

#install php + all dependemcies
RUN apt install --no-install-recommends --no-install-suggests -y \
	ca-certificates \
	php8.2-fpm php8.2-mysql \
	wget \
	tar && \
	rm -rf /var/lib/apt/lists/*

ARG		PHPPATH=/etc/php/8.2/fpm

RUN		service php8.2-fpm stop

#copy conf
COPY	conf/www.conf ${PHPPATH}/pool.d/

#change some values in conf files (sed -i stream editor, -i in place: cli tool to find &replace text inside files, -i make change directly)
#pattern: sed -i 's/<search>/<replace>/g' <file>
RUN		sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHPPATH}/php.ini && \
		sed -i "s/listen = \/run\/php\/php$PHP_VERSION_ENV-fpm.sock/listen = 9000/g" ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;daemonize = yes/daemonize = no/g' ${PHPPATH}/pool.d/www.conf

#download wordpress
RUN	wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

#create folders needed by wp
RUN	mkdir -p /run/php/ && \
	mkdir -p /var/run/php/ && \
	mkdir -p /var/www/inception/

#change owner to www-data
RUN	chown -R www-data:www-data /var/www/inception/

COPY	conf/wp-config.php /tmp/

COPY	tools/setup_wp.sh /bin/
RUN		chmod +x /bin/setup_wp.sh

EXPOSE 9000

CMD		["setup_wp.sh", "php-fpm8.2", "--nodaemonize"]

