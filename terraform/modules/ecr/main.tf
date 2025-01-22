# Create ECR repos for frontend and backend 
resource "aws_ecr_repository" "frontend" {
  name = "frontend-repo"
}

resource "aws_ecr_repository" "backend" {
    name = "backend-repo"
}


