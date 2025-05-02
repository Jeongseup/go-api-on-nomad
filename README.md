# go-api-on-nomad

🚀 A simple practice project deploying a Go REST API using [Nomad](https://www.nomadproject.io/), [Consul](https://www.consul.io/), and [Traefik](https://traefik.io/).

This repository demonstrates how to deploy a statically compiled Go API app across a Nomad cluster with load balancing via Traefik and service discovery powered by Consul.

---

## 📦 Project Structure

```
.
├── consul/                 # Consul server/client configurations
│   └── configs/
│       ├── server.hcl
│       └── client.hcl
├── nomad/                  # Nomad configuration and job specs
│   ├── configs/
│   │   ├── nomad.hcl       # Nomad server+client settings
│   │   └── nomad.env
│   └── jobs/
│       ├── go-api.nomad
│       └── traefik.nomad
├── go-api/                 # The Go application
│   ├── main.go
│   ├── build.sh
│   └── go.mod
└── README.md
```

---

## 🛠️ Requirements

- Ubuntu 20.04+ or equivalent
- Nomad 1.6+
- Consul 1.13+
- (Optional) Traefik v2.11 for reverse proxy
- curl / dig / resolvectl for debugging

---

## ⚙️ Getting Started

### 1. Build the Go API

```bash
cd go-api
./build.sh
```

> This builds a static binary for `linux/amd64`.

### 2. Start Consul Agent

On server node:

```bash
consul agent -config-file=./consul/configs/server.hcl
```

On client nodes:

```bash
consul agent -config-file=./consul/configs/client.hcl
```

### 3. Start Nomad

On server node:

```bash
nomad agent -config=./nomad/configs/nomad.hcl
```

### 4. Run Nomad Jobs

```bash
nomad job run nomad/jobs/go-api.nomad
nomad job run nomad/jobs/traefik.nomad
```

### 5. Test the Application

```bash
curl http://<any-nomad-client-ip>:8080/go-api
```

> Should return `Hello, Nomad from Go!`

---

## 🔍 Features Demonstrated

- ✅ Nomad job spec for Go app and Traefik
- ✅ Go binary downloaded from GitHub release (`artifact`)
- ✅ Raw_exec driver usage
- ✅ Consul DNS-based service discovery
- ✅ Load-balanced internal/external access via Traefik
- ✅ Multinode spreading via `spread { attribute = "${node.unique.name}" }`

---

## 📎 Reference

- [Nomad Docs](https://developer.hashicorp.com/nomad)
- [Consul DNS Discovery](https://developer.hashicorp.com/consul/docs/discovery/dns)
- [Traefik Nomad Guide](https://doc.traefik.io/traefik/providers/consul-catalog/)
