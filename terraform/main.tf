terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

resource "docker_image" "healthcaremrs" {
  name = "khowshikksharma/healthcaremrs:latest"
}

resource "docker_container" "healthcaremrs_container" {
  name  = "healthcaremrs-app"
  image = docker_image.healthcaremrs.name

  ports {
    internal = 80
    external = 8090
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
}

# 🆕 Add this:
resource "docker_image" "nagios" {
  name = "jasonrivers/nagios:latest"
}

resource "docker_container" "nagios_container" {
  name  = "nagios-monitor"
  image = docker_image.nagios.name

  ports {
    internal = 80
    external = 8085
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  volumes {
    host_path      = "${abspath(path.module)}/nagios/healthcaremrs.cfg"
    container_path = "/opt/nagios/etc/servers/healthcaremrs.cfg"
    read_only      = false
  }

}
