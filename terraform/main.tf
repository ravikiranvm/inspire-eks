provider "aws" {
    region = "us-east-1"
}

# Referencing the database module
module "databse" {
    source = "./modules/database"
}

# Referencing the kubernetes module
module "kubernetes" {
    source = "./modules/kubernetes"
}