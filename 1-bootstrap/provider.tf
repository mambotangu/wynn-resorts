terraform {
  backend "gcs" {
    bucket = "bkt-b-tfstate-7124"
    prefix = "tf_state_bootstrap"
  }
}
