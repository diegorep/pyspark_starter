.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-local: env-local ## Builds the cluster on a local environment
	sh scripts/build_local.sh

env-local: ## Set local environment variables
	source scripts/env_local.sh && sh scripts/env_local.sh

test-local: ## Locally run unit tests with nose
	docker-compose run --rm data nosetests tests/

pyspark-local: ## Open up a pyspark terminal
	docker-compose run --rm data pyspark

bash-local: ## Open a bash shell on the local cluster
	docker-compose run --rm data /bin/bash

clean-local: ## Tear down local cluster
	sh scripts/teardown_local.sh

build-remote: env-remote ## Builds the cluster on aws
	sh scripts/env_remote.sh && scripts/build_remote.sh

env-remote: ## Set environment to point to aws cluster
	source scripts/env_remote.sh && sh scripts/env_remote.sh

deploy: build-remote ## Build remote cluster and launch cron
	echo Not implemented yet

clean-remote: ## Tear down aws cluster
	sh scripts/teardown_remote.sh
