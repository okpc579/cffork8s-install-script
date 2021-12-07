#!/bin/bash

source variables.yml

kapp deploy -a sidecar -f manifest/cf-for-k8s-rendered.yml
