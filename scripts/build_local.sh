#!/bin/bash
source ./scripts/local_env_vars.sh
docker-machine create $DRIVER_OPTIONS ${CLUSTER_PREFIX}-ks
docker $(docker-machine config ${CLUSTER_PREFIX}-ks) run -d -p "8500:8500" -h "consul" progrium/consul -server -bootstrap
KEYSTORE_IP=$(docker-machine ip ${CLUSTER_PREFIX}-ks)
SWARM_OPTIONS="--swarm --swarm-discovery=consul://$KEYSTORE_IP:8500 --engine-opt=cluster-store=consul://$KEYSTORE_IP:8500 --engine-opt=cluster-advertise=$NET_ETH:2376"
MASTER_OPTIONS="$DRIVER_OPTIONS $SWARM_OPTIONS --swarm-master -engine-label role=master"
docker-machine create $MASTER_OPTIONS $MASTER
eval $(docker-machine env --swarm $MASTER)
docker-compose up -d master
export WORKER_OPTIONS="$DRIVER_OPTIONS $SWARM_OPTIONS"
create_node() {
    docker-machine create ${WORKER_OPTIONS} $1-n$2
}
export -f create_node
parallel -j0 --no-run-if-empty create_node ::: ${CLUSTER_PREFIX} ::: $(seq -s ' ' 1 $CLUSTER_NUM_NODES)
eval $(docker-machine env --swarm $MASTER)
docker-compose scale master=1 worker=$CLUSTER_NUM_NODES
