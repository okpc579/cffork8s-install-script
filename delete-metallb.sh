#!/bin/bash

kubectl delete -f manifest/metallb_config.yml
kubectl delete -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml