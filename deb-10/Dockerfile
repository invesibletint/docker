FROM debian:buster
RUN sed -i -e 's|http://deb.debian.org|http://archive.debian.org|g' -e 's|http://security.debian.org|http://archive.debian.org|g' /etc/apt/sources.list && printf 'Acquire::Check-Valid-Until "false";\n' > /etc/apt/apt.conf.d/99-archive && export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y --no-install-recommends openssh-server && rm -rf /var/lib/apt/lists/* && mkdir -p /run/sshd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
