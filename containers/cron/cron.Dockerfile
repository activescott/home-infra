FROM alpine:3.13

# install the docker cli. The docker-compose file should mount /var/run/docker.sock:/var/run/docker.sock so we can launch containers on the host operating system
RUN apk add docker

COPY ./cron_tasks_folder /etc/periodic

CMD crond -f -l 8
