{
  "visible_to": ["{{ env.Getenv "NRN" }}"],
  "assignable_to": "any",
  "type": "scope",
  "attributes": {
    "nrn": "{{ env.Getenv "NRN" }}"
  },
  "use_default_actions": false,
  "selectors": {"category": "Scope", "imported": false, "provider": "Agent", "sub_category": "Custom"},
  "available_actions": ["create-scope"]
}
