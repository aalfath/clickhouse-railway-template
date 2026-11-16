# ClickHouse for Railway: the official image, pinned by version and digest,
# plus a small start script and config. Bump the pin here to ship an update.
FROM clickhouse/clickhouse-server:26.10.4.207@sha256:4f491abc44d9f4a1747c033c35ddd5bc385521305d85ca8251ba0824ff597035

COPY config.d/railway.xml /etc/clickhouse-server/config.d/railway.xml
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod 0755 /usr/local/bin/railway-entrypoint.sh

# HTTP interface (Railway's public domain and private network) and native protocol (private network)
EXPOSE 8123 9000

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
