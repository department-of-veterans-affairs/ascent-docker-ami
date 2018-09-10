#!/bin/bash
#Required
domain=$1
vault_url=$2
vault_token=$3
commonname=$domain

echo
echo "Generating key request for $domain"
echo

password=dummypassword

#Generate a key
openssl genrsa -des3 -passout pass:$password -out $domain.key 2048 -noout

openssl rsa -in $domain.key -passin pass:$password -out $domain.key

#Create the request
echo
echo "Creating CSR"
echo 
openssl req -new -key $domain.key -out $domain.csr -passin pass:$password -subj '/CN=docker/O=GDIT/C=US'

echo 
echo "create payload for vault"
echo 
csr=$(cat $domain.csr | awk '{printf "%s",$0} END {print ""}' | awk '{ sub(/BEGIN CERTIFICATE REQUEST-----/, "BEGIN CERTIFICATE REQUEST-----\\n"); print }' | awk '{ sub(/-----END/, "\\n-----END"); print }')
echo "{ \"csr\" : \"$csr\", \"common_name\" : \"$commonname\"}" >> payload.json

echo 
echo "Sign the cert"
echo 
curl -k --header "X-Vault-Token: $vault_token" --request POST --data @payload.json $vault_url/v1/pki/sign/vetservices >> response.json

echo 
echo "Parse response to get the certs"
echo
cat response.json | jq '.data.certificate' | awk '{ gsub(/\"/, ""); print }' | awk '{ gsub(/\\n/, "\n"); print }' >> $domain.crt
cat response.json | jq '.data.issuing_ca' | awk '{ gsub(/\"/, ""); print }' | awk '{ gsub(/\\n/, "\n"); print }'  >> ca.crt

sudo mkdir -p /opt/consul/certs
sudo mv $domain.crt /opt/consul/certs
sudo mv ca.crt /opt/consul/certs
sudo mv $domain.key /opt/consul/certs
sudo chown -R consul:consul /opt/consul/certs