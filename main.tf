terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
    }
  }
}

# Configure the AWS Provider:in v4.0, only region & profile is required
#shared_credentials_files - List of paths to the shared credentials file. If not set, the default is [~/.aws/credentials].
#the best practive is to not hardcode the profile/access_key/secret_key here
#for dev_demo its ok
provider "aws" {
    region = "ap-southeast-1"
    profile = "abel_sit_qa" #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-4-upgrade
    # access_key = #deprecated
    # secret_key = #deprecated
}

variable vpc_cidr_block {
  type        = string
  description = "vpc cidr block"
}

variable vpc-environment {
  type        = string
  description = "deployment environment"
}
variable vpc-name {
  type        = string
  description = "name of vpc tag"
}

# Create a VPC
resource "aws_vpc" "development-vpc" {
    tags = {
        Name = var.vpc-name
        vpc_env: var.vpc-environment
    }
    cidr_block = var.vpc_cidr_block
}

#declare variables here
variable "subnet_cidr_block" {
  description = "Subnet CIDR block for the VPC."
  type        = string
}

resource "aws_subnet" "dev-subnet-1" {
    availability_zone = "ap-southeast-1a"
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.subnet_cidr_block #var references a variable we declared above
    # cidr_block = "10.0.0.0/24" #moved to tf variable file
    tags = {
        Name = "subnet-1-dev"
    }
}

#referencing the default vpc { = } is essential
data "aws_vpc" "existing_vpc" {
    default = true #this will look for the default vpc
}

#referencing an existing/default vpc: the subnet cidr has to be the next subset (unique subnet)
resource "aws_subnet" "dev-subnet-2" {
    vpc_id            = data.aws_vpc.existing_vpc.id #references a variable in data
    availability_zone = "ap-southeast-1a" #same az
    cidr_block        = "172.31.48.0/20" #the current vpc subnet already has a subset of {0, 16, 32} so the next ip range is {48}
    tags = {
        Name = "subnet-2-default"
    }
}



# output dev-vpc-id {
#   value       = aws_vpc.development-vpc.id
#   description = "The ID of the VPC created"
# }

# output dev-subnet-id {
#   value       = aws_subnet.dev-subnet-1.id
#   description = "vpc id for subnet 1"
# }

# output dev-subnet2-id {
#   value       = aws_subnet.dev-subnet-2.id
#   description = "vpc id for subnet 2"
# }

# output data-existing-vpc-id {
#   value       = data.aws_vpc.existing_vpc.id
#   description = "vpc id for data"
# }
