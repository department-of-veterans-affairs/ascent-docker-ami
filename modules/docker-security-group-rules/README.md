# Docker Security Group Rules Module

This folder contains a [Terraform](www.terraform.io) module which defines the security rules used by a Docker swarm to control inbound and outbound traffic.

## Using this module

```hcl
module "security_group_rules" {
  source = "git::git@github.com:jasonluck/terraform-docker-aws.git//modules/docker-security-group-rules?ref=v0.0.1"

  security_group_id = "${module.cluster.security_group_id}"
  
  # ... (other params omitted) ...
}
```

Note the following parameters:

* `source`: Use this parameter to specify the URL of this module. The double slash (`//`) is intentional 
  and required. Terraform uses it to specify subfolders within a Git repo (see [module 
  sources](https://www.terraform.io/docs/modules/sources.html)). The `ref` parameter specifies a specific Git tag in 
  this repo. That way, instead of using the latest version of this module from the `master` branch, which 
  will change every time you run Terraform, you're using a fixed version of the repo.

* `security_group_id`: Use this parameter to specify the ID of the security group to which the rules in this module should be added.
  
You can find the other parameters in [variables.tf](variables.tf).