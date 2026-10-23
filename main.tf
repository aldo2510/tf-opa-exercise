terraform {
  required_version = ">= 1.5.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Este laboratorio no crea recursos en ningún proveedor cloud.
# random_pet genera un nombre local y permite practicar el ciclo de Terraform.
resource "random_pet" "lab_name" {
  prefix = "lab"
  length = 2
}

output "generated_name" {
  description = "Nombre generado para el laboratorio."
  value       = random_pet.lab_name.id
}
