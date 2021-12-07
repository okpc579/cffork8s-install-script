#!/bin/bash

source variables.yml

kapp deploy -a paasta -f manifest/cf-for-k8s-rendered.yml
