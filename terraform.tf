terraform {
  required_version = "~> 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
  backend "local" {
    path = "./terraform.tfstate"
  }
}
