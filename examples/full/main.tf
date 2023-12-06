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
