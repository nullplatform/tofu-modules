# 1. Obtener los IDs de los servicios de Oracle para la región (necesario para el Service Gateway)
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}
