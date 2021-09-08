#!/bin/bash

source variables.yml

while [ 1 ]; do
read -p "Are you want delete cffork8s? (y/n) " RESP
if [ "$RESP" = "y" ] || [ "$RESP" = "Y" ] || [ "$RESP" = "yes" ] || [ "$RESP" = "YES" ]; then
  break
elif [ "$RESP" = "n" ] || [ "$RESP" = "N" ] || [ "$RESP" = "no" ] || [ "$RESP" = "NO" ]; then
  echo "delete canceled"
  return
else
  echo "plz input y or n"
fi
done

echo "delete cffork8s"
kapp delete -a paasta -y


if [[ ${use_metallb} = "true" ]]; then
	echo "MetalLB deploy Check"
	METALLBCHECK=$(kubectl get ns metallb-system)
	if [[ $METALLBCHECK =~ "metallb-system" ]]; then
		kubectl delete -f manifest/metallb_config.yml
		kubectl delete -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml 
		echo "delete MetalLB"
	else
	    echo "MetalLB is not installed -> END" 
	fi
elif [[ ${use_metallb} = "false" ]]; then

else
	echo "plz check variables.yml : use_metallb"
	exit 1
fi