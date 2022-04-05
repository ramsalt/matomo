#!/bin/bash
set -euo pipefail

UNAME="${1:-}"

if [ -z "${UNAME}" ]; then
    echo -e "Usage:\n\t$0 username\n"
    exit 2
fi

echo -e "\nWARNING:\nThis will overwrite any existing key/certificate for user ${UNAME}!\n"
read -p "Enter yes to continue, anything else to abort: " y
echo

if [ "${y}" != "yes" ]; then
    echo "Aborting."
    exit 0
fi

openssl genrsa -out ${UNAME}.key 4096
openssl req -new -subj "/CN=${UNAME}/O=${UNAME}" -key ${UNAME}.key -nodes -out ${UNAME}.csr

kubectl delete csr/${UNAME}

export BASE64_CSR=$(base64 -w0 < ${UNAME}.csr)

cat <<_EOF_ | envsubst | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${UNAME}
spec:
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: $((3600 * 24 * 365))
  groups:
  - system:authenticated
  request: ${BASE64_CSR}
  usages:
  - digital signature
  - key encipherment
  - client auth
_EOF_

kubectl certificate approve ${UNAME}

kubectl get csr/${UNAME} -o jsonpath='{.status.certificate}' | base64 -d > ${UNAME}.crt

cat << _EOF_
User ${UNAME} created.

key is in ${UNAME}.key
crt is in ${UNAME}.crt
_EOF_

exit 0
