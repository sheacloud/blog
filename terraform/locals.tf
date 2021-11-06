locals {
    environment = terraform.workspace == "dev" ? "dev" : "prod"
    domain_name = terraform.workspace == "dev" ? "dev.${var.domain_name}" : var.domain_name
}