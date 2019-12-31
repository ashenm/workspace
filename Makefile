TRAVIS_REPO_SLUG?=ashenm/workspace
TRAVIS_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)

.PHONY: help
.SILENT: help
help: ## show make targets
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: install
install: ## install build requisits
	docker pull ashenm/workspace:latest

.PHONY: build
build: install ## build docker image
	docker build -t "$(TRAVIS_REPO_SLUG):$(TRAVIS_BRANCH)" .

.PHONY: deploy
deploy: build ## deploy image to docker hub
	echo "$${DOCKER_PASSWORD:?Missing Docker password!}" | \
		docker login --username "$${DOCKER_USERNAME:?Missing Docker username!}" --password-stdin
	docker push "$(TRAVIS_REPO_SLUG):$(TRAVIS_BRANCH)"

.PHONY: clean
clean: ## remove local docker images
	docker images --all --filter reference="$(TRAVIS_REPO_SLUG):$(TRAVIS_BRANCH)" --format "{{.ID}}" | \
		xargs --no-run-if-empty docker rmi >> /dev/null
