#!/usr/bin/env sh

# Certbot command-line options: https://certbot.eff.org/docs/using.html#certbot-command-line-options
docker run -it --rm --name certbot \
            -v "/share/CACHEDEV1_DATA/app-data/letsencrypt:/etc/letsencrypt" \
            certbot/dns-cloudflare certonly \
            -d "*.activescott.com" \
            --dns-cloudflare \
            --dns-cloudflare-credentials "/etc/letsencrypt/cloudflare-secret.ini" \
            -n \
            --agree-tos \
            --email scott+certbot@willeke.com
