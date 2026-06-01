provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Project     = "Module Testing"
      Environment = "dev"
      Owner       = "edm"
      ManagedBy   = "terraform"
    }
  }
}