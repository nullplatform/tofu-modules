{
  "name": "Example Functions",
  "description": "Scope-wide configuration for example scopes",
  "category": "scope-configurations",
  "icon": "np:example",
  "visible_to": [
    "{{ env.Getenv "NRN" }}"
  ],
  "allow_dimensions": true,
  "schema": {
    "type": "object",
    "properties": {
      "state_bucket": { "type": "string" }
    }
  }
}
