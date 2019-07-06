#!/bin/bash

set -e

gcloud container clusters create my-cluster --machine-type=g1-small --num-nodes=2

gcloud compute addresses create irc-ip --region us-west1

IP=$(gcloud compute addresses list --format='value(address)' --limit=1)
perl -p -i -e "s/loadBalancerIP: .*/loadBalancerIP: $IP/" resources.yml

kubectl create secret generic servers-config --from-file=servers.conf
kubectl create configmap      certificate    --from-file=certificate.pem
kubectl create secret generic tls-key        --from-file=key.pem
kubectl create secret generic opers-config   --from-file=opers.conf
kubectl create secret generic users-config   --from-file=users.conf

kubectl apply -f resources.yml
