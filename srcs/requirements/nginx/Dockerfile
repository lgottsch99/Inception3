FROM debian:12

RUN		apt update && apt install -y --no-install-recommends --no-install-suggests \
		nginx \
		openssl && \
		rm -rf /var/lib/apt/lists/*

ARG CERT_FOLDER CERTIFICATE KEY DOMAIN


#generate tsl certs, CN=common name of cert, domain name that the certificate is valid for
RUN mkdir -p ${CERT_FOLDER} && \
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out ${CERTIFICATE} \
    -keyout ${KEY} \
    -subj "/CN=${DOMAIN}"

COPY	conf/nginx.conf		/etc/nginx/
COPY	conf/server.conf	/etc/nginx/conf.d/

#complete server conf file (SAFER: otherwise sensitive info (where certs live) public)
RUN	echo "\tserver name ${COMMON_NAME};\n\
	\tssl_certificate ${CERTIFICATE};\n\
	\tssl_certificate_key ${KEY};\n\
	}" >> /etc/nginx/conf.d/server.conf

#create folder for wp files
RUN	mkdir -p /var/www/
RUN	chown -R www-data:www-data /var/www/

EXPOSE 443

CMD	["nginx", "-g", "daemon off;"]