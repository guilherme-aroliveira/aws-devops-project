# AWS DevOps Project

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)

Lorem Ipsum

### Description

Lorem ipsum

### Usage

To do local tests, terraform can be executed locally in this way:

```shell
terraform init -backend-config=aws.conf
terraform plan
```

<p>The file <span style="color:#98971a">aws.conf</span> has all the ihe information related to the backend. The file is <strong>only</strong> for local use,
do not commit it to the git repository, because it contains sensitive data about the infrastructure. </p>

Example of a backend file:
```terraform
bucket          = "bucket's name"
key             = "bucket's arn"
region          = "aws region"
role_arn        = "aws role to execute terraform with credentials"
```
The infrastructure provisioning is performed by a pipeline file (example: pipelines.yaml),
which executes a previously created GitHub Actions pipeline. Each pull request will trigger the pipeline.

### Tools Used 

- Terraform
- GitHub Actions
- AWS 

### License

Copyright (c) 2026, Guilherme Oliveira. All rights reserved.

Licensed under the MIT License. See [LICENSE](LICENSE)