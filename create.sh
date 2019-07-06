#!/bin/bash

set -e

gcloud container clusters create my-cluster --machine-type=g1-small --num-nodes=2

gcloud compute addresses create irc-ip --region us-west1

IP=$(gcloud compute addresses list --format='value(address)' --limit=1)
perl -p -i -e "s/loadBalancerIP: .*/loadBalancerIP: $IP/" resources.yml

kubectl create secret generic irc-config \
	--from-file=configs/catbox-0.conf \
	--from-file=configs/catbox-1.conf \
	--from-file=configs/certificate.pem \
	--from-file=configs/key.pem \
	--from-file=configs/opers.conf \
	--from-file=configs/servers.conf \
	--from-file=configs/users.conf

kubectl apply -f resources.yml
