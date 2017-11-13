#!/bin/bash

set -x

VAULT_URL='vault.internal.vets-api.gov'

curl -ksL -o /etc/pki/ca-trust/source/anchors/vault-ca.pem https://$VAULT_URL:8200/v1/pki/ca/pem
update-ca-trust
