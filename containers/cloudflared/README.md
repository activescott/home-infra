Docs for using the `cloudflared` tunnel is at https://developers.cloudflare.com/cloudflare-one/connections/connect-apps

To authenticate and set up cloudflared it I did the following:

- ssh to host
- run the following command: `docker run -v "/share/CACHEDEV1_DATA/app-data/cloudflared:/etc/cloudflared" cloudflare/cloudflared:2020.7.4 tunnel login`
- It provides a URL to open in your browser
- After following in-browser steps it saves a cert to `/home/nonroot/.cloudflared/cert.pem`
- Copy the cert to the host: `docker cp "<container ID>:/home/nonroot/.cloudflared/cert.pem" "/share/CACHEDEV1_DATA/app-data/cloudflared-home"`
- Create a tunnel: `docker run -v "/share/CACHEDEV1_DATA/app-data/cloudflared:/etc/cloudflared" cloudflare/cloudflared:2020.7.4 tunnel create "home.activescott.com"`
  - It creates a tunnel with id `00000000-0000-0000-0000-000000000000` and credentials file for the tunnel at `/etc/cloudflared/00000000-0000-0000-0000-000000000000.json`
- ???


Configuration file reference: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/config

Tutorials for creating various cloudflare tunnels are at https://developers.cloudflare.com/cloudflare-one/tutorials. Exposing ssh is at https://developers.cloudflare.com/cloudflare-one/tutorials/ssh

The cloudflare cotnainer is at https://hub.docker.com/r/cloudflare/cloudflared
The actual container source is at https://github.com/cloudflare/cloudflared/blob/master/Dockerfile
