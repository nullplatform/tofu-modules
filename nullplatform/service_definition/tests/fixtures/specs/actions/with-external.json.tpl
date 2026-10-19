{
  "name": "With external",
  "type": "create",
  "external": {
    "action": "list-things",
    "output_schema": { "type": "object", "required": ["things"], "properties": { "things": { "type": "array" } } }
  },
  "parameters": { "schema": { "type": "object", "properties": {} }, "values": {} },
  "results": { "schema": { "type": "object", "properties": {} }, "values": {} }
}
