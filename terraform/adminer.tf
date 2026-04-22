# =============================================================================
# adminer.tf — Interface web PostgreSQL (importé via terraform import)
# Créé manuellement puis importé dans le state avec :
#   docker run -d --name shopmicrfo_adminer --network shopmicrfo_network \
#     -p 8081:8080 adminer:latest
#   terraform import docker_container.adminer $(docker inspect -f '{{.Id}}' shopmicrfo_adminer)
# =============================================================================

resource "docker_container" "adminer" {
  name  = "${var.project_name}_adminer"
  image = docker_image.adminer.image_id

  restart = var.restart_policy

  ports {
    internal = 8080
    external = 8081
  }

  networks_advanced {
    name = docker_network.app.name
  }

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "service"
    value = "adminer"
  }
}
