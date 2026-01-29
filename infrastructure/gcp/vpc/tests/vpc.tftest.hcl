mock_provider "google" {}
mock_provider "google-beta" {}

variables {
  project_id   = "myorg-project"
  network_name = "myorg-vpc"
  subnets = [
    {
      subnet_name   = "myorg-subnet"
      subnet_ip     = "10.0.0.0/24"
      subnet_region = "us-central1"
    }
  ]
}

run "plans_with_valid_config" {
  command = plan
}

run "multiple_subnets" {
  command = plan

  variables {
    subnets = [
      {
        subnet_name   = "subnet-a"
        subnet_ip     = "10.0.0.0/24"
        subnet_region = "us-central1"
      },
      {
        subnet_name   = "subnet-b"
        subnet_ip     = "10.0.1.0/24"
        subnet_region = "us-east1"
      }
    ]
  }
}

run "with_secondary_ranges" {
  command = plan

  variables {
    secondary_ranges = {
      "myorg-subnet" = [
        { range_name = "pods", ip_cidr_range = "10.1.0.0/16" },
        { range_name = "services", ip_cidr_range = "10.2.0.0/20" }
      ]
    }
  }
}
