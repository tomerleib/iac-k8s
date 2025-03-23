variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
  default     = "terraform-kind"
}

variable "worker_nodes" {
  description = "Number of worker nodes to create"
  type        = number
  default     = 2
}

variable "node_port" {
  description = "Port to expose on the host machine"
  type        = number
  default     = 30000
} 