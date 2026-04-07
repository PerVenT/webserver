# ==========================================
# Stage 1: Builder
# ==========================================
FROM alpine:3.19 AS builder

RUN apk add --no-cache wget

ARG TINI_VERSION=v0.19.0
WORKDIR /tmp

RUN wget -q "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static" && \
    wget -q "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static.sha256sum"

RUN sha256sum -c tini-static.sha256sum && \
    chmod +x tini-static

# ==========================================
# Stage 2: Final
# ==========================================
FROM busybox:1.37

RUN addgroup -S webserver && \
    adduser -S webserver -G webserver

COPY --from=builder /tmp/tini-static /tini

WORKDIR /opt/webserver

COPY --chown=webserver:webserver webserver.sh .

RUN chmod +x webserver.sh

EXPOSE 8080

USER webserver

ENTRYPOINT ["/tini", "--"]

CMD ["/opt/webserver/webserver.sh"]

