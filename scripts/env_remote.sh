#!/bin/bash
export CLUSTER_PREFIX=remote-cluster-${USER}
export DRIVER_OPTIONS="--driver amazonec2 --amazonec2-security-group=default --engine-storage-driver=overlay --amazonec2-region=us-west-2"
export NET_ETH=eth0
export CLUSTER_NUM_NODES=8
export MASTER=${CLUSTER_PREFIX}-n0
