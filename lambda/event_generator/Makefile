.PHONY: default down install lambda lint run test up

default:
	echo "Target required"

down:
	docker-compose down

install:
	asdf install
	npm install -g npm@7
	cd app; npm install

lambda:
	docker-compose up --build event_generator

lint:
	cd app; npm run lint; npm run format-check

run: up

test:
	cd app; npm run test

up: lambda
