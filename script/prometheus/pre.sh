#!/bin/env bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../../.env

declare readonly PROMETHEUS_YML_FILE="${BASE_PATH}/../../etc/prometheus/prometheus.yml"
echo "Writing '${PROMETHEUS_YML_FILE}' using '${PROMETHEUS_TARGETS}'"

cat > ${PROMETHEUS_YML_FILE} <<EOL
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "Prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "Services"
    metrics_path: "/actuator/prometheus"
    scrape_interval: 5s
    static_configs:
EOL

for PROMETHEUS_TARGET in ${PROMETHEUS_TARGETS//,/ }; do 
  echo "      - targets: [\"${PROMETHEUS_TARGET}\"]" >> ${PROMETHEUS_YML_FILE}
done