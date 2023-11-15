This is simply a cheap way to redirect https://activescott.com (NOTE: root of domain, which can't generally be CNAME) to https://scott.willeke.com

To do it's work, it uses Traefik middleware in the Ingress.
The thing I wish would be better is to not have to spin up a pod at all but I couldn't figure out how to do that. Traefik seems to require a discoverable service, and the headless service or externalIP service didn't work.
