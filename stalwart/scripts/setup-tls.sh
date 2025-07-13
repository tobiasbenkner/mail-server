[tls."default"]
certificate = "/etc/letsencrypt/live/mail.example.com/fullchain.pem"
private-key = "/etc/letsencrypt/live/mail.example.com/privkey.pem"

stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config tls.default.certificate "%{file:/data/certs/${DOMAIN}/cert.pem}%"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config tls.default.private-key "%{file:/data/certs/${DOMAIN}/key.pem}%"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.smtp.tls.mode "starttls"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.smtp.tls.certificates "[\"default\"]"

stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.smtp.ehlo-hostname "mail.${DOMAIN}"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.imap.tls.mode "starttls"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.imap.tls.certificates "[\"default\"]"
