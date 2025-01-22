provider "aws" {
    region = "us-east-1"
}

# Referencing the database module
module "databse" {
    source = "./modules/database"
}

# Referencing the kubernetes module
module "ecr" {
    source = "./modules/ecr"
}

# Define the VPC and Subnets
resource "aws_vpc" "inspire_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "inspire-vpc"
  }
}

resource "aws_subnet" "inspire_subnet_a" {
  vpc_id                  = aws_vpc.inspire_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "inspire-subnet-a"
  }
}

resource "aws_subnet" "inspire_subnet_b" {
  vpc_id                  = aws_vpc.inspire_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "inspire-subnet-b"
  }
}

resource "aws_subnet" "inspire_subnet_c" {
  vpc_id                  = aws_vpc.inspire_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "inspire-subnet-c"
  }
}

# Create the Internet Gateway (IGW)
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.inspire_vpc.id
  tags = {
    Name = "eks-igw"
  }
}

# Attach IGW to the VPC
resource "aws_internet_gateway_attachment" "eks_vpc_attachment" {
  vpc_id       = aws_vpc.inspire_vpc.id
  internet_gateway_id = aws_internet_gateway.eks_igw.id
}

# Create a Route Table for public subnets
resource "aws_route_table" "eks_public_route_table" {
  vpc_id = aws_vpc.inspire_vpc.id
}

# Create a Route to the IGW
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.eks_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id
}

# Attach the Route Table to each public subnet
resource "aws_route_table_association" "public_association_a" {
  subnet_id     = aws_subnet.inspire_subnet_a.id
  route_table_id = aws_route_table.eks_public_route_table.id
}

resource "aws_route_table_association" "public_association_b" {
  subnet_id     = aws_subnet.inspire_subnet_b.id
  route_table_id = aws_route_table.eks_public_route_table.id
}

resource "aws_route_table_association" "public_association_c" {
  subnet_id     = aws_subnet.inspire_subnet_c.id
  route_table_id = aws_route_table.eks_public_route_table.id
}

# Setup EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "inspire-eks-cluster"
  cluster_version = "1.31"
  version   =   "20.33.0"
  subnet_ids      = [aws_subnet.inspire_subnet_a.id, aws_subnet.inspire_subnet_b.id, aws_subnet.inspire_subnet_c.id]
  vpc_id          = aws_vpc.inspire_vpc.id
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 1
      desired_size = 1
      instance_types = ["t3.medium"]
    }
  }
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
