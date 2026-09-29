#!/usr/bin/env bash
# Renders the local spike server (Synapse + MAS + Element Web behind Caddy
# with a local CA) into ./generated and starts it.
#
#   ./setup.sh            render configs (once) and start
#   ./setup.sh users      create the test users alice and bob in MAS
#   ./setup.sh ca         export Caddy's root CA and trust it in booted iOS simulators
#   ./setup.sh down       stop (keeps data)
#   ./setup.sh reset      stop and delete all data and generated secrets
#
# All services listen on https://localhost with separate ports (local CA).
# The iOS simulator shares the Mac's network; the Android emulator reaches
# them through `./setup.sh android` (adb reverse). nip.io is not usable here
# because the router's DNS rebind protection drops private answers.
set -euo pipefail

cd "$(dirname "$0")"

GEN=generated
HOST=${HOST:-localhost}
HS_PORT=28448
AUTH_PORT=28449
WEB_PORT=28450
SERVER_NAME=ngo-spike.test
HS_URL="https://${HOST}:${HS_PORT}"
AUTH_URL="https://${HOST}:${AUTH_PORT}"
WEB_URL="https://${HOST}:${WEB_PORT}"
TEST_PASSWORD=${TEST_PASSWORD:-spike-password-1}

compose() {
    docker compose --env-file "$GEN/.env" "$@"
}

secret() {
    openssl rand -hex 32
}

