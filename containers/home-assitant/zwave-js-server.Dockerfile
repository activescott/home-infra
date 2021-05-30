# from https://github.com/zwave-js/zwave-js-server
FROM node:14.17-alpine

WORKDIR /app

# the version (only) for the main zwave-js-server (@zwave-js/server):
ARG ZWAVE_JS_SERVER_VER=1.7.0
# zwave-js is a peer dependency of zwave-js-server, so we have to include it too:
ARG ZWAVE_JS_VER=^7.6.0
RUN npm install "zwave-js@${ZWAVE_JS_VER}" "@zwave-js/server@${ZWAVE_JS_SERVER_VER}"

ENV NODE_ENV=production

# docker-compose.yml should map the Z-Wave USB stick to /dev/zwave
ARG USB_PATH=/dev/zwave
ARG CONFIG_PATH=/config/config.js
ARG CACHE_DIR=/cache

CMD ./node_modules/.bin/zwave-server --config  "$USB_PATH"
