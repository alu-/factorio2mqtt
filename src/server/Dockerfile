FROM node:22-alpine

LABEL AUTHOR="alu <alu@byteberry.net>"

VOLUME [ "/script-output" ]

ENV SCRIPT_OUTPUT_PATH= \
    MQTT_HOST= \
    MQTT_USERNAME= \
    MQTT_PASSWORD= \
    CHOKIDAR_USEPOLLING=true

RUN apk add --no-cache tini

WORKDIR /app

COPY package*.json /app/
RUN npm install

COPY index.js /app/

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "node", "index.js", "/script-output" ]