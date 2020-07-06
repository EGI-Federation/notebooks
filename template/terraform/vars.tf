variable "ip_pool" {
  type        = string
  description = "The name of the public IP pool for the servers"
}

variable "net_id" {
  type        = string
  description = "The id of the network"
}

variable "master_cpus" {
  type        = number 
  description = "Number of CPUs for the master"
}

variable "master_ram" {
  type        = number 
  description = "RAM for the master"
}

variable "worker_cpus" {
  type        = number 
  description = "Number of CPUs for the worker"
}

variable "worker_ram" {
  type        = number 
  description = "RAM for the worker"
}

variable "extra_workers" {
  type        = number
  description = "Number of extra workers to create"
}

# This is quite safe to keep untouched
variable "appdb_image_id" {
  type        = string
  description = "The AppDB id of the image to start"
  # This is the EGI Docker image
  default     = "1006"
}

