output "container_name" {
  description = "Nom du conteneur Docker créé"
  value       = docker_container.service.name
}

output "container_id" {
  description = "ID du conteneur Docker"
  value       = docker_container.service.id
}

output "image_id" {
  description = "ID de l'image Docker buildée"
  value       = docker_image.service.image_id
}

output "volume_name" {
  description = "Nom du volume Docker (null si enable_volume = false)"
  value       = var.enable_volume ? docker_volume.service[0].name : null
}
