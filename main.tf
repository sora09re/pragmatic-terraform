provider "aws" {
  region  = "ap-northeast-1"
  profile = var.aws_profile
  default_tags {
    tags = {
      Env   = "pragmatic-terraform"
      Owner = "s-aoki"
    }
  }
}
