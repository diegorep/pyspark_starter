.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-local: ## Builds the cluster on a local environment
	sh scripts/build_local.sh

env-local: ## Set shell environment to point to local cluster
	sh scripts/env_local.sh

restart-local: ## Start/Restart the local cluster
	sh scripts/restart_local.sh

clean-local: ## Tear down local cluster
	sh scripts/teardown_local.sh

build-remote: ## Builds the cluster on aws
	scripts/build_remote.sh

env-remote: ## Set shell environment to point to remote cluster
	sh scripts/env_remote.sh

restart-remote: ## Start/Restart the remote cluster
	sh scripts/restart_remote.sh

clean-remote: ## Tear down aws cluster
	sh scripts/teardown_remote.sh

pyspark: ## Open up a pyspark terminal on the active master node
	docker-compose run --rm master pyspark

bash: ## Open a bash shell on the active cluster
	docker-compose run --rm master /bin/bash

unittest: ## Run unit test suite on active cluster
	docker-compose run --rm master nosetests tests

loadtest: ## Run load tests on active cluster
	echo Not implemented yet

deploy: ## Build deployment cluster and launch cron
	echo Not implemented yet
