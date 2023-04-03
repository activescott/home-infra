# Plex

This is the kubernetes setup for plex media server. Plex provides the source for the containers and detailed information on how to set it up in docker at https://github.com/plexinc/pms-docker ❤️

# Container config notes:

`ADVERTISE_IP` is host's private IP. Must be used for bridge networking.
`PLEX_CLAIM` Get it at https://www.plex.tv/claim (it expires every 4mins)

## CONFIG:

WHERE IS THE CONFIG DIR?
Run `getcfg -f /etc/config/qpkg.conf PlexMediaServer Install_path` (from https://support.plex.tv/articles/202915258-where-is-the-plex-media-server-data-directory-located/)

## Hardware acceleration?

Intel Quick Sync works as part of many intel CPUs. See https://github.com/plexinc/pms-docker#intel-quick-sync-hardware-transcoding-support
