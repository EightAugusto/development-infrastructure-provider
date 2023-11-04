# Development Infraestructure Provider

Centralized repository to provide deployment tools for local Docker development.

---
## Requirements

* Make 3.81
* Docker 24.0.6

---
## Available Applications:

Application Name   | Application|
---                | ---        |
Jaeger 1.50.0      | jaeger     |
Prometheus v2.47.2 | prometheus |

---
## Run

```
APPLICATION=...; \
make APPLICATION=${APPLICATION} docker.start 
```