#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR/../..; pwd` 
RESOURCE_ROOT="$WORKSPACE_ROOT/base/example"

set -x

# Creating the Redis Deployment:
echo ""
kubectl apply -f "$RESOURCE_ROOT/redis-leader-deployment.yaml"
kubectl get pods

# Creating the Redis leader Service
echo ""
kubectl apply -f "$RESOURCE_ROOT/redis-leader-service.yaml"
kubectl get pods

# Set up Redis followers 
echo ""
kubectl apply -f "$RESOURCE_ROOT/redis-follower-deployment.yaml"
kubectl get pods

# Creating the Redis follower service 
echo ""
kubectl apply -f "$RESOURCE_ROOT/redis-follower-service.yaml"
kubectl get service

# Creating the Guestbook Frontend Deployment
echo ""
kubectl apply -f "$RESOURCE_ROOT/frontend-deployment.yaml"
kubectl get pods -l app=guestbook -l tier=frontend

# Creating the Frontend Service
echo ""
kubectl apply -f "$RESOURCE_ROOT/frontend-service.yaml"
kubectl get services -l tier=frontend
