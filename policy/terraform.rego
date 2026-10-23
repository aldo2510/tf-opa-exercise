package terraform.security

import rego.v1

# Require random_pet.lab_name to use the approved "lab" prefix.
deny contains msg if {
  some rc in input.resource_changes
  rc.type == "random_pet"
  rc.name == "lab_name"
  rc.change.after.prefix != "lab"
  msg := sprintf("random_pet.lab_name must use prefix = \"lab\" (found: %v)", [rc.change.after.prefix])
}

# Ensure the expected resource exists in the plan.
deny contains msg if {
  not some_lab_name_resource
  msg := "Plan must include random_pet.lab_name."
}

some_lab_name_resource if {
  some rc in input.resource_changes
  rc.type == "random_pet"
  rc.name == "lab_name"
  rc.change.actions != ["delete"]
}

allow if {
  count(deny) == 0
}
