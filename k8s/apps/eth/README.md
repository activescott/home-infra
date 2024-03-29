# ETH

A ethereum validating node. To explore performance feasibility of solo-staking.

## Ethereum Basic Requirements

- In Ethereum's PoS, you must run a full node and stake 32 ETH to become a validator.
- Full Node

## Clients

An ethereum node needs two clients, an **Execution client** and a **Consensus Client**. There a multiple clients to choose from and one is incentivized to choose a "minority" client to increase the diversity of clients in the wild.

## Execution Client

As of Jan 2024 there are only three stable clients: Besu, Geth, and Nethermind. Erigon is recommended by some and is in "alpha and beta" rather than "alpha" like the others. Geth has a concerning 84% of clients.

I tried erigon and had it running but it seemed to struggle to stay in sync and it was hard to monitor it. After using nethermind on another host and finding it easy to understand from its docs and logs switching to it here too.

Note we must run a "full node" for execution client in order to support PoS validator.

[Nethermind (.NET) requirements](https://docs.nethermind.io/get-started/system-requirements): 4 Cores and 16 GB MEM and 1TB (min) - 2TB (recommended) of disk space.

[BESU (Java) Requirements](https://besu.hyperledger.org/public-networks/get-started/system-requirements): 32GB RAM?? 3TB SSD full node.

[Erigon (Golang) requirements](https://github.com/ledgerwatch/erigon#system-requirements): **>=16GB Mem, 400GB disk**, NOTE (>=3.5TB for archive node where Nethermind was 14TB). Like every client, they do not recommend HDD, only SSD: _Do not recommend HDD - on HDD Erigon will always stay N blocks behind chain tip, but not fall behind._

## Consensus Client

The [Lodestar client](https://lodestar.chainsafe.io/) is a Consensus client written in TypeScript.

- Status: Stable (as of Jan 2024)
- [Lodestar Requirements](https://chainsafe.github.io/lodestar/#specifications):
  - Intel Core i7–4770 or AMD FX-8310
  - 8GB RAM
  - 100GB available space **SSD**

### Lodestar Docker:

- Docs: https://chainsafe.github.io/lodestar/getting-started/installation/#docker-installation
- Container: https://hub.docker.com/r/chainsafe/lodestar

## TODO

### Assumptions

Using Lodestar and Erigon provided containers from dockerhub in k8s

### Steps

#### Erigon

- [+] Setup ssd paths
- Setup K8s StatefulSet for container (choose a version num based on latest `stable` tag)
  - [+] Setup command see docs and
- [+] Setup Service as loadbalancer type service (see plex)
  - Forward ports:
    - [+] Setup ports in service: https://erigon.gitbook.io/erigon/basic-usage/default-ports-and-firewallshttps://erigon.gitbook.io/erigon/basic-usage/default-ports-and-firewalls
    - [+] Forward Ports from FW to k8s node
- [+] use script to set permission in the erigon directories to the user 4010 (eerigon)
- [ ] setup monitoring via prometheus and grafana:

  - [+] Setup prometheus and grafana in kubernetes: https://grafana.com/blog/2023/01/19/how-to-monitor-kubernetes-clusters-with-the-prometheus-operator/
  - [+] Run Erigon with --metrics
  - [+] Setup Prometheus to scrap erigon and make sure the target works: https://github.com/ledgerwatch/erigon/blob/devel/cmd/prometheus/Readme.md
  - [+] Download some dashboards for erigon (see readme above, they provide them)

- [ ] Consider migrating to their published kustomization setup at https://github.com/ledgerwatch/erigon/tree/devel/k8s

#### Lodestar

- [ ] TODO

## References

- https://github.com/eth-educators/eth-docker / https://eth-docker.net/

  - A docker-compose setup for both clients and supports all FOSS clients.
    It's a shellscript that sets environment variables and a bunch of docker compose files that use those environment variables. It merges the compose files like https://docs.docker.com/compose/multiple-compose-files/merge/
  - There are a bunch of docker-compose files here that show lots of different options.

- Spinning up a Node: https://ethereum.org/developers/docs/nodes-and-clients/run-a-node

- Client Information: https://clientdiversity.org/

- Official Eth LaunchPad: https://launchpad.ethereum.org/en/
