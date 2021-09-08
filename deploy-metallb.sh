#!/bin/bash
source variables.yml

mkdir manifest -p

kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml

awk -v metallb_cidr="$metallb_cidr" 'NR==12{print "      - "metallb_cidr}1' support-files/metallb_config.yml > manifest/metallb_config.yml

kubectl apply -f manifest/metallb_config.yml
