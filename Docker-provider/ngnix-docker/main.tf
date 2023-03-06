terraform { 
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}
provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource docker_image nginx {
  name = "nginx:latest"
  pull_triggers = [data.docker_registry_image.nginx.sha256_digest]
}

resource docker_container nginx_container {
  image = docker_image.nginx.name
  name = "nginx_container"

  ports {
    external= 8080
    internal= 80
  }
}