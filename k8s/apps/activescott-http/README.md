# activescott-http: Redirect activescott.com to scott.willeke.com

This is a simple way to redirect https://activescott.com (NOTE: root of domain, which can't generally be CNAME) to https://scott.willeke.com

## How it works

- The redirect uses the Traefik Ingress Controller's middleware in the Ingress.
- It also requires a couple external things to be setup:
  - DNS for A record of activescott.com has to direct into the cluster's IP.
  - In my case, this is a DNS entry that is manged by DynamicDNS on my router.
  - There is also a port-forward in my router for all https/443 requests to come to the cluster.

## Todo

The thing I wish would be better is to not have to spin up a pod at all but I couldn't figure out how to do that. Traefik seems to require a discoverable service, and the headless service or externalIP service didn't work.
