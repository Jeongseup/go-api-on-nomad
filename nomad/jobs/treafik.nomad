job "traefik" {
  datacenters = ["dc1"]
  type        = "system"

  group "traefik-group" {
    count = 1

    network {
      port "http" {
        static = 8080
      }
      port "api" {
        static = 8081
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image = "traefik:v2.11"
        ports = ["http", "api"]
        network_mode = "host"

        args = [
          "--entrypoints.web.address=:8080",
          "--entrypoints.traefik.address=:8081",
          "--api.dashboard=true",
          "--api.insecure=true",
          "--providers.consulcatalog=true",
          "--providers.consulcatalog.endpoint.address=127.0.0.1:8500",
          "--providers.consulcatalog.endpoint.scheme=http",
          "--log.level=INFO"
        ]
      }

      resources {
        cpu    = 300
        memory = 256
      }

      service {
        name = "traefik"
        port = "http"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
