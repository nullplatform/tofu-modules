# A specification version that is not known until apply, as when the checklist
# is created or changed in the same apply. The mocked provider gives computed
# attributes a value at plan, so the id of a built-in resource stands in.
terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
    }
  }
}

resource "terraform_data" "version" {}

module "action" {
  source = "../../.."

  nrn    = "organization=1:account=2"
  action = "deployment:create"

  checklist = {
    specification_id = "spec_${terraform_data.version.id}"
    on_fail          = "manual"
  }
}
