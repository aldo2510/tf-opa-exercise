terraform {
  required_version = ">= 1.5.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# This lab creates no cloud resources.
resource "random_pet" "lab_name" {
  prefix = "lax"
  length = 2
}

output "generated_name" {
  description = "Generated lab name."
  value       = random_pet.lab_name.id
}
