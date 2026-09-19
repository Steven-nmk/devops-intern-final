variable "app_tag" {
  type        = string
  description = "The tag of the NGINX app image to deploy"
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
      attempts = 2
      interval = "1m"
      delay    = "10s"
      mode     = "fail"
    }

    reschedule {
      attempts       = 3
      interval       = "5m"
      delay          = "15s"
      delay_function = "exponential"
      unlimited      = false
    }

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name     = "nginx-app"
      port     = "http"
      provider = "consul"

      check {
        name     = "nginx-health"
        type     = "http"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "ghcr.io/steven201nmk/nginx-app:${var.app_tag}"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
