.DEFAULT_GOAL=help

.PHONY: assess
assess: ## test docker image
	./scripts/assess

.PHONY: build
build: install ## build docker image
	./scripts/build

.PHONY: clean
clean: ## remove locally built images
	./scripts/clean

.PHONY: culminate
culminate: build ## trigger reverse dependency builds
	./scripts/culminate

.PHONY: deploy
deploy: ## deploy image to docker hub
	./scripts/deploy

.PHONY: help
.SILENT: help
help: ## show make targets
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: install
install: ## install build requisites
	./scripts/install

.PHONY: purge
purge: ## remove dangling deployed images
	./scripts/purge

.PHONY: run
run: ## spawn container from locally built image
	./scripts/workspace --blank --image ashenm/workspace:alpha
