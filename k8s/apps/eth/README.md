# ETH

A ethereum validating node. To explore performance feasibility of solo-staking.

## Ethereum Basic Requirements

- In Ethereum's PoS, you must run a full node and stake 32 ETH to become a validator.
- Full Node

## Clients

An ethereum node needs two clients, an **Execution client** and a **Consensus Client**. There a multiple clients to choose from and one is incentivized to choose a "minority" client to increase the diversity of clients in the wild.

## Execution Client

As of Jan 2024 there are only three stable clients: Besu, Geth, and Nethermind. Erigon is recommended by some and is in "alpha and beta" rather than "alpha" like the others. Geth has a concerning 84% of clients.

Note we must run a "full node" for execution client in order to support PoS validator.

[Nethermind (.NET) requirements](https://docs.nethermind.io/get-started/system-requirements): 4 Cores and 16 GB MEM and 1TB (min) - 2TB (recommended) of disk space.

[BESU (Java) Requirements](https://besu.hyperledger.org/public-networks/get-started/system-requirements): 32GB RAM?? 3TB SSD full node.

[Erigon (Golang) requirements](https://github.com/ledgerwatch/erigon#system-requirements): **>=16GB Mem, 400GB disk**, NOTE (>=3.5TB for archive node where Nethermind was 14TB). Like every client, they do not recommend HDD, only SSD: _Do not recommend HDD - on HDD Erigon will always stay N blocks behind chain tip, but not fall behind._

### Erigon

#### Erigon Docker

Container: https://hub.docker.com/r/thorax/erigon#!
A compose file using that container is at https://github.com/ledgerwatch/erigon/blob/devel/docker-compose.yml - note that this splits services up and they do not recommend that. They recommend running their single binary to orchestrate everything.

https://erigon.gitbook.io/erigon/basic-usage/usage

#### Erigon Config:

https://erigon.gitbook.io/erigon/basic-usage/usage !!

https://erigon.gitbook.io/erigon/basic-usage/getting-started/docker !!

> You can run a Erigon full node using the --prune command. In this example you can run a Ethereum full node storing only the latest 90'000 blocks:
> ./build/bin/erigon --prune=hrtc # --https://erigon.gitbook.io/erigon/basic-usage/usage/type-of-node

Use --datadir to choose where to store data.

Ports: https://erigon.gitbook.io/erigon/basic-usage/default-ports-and-firewalls

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
  - Erigon: https://github.com/ledgerwatch/erigon/blob/devel/cmd/prometheus/Readme.md

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