render() {
    mkdir -p "$GEN/synapse" "$GEN/mas/keys"

    if [[ ! -f "$GEN/secrets.env" ]]; then
        {
            echo "POSTGRES_PASSWORD=$(secret)"
            echo "MAS_SYNAPSE_SECRET=$(secret)"
            echo "MAS_ENCRYPTION_SECRET=$(secret)"
            echo "MACAROON_SECRET_KEY=$(secret)"
            echo "FORM_SECRET=$(secret)"
        } > "$GEN/secrets.env"
        chmod 600 "$GEN/secrets.env"
    fi
    # shellcheck disable=SC1091
    source "$GEN/secrets.env"

    {
        echo "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}"
        echo "HS_PORT=${HS_PORT}"
        echo "AUTH_PORT=${AUTH_PORT}"
        echo "WEB_PORT=${WEB_PORT}"
    } > "$GEN/.env"

    if [[ ! -f "$GEN/synapse/signing.key" ]]; then
        docker run --rm -v "$PWD/$GEN/synapse:/data" -e SYNAPSE_SERVER_NAME="$SERVER_NAME" \
            -e SYNAPSE_REPORT_STATS=no -e UID=1000 -e GID=1000 -e SYNAPSE_CONFIG_PATH=/data/generated.yaml \
            ghcr.io/element-hq/synapse:v1.161.0 generate >/dev/null
        mv "$GEN/synapse/${SERVER_NAME}.signing.key" "$GEN/synapse/signing.key"
        rm -f "$GEN/synapse/${SERVER_NAME}.log.config" "$GEN/synapse/generated.yaml"
    fi

    if [[ ! -f "$GEN/mas/keys/rsa.pem" ]]; then
        openssl genrsa 2048 2>/dev/null > "$GEN/mas/keys/rsa.pem"
        openssl ecparam -name prime256v1 -genkey -noout 2>/dev/null > "$GEN/mas/keys/p256.pem"
        chmod 644 "$GEN/mas/keys"/*.pem
    fi

    cat > "$GEN/postgres-init.sql" <<SQL
CREATE DATABASE synapse;
CREATE DATABASE mas;
SQL

    cat > "$GEN/synapse/log.config" <<'YAML'
version: 1
formatters:
  precise:
    format: '%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s'
handlers:
  console:
    class: logging.StreamHandler
    formatter: precise
root:
  level: INFO
  handlers: [console]
disable_existing_loggers: false
YAML

    cat > "$GEN/synapse/homeserver.yaml" <<YAML
server_name: "${SERVER_NAME}"
public_baseurl: "${HS_URL}/"
pid_file: /data/homeserver.pid
report_stats: false

listeners:
  - port: 8008
    type: http
    tls: false
    x_forwarded: true
    bind_addresses: ["0.0.0.0"]
    resources:
      - names: [client]
        compress: false

database:
  name: psycopg2
  args:
    user: spike
    password: "${POSTGRES_PASSWORD}"
    dbname: synapse
    host: postgres
    cp_min: 1
    cp_max: 5

log_config: /data/log.config
media_store_path: /data/media_store
signing_key_path: /data/signing.key
macaroon_secret_key: "${MACAROON_SECRET_KEY}"
form_secret: "${FORM_SECRET}"

federation_domain_whitelist: []
trusted_key_servers: []
suppress_key_server_warning: true

enable_registration: false
encryption_enabled_by_default_for_room_type: invite
user_directory:
  enabled: true
  search_all_users: true
max_upload_size: 50M

# Allow pushes to the mock gateway on the Docker host (push_gateway.py)
ip_range_whitelist: ["0.250.250.254/32", "192.168.65.0/24"]

# Relaxed for automated spike measurements
rc_message:
  per_second: 50
  burst_count: 100

matrix_authentication_service:
  enabled: true
  endpoint: "http://mas:8080/"
  secret: "${MAS_SYNAPSE_SECRET}"
YAML

    cat > "$GEN/mas/config.yaml" <<YAML
http:
  public_base: "${AUTH_URL}/"
  issuer: "${AUTH_URL}/"
  trusted_proxies: [172.16.0.0/12, 192.168.0.0/16, 127.0.0.1/8]
  listeners:
    - name: web
      resources:
        - name: discovery
        - name: human
        - name: oauth
        - name: compat
        - name: graphql
        - name: assets
        - name: adminapi
      binds:
        - address: "0.0.0.0:8080"
    - name: internal
      resources:
        - name: health
      binds:
        - address: "0.0.0.0:8081"

database:
  uri: "postgresql://spike:${POSTGRES_PASSWORD}@postgres/mas"

email:
  from: '"NGO.Tools Chat Spike" <no-reply@ngo-spike.test>'
  reply_to: '"NGO.Tools Chat Spike" <no-reply@ngo-spike.test>'
  transport: blackhole

# Spike only: production disables passwords and uses NGO.Tools as upstream.
passwords:
  enabled: true
  minimum_complexity: 0

account:
  password_registration_enabled: false
  account_deactivation_allowed: false

branding:
  service_name: "NGO.Tools Chat (Spike)"

matrix:
  kind: synapse
  homeserver: "${SERVER_NAME}"
  endpoint: "http://synapse:8008/"
  secret: "${MAS_SYNAPSE_SECRET}"

policy:
  data:
    client_registration:
      allow_insecure_uris: true
      allow_host_mismatch: true
      allow_missing_contacts: true

# Spike only: short-lived access tokens so that refresh is exercised in tests
experimental:
  access_token_ttl: 60

secrets:
  encryption: "${MAS_ENCRYPTION_SECRET}"
  keys_dir: /keys
YAML

    cat > "$GEN/Caddyfile" <<CADDY
{
    local_certs
    skip_install_trust
}

${HOST}:${HS_PORT} {
    @compat path_regexp ^/_matrix/client/(.*)/(login|logout|refresh)
    reverse_proxy @compat mas:8080
    reverse_proxy synapse:8008
}

${HOST}:${AUTH_PORT} {
    reverse_proxy mas:8080
}

${HOST}:${WEB_PORT} {
    reverse_proxy element:8080
}
CADDY

    cat > "$GEN/element-config.json" <<JSON
{
    "default_server_config": {
        "m.homeserver": {
            "base_url": "${HS_URL}",
            "server_name": "${SERVER_NAME}"
        }
    },
    "brand": "NGO.Tools Chat (Spike)",
    "disable_custom_urls": true,
    "disable_guests": true,
    "setting_defaults": { "language": "de" }
}
JSON

    chmod -R a+rX "$GEN/synapse" "$GEN/mas"
}

wait_healthy() {
    for _ in $(seq 1 60); do
        if curl -skf "${HS_URL}/_matrix/client/versions" >/dev/null \
            && curl -skf "${AUTH_URL}/.well-known/openid-configuration" >/dev/null; then
            return 0
        fi
        sleep 2
    done
    echo "Server did not become healthy" >&2
    compose ps
    return 1
}

print_endpoints() {
    echo "Homeserver: ${HS_URL}"
    echo "MAS:        ${AUTH_URL}"
    echo "Element:    ${WEB_URL}"
    echo "Server name: ${SERVER_NAME}"
}

case "${1:-up}" in
    up)
        render
        compose up -d
        wait_healthy
        print_endpoints
        ;;
    users)
        for user in Alice Bob; do
            localpart=$(echo "$user" | tr "[:upper:]" "[:lower:]")
            compose exec -T mas mas-cli manage register-user --yes --ignore-password-complexity \
                --password "$TEST_PASSWORD" --display-name "$user" "$localpart" || true
        done
        echo "Users alice and bob (password from TEST_PASSWORD)"
        ;;
    ca)
        compose cp caddy:/data/caddy/pki/authorities/local/root.crt "$GEN/caddy-root.crt"
        xcrun simctl keychain booted add-root-cert "$GEN/caddy-root.crt" 2>/dev/null \
            && echo "Trusted in booted iOS simulator(s)" || echo "No booted iOS simulator"
        echo "Root CA: $PWD/$GEN/caddy-root.crt"
        ;;
    android)
        for port in "$HS_PORT" "$AUTH_PORT" "$WEB_PORT"; do
            adb reverse "tcp:${port}" "tcp:${port}"
        done
        compose cp caddy:/data/caddy/pki/authorities/local/root.crt "$GEN/caddy-root.crt"
        adb push "$GEN/caddy-root.crt" /sdcard/Download/ngo-spike-root.crt >/dev/null
        echo "Ports forwarded; install /sdcard/Download/ngo-spike-root.crt as CA certificate on the emulator"
        ;;
    down)
        compose down
        ;;
    reset)
        compose down -v || true
        rm -rf "$GEN"
        ;;
    env)
        print_endpoints
        ;;
    *)
        echo "Usage: $0 [up|users|ca|android|down|reset|env]" >&2
        exit 1
        ;;
esac
