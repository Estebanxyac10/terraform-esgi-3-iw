project_name = "shopmicrfo"

network_subnet = "172.20.0.0/16"

frontend_port        = 8080
user_service_port    = 3001
product_service_port = 3002
order_service_port   = 3003
postgres_port        = 5432

db_name     = "shopdb"
db_user     = "shopuser"
db_password = "shoppassword"

postgres_image_tag = "16-alpine"
services_image_tag = "latest"
