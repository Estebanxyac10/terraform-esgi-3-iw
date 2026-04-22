# =============================================================================
# volumes.tf — Volumes Docker pour la persistance des données
# =============================================================================

# Volume pour les données PostgreSQL
# Sans ce volume, les données sont perdues à chaque terraform destroy/apply
resource "docker_volume" "postgres_data" {
  name = "${var.project_name}_postgres_data"

  labels {
    label = "project"
    value = var.project_name
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Volumes optionnels pour chaque microservice (créés avec toset + for_each)
resource "docker_volume" "service_volumes" {
  for_each = toset(["user", "product", "order"])

  name = "${var.project_name}_${each.key}_data"

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "service"
    value = each.key
  }
}
