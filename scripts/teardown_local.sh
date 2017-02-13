CLUSTER_PREFIX=local-cluster-${USER}
docker-machine rm -y $(docker-machine ls | grep "^${CLUSTER_PREFIX}" | cut -d\  -f1 | xargs)
