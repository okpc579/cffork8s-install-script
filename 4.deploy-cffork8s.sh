#!/bin/bash

source variables.yml



if [[ ${use_metallb} = "true" ]]; then
	mkdir manifest -p
	kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml
	awk -v metallb_cidr="$metallb_cidr" 'NR==12{print "      - "metallb_cidr}1' support-files/metallb_config.yml > manifest/metallb_config.yml
	kubectl apply -f manifest/metallb_config.yml
elif [[ ${use_metallb} = "false" ]]; then
	echo "MetalLB deploy Check"
	METALLBCHECK=$(kubectl get ns metallb-system)
	if [[ $METALLBCHECK =~ "metallb-system" ]]; then
		echo "MetalLB is installed -> delete MetalLB" 
	    kubectl delete -f manifest/metallb_config.yml
		kubectl delete -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml
		echo "Continue cffork8s install" 
	else
	    echo "MetalLB is not installed -> Continue cffork8s install" 
	fi
fi
else
	echo "plz check variables.yml : use_metallb"
	exit 1
fi

kapp deploy -a paasta -f manifest/cf-for-k8s-rendered.yml -y