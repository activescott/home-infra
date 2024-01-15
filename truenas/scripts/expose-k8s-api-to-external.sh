#!/bin/bash

set -x

/sbin/iptables -D INPUT -p tcp -m tcp --dport 6443 -m comment --comment "iX Custom Rule to drop connection requests to k8s cluster from external sources" -j DROP

