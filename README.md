# Development Infraestructure Provider

Centralized repository to provide deployment tools for local Docker development.

---
## Requirements

* Make 3.81
* Docker 26.1.4

---
## Available Applications:

Application Name   | Application|
---                | ---        |
Jaeger 1.50.0      | jaeger     |
Prometheus v2.47.2 | prometheus |
Keycloak 25.0      | keycloak   |

---
## Run

```
make docker.start APPLICATION=...
```