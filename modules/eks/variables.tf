variable "cluster_name" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "cluster_role_arn" { type = string }
variable "node_role_arn" { type = string }
variable "node_group_desired_size" { 
    type = number 
    default = 2 
}
