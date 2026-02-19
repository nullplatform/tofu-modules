terraform {
  backend "s3" {
    bucket         = "<existing-backend-bucket>"
    key            = "infrastructure/terraform.tfstate"
    region         = "<aws-region>"
    dynamodb_table = "<existing-dynamodb-table>"
    encrypt        = true
    profile        = "<aws-profile>"
  }
}
