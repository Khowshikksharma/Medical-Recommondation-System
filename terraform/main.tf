provider "render" {
  api_key = var.render_api_key
}

resource "render_service" "mrs_app" {
  name         = "healthcaremrs"
  service_type = "web_service"
  docker_image = "docker.io/khowshikksharma/healthcaremrs"
  branch       = "main"
  env = {
    FLASK_APP = "main.py"
  }
}
