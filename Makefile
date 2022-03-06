.DEFAULT_GOAL=help
DEFAULT_BRANCH=master

.PHONY: assess
assess: ## test all images
	./pants test ::

.PHONY: assess-affected
assess-affected:
	./pants --changed-since=$(DEFAULT_BRANCH) --changed-dependees=transitive test

.PHONY: build
build: install ## build all images
	./pants package ::

.PHONY: build-affected
build-affected:
	./pants --changed-since=$(DEFAULT_BRANCH) --changed-dependees=transitive package

.PHONY: deploy
deploy: ## deploy all images to docker hub
	./pants publish ::

.PHONY: deploy-affected
deploy-affected:
	./pants --changed-since=$(DEFAULT_BRANCH) --changed-dependees=transitive publish

.PHONY: help
.SILENT: help
help: ## show make targets
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: install
install: ## install build requisites
	./src/latest/scripts/init-filesystem
	./src/railsbank/scripts/init-filesystem
