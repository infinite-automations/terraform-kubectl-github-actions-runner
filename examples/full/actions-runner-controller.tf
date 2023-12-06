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
