terraform {
  backend "s3" {
    bucket         = "[organization]-terraform-state"
    key            = "logrhythm/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
