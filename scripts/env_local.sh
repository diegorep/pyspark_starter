#!/bin/bash
source ./scripts/local_env_vars.sh
cluster_status=$(docker-machine status ${CLUSTER_PREFIX}-n0)
ret_code=$? 
if [ $ret_code = 0 ]; then
    echo '# Your cluster state: ' $cluster_status
    echo '# Run this command to configure your shell:'
    echo '# source scripts/local_env_vars.sh && eval $(docker-machine env --swarm' ${CLUSTER_PREFIX}-n0 ')'
fi
