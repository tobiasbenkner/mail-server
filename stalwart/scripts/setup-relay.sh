[queue.outbound]
next-hop = [ { if = "is_local_domain('', rcpt_domain)", then = "'relay'" }, { else = false } ]

[remote."relay"]
address = "smtp.provider-domain.com"
port = 587
protocol = "smtp"

[remote."relay".tls]
implicit = false
allow-invalid-certs = false

[remote."relay".auth]
username = "<SMTP-Benutzer>"
secret = "<SMTP-Passwort>"