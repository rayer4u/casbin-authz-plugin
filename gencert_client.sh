#!/bin/sh
# https://tech.paulcz.net/2016/01/secure-docker-with-tls/


read -p "Enter your client name(linux user name): " UN

_HOME=`getent passwd $UN | cut -d: -f6`

if [ $_HOME ]; then
    echo $_HOME
else
    echo "$UN is not a valid linux user!"
    exit 1
fi


## client
docker run --rm -v $(pwd)/ssl:/certs \
    -e SSL_EXPIRE=3650 -e SSL_SUBJECT=$UN \
    paulczar/omgwtfssl

su - $UN -c "mkdir -p ~/.docker"

cp -v ssl/ca.pem $_HOME/.docker
mv -v ssl/{cert,key}.pem $_HOME/.docker
chown $UN:$UN  $_HOME/.docker/{cert,key}.pem



# openssl genrsa -aes256 -out ca-key.pem 4096
# openssl req -new -x509 -days 3650 -key ca-key.pem -sha256 -out ca.pem -subj "/CN=$HOSTNAME"

# openssl genrsa -out server-key.pem 4096
# openssl req -subj "/CN=$HOSTNAME" -sha256 -new -key server-key.pem -out server.csr

# openssl req -subj "/CN=`id -un`" -sha256 -new -key server-key.pem -out server.csr

# # create self-signed server certificate:

# read -p "Enter your domain [www.example.com]: " DOMAIN


# echo "Create server key..."

# openssl genrsa -des3 -out $DOMAIN.key 2048

# echo "Create server certificate signing request..."

# SUBJECT="/C=US/ST=Mars/L=iTranswarp/O=iTranswarp/OU=iTranswarp/CN=$DOMAIN"

# openssl req -new -subj $SUBJECT -key $DOMAIN.key -out $DOMAIN.csr

# echo "Remove password..."

# mv $DOMAIN.key $DOMAIN.origin.key
# openssl rsa -in $DOMAIN.origin.key -out $DOMAIN.key

# echo "Sign SSL certificate..."

# openssl x509 -req -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt

# echo "TODO:"
# echo "Copy $DOMAIN.crt to /etc/nginx/ssl/$DOMAIN.crt"
# echo "Copy $DOMAIN.key to /etc/nginx/ssl/$DOMAIN.key"
# echo "Add configuration in nginx:"
# echo "server {"
# echo "    ..."
# echo "    listen 443 ssl;"
# echo "    ssl_certificate     /etc/nginx/ssl/$DOMAIN.crt;"
# echo "    ssl_certificate_key /etc/nginx/ssl/$DOMAIN.key;"
# echo "}"
