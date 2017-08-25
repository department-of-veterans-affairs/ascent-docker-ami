#!/bin/bash

# setup ssh to get authorized keys from Vault

########################################

set -x

sudo sed -i 's@SELINUX=enforcing@SELINUX=permissive@' /etc/selinux/config
sudo cat /etc/selinux/config
sudo setenforce Permissive

sudo cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
sudo sed -i 's@#AuthorizedKeysCommand none@AuthorizedKeysCommand /etc/ssh/ssh-command.sh@' /etc/ssh/sshd_config
sudo sed -i 's@#AuthorizedKeysCommandUser nobody@AuthorizedKeysCommandUser nobody@' /etc/ssh/sshd_config
sudo sed -i 's@#AuthorizedKeysCommandUser nobody@AuthorizedKeysCommandUser nobody@' /etc/ssh/sshd_config
sudo sed -i 's@#LogLevel INFO@LogLevel VERBOSE@' /etc/ssh/sshd_config
sudo systemctl restart sshd

cat > /tmp/ssh-command.sh << 'EOF'
#!/bin/bash

#############################################
#
#  Environment Variables Needed:
#
#  VAULT_URL = protocol://host:port/path-to-authorized_keys/
#     example - https://localhost:8200/v1/secret/authorized_keys/
#  VAULT_READ_TOKEN = token for authenticating to vault and reading key file
#
#############################################

VAULT_URL=XX_VAULT_URL
VAULT_READ_TOKEN=XX_VAULT_READ_TOKEN


# Check vault
curl -sk -H "X-Vault-Token:$VAULT_READ_TOKEN" $VAULT_URL$1 | jq -r '.data|join("\n")'

exit 0
EOF

test -n $VAULT_URL && test -n $VAULT_TOKEN && sed -i -e 's,'XX_VAULT_URL','"$VAULT_URL"',' -e 's,'XX_VAULT_READ_TOKEN','"$VAULT_TOKEN"',' /tmp/ssh-command.sh

sudo mv /tmp/ssh-command.sh /etc/ssh
sudo chown root:root /etc/ssh/ssh-command.sh
sudo chmod 755 /etc/ssh/ssh-command.sh

exit 0

