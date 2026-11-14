.PHONY: build run push clean

build:
	./version_tag.sh
	docker compose build web
run:
	docker compose up -d
push:
	docker compose push web
clean:
	docker compose down
	docker images -f "dangling=true" -f "reference=umeshdulara/flask-app" -q | xargs -r docker rmi || true
