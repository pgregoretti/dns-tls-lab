# DNS and TLS Troubleshooting Lab

## Overview

This project is a local lab environment designed to simulate how DNS resolution and TLS (HTTPS) work in a real-world web application stack.

It demonstrates how a client resolves a hostname to an IP address, establishes a secure TLS connection, and receives content through a reverse proxy. The lab is also intended to practice troubleshooting common DNS and TLS-related issues that occur in production environments.

This project is especially relevant for roles involving Site Reliability Engineering, networking, and edge infrastructure.

---

## What This Project Covers

- Hostname resolution using local DNS (`/etc/hosts`)
- HTTPS configuration with Nginx
- TLS certificate generation using OpenSSL
- HTTP to HTTPS redirection
- Reverse proxy behavior
- TLS inspection and debugging using command-line tools

---

## Architecture

```
Client → DNS Resolution → Nginx (HTTPS) → Static App
```

- The client resolves `app.local.test` to `127.0.0.1`
- Nginx listens on HTTP (80) and HTTPS (443)
- HTTP traffic is redirected to HTTPS
- TLS is terminated at Nginx using a locally generated certificate
- Nginx serves a static HTML application

---

## Prerequisites

- Docker and Docker Compose
- OpenSSL
- macOS or Linux environment

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone <repo-url>
cd dns-tls-lab
```

---

### 2. Generate TLS certificates

Certificates are generated locally and are not stored in the repository.

Run:

```bash
./scripts/generate-certs.sh
```

This will create:

- `nginx/certs/app.local.test.crt`
- `nginx/certs/app.local.test.key`

---

### 3. Configure local DNS

Add the following entry to your `/etc/hosts` file:

```bash
127.0.0.1 app.local.test
```

---

### 4. Start the environment

```bash
docker compose up -d
```

---

### 5. Test the application

Test HTTP (should redirect to HTTPS):

```bash
curl -I http://app.local.test:8080
```

Test HTTPS:

```bash
curl -k https://app.local.test:8443
```

Open in browser:

```
https://app.local.test:8443
```

Note: The browser will show a security warning because the certificate is self-signed.

---

## Debugging and Validation

### Check DNS resolution

```bash
ping app.local.test
```

### Inspect TLS handshake

```bash
openssl s_client -connect app.local.test:8443 -servername app.local.test
```

### View certificate details

```bash
echo | openssl s_client -connect app.local.test:8443 -servername app.local.test 2>/dev/null | openssl x509 -noout -subject -issuer -dates -ext subjectAltName
```

---

## Failure Scenarios to Test

This lab is designed to simulate common production issues:

### 1. Hostname mismatch
- Generate a certificate for a different domain
- Observe TLS validation errors

### 2. DNS resolution failure
- Remove the `/etc/hosts` entry
- Observe connection failures

### 3. Invalid or expired certificate
- Modify certificate parameters or regenerate incorrectly
- Observe browser and curl errors

### 4. Redirect issues
- Modify or remove HTTP → HTTPS redirect
- Observe behavior differences

---

## Security Notes

- Private keys are not committed to the repository
- Certificates are generated locally using OpenSSL
- This follows standard security practices for key management

---

## Future Improvements

- Use a real domain with a public DNS provider
- Integrate Let's Encrypt for trusted certificates
- Add intermediate certificate chain validation
- Introduce a backend service and proxy traffic instead of serving static content
- Add logging and monitoring for TLS and request handling

---

## Purpose

The goal of this project is to build a deeper understanding of how DNS and TLS function together in modern infrastructure, and to develop practical troubleshooting skills that apply to production systems involving CDNs, reverse proxies, and secure web traffic.
