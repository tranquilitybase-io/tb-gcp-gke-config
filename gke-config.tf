module "dac-secret" {
  source = "./modules/dac-secret"

  content = module.SharedServices_namespace_creation.id
  context_name = module.k8s-ec_context.context_name

  depends_on = [module.SharedServices_namespace_creation, module.k8s-ec_context]
}

module "k8s-ec_context" {
  source = "./modules/k8s-context"

  cluster_name    = var.cluster_name
  region          = var.region
  cluster_project = var.project_id

//  depends_on = [module.gke]
}

module "SharedServices_namespace_creation" {
  source = "./modules/start_service"

  k8s_template_file = var.sharedservice_namespace_yaml_path
  cluster_context   = module.k8s-ec_context.context_name

  depends_on = [module.k8s-ec_context]
}

resource "null_resource" "kubernetes_service_account_key_secret" {
  triggers = {
    content = module.SharedServices_namespace_creation.id
    k8_name = module.k8s-ec_context.context_name
  }

  provisioner "local-exec" {
    command = "echo 'kubectl --context=${module.k8s-ec_context.context_name} create secret generic ec-service-account -n ssp --from-file=${local_file.ec_service_account_key.filename}' | tee -a ./kube.sh"
  }

  provisioner "local-exec" {
    command = "echo 'kubectl --context=${self.triggers.k8_name} delete secret ec-service-account' -n ssp | tee -a ./kube.sh"
    when    = destroy
  }
}

resource "null_resource" "kubernetes_jenkins_service_account_key_secret" {
  triggers = {
    content = module.SharedServices_namespace_creation.id
    k8_name = module.k8s-ec_context.context_name
  }

  provisioner "local-exec" {
    command = "echo 'kubectl --context=${module.k8s-ec_context.context_name} create secret generic ec-service-account -n cicd --from-file=${local_file.ec_service_account_key.filename}' | tee -a ./kube.sh"
  }

  provisioner "local-exec" {
    command = "echo 'kubectl --context=${self.triggers.k8_name} delete secret ec-service-account' -n cicd | tee -a ./kube.sh"
    when    = destroy
  }
}

module "SharedServices_storageclass_creation" {
  source = "./modules/start_service"

  k8s_template_file = var.sharedservice_storageclass_yaml_path
  cluster_context   = module.k8s-ec_context.context_name

  depends_on = [module.k8s-ec_context]
}

module "SharedServices_jenkinsmaster_creation" {
  source = "./modules/start_service"

  k8s_template_file = var.sharedservice_jenkinsmaster_yaml_path
  cluster_context   = module.k8s-ec_context.context_name
  # Jenkins Deployment depends on the ec-service-account secret creation

  depends_on = [module.dac-secret, null_resource.kubernetes_jenkins_service_account_key_secret]
}

//todo figure out where these values are used
module "SharedServices_configuration_file" {
  source = "./modules/start_service"

  k8s_template_file = local_file.ec_config_map.filename
  cluster_context   = module.k8s-ec_context.context_name

  depends_on = [module.k8s-ec_context]
}

module "SharedServices_ec" {
  source = "./modules/start_service"

  k8s_template_file = var.eagle_console_yaml_path
  cluster_context   = module.k8s-ec_context.context_name

  depends_on = [module.dac-secret, module.k8s-ec_context]
}

module "tls" {
  source = "./modules/tls"
}

resource "google_sourcerepo_repository" "activator-terraform-code-store" {
  name       = "terraform-code-store"
  project    = var.project_id
}

resource "google_sourcerepo_repository_iam_binding" "terraform-code-store-admin-binding" {
  repository = google_sourcerepo_repository.activator-terraform-code-store.name
  project    = var.project_id
  role       = "roles/source.admin"

  members = [
    local.service_account_name,
  ]
}

