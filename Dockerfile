FROM alpine:3.10
RUN apk -U add --no-cache openssh-server bash tini
COPY sshd_config /etc/sshd_config
COPY run.sh /usr/local/bin/
EXPOSE 22/tcp
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["run.sh"]
