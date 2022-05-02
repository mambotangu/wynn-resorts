terraform {
  backend "gcs" {
    bucket = "bkt-b-sb-tfstate-161"
    prefix = "tf_state_organization"
  }
}
data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    bucket = "bkt-b-sb-tfstate-161"
    prefix = "tf_state_bootstrap"
  }
}
