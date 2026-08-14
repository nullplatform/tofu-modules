mock_provider "nullplatform" {}

# components is an ordered block list, so the BOM has to come out in the order the
# caller wrote it. The module keys an intermediate map by component index, and
# Terraform walks maps in lexicographic key order — which only matches numeric
# order while every key is one digit.
variables {
  nrn = "organization=myorg:account=myaccount"

  release = {
    version = "1.0.0"
    slug    = "order-fixture"
    name    = "Order Fixture"
  }

  # 1 spec + 11 actions = 12 components, so the indices cross from 9 to 10.
  #
  # Written out literally: a test file's top-level `variables` block cannot call
  # functions, so the concat/range/format this used to build failed with
  # "Function calls not allowed" and left `components` unset. Assertions inside a
  # `run` block are unaffected, which is why the range/format below still work.
  components = [
    {
      type = "service_specification"
      resource = {
        id                    = "id-spec"
        slug                  = "the-spec"
        name                  = "The Spec"
        last_snapshot_id      = "snap-spec"
        visible_to            = ["organization=myorg:account=myaccount"]
        action_specifications = []
      }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a00"
        slug             = "action-00"
        last_snapshot_id = "snap-a00"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a01"
        slug             = "action-01"
        last_snapshot_id = "snap-a01"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a02"
        slug             = "action-02"
        last_snapshot_id = "snap-a02"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a03"
        slug             = "action-03"
        last_snapshot_id = "snap-a03"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a04"
        slug             = "action-04"
        last_snapshot_id = "snap-a04"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a05"
        slug             = "action-05"
        last_snapshot_id = "snap-a05"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a06"
        slug             = "action-06"
        last_snapshot_id = "snap-a06"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a07"
        slug             = "action-07"
        last_snapshot_id = "snap-a07"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a08"
        slug             = "action-08"
        last_snapshot_id = "snap-a08"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a09"
        slug             = "action-09"
        last_snapshot_id = "snap-a09"
      }
      parent_resource = { id = "id-spec" }
    },
    {
      type = "action_specification"
      resource = {
        id               = "id-a10"
        slug             = "action-10"
        last_snapshot_id = "snap-a10"
      }
      parent_resource = { id = "id-spec" }
    },
  ]
}

run "bom_keeps_component_order_past_ten_components" {
  command = plan

  assert {
    condition     = length(nullplatform_package.this.components) == 12
    error_message = "expected 12 components, got ${length(nullplatform_package.this.components)}"
  }

  # Unpadded keys sorted this as action-00, action-09, action-10, action-01, …
  assert {
    condition = [
      for c in nullplatform_package.this.components : c.name
      if c.resource_type == "action_specification"
      ] == [
      for i in range(11) : format("action_specification/action-%02d", i)
    ]
    error_message = "BOM component order does not follow var.components order"
  }

  assert {
    condition     = nullplatform_package.this.components[0].name == "service_specification/the-spec"
    error_message = "the service specification should stay the first BOM component"
  }
}

# The sort key is zero-padded, but the artifact's fallback name is published in the
# BOM — it has to stay the bare index, or padding the key silently renames the
# component for every package that never set an explicit `name`.
run "artifact_fallback_name_ignores_index_padding" {
  command = plan

  variables {
    components = [
      {
        type = "service_specification"
        resource = {
          id                    = "id-spec"
          slug                  = "the-spec"
          name                  = "The Spec"
          last_snapshot_id      = "snap-spec"
          visible_to            = ["organization=myorg:account=myaccount"]
          action_specifications = []
        }
      },
      {
        type = "artifact"
        resource = {
          type = "git_repository"
          meta = { url = "https://example.com/repo", reference = "main" }
        }
      },
    ]
  }

  assert {
    condition = [
      for c in nullplatform_package.this.components : c.name
      if c.resource_type == "artifact"
    ] == ["artifact/artifact-1"]
    error_message = "artifact fallback name should be artifact-<index> with no padding"
  }
}
