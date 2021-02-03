# many-tfe

Terraform configurations for producing a whole bunch of... stuff,
using the [tfe provider](https://registry.terraform.io/providers/hashicorp/tfe/latest).

Each config is in its own directory and relatively contained.

## How to use any of the configs in this repo

```
cp terraform.tfvars.example terraform.tfvars
```

Fill in the variable values with your token and some base data. Then run `terraform plan` to see what will be created.

Once you've adjusted things to your satisfaction, run `terraform apply` to make it happen.

Be aware that applies may take a while due to the sheer number of resources being created.
