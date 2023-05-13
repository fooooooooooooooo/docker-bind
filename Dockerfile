FROM ubuntu:jammy

LABEL maintainer="sameer@damagehead.com"

RUN apt-get update && apt-get install -y gnupg1
COPY setup-repos.sh .
RUN sh setup-repos.sh

ENV BIND_USER=bind
ENV BIND_VERSION=9.18
ENV WEBMIN_VERSION=2
ENV DATA_DIR=/data

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get install -y bind9=1:${BIND_VERSION}* bind9-host=1:${BIND_VERSION}* dnsutils webmin=${WEBMIN_VERSION}*
RUN rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]
