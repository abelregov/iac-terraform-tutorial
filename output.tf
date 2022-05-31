output dev-vpc-id {
  value       = aws_vpc.development-vpc.id
  description = "The ID of the VPC created"
}

output dev-subnet-id {
  value       = aws_subnet.dev-subnet-1.id
  description = "vpc id for subnet 1"
}

output dev-subnet2-id {
  value       = aws_subnet.dev-subnet-2.id
  description = "vpc id for subnet 2"
}

output data-existing-vpc-id {
  value       = data.aws_vpc.existing_vpc.id
  description = "vpc id for data"
}