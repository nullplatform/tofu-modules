mock_provider "nullplatform" {}

# Components are passed as object literals rather than resource references so the
# BOM is fully known at plan time and can be asserted on. `resource` only needs
# the fields the module reads: id, slug, last_snapshot_id (+ action_specifications
# on specs).
variables {
  nrn = "organization=myorg:account=myaccount"

  release = {
    version = "1.0.0"
    default = true
    slug    = "sqs-queue"
    name    = "SQS Queue"
  }

  components = [
    {
      type = "service_specification"
      resource = {
        id               = "id-spec"
        slug             = "sqs-queue"
        name             = "SQS Queue"
        last_snapshot_id = "snap-spec"
        visible_to       = ["organization=myorg:account=myaccount"]
        # A spec whose actions are its own resources (use_default_actions = false).
        # The provider populates this read-only attribute from whatever actions
        # exist on the server regardless of use_default_actions, so it is empty on
        # the first apply (the spec is created before the actions) and populated on
        # every plan after that.
        action_specifications = [
          { id = "id-create", slug = "create-sqs-queue", last_snapshot_id = "snap-create" },
          { id = "id-update", slug = "update-sqs-queue", last_snapshot_id = "snap-update" },
        ]
      }
    },
    {
      type            = "action_specification"
      resource        = { id = "id-create", slug = "create-sqs-queue", last_snapshot_id = "snap-create" }
      parent_resource = { id = "id-spec" }
    },
    {
      type            = "action_specification"
      resource        = { id = "id-update", slug = "update-sqs-queue", last_snapshot_id = "snap-update" }
      parent_resource = { id = "id-spec" }
    },
  ]
}

# Regression guard for the duplication bug: with the actions listed explicitly AND
# present in the spec's action_specifications, both code paths emit the same
# resource_ids. Without deduping, the BOM carried each action twice (once named
# action_specification/<spec>/<action>, once action_specification/<action>).
run "explicit_actions_are_not_duplicated_by_spec_expansion" {
  command = plan

  assert {
    condition     = length(nullplatform_package.this.components) == 3
    error_message = "BOM should hold exactly 3 components (1 spec + 2 actions), got ${length(nullplatform_package.this.components)}"
  }

  assert {
    condition = length(distinct([for c in nullplatform_package.this.components : c.resource_id])) == length(nullplatform_package.this.components)
    error_message = "BOM must not pin the same resource_id twice"
  }

  # The explicit entry wins, so the name is the flat one. This matters beyond
  # cosmetics: it is the name the first apply publishes (when action_specifications
  # is still empty), so keeping it stable avoids a rename-only republish later.
  assert {
    condition = alltrue([
      for c in nullplatform_package.this.components :
      can(regex("^action_specification/[a-z-]+$", c.name))
      if c.resource_type == "action_specification"
    ])
    error_message = "explicit actions should keep their flat action_specification/<slug> name"
  }

  assert {
    condition = alltrue([
      for c in nullplatform_package.this.components :
      c.parent_id == "id-spec"
      if c.resource_type == "action_specification"
    ])
    error_message = "every action component should hang off the service specification"
  }
}

# The first apply: the spec exists but its actions do not yet, so
# action_specifications is empty and only the explicit entries can carry them.
run "explicit_actions_are_pinned_when_spec_expansion_is_empty" {
  command = plan

  variables {
    components = [
      {
        type = "service_specification"
        resource = {
          id                    = "id-spec"
          slug                  = "sqs-queue"
          name                  = "SQS Queue"
          last_snapshot_id      = "snap-spec"
          visible_to            = ["organization=myorg:account=myaccount"]
          action_specifications = []
        }
      },
      {
        type            = "action_specification"
        resource        = { id = "id-create", slug = "create-sqs-queue", last_snapshot_id = "snap-create" }
        parent_resource = { id = "id-spec" }
      },
      {
        type            = "action_specification"
        resource        = { id = "id-update", slug = "update-sqs-queue", last_snapshot_id = "snap-update" }
        parent_resource = { id = "id-spec" }
      },
    ]
  }

  assert {
    condition     = length(nullplatform_package.this.components) == 3
    error_message = "BOM should hold 1 spec + 2 explicit actions, got ${length(nullplatform_package.this.components)}"
  }
}

# The common path must keep working: no explicit action entries, so the spec's
# own action_specifications are the only source of action components.
run "spec_expansion_still_pins_actions_when_none_are_explicit" {
  command = plan

  variables {
    components = [
      {
        type = "service_specification"
        resource = {
          id               = "id-spec"
          slug             = "sqs-queue"
          name             = "SQS Queue"
          last_snapshot_id = "snap-spec"
          visible_to       = ["organization=myorg:account=myaccount"]
          action_specifications = [
            { id = "id-create", slug = "create-sqs-queue", last_snapshot_id = "snap-create" },
            { id = "id-update", slug = "update-sqs-queue", last_snapshot_id = "snap-update" },
          ]
        }
      },
    ]
  }

  assert {
    condition     = length(nullplatform_package.this.components) == 3
    error_message = "BOM should hold 1 spec + 2 auto-expanded actions, got ${length(nullplatform_package.this.components)}"
  }

  assert {
    condition = alltrue([
      for c in nullplatform_package.this.components :
      can(regex("^action_specification/sqs-queue/[a-z-]+$", c.name))
      if c.resource_type == "action_specification"
    ])
    error_message = "auto-expanded actions should keep their nested action_specification/<spec>/<action> name"
  }
}

# Actions without a snapshot cannot be pinned and must be skipped rather than sent
# with an empty resource_revision_id.
run "spec_expansion_skips_actions_without_a_snapshot" {
  command = plan

  variables {
    components = [
      {
        type = "service_specification"
        resource = {
          id               = "id-spec"
          slug             = "sqs-queue"
          name             = "SQS Queue"
          last_snapshot_id = "snap-spec"
          visible_to       = ["organization=myorg:account=myaccount"]
          action_specifications = [
            { id = "id-create", slug = "create-sqs-queue", last_snapshot_id = "snap-create" },
            { id = "id-nosnap", slug = "no-snapshot-yet", last_snapshot_id = "" },
          ]
        }
      },
    ]
  }

  assert {
    condition     = length(nullplatform_package.this.components) == 2
    error_message = "the snapshotless action should be skipped, leaving 1 spec + 1 action"
  }
}
