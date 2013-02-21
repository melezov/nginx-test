#!/bin/bash

openssl genrsa -out auth.nginx-test.com.key 2048

echo "
[ req ]
 distinguished_name     = req_distinguished_name
 attributes             = req_attributes
 prompt                 = no

[ req_distinguished_name ]
CN                     = 89859025444/Markov Browser
[ req_attributes ]
challengePassword      = dinamo
" > `dirname $0`/marko@auth.nginx-test.com.conf
openssl req -new -x509 -days 365 -key `dirname $0`/auth.nginx-test.com.key -out `dirname $0`/marko@auth.nginx-test.com.pem -config `dirname $0`/marko@auth.nginx-test.com.conf
rm `dirname $0`/marko@auth.nginx-test.com.conf

openssl pkcs12 -export -password pass:'dinamo' -out `dirname $0`/marko@auth.nginx-test.com.p12 -inkey `dirname $0`/auth.nginx-test.com.key -in `dirname $0`/marko@auth.nginx-test.com.pem -name "marko@auth.nginx-test.com"
