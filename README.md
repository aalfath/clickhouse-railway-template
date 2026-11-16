[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/clickhouse-3?utm_medium=integration&utm_source=button&utm_campaign=clickhouse)

# ClickHouse on Railway

A one-click [Railway](https://railway.com) template for [ClickHouse](https://clickhouse.com), the open-source column-oriented database for real-time analytics.

It deploys **ClickHouse 26.10.4.207** (latest stable when this was written), built from the official image `clickhouse/clickhouse-server`, pinned by version and digest in the [`Dockerfile`](Dockerfile).

## What you get

- One ClickHouse service, built from this repo.
- The HTTP interface (port 8123) on a Railway domain with HTTPS. The `/play` SQL console is at `https://YOUR-DOMAIN/play`.
- The HTTP and native (9000) interfaces on Railway's private network for your other services.
- A volume at `/var/lib/clickhouse`, so data survives redeploys.
- A generated 32-character password. ClickHouse refuses to start without one, so the HTTP interface is never left open.
- SQL user management on (`CREATE USER`, `GRANT`, ...).
- Logs go to Railway's log view. High-volume diagnostic system tables (`trace_log`, `text_log`, `metric_log`, ...) are off, and `query_log`, `part_log` and `error_log` keep 7 days of data, so the volume doesn't fill up with ClickHouse's own logs.
- Health check on `/ping`.

## Variables

| Variable | Default | What it does |
|---|---|---|
| `CLICKHOUSE_USER` | `default` | User created on first start |
| `CLICKHOUSE_PASSWORD` | generated secret | That user's password |
| `CLICKHOUSE_DB` | `default` | Database created on first start |
| `PORT` | `8123` | HTTP port (the domain points at it) |
| `CLICKHOUSE_HOST` | private domain | Private host name for your other services |
| `CLICKHOUSE_URL` | reference | Private HTTP URL with credentials, for services in the same project |
| `CLICKHOUSE_PUBLIC_URL` | reference | Public HTTPS URL with credentials |

Optional, not set by default:

- `CLICKHOUSE_LOG_RETENTION_DAYS` (default `7`): days of `query_log`, `part_log` and `error_log` to keep.
- `CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT` (default `1`): set to `0` to turn SQL user management off.

The user, password and database are applied on every start by the official entrypoint. Change the password by changing `CLICKHOUSE_PASSWORD` and redeploying.

## Connecting

From another Railway service in the same project, reference `${{ClickHouse.CLICKHOUSE_URL}}`, or use the host `${{ClickHouse.CLICKHOUSE_HOST}}` with port 8123 (HTTP) or 9000 (native).

From your machine, over HTTPS:

```sh
curl -u "default:$CLICKHOUSE_PASSWORD" "https://YOUR-DOMAIN/?query=SELECT%20version()"
```

The native protocol (port 9000) is only on the private network, because without TLS it sends the password in clear text. If you need it from outside, add a TCP proxy for port 9000 in the service's networking settings and accept that trade-off, or use `railway connect` / the HTTPS interface instead.

## Updates

This template builds from this repo. When the pinned version in the `Dockerfile` changes on `main`, Railway shows an "update available" notice on every deployed copy, and you choose when to apply it. Read [`CHANGELOG.md`](CHANGELOG.md) first: ClickHouse upgrades are usually in place, but check the upstream [changelog](https://clickhouse.com/docs/whats-new/changelog) for backward-incompatible changes before you apply a new version.

## Local test

```sh
CLICKHOUSE_PASSWORD=change-me docker compose up --build
curl -u default:change-me "http://localhost:42195/?query=SELECT%201"
```

## License

The wrapper files in this repo are MIT. ClickHouse is Apache-2.0.
