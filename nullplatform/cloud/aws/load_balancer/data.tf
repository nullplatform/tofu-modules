# Opción alternativa: obtener el CIDR directamente del VPC
data "aws_vpc" "this" {
  id    = var.vpc_id
}

# Obtener subnets privadas automáticamente
data "aws_subnets" "private" {

  filter {
    name   = "tag:Name"
    values = ["*-private-*"]  # Busca subnets con "private" en el nombre
  }
}

# Obtener subnets públicas automáticamente
data "aws_subnets" "public" {

  filter {
    name   = "tag:Name"
    values = ["*-public-*"]  # Busca subnets con "private" en el nombre
  }
}