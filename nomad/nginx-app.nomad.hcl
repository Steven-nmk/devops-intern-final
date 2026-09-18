variable "image_tag" {
  type        = string
  description = "The container tag of the application image in GHCR"
  default     = "latest"
}

job "nginx-app" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "2m"
    auto_revert       = true
  }

  group "web" {
    count = 1

    restart {
      attempts = 3
      interval = "5m"
      delay    = "15s"
      mode     = "fail"
    }

    reschedule {
      attempts       = 5
      interval       = "10m"
      delay          = "30s"
      delay_function = "exponential"
    }

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "nginx-web"
      port = "http"

      check {
        type     = "http"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "ghcr.io/your_github_handle/devops-intern-final:${var.image_tag}"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
