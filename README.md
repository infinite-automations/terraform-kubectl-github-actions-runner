# terraform-kubectl-github-actions-runner

Setup the a GitHub Actions Runner in an existing kubernetes cluster

To setup the runner controller see the [actions runner controller module](https://registry.terraform.io/modules/infinite-automations/github-actions-runner-controller/helm/latest) from the [terraform-kubectl-github-actions-runner-controller](https://github.com/infinite-automations/terraform-helm-github-actions-runner-controller) repository.

<!-- BEGIN_TF_DOCS -->


## Module Usage

```hcl
module "actions_runner" {
  source = "../.."

  repo_owner = "infinite-automations"
  repo_name  = "terraform-kubectl-github-actions-runner"
  labels     = var.labels

  namespace        = "github-actions-runner"
  create_namespace = true

  name                        = "github-actions-runner"
  runner_service_account_name = "github-actions-runner"
  job_service_account_name    = "github-actions-job"

  runner_image = "summerwind/actions-runner:latest"
  ephemeral    = true

  min_count                = 1
  max_count                = 3
  scale_down_delay_seconds = 300
  metrics = [
    {
      type               = "PercentageRunnersBusy"
      scaleUpThreshold   = "0.75"
      scaleDownThreshold = "0.25"
      scaleUpFactor      = "2"
      scaleDownFactor    = "0.5"
    },
    {
      "type"       = "TotalNumberOfQueuedAndInProgressWorkflowRuns"
      "repository" = "infinite-automations/terraform-kubectl-github-actions-runner"
      "name"       = "total"
    }
  ]

  storage_class_name = "standard"
  storage_size       = "100Mi"

  depends_on = [module.actions_runner_controller]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.23.0 |

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.runner](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.runner_autoscaler](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_config_map.job-template](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_role.runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_secret.job](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service_account.job](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_service_account.runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the repository | `string` | n/a | yes |
| <a name="input_repo_owner"></a> [repo\_owner](#input\_repo\_owner) | The owner of the repository | `string` | n/a | yes |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | If true, the namespace will be created | `bool` | `true` | no |
| <a name="input_ephemeral"></a> [ephemeral](#input\_ephemeral) | If true, the runner will be ephemeral | `bool` | `true` | no |
| <a name="input_job_service_account_name"></a> [job\_service\_account\_name](#input\_job\_service\_account\_name) | The name of the service account for the job | `string` | `"github-actions-job"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels for the runner | `list(string)` | <pre>[<br>  "k8s",<br>  "arc"<br>]</pre> | no |
| <a name="input_max_count"></a> [max\_count](#input\_max\_count) | The maximum number of runners | `number` | `3` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | The metrics for the runner | `list(map(string))` | <pre>[<br>  {<br>    "scaleDownFactor": "0.5",<br>    "scaleDownThreshold": "0.25",<br>    "scaleUpFactor": "2",<br>    "scaleUpThreshold": "0.75",<br>    "type": "PercentageRunnersBusy"<br>  }<br>]</pre> | no |
| <a name="input_min_count"></a> [min\_count](#input\_min\_count) | The minimum number of runners | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the runner deployment | `string` | `"github-actions-runner"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the runner controller into | `string` | `"github-actions-runner"` | no |
| <a name="input_runner_image"></a> [runner\_image](#input\_runner\_image) | The image for the runner | `string` | `"summerwind/actions-runner:latest"` | no |
| <a name="input_runner_service_account_name"></a> [runner\_service\_account\_name](#input\_runner\_service\_account\_name) | The name of the service account for the runner | `string` | `"github-actions-runner"` | no |
| <a name="input_scale_down_delay_seconds"></a> [scale\_down\_delay\_seconds](#input\_scale\_down\_delay\_seconds) | The number of seconds from scaling out to wait before scaling down | `number` | `300` | no |
| <a name="input_storage_class_name"></a> [storage\_class\_name](#input\_storage\_class\_name) | The storage class name for the runner | `string` | `"default"` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | The storage size for the runner | `string` | `"100Mi"` | no |



<!-- END_TF_DOCS -->