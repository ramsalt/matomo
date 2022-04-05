#!/bin/bash
set -euo pipefail

UNAME="${1:-}"

if [ -z "${UNAME}" ]; then
    echo -e "Usage:\n\t$0 username\n"
    exit 2
fi

# Cluster Name (get it from the current context)
CURRENT_CONTEXT=$(kubectl config view --minify -o jsonpath='{.current-context}')
CLUSTER_NAME=$(kubectl config view --minify -o json | jq -r '.contexts[] | select(.name == "'${CURRENT_CONTEXT}'") | .context.cluster')
CLIENT_CERTIFICATE_DATA=$(kubectl get csr ${UNAME} -o jsonpath='{.status.certificate}')
CLUSTER_CA=$(kubectl config view --raw -o json | jq -r '.clusters[] | select(.name == "'${CLUSTER_NAME}'") | .cluster."certificate-authority-data"')
CLUSTER_ENDPOINT=$(kubectl config view --raw -o json | jq -r '.clusters[] | select(.name == "'${CLUSTER_NAME}'") | .cluster."server"')

CLIENT_KEY_DATA=$(base64 -w0 < ${UNAME}.key)

envsubst <<_EOF_
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${CLUSTER_CA}
    server: ${CLUSTER_ENDPOINT}
  name: ${CLUSTER_NAME}
users:
- name: ${UNAME}
  user:
    client-certificate-data: ${CLIENT_CERTIFICATE_DATA}
    client-key-data: ${CLIENT_KEY_DATA}
contexts:
- context:
    cluster: ${CLUSTER_NAME}
    user: ${UNAME}
  name: ${UNAME}-${CLUSTER_NAME}
current-context: ${UNAME}-${CLUSTER_NAME}
_EOF_
