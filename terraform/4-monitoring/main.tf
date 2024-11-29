terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "log_groups" {
  source = "./log-groups"
}

module "alarms" {
  source = "./cloudwatch-alarms"
}

module "dashboards" {
  source = "./dashboards"
}
