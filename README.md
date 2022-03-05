# NYDIG

Solution for a technical interview project

## Overview

**Objective**: Design and codify a solution for self-hosting Splunk Enterprise used to collect and index VPC flow logs from a development and production VPC.

## Documentation
* [Technical Implementation Plan (TIP)](https://docs.google.com/document/d/1ngeUnW6V_6dT39Ch0z5WAEMv9DhDOLNEiLzSUuovPs0/edit?usp=sharing)

## Technical Considerations

### Terraform Modules

#### What is a Terraform module?

From the Terraform documentation...

>A *module* is a container for multiple resources that are used together. Modules can be used to create lightweight abstractions, so that you can describe your infrastructure in terms of its architecture, rather than directly in terms of physical objects.

Additionally, it is important to differential between the *root module* and a *reusable module*.
* **Root module**: The `.tf` files in your working directory when you run `terraform plan` or `terraform apply` together form the root module. The root module may call other modules and connect them together by passing output values from one to input values of another.
* **Reusable module**: A reusable module is defined using all of the same configuration language concepts used in the root module (input variables, output values, resources), however reusable modules are meant to be used by lots of configurations. As such, reusable modules facilitate *module composition*, which describes the process of taking multiple composable building-block modules and assembling them together to produce a larger system.

#### When to use root and reusable modules

A good module should raise the level of abstraction by describing a new concept in your architecture that is constructed from resource types offered by providers. A root module typically comprises a single (or multi-region) instantiation of a system with a specific configuration. Given that a root modules comprises a single deployment and a single deployment has its own state, it follows that each AWS account or environment have its own root module. A reusable module, on the other hand, describes a set of resources, which are more configurable and are meant to be consumed my other modules. Reusable modules should be placed in their own repository and provide semantic versioning.

#### How to create a good module

* Modules should be flat. Creating a deeply-nested tree of modules is discouraged. Instead, individual modules should be composable and reusable. Modules should accept the object it needs as an argument via an input variable, thereby using dependency inversion to establish a relationship with the higher-level calling module.
* Modules should provides a higher level of abstraction. Do not write modules that are just thin wrappers around single resource types.
* Do not overuse modules. A module should describe a collection of logically consistent resources. Subdividing a system into multiple tightly coupled modules is discourages.

### Terraform Data Sources

#### What is a Terraform data source?

From the Terraform documentation...

>*Data sources* allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.

There are two commonly used sources from which Terraform can retrieve data:
* **Resource**: Given a resource (ex. `aws_instance`) and query constraints defined by the data source, Terraform retrieves data about the resource for use in configuration elsewhere in the Terraform module.
* **Remote state**: The `terraform_remote_state` data source retrieves the root module output values from some other Terraform configuration, using the latest state snapshot from the remote backend.

#### Resource vs. remote state

In most cases, it is better to retrieve data directly from the resource itself than from remote state. In this way, a dependency between the data source (remote Terraform module) and the data destination (consuming Terraform module) can be eliminated. Instead, the resource itself should comprise the information needed to facilitate querying and filtering.

**Example**

```hcl
data "aws_vpc" "us" {
  provider = aws.us

}

data "aws_subnet_ids" "public" {
  provider = aws.us
  vpc_id   = data.aws_vpc.us.id

  filter {
    name   = "tag:public"
    values = ["true"]
  }
}
```

The above example is considered a better practice than outputting the specific subnet IDs from the Terraform module in which they are defined. That method, however, is better than hardcoding the subnet IDs as an input variable to the consuming Terraform module.
