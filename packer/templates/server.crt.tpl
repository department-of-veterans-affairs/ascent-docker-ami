{{ with secret "pki/issue/vetservices" "common_name=SERVER_NAME" "ip_sans=LOCAL_IP,127.0.0.1" }}{{ .Data.certificate }}{{ end }}
