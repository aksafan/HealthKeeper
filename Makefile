build: docker-build
up: docker-up
down: docker-down
restart: docker-down docker-up
init: docker-build docker-up bundle-install wait-db setup-db
reinit: docker-down-all docker-build docker-up bundle-install wait-db setup-db

docker-build:
	docker compose build --no-cache

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-all:
	docker-compose down -v --remove-orphans

bundle-install:
	docker-compose exec -T health-keeper-app ./bin/bundle install

bundle-add:
	docker-compose exec -T health-keeper-app ./bin/bundle add $(gem)

routes:
	docker-compose exec -T health-keeper-app rails routes

generate:
	docker-compose exec -T health-keeper-app rails generate $(options)

wait-db:
	until docker-compose exec -T health-keeper-postgres pg_isready --timeout=0 --dbname=app ; do sleep 1 ; done

migrate-db:
	docker-compose exec -T health-keeper-app rails db:migrate

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
rubocop:
	docker-compose exec -T health-keeper-app rubocop $(options)
