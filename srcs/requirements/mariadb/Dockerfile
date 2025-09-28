FROM debian:12

RUN	apt update && \
	apt install -y --no-install-recommends --no-install-suggests \
	mariadb-server && \
	rm -rf /var/lib/apt/lists/*

#copy conf
COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/

#copy setup script
COPY	tools/setup.sh /bin/
RUN	chmod +x /bin/setup.sh

EXPOSE 3306

CMD	["setup.sh", "mysqld_safe"]