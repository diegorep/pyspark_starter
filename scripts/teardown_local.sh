#!/bin/bash
source scripts/local_env_vars.sh
docker-machine rm -y $(docker-machine ls | grep "^${CLUSTER_PREFIX}" | cut -d\  -f1 | xargs)
