#!/bin/bash

mkdir -p nginx/certs

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout nginx/certs/app.local.test.key \
  -out nginx/certs/app.local.test.crt \
  -subj "/CN=app.local.test" \
  -addext "subjectAltName=DNS:app.local.test"

echo "Certs generated!"