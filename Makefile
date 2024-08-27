include .env

docker.network:
	@echo "Verifying/Creating docker network: $(DOCKER_NETWORK)"
	@docker network inspect $(DOCKER_NETWORK) >/dev/null 2>&1 || docker network create --driver bridge $(DOCKER_NETWORK)

docker.start: docker.network
	@echo "Starting the application: $(APPLICATION)"
	@if [ -f "./script/$(APPLICATION)/pre.sh" ]; then echo "Executing Pre Script"; sh ./script/$(APPLICATION)/pre.sh; fi
	@docker compose --project-name $(APPLICATION) --file ./lib/docker-compose-$(APPLICATION).yml --env-file .env up --build --detach
	@if [ -f "./script/$(APPLICATION)/post.sh" ]; then echo "Executing Post Script"; sh ./script/$(APPLICATION)/post.sh; fi

docker.stop:
	@echo "Stopping the application: $(APPLICATION)"
	@docker rm --force $(shell docker ps --filter label=com.docker.compose.project=$(APPLICATION) --all --quiet)

docker.clean:
	@echo "Cleaning the application: $(APPLICATION)"
	@docker volume rm --force $(shell docker volume ls --filter "label=com.docker.compose.project=$(APPLICATION)" --format '{{.Name}}')