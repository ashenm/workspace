.PHONY: help
.SILENT: help
help: ## show make targets
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: build
build: install ## build docker image
	./scripts/build.sh

.PHONY: assess
assess: ## test docker image
	./scripts/assess.sh

.PHONY: clean
clean: ## remove locally built images
	./scripts/clean.sh

.PHONY: culminate
culminate: ## trigger reverse dependency builds
	./scripts/culminate.sh

.PHONY: deploy
deploy: ## deploy image to docker hub
	./scripts/deploy.sh

.PHONY: install
install: ## install build requisites
	./scripts/install.sh

.PHONY: purge
purge: ## remove dangling deployed images
	./scripts/purge.sh

.PHONY: run
run: ## spawn container from locally built image
	./scripts/run.sh --alpha --dry
