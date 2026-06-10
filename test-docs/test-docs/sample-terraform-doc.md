# aap_inventory Resource

This resource allows you to create inventories in AAP.

## Example Usage

```hcl
resource "aap_inventory" "example" {
  name = "my-inventory"
}
```

## Argument Reference

The following arguments are supported:

* `name` - Name of inventory
* `description` - Description

## Attributes

* `id` - ID of the resource

You should configure these as needed.
