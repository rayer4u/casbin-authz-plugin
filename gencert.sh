#!/bin/sh
# https://tech.paulcz.net/2016/01/secure-docker-with-tls/


mkdir -p ~/.docker

cd /etc/docker

## server cert
docker run --rm -v $(pwd)/ssl:/certs \
    -e CA_EXPIRE=36500 -e SSL_KEY=server-key.pem -e SSL_CSR=server.csr -e SSL_CERT=server.pem -e SSL_EXPIRE=3650 -e SSL_SUBJECT=$HOSTNAME  -e SSL_DNS=localhost\
    paulczar/omgwtfssl

## root client
docker run --rm -v $(pwd)/ssl:/certs \
    -e SSL_EXPIRE=3650 -e SSL_SUBJECT=$(id -un) \
    paulczar/omgwtfssl

cp -v ssl/ca.pem ~/.docker
mv -v ssl/{cert,key}.pem ~/.docker

# openssl genrsa -aes256 -out ca-key.pem 4096
# openssl req -new -x509 -days 3650 -key ca-key.pem -sha256 -out ca.pem -subj "/CN=$HOSTNAME"

# openssl genrsa -out server-key.pem 4096
# openssl req -subj "/CN=$HOSTNAME" -sha256 -new -key server-key.pem -out server.csr

# openssl req -subj "/CN=`id -un`" -sha256 -new -key server-key.pem -out server.csr
