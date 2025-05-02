job "go-api" {
  datacenters = ["dc1"]
  type = "service"

  group "go-api-group" {
    count = 3

    spread {
      attribute = "${node.unique.name}"
      weight    = 100
    }

    network {
      port "http" {
        static = 8000
      }
    }

    task "go-api" {
      driver = "raw_exec"

      artifact {
        source      = "https://github.com/Jeongseup/nomad-go-app-example/releases/download/v0.1.0/go-api"
        destination = "/opt/app/"
      }

      config {
        command = "/opt/app/go-api"
      }

      resources {
        cpu    = 100
        memory = 128
      }

      service {
        name = "go-api"
        port = "http"


        tags = [
          "traefik.enable=true",                                 # Traefik에 이 서비스 노출
          "traefik.http.routers.go-api.rule=PathPrefix(`/go-api`)",    # 요청 경로: `/`이면 go-api로
          "traefik.http.services.go-api.loadbalancer.server.port=8000", # 실제 go-api 서비스가 응답하는 포트
          "traefik.http.services.go-api.loadbalancer.sticky=false"     # 라운드로빈 적용을 위해 sticky 비활성화
        ]

        check {
          name     = "http-check"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
     }
    }
  }
}
