# from https://github.com/zwave-js/zwave-js-server
FROM node:14.17-alpine

WORKDIR /app

# zwave-js uses Node SerialPort and that requires python and some other stuff to compile inside 
# the container during install. We add these necessary build and runtime dependencies below 
# (from https://serialport.io/docs/guide-installation/#alpine-linux)
RUN apk add --no-cache make gcc g++ python linux-headers udev

# the version (only) for the main zwave-js-server (@zwave-js/server):
## https://github.com/zwave-js/zwave-js-server
ARG ZWAVE_JS_SERVER_VER=1.9.2
# zwave-js is a peer dependency of zwave-js-server, so we have to include it too:
## https://github.com/zwave-js/node-zwave-js
ARG ZWAVE_JS_VER=8.0.7

RUN npm install "zwave-js@${ZWAVE_JS_VER}" "@zwave-js/server@${ZWAVE_JS_SERVER_VER}"

ENV NODE_ENV=production

# docker-compose.yml should map the Z-Wave USB stick to /dev/zwave
ENV USB_PATH=/dev/zwave
# docker-compose.yml should map the ZWave JS Config file in /config/config.js
ENV CONFIG_PATH=/config/config.js

CMD ./node_modules/.bin/zwave-server --config ${CONFIG_PATH} ${USB_PATH}
