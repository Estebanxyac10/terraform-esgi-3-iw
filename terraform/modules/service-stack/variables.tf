variable "name" {
  description = "Nom du service"
  type        = string
}

variable "build_context" {
  description = "Chemin vers le dossier de build Docker"
  type        = string
}

variable "dockerfile_path" {
  description = "Nom du Dockerfile (relatif au build_context)"
  type        = string
  default     = "Dockerfile"
}

variable "internal_port" {
  description = "Port écouté par le processus dans le conteneur"
  type        = number
}

variable "external_port" {
  description = "Port exposé sur la machine hôte"
  type        = number
}

variable "network_name" {
  description = "Nom du réseau Docker à rejoindre"
  type        = string
}

variable "env_vars" {
  description = "Variables d'environnement passées au conteneur (format KEY=VALUE)"
  type        = list(string)
  default     = []
}

variable "project_name" {
  description = "Nom du projet (pour nommage et labels)"
  type        = string
}

variable "image_tag" {
  description = "Tag appliqué à l'image Docker buildée"
  type        = string
  default     = "latest"
}

variable "restart_policy" {
  description = "Politique de redémarrage du conteneur"
  type        = string
  default     = "unless-stopped"
}

variable "enable_volume" {
  description = "Crée un volume Docker optionnel pour ce service"
  type        = bool
  default     = false
}

variable "source_files" {
  description = "Liste des fichiers sources utilisés pour le trigger de rebuild"
  type        = list(string)
  default     = []
}
