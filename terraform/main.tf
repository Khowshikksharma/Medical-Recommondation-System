terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "null" {}

resource "null_resource" "init" {
  provisioner "local-exec" {
    command = "echo Terraform setup for HealthCareMRS complete."
  }
}
