# Terraform + OPA/Rego exercise

A hands-on lab combining Terraform, the local `random` provider, OPA/Rego policy as code, and GitHub Actions. **It creates no resources in AWS, Azure, or GCP and requires no cloud credentials.**

## Files

- `main.tf`: defines `random_pet.lab_name` and an output.
- `policy/terraform.rego`: policy requiring the `lab` prefix.
- `.github/workflows/terraform-opa.yml`: init, validate, plan, OPA evaluation, and apply.

## Pipeline flow

1. Checks out the repository and installs Terraform and OPA.
2. Runs `terraform fmt`, `terraform init`, and `terraform validate`.
3. Creates a Terraform plan and exports it as JSON.
4. Evaluates the Rego policy against the JSON plan.
5. If policy evaluation fails, the job fails and `terraform apply` is skipped.
6. If all checks pass, events on `main` and manual runs apply the saved plan. Pull requests only validate and plan; they do not apply.

## Run locally

Requirements: Terraform 1.5+ and the OPA CLI.

```bash
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json
opa check --strict policy/
opa eval --format pretty --data policy/terraform.rego --input tfplan.json 'data.terraform.security.deny'
```

The `deny` result should be an empty list (`[]`). To test a policy violation, change `prefix = "lab"` in `main.tf` to a different value and regenerate the plan. OPA should detect the violation and the workflow must not reach `apply`.

## What the policy checks

The policy requires `random_pet.lab_name` to use `prefix = "lab"` and checks that the expected resource is present in the plan. In a real environment, policies could enforce encryption, mandatory tags, approved regions, allowed instance sizes, or network restrictions.

## Security note

This educational pipeline auto-applies after policy success on `main` pushes and manual runs. For real infrastructure, add GitHub Environment approvals, branch protection, and appropriate access controls. Do not use automatic apply in production without these safeguards.
