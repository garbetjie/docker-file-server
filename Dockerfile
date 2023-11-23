FROM alpine:3.17

# Install S6.
RUN set -e; \
    mkdir /tmp/root; \
    wget https://github.com/just-containers/s6-overlay/releases/download/v3.1.6.2/s6-overlay-noarch.tar.xz -P /tmp; \
    wget https://github.com/just-containers/s6-overlay/releases/download/v3.1.6.2/s6-overlay-$(uname -m).tar.xz -P /tmp; \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz; \
    tar -C / -Jxpf /tmp/s6-overlay-$(uname -m).tar.xz; \
    rm -f /tmp/*.tar.xz

# Install Samba.
RUN apk add --no-cache samba bash gawk

# Samba configuration.
ENV SAMBA_WORKGROUP="WORKGROUP" \
    SAMBA_SERVER_STRING="Samba [%v]" \
    SAMBA_GUEST_ACCOUNT="nobody" \
    SAMBA_CREATE_MASK="0644" \
    SAMBA_LOG_LEVEL=1 \
    SAMBA_DIRECTORY_MASK="0755"

COPY services/smbd /etc/s6-overlay/s6-rc.d/samba

RUN touch /etc/s6-overlay/s6-rc.d/user/contents.d/samba

ENTRYPOINT ["/init"]