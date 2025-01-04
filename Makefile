build: docker-build
up: docker-up
down: docker-down
restart: docker-down docker-up
init: docker-build docker-up bundle-install wait-db setup-db
reinit: docker-down-all docker-build docker-up bundle-install wait-db setup-db

db\:setup: up setup-db
bundle-install: up bin-bundle-install
bundle-add: up bin-bundle-install
routes: up rails-routes
generate: up rails-generate
db\:migrate: up migrate-db
db\:rollback: up rollback-db
db\:setup: up setup-db
db\:reset: up reset-db
db\:seed: up seed-db
rspec: up test
rubocop: up linter

docker-build:
	docker compose build --no-cache

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-all:
	docker-compose down -v --remove-orphans

bin-bundle-install:
	docker-compose exec -T health-keeper-app ./bin/bundle install

bin-bundle-add:
	docker-compose exec -T health-keeper-app ./bin/bundle add $(gem)

rails-routes:
	docker-compose exec -T health-keeper-app rails routes

rails-generate:
	docker-compose exec -T health-keeper-app rails generate $(options)

wait-db:
	until docker-compose exec -T health-keeper-postgres pg_isready --timeout=0 --dbname=app ; do sleep 1 ; done

migrate-db:
	docker-compose exec -T health-keeper-app rails db:migrate

STEP ?= 1
rollback-db:
	docker-compose exec -T health-keeper-app rails db:rollback STEP=$(STEP)

setup-db:
	docker-compose exec -T health-keeper-app rails db:setup

reset-db:
	docker-compose exec -T health-keeper-app rails db:reset

seed-db:
	docker-compose exec -T health-keeper-app rails db:seed

sh:
	docker-compose exec $(c) sh

logs:
	docker-compose logs --tail=0 --follow

test:
	docker-compose exec -T health-keeper-app rspec

options ?=
linter:
	docker-compose exec -T health-keeper-app rubocop $(options)
