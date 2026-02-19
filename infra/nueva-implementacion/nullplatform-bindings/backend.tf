terraform {
  backend "s3" {
    bucket         = "<existing-backend-bucket>"
    key            = "nullplatform-bindings/terraform.tfstate"
    region         = "<aws-region>"
    dynamodb_table = "<existing-dynamodb-table>"
    encrypt        = true
    profile        = "<aws-profile>"
  }
}
