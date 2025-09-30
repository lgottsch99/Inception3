# DONT FORGET TO ADD DOMAIN NAME to /etc/hosts file -> "127.0.0.1  DOMAIN_NAME"


#-f flag: use this file as Compose conf instead of default docker-compose.yml in current dir
COMPOSE_FILE = -f srcs/docker-compose.yml

build:
	docker compose $(COMPOSE_FILE) build

up: create dir
	docker compose $(COMPOSE_FILE) up -d 

down:
	docker compose $(COMPOSE_FILE) down

status:
	docker ps


create dir:
	@mkdir -p ~/data/wordpress
	@mkdir -p ~/data/database