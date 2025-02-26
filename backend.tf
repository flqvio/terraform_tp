terraform {
  backend "s3" {
    bucket         = "terraform-state-qh2o7"
    key            = "global/s3/student_19/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}