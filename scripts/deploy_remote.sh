export CLUSTER_PREFIX=c${USER}
export DRIVER_OPTIONS="--driver amazonec2 --amazonec2-security-group=default --engine-storage-driver=overlay --amazonec2-region=us-west-2"
docker-machine create $DRIVER_OPTIONS --amazonec2-instance-type=t2.micro ${CLUSTER_PREFIX}ks
docker $(docker-machine config ${CLUSTER_PREFIX}ks) run -d -p "8500:8500" -h "consul" progrium/consul -server -bootstrap
NET_ETH=eth0
KEYSTORE_IP=$(aws ec2 describe-instances | jq -r ".Reservations[].Instances[] | select(.KeyName==\"${CLUSTER_PREFIX}ks\" and .State.Name==\"running\") | .PrivateIpAddress")
SWARM_OPTIONS="--swarm --swarm-discovery=consul://$KEYSTORE_IP:8500 --engine-opt=cluster-store=consul://$KEYSTORE_IP:8500 --engine-opt=cluster-advertise=$NET_ETH:2376"
MASTER_OPTIONS="$DRIVER_OPTIONS $SWARM_OPTIONS --swarm-master -engine-label role=master --amazonec2-instance-type=m4.large"
export MASTER=${CLUSTER_PREFIX}n0
docker-machine create $MASTER_OPTIONS --amazonec2-instance-type=m4.large $MASTER
eval $(docker-machine env --swarm $MASTER)
docker-compose up -d master
WORKER_OPTIONS="$DRIVER_OPTIONS $SWARM_OPTIONS --amazonec2-request-spot-instance --amazonec2-spot-price=0.074 --amazonec2-instance-type=m4.2xlarge"
CLUSTER_NUM_NODES=11
parallel -j0 --no-run-if-empty --line-buffer docker-machine create $WORKER_OPTIONS < <(for n in $(seq 1 $CLUSTER_NUM_NODES); do echo "${CLUSTER_PREFIX}n$n"; done)
