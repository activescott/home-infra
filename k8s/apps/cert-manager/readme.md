# k8s/apps/cert-manager

This installs and manages cert-manager installation in the kubernetes cluster.

## Usage / How it works
For willeke.com (google domains)
-  Lets Encrypt's HTTP01 challenge type challenges over HTTP at the domain that a cert is being requested for. This domain must already be in DNS resolving to the cluster's public IP. We do that by using DynamicDNS in OPNsense at https://10.x.x.x/ui/dyndns/. Get a token for that at https://domains.google.com/registrar/willeke.com/security 
- In the firewall's public IP, ports 80 and 443 are forwarded to the k8s cluster (https://10.x.x.x/firewall_nat.php). 
  - This allows the cert-manager http01 solver to solve ACME challenges for lets encrypt.
  - cert-manager temporarily stands up a pod and ingress-related resources to respond to the challenge.





https://domains.google.com/registrar/willeke.com/security