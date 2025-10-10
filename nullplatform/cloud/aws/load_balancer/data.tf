# Opción alternativa: obtener el CIDR directamente del VPC
data "aws_vpc" "this" {
  id    = var.vpc_id
}

# Obtener subnets privadas automáticamente
data "aws_subnets" "private" {

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Type = "private"
  }
}

# Obtener subnets públicas automáticamente
data "aws_subnets" "public" {

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Type = "public"
  }
}