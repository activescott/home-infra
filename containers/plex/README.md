# Plex

This is the container for plex media server. Plex provides the source for the containers and detailed information on how to set it up at https://github.com/plexinc/pms-docker ❤️

# Container config notes:

`ADVERTISE_IP` is host's private IP. Must be used for bridge networking.
`PLEX_CLAIM` Get it at https://www.plex.tv/claim (it expires every 4mins)

# Old config:

I originally had this running as a QNAP packaged app, but switched to a container.

Original QNAP package configuration notes:

Libraries on the host:

- /share/CACHEDEV1_DATA/Multimedia/Movies
- /share/CACHEDEV1_DATA/Multimedia/TV Shows
- /share/CACHEDEV1_DATA/Multimedia/Music
- /share/CACHEDEV1_DATA/scott-photos

Version: 1.24.3.5033
Private IP 10.x.xxx.16 : 32400 < 192.xxx.xxx.xxx : 32400

## CONFIG:

WHERE IS THE CONFIG DIR?
Run `getcfg -f /etc/config/qpkg.conf PlexMediaServer Install_path` (from https://support.plex.tv/articles/202915258-where-is-the-plex-media-server-data-directory-located/)

## Hardware acceleration?

I dno't have the hardware yet, but can be setup according to https://www.reddit.com/r/qnap/comments/k9yznh/guide_plex_hardware_transcode_with_docker_and_gpu/
