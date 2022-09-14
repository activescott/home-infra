# PhotoPrism Container

PhotoPrism for photos: https://docs.photoprism.app/getting-started/docker-compose/

## Configuration Highlights

- mariadb runs in it's own container for the primary data storage.
- HTTPS access with a letsncrypt cert (pulled from the cron container separtaely) is done via Traefik ingress proxy which runs in it's own container
  - See the app-data subdirectory for the initial traefik configuration files I used to configure it.
- Traefik and PhotoPrism each have their own IP and MAC address via a macvlan driver. This just makes it easier to use than adding more and more ports to the main host IP and makes network monitoring a bit easier.
- I map photos.activescott.com DNS entry to Traefik.

## TODO:

- [+] set up a dedicated photo import directory separate from scott-photos other files.
- [+] Put Traefik's https port on 443 instead of the high port.

## PhotoPrism Docs:

- https://docs.photoprism.app/getting-started/docker-compose/
- https://docs.photoprism.app/user-guide/first-steps/

## Macvlan

I am putting this container on a docker `macvlan` so that it has it's own mac address and dedicated IP on the network. This makes it easier to monitor flows.

- Excellent demo of macvlan usage in docker-compose: https://dev.to/fredlab/make-docker-containers-available-both-on-your-local-network-with-macvlan-and-on-the-web-with-traefik-2hj1
- https://docs.docker.com/network/macvlan/
- https://docs.docker.com/network/network-tutorial-macvlan/

We can assign MAC addresses to the container on a macvlan network. Consider the _Universal vs. local (U/L bit)_ and _Unicast vs. multicast (I/G bit)_.

### Universal vs. local (U/L bit)

- A **universally administered address** is uniquely assigned to a device by its manufacturer.
- A **locally administered address** is assigned to a device by software or a network administrator, overriding the burned-in address for physical devices.

### Unicast vs. multicast (I/G bit)

- **Unicast**: When this bit is 0 (zero), the frame is meant to reach only one receiving NIC.
- **Multicast**: If the least significant bit of the first octet is set to 1 (i.e. the second hexadecimal digit is odd) the frame will still be sent only once; however, NICs will choose to accept it based on criteria other than the matching of a MAC address: for example, based on a configurable list of accepted multicast MAC addresses.

TLDR; Choose a locally administered, Unicast address from this table: https://en.wikipedia.org/wiki/MAC_address#Ranges_of_group_and_locally_administered_addresses

So I'll use: `AA:AA:AA:xx:xx:xx` where the remaining hex digits can be simply generated with a shell command of `openssl rand -hex 3`.

## Traefik Service as Reverse Proxy/Ingress

The idea here is to setup a proxy ingress proxy to present certs and control incoming access to other containers.
Planning to use traefik which allows setting up the main proxy and then using labels on the other containers to tell traefik which containers to proxy and which ports, domains, and certs to use.

- [Routing & Load Balancing Overview | Traefik Docs - Traefik](https://doc.traefik.io/traefik/routing/overview/)
- [Docker-compose basic example | Traefik Docker Documentation - Traefik](https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/)

- [Using Traefik as Reverse Proxy – PhotoPrism](https://docs.photoprism.app/getting-started/proxies/traefik/)
