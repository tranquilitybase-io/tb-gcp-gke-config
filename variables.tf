
# EC Deployment
variable "eagle_console_yaml_path" {
  default     = "./modules/kubernetes_yaml/eagle_console.yaml"
  description = "Path to the yaml file describing the eagle console resources"
  type        = string
}

variable "ec_repository_name" {
  default     = "EC-activator-tf"
  description = "Repository name used to store activator code"
  type        = string
}

variable "endpoint_file" {
  type        = string
  description = "Path to local file that will be created to store istio endpoint. The file will be created in the terraform run or overwritten (if exists). You need to ensure that directory in which it's created exists"
  default     = "/opt/tb/repo/tb-gcp-tr/gae-self-service-portal/endpoint-meta.json"
}

variable "ec_iam_service_account_roles" {
  default = [
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/compute.xpnAdmin",
    "roles/resourcemanager.projectDeleter",
    "roles/billing.projectManager",
    "roles/owner",
    "roles/compute.networkAdmin",
    "roles/datastore.owner",
    "roles/browser",
    "roles/resourcemanager.projectIamAdmin"
  ]
  description = "Roles attached to service account"
  type        = list(string)
}

#iTop deployment
variable "itop_database_user_name" {
  description = "iTop's database user account name"
  default     = "itop"
  type        = string
}

variable "ec_ui_source_bucket" {
  default     = "tranquility-base-ui"
  description = "GCS Bucket hosting Self Service Portal Angular source code."
  type        = string
}

variable "private_dns_name" {
  type        = string
  default     = "private-shared"
  description = "Name for private DNS zone in the shared vpc network"
}

variable "private_dns_domain_name" {
  type        = string
  default     = "tranquilitybase-demo.io." # domain requires . to finish
  description = "Domain name for private DNS in the shared vpc network"
}
## DAC Services ##########
# Namespace creations
variable "sharedservice_namespace_yaml_path" {
  default     = "/home/amce/tb-gcp-management-plane/namespaces.yaml"
  description = "Path to the yaml file to create namespaces on the shared gke-ec cluster"
  type        = string
}

# StorageClasses creation
variable "sharedservice_storageclass_yaml_path" {
  default     = "../kubernetes_yaml/storageclasses.yaml"
  description = "Path to the yaml file to create storageclasses on the shared gke-ec cluster"
  type        = string
}

#Jenkins install
variable "sharedservice_jenkinsmaster_yaml_path" {
  default     = "./jenkins-master.yaml"
  description = "Path to the yaml file to deploy Jenkins on the shared gke-ec cluster"
  type        = string
}

variable "folder_id" {
}

variable "vpc_name" {
}

variable "vpc_id" {

}
variable "subnet_name" {
}

variable "random_id" {
}

variable "billing_id" {
}

variable "state_bucket_name" {
}

variable "cluster_name" {
}

#env vars

variable "region" {
}

variable "project_id" {
}