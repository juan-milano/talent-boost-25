variable "token_service_account" {
  type        = string
}


variable "project_id" {
  type        = string
}

variable "region_name" {
  type        = string
  default     = "us-central1" # You can set a default region
}

variable "gcp_service_list" {
  description = "List of GCP service to be enabled for a project."
  type        = list(any)
}

variable "vpc_network_name" {
  type        = string
  default     = "my-vpc-network" # You can set a default network name
}

variable "auto_create_subnetworks" {
  type        = bool
  default     = false
}

variable "subnet_name" {
  type        = string
  default     = "my-subnet"
}

variable "subnet_ip_cidr_range" {
  type        = string
  default     = "10.0.1.0/24"
}
