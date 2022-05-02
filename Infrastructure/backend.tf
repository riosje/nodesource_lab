terraform {
  backend "s3" {
    bucket = "tf-state-nodesource-lab"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}