#!/bin/env bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../../.env

until curl --silent --fail --output /dev/null localhost:${NEXUS_PUBLIC_PORT}; do
do
  echo "Waiting healthcheck for 'localhost:${NEXUS_PUBLIC_PORT}'"
  sleep 30
done

echo "Changing the default Nexus 'admin' password with '${DEFAULT_PASSWORD}'"
curl --silent --insecure --request PUT \
    http://localhost:${NEXUS_PUBLIC_PORT}/service/rest/v1/security/users/admin/change-password \
    --header "Content-Type: text/plain" \
    --user admin:$(docker exec -it nexus cat /nexus-data/admin.password) \
    --data "${DEFAULT_PASSWORD}"

echo "Enable Local Authentication and Docker Bearer Token Realm"
curl --silent --insecure --request PUT \
    http://localhost:${NEXUS_PUBLIC_PORT}/service/rest/v1/security/realms/active \
    --header "Content-Type: application/json" \
    --user admin:${DEFAULT_PASSWORD} \
    --data '["NexusAuthenticatingRealm", "DockerToken"]'

echo "Enable Anonymous Access"
curl --silent --insecure --request PUT \
    http://localhost:${NEXUS_PUBLIC_PORT}/service/rest/internal/ui/anonymous-settings \
    --header "Content-Type: application/json" \
    --user admin:${DEFAULT_PASSWORD} \
    --data '{ "enabled": true, "userId": "anonymous", "realmName": "NexusAuthorizingRealm" }'

echo "Creating the default user '${DEFAULT_USER}' password with '${DEFAULT_PASSWORD}'"
curl --silent --insecure --request POST \
    http://localhost:${NEXUS_PUBLIC_PORT}/service/rest/v1/security/users \
    --header "Content-Type: application/json" \
    --user admin:${DEFAULT_PASSWORD} \
    --data "{
      \"userId\": \"${DEFAULT_USER}\",
      \"firstName\": \"${DEFAULT_USER}\",
      \"lastName\": \"${DEFAULT_USER}\",
      \"emailAddress\": \"${DEFAULT_USER}@admin.com\",
      \"password\": \"${DEFAULT_PASSWORD}\",
      \"status\": \"active\",
      \"roles\": [
        \"nx-admin\"
      ]
    }" > /dev/null

echo "Creating Docker Repository"
curl --silent --insecure --request POST \
  http://localhost:${NEXUS_PUBLIC_PORT}/service/rest/v1/repositories/docker/hosted \
  --header "Content-Type: application/json" \
  --user admin:${DEFAULT_PASSWORD} \
  --data "{
    \"name\": \"docker\",
    \"online\": true,
    \"storage\": {
      \"blobStoreName\": \"default\",
      \"strictContentTypeValidation\": true,
      \"writePolicy\": \"ALLOW\"
    },
    \"component\": {
      \"proprietaryComponents\": false
    },
    \"docker\": {
      \"v1Enabled\": true,
      \"forceBasicAuth\": false,
      \"httpPort\": ${NEXUS_DOCKER_PORT}
    },
    \"format\": \"docker\",
    \"type\": \"hosted\"
  }" > /dev/null