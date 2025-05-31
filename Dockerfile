FROM debian:bookworm-slim

LABEL maintaner="BluePhi09 <admin@bluephi09.me>"

LABEL description="Corosync Qdevice Network daemon"
LABEL documentation="https://github.com/BluePhi09/docker-qdevice"
LABEL version="2.0"
LABEL website="https://github.com/BluePhi09/docker-qdevice"

RUN apt-get update \
    && apt-get upgrade -qy \
    && apt-get install --no-install-recommends -y supervisor openssh-server corosync-qnetd corosync-qdevice libnss3-tools libnss3 \
    && apt-get -y autoremove \
    && apt-get clean all \
    && rm -rf /var/lib/apt/* /var/lib/dpkg/* /var/lib/cache/* /var/lib/log/* /var/log/*
	
RUN ln -s /usr/lib/x86_64-linux-gnu/libnssckbi.so /etc/corosync/qnetd/nssdb/libnssckbi.so
RUN mkdir -p /etc/corosync/qnetd/nssdb

RUN mkdir -p /run/sshd
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
RUN sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's|^#AuthorizedKeysFile.*|AuthorizedKeysFile .ssh/authorized_keys|' /etc/ssh/sshd_config
RUN sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

ENV container=docker

COPY supervisord.conf /etc/supervisord.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

HEALTHCHECK CMD corosync-qnetd-tool -s

VOLUME [ "/etc/corosync" , "/etc/ssh" ]

EXPOSE 22/tcp
EXPOSE 5403/tcp

STOPSIGNAL SIGTERM

CMD ["/entrypoint.sh"]