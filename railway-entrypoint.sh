#!/bin/bash
# Railway start script: writes the runtime config, then hands over to the
# official image's entrypoint (/entrypoint.sh), which creates the user and database.
set -euo pipefail

export PORT="${PORT:-8123}"
export CLICKHOUSE_USER="${CLICKHOUSE_USER:-default}"
export CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT="${CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT:-1}"
RETENTION_DAYS="${CLICKHOUSE_LOG_RETENTION_DAYS:-7}"

if [ -z "${CLICKHOUSE_PASSWORD:-}" ]; then
  echo "railway-entrypoint: CLICKHOUSE_PASSWORD is empty. Set it (the template generates one) so the HTTP interface is not left open." >&2
  exit 1
fi
case "$PORT" in ''|*[!0-9]*) echo "railway-entrypoint: PORT must be a number, got '$PORT'" >&2; exit 1;; esac
case "$RETENTION_DAYS" in ''|*[!0-9]*) echo "railway-entrypoint: CLICKHOUSE_LOG_RETENTION_DAYS must be a number" >&2; exit 1;; esac

cat > /etc/clickhouse-server/config.d/zz-railway-runtime.xml <<XML
<clickhouse>
  <http_port>${PORT}</http_port>
  <query_log><ttl>event_date + INTERVAL ${RETENTION_DAYS} DAY DELETE</ttl></query_log>
  <part_log><ttl>event_date + INTERVAL ${RETENTION_DAYS} DAY DELETE</ttl></part_log>
  <error_log><ttl>event_date + INTERVAL ${RETENTION_DAYS} DAY DELETE</ttl></error_log>
</clickhouse>
XML

exec /entrypoint.sh "$@"
