#-f flag: use this file as Compose conf instead of default docker-compose.yml in current dir
COMPOSE_FILE = -f srcs/docker-compose.yml
HOST_URL = lgottsch.42.fr


build:
	docker compose $(COMPOSE_FILE) build
	sudo sed -i "/[[:space:]]$(HOST_URL)$/d" /etc/hosts
	sudo sed -i "\$a127.0.0.1 $(HOST_URL)" /etc/hosts

up: create dir
	docker compose $(COMPOSE_FILE) up -d 

down:
	docker compose $(COMPOSE_FILE) down

status:
	docker ps


create dir:
	@mkdir -p ~/data/wordpress
	@mkdir -p ~/data/database