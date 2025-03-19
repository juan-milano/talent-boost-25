//Enable services and apis
resource "google_project_service" "services_enabled_project" {
  for_each           = toset(var.gcp_service_list)
  service            = each.key
  project            = var.project_id
  disable_on_destroy = false
}

module "vpc" {
  source     = "./modules/net-vpc"
  project_id = var.project_id
  name       = "my-network"
  subnets = [
    {
      ip_cidr_range = "10.0.0.0/24"
      name          = "production"
      region        = "us-west1"
      secondary_ip_ranges = {
        pods     = "172.16.0.0/20"
        services = "192.168.0.0/24"
      }
    },
    {
      ip_cidr_range = "10.0.16.0/24"
      name          = "production"
      region        = "us-west2"
    }
  ]
}

module "nat" {
  source         = "./modules/net-cloudnat"
  project_id = var.project_id
  region         = "us-west1"
  name           = "us-west1-nat"
  router_network = module.vpc.name
}


module "cluster" {
  source     = "./modules/gke-cluster-standard"
  project_id = var.project_id
  name       = "prueba-cluster"
  location   = "us-west1-a"
  vpc_config = {
    master_ipv4_cidr_block =  "10.0.0.0/24"
    network                = module.vpc.self_link
    subnetwork             = module.vpc.subnet_self_links["${var.region_name}/production"]
  }
  deletion_protection = false
}


module "cluster_nodepool" {
  source       = "./modules/gke-nodepool"
  project_id = var.project_id
  cluster_name = module.cluster.name
  location   = "us-west1-a"
  name         = "nodepool"
  service_account = {
    create = true
  }
  node_count = { initial = 3 }
}