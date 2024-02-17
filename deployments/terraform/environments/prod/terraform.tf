terraform {
  required_version = ">= 0.15.0"

  #   backend "s3" {
  #     bucket         = "prod-terraform-state"
  #     key            = "terraform.tfstate"
  #     region         = "us-east-2"
  #     dynamodb_table = "prod-terraform-state-lock"
  #     encrypt        = true
  #   }
}
