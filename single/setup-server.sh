export PASSWORD=your-password

alias stalwart-cli="docker exec -ti mailserver stalwart-cli -u http://127.0.0.1:8080 -c ${PASSWORD}"
stalwart-cli server add-config server.hostname mail.benkner-it.com
stalwart-cli server add-config acme.letsencrypt.contact postmaster@benkner-it.com
stalwart-cli server add-config acme.letsencrypt.domains mail.benkner-it.com
stalwart-cli server add-config acme.letsencrypt.challenge tls-alpn-01
stalwart-cli server add-config acme.letsencrypt.directory https://acme-v02.api.letsencrypt.org/directory
stalwart-cli server add-config acme.letsencrypt.renew-before 30d

docker restart mailserver