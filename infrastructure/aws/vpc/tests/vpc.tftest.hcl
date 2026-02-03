mock_provider "aws" {}

variables {
  organization = "myorg"
  account      = "poc"
  vpc = {
    cidr_block      = "10.0.0.0/16"
    azs             = ["us-east-1a", "us-east-1b"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  }
}

run "plans_with_valid_config" {
  command = plan
}

run "three_az_config" {
  command = plan

  variables {
    vpc = {
      cidr_block      = "10.0.0.0/16"
      azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
      private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
      public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
    }
  }
}
