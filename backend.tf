terraform {

	required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
	
  cloud {
    organization = "weitest"

    workspaces {
      project = "myproject"
      name = "REQ1234567"
    }
  }
}