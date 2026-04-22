# =============================================================================
# modules/service-stack/main.tf
# Module regroupant : build image Docker, conteneur, et volume optionnel
# =============================================================================

resource "docker_image" "service" {
  name = "${var.project_name}/${var.name}:${var.image_tag}"

  build {
    context    = var.build_context
    dockerfile = var.dockerfile_path
  }

  triggers = {
    source_hash = length(var.source_files) > 0 ? sha256(join("", [
      for f in var.source_files : filesha256(f)
    ])) : ""
  }
}

resource "docker_container" "service" {
  name  = "${var.project_name}_${replace(var.name, "-", "_")}"
  image = docker_image.service.image_id

  restart = var.restart_policy

  env = var.env_vars

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  networks_advanced {
    name = var.network_name
  }

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "service"
    value = var.name
  }

  lifecycle {
    ignore_changes = [image]
  }
}

# Volume optionnel — créé uniquement si enable_volume = true
resource "docker_volume" "service" {
  count = var.enable_volume ? 1 : 0

  name = "${var.project_name}_${replace(var.name, "-", "_")}_data"

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "service"
    value = var.name
  }
}
