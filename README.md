# Development Infraestructure Provider

Centralized repository to provide deployment tools for local Docker development.

---
## Requirements

* Make 3.81
* Docker 27.1.1

---
## Available Applications:

Application Name   | Application|
---                | ---        |
Jaeger 1.66.0      | jaeger     |
Kafka 3.8.0        | kafka      |
Keycloak 25.0      | keycloak   |
Nexus 3.71.0       | nexus      |
Ollama 0.5.7       | ollama     |
Prometheus  3.1.0  | prometheus |
Valkey 8.0.2       | valkey     |

---
## Run

```
make docker.start APPLICATION=...
```