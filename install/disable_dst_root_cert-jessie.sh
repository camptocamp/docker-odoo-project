# Following the expiracy of DST Root X3 certificate
# the chain of trust of openssl cannot use the valid ISRG Root X1
# Thus we have to disable the expired certificate
sed -i '/^mozilla\/DST_Root_CA_X3.crt$/ s/^/!/' /etc/ca-certificates.conf
update-ca-certificates
