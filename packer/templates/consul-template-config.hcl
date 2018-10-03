vault {
  renew_token   = false
  unwrap_token = false

  retry {
    attempts = 10
  }

  ssl {
    enabled = true
    verify  = false
  }
}

template {
  source = "/tmp/templates/ca.crt.tpl"
  destination = "/var/lib/jenkins/docker-certs/ca.crt"
  perms = 0644
}

template {
  source = "/tmp/templates/server.crt.tpl"
  destination = "/var/lib/jenkins/docker-certs/server.crt"
  perms = 0644
}

template {
  source = "/tmp/templates/server.key.tpl"
  destination = "/var/lib/jenkins/docker-certs/server.key"
  perms = 0644
}
