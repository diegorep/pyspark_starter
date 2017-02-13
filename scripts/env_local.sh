#!/bin/bash
export CLUSTER_PREFIX=local-cluster-${USER}
export DRIVER_OPTIONS="--driver virtualbox"
export NET_ETH=eth1
export MASTER=${CLUSTER_PREFIX}-n0
export CLUSTER_NUM_NODES=8
