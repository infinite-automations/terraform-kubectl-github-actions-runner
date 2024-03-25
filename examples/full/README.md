<!-- BEGIN_TF_DOCS -->


## 1. Setup Cert Manager

```hcl
# create namespace for cert mananger
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    labels = {
      "name" = "cert-manager"
    }
    name = "cert-manager"
  }
}

# install cert-manager helm chart using terraform
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.12.3"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  atomic     = true
  timeout    = 600
  set {
    name  = "installCRDs"
    value = "true"
  }
}
```

## 2. Setup Agents Runner Controller 

```hcl
# setup actions-runner-controller
module "actions_runner_controller" {
  source  = "infinite-automations/github-actions-runner-controller/helm"
  version = "1.0.0"

  namespace                                 = "github-actions-runner-controller"
  create_namespace                          = true
  allow_granting_container_mode_permissions = false
  github_app_id                             = var.github_app_id
  github_app_install_id                     = var.github_app_install_id
  github_app_private_key                    = var.github_app_private_key
  kubernetes_secret_name                    = "github-auth-secret"
  helm_deployment_name                      = "actions-runner-controller"
  helm_chart_version                        = "0.23.5"
  replicas                                  = 1
  atomic                                    = true
  timeout                                   = 600

  depends_on = [helm_release.cert_manager]
}
```

## 3. Setup Runner

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
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.11.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.12.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.24.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_app_id"></a> [github\_app\_id](#input\_github\_app\_id) | GitHub App ID | `string` | n/a | yes |
| <a name="input_github_app_install_id"></a> [github\_app\_install\_id](#input\_github\_app\_install\_id) | GitHub App Install ID | `string` | n/a | yes |
| <a name="input_github_app_private_key"></a> [github\_app\_private\_key](#input\_github\_app\_private\_key) | GitHub App Private Key | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels for the runner | `list(string)` | n/a | yes |



<!-- END_TF_DOCS -->