include .env

NAME := $(or $(BASE_IMAGE),$(BASE_IMAGE),drupalwxt/site-wxt)
VERSION := $(or $(VERSION),$(VERSION),'latest')

all: base docker_build

base:
	docker build -f docker/Dockerfile \
	    -t $(NAME):$(VERSION) \
	    --no-cache \
		.

build: all

docker_build:
	docker-compose build --no-cache
	docker-compose up -d

drupal_install:
	@echo "Begin install..."
	docker-compose exec web /app/docker/bin/cli drupal-first-run $(PROFILE_NAME)

drupal_migrate:
	docker-compose exec web /app/docker/bin/cli drupal-migrate

phpcs:
	docker run -i --entrypoint=/app/docker/bin/phpcs \
    --volumes-from $(DOCKER_NAME)_web \
    --rm \
	$(DOCKER_NAME)_web

sh:
	docker-compose exec web bash

test: phpcs

## CONTAINER COMMANDS

up:
	@echo "Starting up containers for $(DOCKER_NAME)..."
	docker-compose --env-file=./.env up -d --remove-orphans

down:
	@echo "Shutting down and removing containers for $(DOCKER_NAME)..."
	@docker-compose down

stop:
	@echo "Stopping containers for $(DOCKER_NAME)..."
	@docker-compose stop

shell:
	@docker-compose exec php bash

.PHONY: \
	all \
	base \
	build \
	docker_build \
	drupal_install \
	drupal_migrate \
	phpcs \
	test \
	up \
	down \
	stop
