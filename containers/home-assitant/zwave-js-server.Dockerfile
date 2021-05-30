# from https://github.com/zwave-js/zwave-js-server
FROM node:14.17-alpine

WORKDIR /app

ARG ZWAVE_JS_SERVER=@zwave-js/server@1.7.0
RUN npm install $ZWAVE_JS_SERVER

ENV NODE_ENV=production

# docker-compose.yml should map the Z-Wave USB stick to /dev/zwave
ARG USB_PATH=/dev/zwave
ARG CONFIG_PATH=/config/config.js
ARG CACHE_DIR=/cache

CMD ./node_modules/.bin/zwave-server --config  "$USB_PATH"
