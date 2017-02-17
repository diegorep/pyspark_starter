#!/bin/bash
CLUSTER_PREFIX=sparkswarm
DRIVER_OPTIONS="--driver amazonec2 --amazonec2-ami=ami-1e299d7e --amazonec2-region=us-west-2 --amazonec2-security-group=allow-all --amazonec2-ssh-keypath=$HOME/.ssh/id_rsa"
docker-machine create $DRIVER_OPTIONS --amazonec2-instance-type=t2.nano ${CLUSTER_PREFIX}consul
