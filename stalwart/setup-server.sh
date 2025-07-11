export ENDPOINT=http://127.0.0.1:8080
export PASSWORD=your-password
export DOMAIN=mail.benkner-it.com
alias stalwart-cli='docker exec -ti mailserver stalwart-cli'

stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config certificate.default.cert "%{file:/data/certs/${DOMAIN}/cert.pem}%"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config certificate.default.default true
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config certificate.default.private-key "%{file:/data/certs/${DOMAIN}/key.pem}%"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.hostname "${DOMAIN}"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config http.hsts true
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config http.permissive-cors false
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config http.url "protocol + '://' + config_get('server.hostname') + ':' + local_port"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config http.use-x-forwarded true
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.http.bind "[::]:8080"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.http.protocol "http"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.https.bind "[::]:443"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.https.protocol "http"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.https.tls.implicit true
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.imaptls.bind "[::]:993"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.imaptls.protocol "imap"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.imaptls.proxy.override true
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.imaptls.proxy.trusted-networks.0 "172.19.0.2"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.imaptls.proxy.trusted-networks.1 "172.19.0.0/16"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.imaptls.tls.implicit true
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.smtp.bind "[::]:25"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.smtp.protocol "smtp"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.smtp.proxy.override true
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.smtp.proxy.trusted-networks.0 "172.19.0.2"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.smtp.proxy.trusted-networks.1 "172.19.0.0/16"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.submissions.bind "[::]:465"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.submissions.protocol "smtp"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.submissions.proxy.override true
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.submissions.proxy.trusted-networks.0 "172.19.0.2"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.submissions.proxy.trusted-networks.1 "172.19.0.0/16"
stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server add-config server.listener.submissions.tls.implicit true

stalwart-cli -u ${ENDPOINT} -c ${PASSWORD} server reload-config