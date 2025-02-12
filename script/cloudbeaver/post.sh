#!/bin/env bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../../.env

until curl --silent --fail --output /dev/null localhost:${CLOUDBEAVER_PUBLIC_PORT}; do
  echo "Waiting healthcheck for 'localhost:${CLOUDBEAVER_PUBLIC_PORT}'"
  sleep 10
done

echo "Setting cloudbeaver using 'http://localhost:${CLOUDBEAVER_PUBLIC_PORT}/api/gql'"
curl --silent --request POST \
    http://localhost:${CLOUDBEAVER_PUBLIC_PORT}/api/gql \
    --header "Content-Type: application/json" \
    --data-raw "
    {
      \"query\":\"\n    query configureServer(\$configuration: ServerConfigInput!) {\n  configureServer(configuration: \$configuration)\n}\n    \",
      \"variables\": {
        \"configuration\": {
          \"adminName\":\"${DEFAULT_USER}\",
          \"adminPassword\":\"${DEFAULT_PASSWORD}\",
          \"serverName\":\"CloudBeaver CE Server\",
          \"serverURL\":\"http://localhost:8978\",
          \"sessionExpireTime\":604800000,
          \"adminCredentialsSaveEnabled\":true,
          \"publicCredentialsSaveEnabled\":true,
          \"customConnectionsEnabled\":false,
          \"disabledDrivers\":[\"sqlite:sqlite_jdbc\",\"h2:h2_embedded\",\"h2:h2_embedded_v2\",\"clickhouse:yandex_clickhouse\",\"generic:duckdb_jdbc\"],
          \"enabledAuthProviders\":[\"local\"],
          \"anonymousAccessEnabled\":true,
          \"enabledFeatures\":[],
          \"resourceManagerEnabled\":true,
          \"secretManagerEnabled\":false
          }
        },
      \"operationName\":\"configureServer\"
    }" > /dev/null