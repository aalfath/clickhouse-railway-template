# Changelog

## 26.10.4.207 (2026-11-16)

First release.

- ClickHouse 26.10.4.207 from `clickhouse/clickhouse-server:26.10.4.207@sha256:4f491abc44d9f4a1747c033c35ddd5bc385521305d85ca8251ba0824ff597035`.
- HTTP interface on `PORT` (8123), password required, SQL user management on.
- Data on a volume at `/var/lib/clickhouse`.
- Console logging; high-volume system log tables off; `query_log`, `part_log` and `error_log` kept for `CLICKHOUSE_LOG_RETENTION_DAYS` days (default 7).
