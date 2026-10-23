package terraform.security

import rego.v1

# Política de ejemplo:
# - En el plan deben existir recursos random_pet.lab_name.
# - El prefijo configurado debe ser "lab".
# La policy inspecciona el plan JSON de Terraform.
deny contains msg if {
  some rc in input.resource_changes
  rc.type == "random_pet"
  rc.name == "lab_name"
  rc.change.after.prefix != "lab"
  msg := sprintf("random_pet.lab_name debe usar prefix = \"lab\" (valor encontrado: %v)", [rc.change.after.prefix])
}

deny contains msg if {
  not some_lab_name_resource
  msg := "El plan debe incluir el recurso random_pet.lab_name."
}

some_lab_name_resource if {
  some rc in input.resource_changes
  rc.type == "random_pet"
  rc.name == "lab_name"
  rc.change.actions != ["delete"]
}

# La decisión final es permitir solo cuando no haya violaciones.
allow if {
  count(deny) == 0
}
