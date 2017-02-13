CLUSTER_PREFIX=c${USER}
CLUSTER_NUM_NODES=11
docker-machine rm -y $(docker-machine ls | grep "^${CLUSTER_PREFIX}" | cut -d\  -f1 | xargs)
delete_key_pair() {
  aws ec2 delete-key-pair --no-dry-run --key-name $2n$1
  echo Deleted key pair: $2n$1
}
export -f delete_key_pair
parallel -j0 --no-run-if-empty delete_key_pair ::: $(seq -s ' ' 0 ${CLUSTER_NUM_NODES}) ks ::: ${CLUSTER_PREFIX}
