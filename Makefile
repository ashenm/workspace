.DEFAULT_GOAL=help

.PHONY: assess
assess: ## test docker image
	./pants test ::

.PHONY: build
build: install ## build docker image
	./pants package ::

.PHONY: deploy
deploy: ## deploy image to docker hub
	./pants publish ::

.PHONY: help
.SILENT: help
help: ## show make targets
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: install
install: ## install build requisites
	./src/latest/scripts/init-filesystem
	./src/railsbank/scripts/init-filesystem
