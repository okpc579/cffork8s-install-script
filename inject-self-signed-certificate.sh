#!/bin/bash
source variables.yml

if [[ ${app_registry_kind} = "dockerhub" ]]; then
  REGISTRY_PATH=${app_registry_id}
elif [[ ${app_registry_kind} = "private" ]]; then
  REGISTRY_PATH=${app_registry_address}/${app_registry_repository}
fi

ytt -f ./support-files/cert-injection-webhook/deployments/k8s \
    -v pod_webhook_image=paastakr/pod-webhook-image \
    -v setup_ca_certs_image=paastakr/setup-ca-certs-image \
    --data-value-file ca_cert_data=${app_registry_cert_path} \
    --data-value-yaml labels="[kpack.io/build, private-repo-cert-injection]"  > support-files/cert-injection-webhook/manifest.yaml

cat << EOF >> support-files/cert-injection-webhook/manifest.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: cert-injection-webhook
EOF

kapp deploy -a cert-injection-webhook -f ./support-files/cert-injection-webhook/manifest.yaml -y

