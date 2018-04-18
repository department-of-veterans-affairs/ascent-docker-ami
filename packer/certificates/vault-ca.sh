#!/bin/bash

set -x

VAULT_URL='vault.internal.vets-api.gov'
DOCKER_REPO_URL='nexus.internal.vets-api.gov:5000'
DOCKER_DEPLOY_URL='nexus.internal.vets-api.gov:5001'

curl -ksL -o /etc/pki/ca-trust/source/anchors/vault-ca.pem https://$VAULT_URL:8200/v1/pki/ca/pem
update-ca-trust

#Add vault ca certifiacte to docker so our registry url is trusted
# See https://docs.docker.com/engine/security/certificates/#understanding-the-configuration for documentation on this
mkdir -p /etc/docker/certs.d/${DOCKER_DEPLOY_URL}
mkdir -p /etc/docker/certs.d/${DOCKER_REPO_URL}
cp /etc/pki/ca-trust/source/anchors/vault-ca.pem /etc/docker/certs.d/${DOCKER_REPO_URL}/ca.crt
cp /etc/pki/ca-trust/source/anchors/vault-ca.pem /etc/docker/certs.d/${DOCKER_DEPLOY_URL}/ca.crt