terraform {
  backend "s3" {
    bucket         = "task1-terraform-state"   
    key            = "eks-private/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"            
    encrypt        = true
  }
}
