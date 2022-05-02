module "organization_policies" {
  source = "../../modules/organization_policies"
  org_domain_id        = var.org_domain_id
  organization_id = data.terraform_remote_state.bootstrap.outputs.organization_id
}

module "org_level_iam_group_bindings" {
  source               = "../../modules/iam/org-iam"
  domain               = var.domain
  org_id               = var.organization_id
  billing_admin_group  = var.billing_admin_group
  org_admin_group      = var.org_admin_group
  network_admin_group  = var.network_admin_group
  support_admin_group  = var.support_admin_group
  auditor_group        = var.auditor_group
  security_admin_group = var.security_admin_group
}
